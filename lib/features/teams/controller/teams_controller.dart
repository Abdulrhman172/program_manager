import 'package:flutter/material.dart';
import '../model/team_model.dart';

class TeamsController extends ChangeNotifier {
  final List<TeamModel> _teams = [
    TeamModel(
      id: '1',
      projectTitle: 'نظام إدارة المكتبة الإلكترونية',
      department: 'إدارة أعمال عربي',
      supervisor: 'د. محمد أحمد علي',
      members: [
        TeamMemberModel(id: '2021001', name: 'عبدالله محمد سعيد', role: 'قائد الفريق'),
        TeamMemberModel(id: '2021003', name: 'خالد أحمد علي', role: 'عضو'),
        TeamMemberModel(id: '2021002', name: 'فاطمة سالم حسن', role: 'عضو'),
      ],
    ),
    TeamModel(
      id: '2',
      projectTitle: 'تطبيق متابعة الحضور والغياب',
      department: 'إدارة أعمال انجليزي',
      supervisor: 'د. فاطمة سالم حسن',
      members: [
        TeamMemberModel(id: '2021004', name: 'نور سعيد محمود', role: 'قائد الفريق'),
        TeamMemberModel(id: '2021005', name: 'أحمد يحيى حسين', role: 'عضو'),
        TeamMemberModel(id: '2021006', name: 'سارة محمود علي', role: 'عضو'),
      ],
    ),
    TeamModel(
      id: '3',
      projectTitle: 'نظام إدارة المطاعم الذكي',
      department: 'المحاسبة',
      supervisor: 'د. أحمد حسين عمر',
      members: [
        TeamMemberModel(id: '2021007', name: 'علي محمد علي', role: 'قائد الفريق'),
        TeamMemberModel(id: '2021008', name: 'يوسف أحمد سعيد', role: 'عضو'),
        TeamMemberModel(id: '2021009', name: 'هند علي سالم', role: 'عضو'),
      ],
    ),
    TeamModel(
      id: '4',
      projectTitle: 'منصة التعليم الإلكتروني التفاعلية',
      department: 'إدارة أعمال دولية',
      supervisor: 'د. خالد يحيى محمود',
      members: [
        TeamMemberModel(id: '2021010', name: 'سعد خالد محمود', role: 'قائد الفريق'),
        TeamMemberModel(id: '2021011', name: 'ليلى أحمد حسن', role: 'عضو'),
        TeamMemberModel(id: '2021012', name: 'عمر سيف الدين', role: 'عضو'),
      ],
    ),
  ];

  List<TeamModel> _filteredTeams = [];
  String _searchQuery = '';

  TeamsController() {
    _filteredTeams = _teams;
  }

  List<TeamModel> get teams => _filteredTeams;

  int get totalTeams => _teams.length;
  
  int get totalStudents {
    return _teams.fold(0, (sum, team) => sum + team.members.length);
  }

  double get averageTeamSize {
    if (_teams.isEmpty) return 0.0;
    return totalStudents / totalTeams;
  }

  void search(String query) {
    _searchQuery = query;
    _filterList();
    notifyListeners();
  }

  void _filterList() {
    if (_searchQuery.isEmpty) {
      _filteredTeams = List.from(_teams);
    } else {
      _filteredTeams = _teams
          .where((team) =>
              team.projectTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              team.members.any((member) => member.name.toLowerCase().contains(_searchQuery.toLowerCase()) || member.id.contains(_searchQuery)))
          .toList();
    }
  }
}
