import 'package:flutter/material.dart';
import '../model/supervisor_model.dart';

class SupervisorsController extends ChangeNotifier {
  final List<SupervisorModel> _supervisors = [
    SupervisorModel(id: '1', name: 'د. محمد أحمد علي', department: 'إدارة أعمال عربي', email: 'mohamed@ust.edu.ye', researchCount: 8, isActive: true),
    SupervisorModel(id: '2', name: 'د. فاطمة سالم حسن', department: 'إدارة أعمال انجليزي', email: 'fatima@ust.edu.ye', researchCount: 6, isActive: true),
    SupervisorModel(id: '3', name: 'د. خالد يحيى محمود', department: 'إدارة أعمال دولية', email: 'khaled@ust.edu.ye', researchCount: 0, isActive: false),
    SupervisorModel(id: '4', name: 'د. نورة عبدالله', department: 'تسويق رقمي', email: 'noura@ust.edu.ye', researchCount: 2, isActive: true),
    SupervisorModel(id: '5', name: 'د. سالم سعيد', department: 'المحاسبة', email: 'salem@ust.edu.ye', researchCount: 4, isActive: true),
    SupervisorModel(id: '6', name: 'د. هند عبدالرحمن', department: 'الترجمة', email: 'hind@ust.edu.ye', researchCount: 0, isActive: false),
  ];

  List<SupervisorModel> _filteredSupervisors = [];
  String _searchQuery = '';

  SupervisorsController() {
    _filteredSupervisors = _supervisors;
  }

  List<SupervisorModel> get supervisors => _filteredSupervisors;

  int get totalSupervisors => _supervisors.length;
  int get activeSupervisors => _supervisors.where((s) => s.isActive).length;
  int get inactiveSupervisors => _supervisors.where((s) => !s.isActive).length;

  void toggleSupervisorStatus(String id, bool newValue) {
    final index = _supervisors.indexWhere((s) => s.id == id);
    if (index != -1) {
      _supervisors[index].isActive = newValue;
      _filterList();
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _filterList();
    notifyListeners();
  }

  void _filterList() {
    if (_searchQuery.isEmpty) {
      _filteredSupervisors = List.from(_supervisors);
    } else {
      _filteredSupervisors = _supervisors
          .where((supervisor) =>
              supervisor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              supervisor.email.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
}
