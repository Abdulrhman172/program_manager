import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/supabase_service.dart';
import '../model/grade_model.dart';

class GradesController extends ChangeNotifier {
  List<GradeModel> _grades = [];
  List<GradeModel> _filteredGrades = [];
  String _searchQuery = '';
  String _statusFilter = 'الكل';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<GradeModel> get grades => _filteredGrades;
  String get statusFilter => _statusFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalCount => _grades.length;
  int get waitingSupervisorCount =>
      _grades.where((g) => g.gradeStatus == 'بانتظار المشرف').length;
  int get waitingAdminCount =>
      _grades.where((g) => g.gradeStatus == 'بانتظار المسؤول').length;
  int get completedCount =>
      _grades.where((g) => g.gradeStatus == 'مكتملة').length;

  GradesController() {
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram == null) {
        _errorMessage = 'لم يتم تحديد البرنامج';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // جلب الدرجات مع أسماء المجموعات
      final gradesResponse = await SupabaseService.client
          .from('program_manager_grades')
          .select()
          .eq('id_program', idProgram);

      // جلب أسماء المجموعات
      final groupsResponse = await SupabaseService.client
          .from('groups')
          .select('group_id, group_name')
          .eq('id_program', idProgram);

      final groupNames = <int, String>{};
      for (final g in groupsResponse as List) {
        groupNames[(g['group_id'] as num).toInt()] =
            g['group_name'] as String? ?? '';
      }

      // جلب الطلاب في هذا البرنامج
      final studentsResponse = await SupabaseService.client
          .from('student')
          .select('stud_id, stud_name, id_group')
          .eq('id_program', idProgram);

      // جلب درجات الطلاب (إذا كانت موجودة)
      final studentGradesResponse = await SupabaseService.client
          .from('student_grades')
          .select('id_student, program_manager_grade')
          .not('program_manager_grade', 'is', null);

      final studentGradesMap = <int, double>{};
      for (final sg in studentGradesResponse as List) {
        studentGradesMap[(sg['id_student'] as num).toInt()] =
            (sg['program_manager_grade'] as num).toDouble();
      }

      // تجميع الطلاب حسب المجموعة
      final studentsByGroup = <int, List<StudentGradeModel>>{};
      for (final s in studentsResponse as List) {
        final groupId = (s['id_group'] as num?)?.toInt();
        if (groupId != null) {
          final studId = (s['stud_id'] as num).toInt();
          final stud = StudentGradeModel(
            studentId: studId,
            studentName: s['stud_name'] as String? ?? 'طالب',
            programManagerGrade: studentGradesMap[studId],
          );
          if (!studentsByGroup.containsKey(groupId)) {
            studentsByGroup[groupId] = [];
          }
          studentsByGroup[groupId]!.add(stud);
        }
      }

      _grades = (gradesResponse as List).map((e) {
        final model = GradeModel.fromJson(e);
        // إضافة اسم المجموعة والطلاب
        return GradeModel(
          gradeId: model.gradeId,
          groupId: model.groupId,
          idProgram: model.idProgram,
          groupName: groupNames[model.groupId] ?? 'مجموعة ${model.groupId}',
          supervisorGrade: model.supervisorGrade,
          programManagerGrade: model.programManagerGrade,
          finalGrade: model.finalGrade,
          gradeStatus: model.gradeStatus,
          students: studentsByGroup[model.groupId] ?? [],
        );
      }).toList();

      _applyFilter();
    } catch (e) {
      _errorMessage = 'حدث خطأ في جلب الدرجات: ${e.toString()}';
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateProgramManagerGrades(
      int gradeId, int groupId, Map<int, double> studentGradesMap) async {
    final index = _grades.indexWhere((g) => g.gradeId == gradeId);
    if (index == -1) return;

    // تحديث محلي فوري
    double totalGrades = 0.0;
    for (final student in _grades[index].students) {
      if (studentGradesMap.containsKey(student.studentId)) {
        student.programManagerGrade = studentGradesMap[student.studentId];
      }
      totalGrades += student.programManagerGrade ?? 0.0;
    }
    
    final averageGrade = _grades[index].students.isNotEmpty 
        ? totalGrades / _grades[index].students.length 
        : 0.0;

    _grades[index].programManagerGrade = averageGrade;
    _grades[index].gradeStatus = 'مكتملة';
    _applyFilter();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram != null) {
        // حفظ درجات الطلاب الفردية
        for (var entry in studentGradesMap.entries) {
          final studentId = entry.key;
          final grade = entry.value;

          // التحقق مما إذا كان الطالب لديه سجل درجات مسبقاً
          final existingGrade = await SupabaseService.client
              .from('student_grades')
              .select('grade_id')
              .eq('id_student', studentId)
              .maybeSingle();

          if (existingGrade != null) {
            await SupabaseService.client
                .from('student_grades')
                .update({'program_manager_grade': grade})
                .eq('id_student', studentId);
          } else {
            await SupabaseService.client.from('student_grades').insert({
              'id_student': studentId,
              'id_group': groupId,
              'program_manager_grade': grade,
            });
          }
        }

        // حفظ المتوسط في جدول program_manager_grades
        await SupabaseService.client.from('program_manager_grades').update({
          'program_manager_grade': averageGrade,
          'grade_status': 'مكتملة',
        }).eq('grade_id', gradeId).eq('id_program', idProgram);
      }
    } catch (e) {
      if (!_isDisposed) {
        _errorMessage = 'فشل حفظ الدرجة: ${e.toString()}';
        notifyListeners();
      }
    }
  }

  void setFilter(String filter) {
    _statusFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    List<GradeModel> temp = _grades;

    if (_statusFilter != 'الكل') {
      temp = temp.where((g) => g.gradeStatus == _statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((g) =>
              g.groupName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredGrades = temp;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
