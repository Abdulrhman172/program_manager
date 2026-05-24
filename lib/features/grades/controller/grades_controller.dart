import 'package:flutter/material.dart';
import '../model/grade_model.dart';

class GradesController extends ChangeNotifier {
  final List<GradeModel> _grades = [
    GradeModel(
      id: '1',
      researchTitle: 'نظام إدارة المكتبة الإلكترونية',
      supervisorName: 'د. محمد أحمد علي',
      department: 'إدارة أعمال عربي',
      supervisorGrade: 55.0,
      adminGrade: 38.0,
    ),
    GradeModel(
      id: '2',
      researchTitle: 'تطبيق متابعة الحضور والغياب',
      supervisorName: 'د. فاطمة سالم حسن',
      department: 'إدارة أعمال انجليزي',
      supervisorGrade: 58.0,
      adminGrade: null, // بانتظار المسؤول
    ),
    GradeModel(
      id: '3',
      researchTitle: 'منصة التعليم الإلكتروني التفاعلية',
      supervisorName: 'د. نورة عبدالله سعيد',
      department: 'الترجمة',
      supervisorGrade: null, // بانتظار المشرف
      adminGrade: null,
    ),
    GradeModel(
      id: '4',
      researchTitle: 'نظام إدارة المطاعم الذكي',
      supervisorName: 'د. أحمد حسين عمر',
      department: 'تسويق رقمي',
      supervisorGrade: 45.0,
      adminGrade: 35.0,
    ),
    GradeModel(
      id: '5',
      researchTitle: 'تحليل البيانات الضخمة للشركات',
      supervisorName: 'د. محمد أحمد علي',
      department: 'إدارة أعمال دولية',
      supervisorGrade: 59.0,
      adminGrade: null, // بانتظار المسؤول
    ),
  ];

  List<GradeModel> _filteredGrades = [];
  String _searchQuery = '';
  String _statusFilter = 'الكل'; // 'الكل', 'بانتظار المشرف', 'بانتظار المسؤول', 'مكتملة'

  GradesController() {
    _applyFilter();
  }

  List<GradeModel> get grades => _filteredGrades;
  String get statusFilter => _statusFilter;

  // Stats
  int get totalCount => _grades.length;
  int get waitingSupervisorCount => _grades.where((g) => g.status == 'بانتظار المشرف').length;
  int get waitingAdminCount => _grades.where((g) => g.status == 'بانتظار المسؤول').length;
  int get completedCount => _grades.where((g) => g.status == 'مكتملة').length;

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
      temp = temp.where((g) => g.status == _statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((g) =>
              g.researchTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              g.supervisorName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredGrades = temp;
  }

  void updateAdminGrade(String id, double newGrade) {
    final index = _grades.indexWhere((g) => g.id == id);
    if (index != -1) {
      _grades[index].adminGrade = newGrade;
      _applyFilter();
      notifyListeners();
    }
  }
}
