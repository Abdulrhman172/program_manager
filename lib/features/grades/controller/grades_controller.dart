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

      _grades = (gradesResponse as List).map((e) {
        final model = GradeModel.fromJson(e);
        // إضافة اسم المجموعة
        return GradeModel(
          gradeId: model.gradeId,
          groupId: model.groupId,
          idProgram: model.idProgram,
          groupName: groupNames[model.groupId] ?? 'مجموعة ${model.groupId}',
          supervisorGrade: model.supervisorGrade,
          programManagerGrade: model.programManagerGrade,
          finalGrade: model.finalGrade,
          gradeStatus: model.gradeStatus,
          notes: model.notes,
        );
      }).toList();

      _applyFilter();
    } catch (e) {
      _errorMessage = 'حدث خطأ في جلب الدرجات: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProgramManagerGrade(int gradeId, double newGrade) async {
    final index = _grades.indexWhere((g) => g.gradeId == gradeId);
    if (index == -1) return;

    // تحديث محلي فوري
    _grades[index].programManagerGrade = newGrade;
    _grades[index].gradeStatus = 'مكتملة';
    _applyFilter();
    notifyListeners();

    try {
      await SupabaseService.client.from('program_manager_grades').update({
        'program_manager_grade': newGrade,
        'grade_status': 'مكتملة',
      }).eq('grade_id', gradeId);
    } catch (e) {
      _errorMessage = 'فشل حفظ الدرجة: ${e.toString()}';
      notifyListeners();
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
}
