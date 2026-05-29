import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/supabase_service.dart';
import '../model/team_model.dart';

class TeamsController extends ChangeNotifier {
  List<TeamModel> _teams = [];
  List<TeamModel> _filteredTeams = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<TeamModel> get teams => _filteredTeams;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalTeams => _teams.length;

  int get totalStudents =>
      _teams.fold(0, (sum, team) => sum + team.members.length);

  double get averageTeamSize {
    if (_teams.isEmpty) return 0.0;
    return totalStudents / totalTeams;
  }

  TeamsController() {
    fetchTeams();
  }

  Future<void> fetchTeams() async {
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

      // جلب المجموعات من الـ View مع فلترة بـ id_program
      final groupsResponse = await SupabaseService.client
          .from('student_group_view')
          .select()
          .eq('id_program', idProgram);

      // تجميع المجموعات (كل صف يمثل طالب واحد في المجموعة)
      final Map<int, TeamModel> groupMap = {};
      for (final row in groupsResponse) {
        final groupId = (row['group_id'] as num?)?.toInt();
        if (groupId == null) continue;

        if (!groupMap.containsKey(groupId)) {
          groupMap[groupId] = TeamModel.fromJson(row);
        }

        // إضافة الطالب كعضو في المجموعة
        final studId = (row['stud_id'] as num?)?.toInt();
        final studName = row['stud_name'] as String?;
        final leaderId = (row['group_led_id'] as num?)?.toInt();

        if (studId != null && studName != null) {
          groupMap[groupId]!.members.add(TeamMemberModel(
                id: studId,
                name: studName,
                role: studId == leaderId ? 'قائد الفريق' : 'عضو',
              ));
        }
      }

      _teams = groupMap.values.toList();
      _filterList();
    } catch (e) {
      _errorMessage = 'حدث خطأ في جلب البيانات: ${e.toString()}';
    } finally {
      _isLoading = false;
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
      _filteredTeams = List.from(_teams);
    } else {
      _filteredTeams = _teams
          .where((team) =>
              team.groupName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (team.supervisorName
                      ?.toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ??
                  false) ||
              team.members.any((m) =>
                  m.name.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }
  }
}
