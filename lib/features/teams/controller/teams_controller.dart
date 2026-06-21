import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../model/team_model.dart';

class TeamsController extends ChangeNotifier {
  List<TeamModel> _teams = [];
  List<TeamModel> _filteredTeams = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;
  
  RealtimeChannel? _subscription;

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
    _setupRealtime();
  }

  void _setupRealtime() {
    _subscription = SupabaseService.client.channel('public:teams')
      .onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public', table: 'groups', callback: (payload) { fetchTeams(); })
      .onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public', table: 'student', callback: (payload) { fetchTeams(); })
      .subscribe();
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
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
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

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.unsubscribe();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchSupervisors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');
      if (idProgram == null) return [];
      final response = await SupabaseService.client
          .from('supervisor')
          .select('sprvsr_id, sprvsr_name')
          .eq('program_id', idProgram);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUnassignedStudents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');
      if (idProgram == null) return [];
      final response = await SupabaseService.client
          .from('student')
          .select('stud_id, stud_name, stud_college_num')
          .eq('id_program', idProgram)
          .isFilter('id_group', null);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<bool> changeSupervisor(int groupId, int? newSupervisorId) async {
    try {
      await SupabaseService.client
          .from('groups')
          .update({'id_sprvsr': newSupervisorId})
          .eq('group_id', groupId);
      return true;
    } catch (e) {
      _errorMessage = 'فشل تغيير المشرف: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeStudent(int studentId, int? leaderId) async {
    if (leaderId != null && studentId == leaderId) {
      _errorMessage = 'لا يمكن حذف قائد الفريق. يرجى تعيين قائد جديد أولاً.';
      notifyListeners();
      return false;
    }
    try {
      await SupabaseService.client
          .from('student')
          .update({'id_group': null})
          .eq('stud_id', studentId);
      return true;
    } catch (e) {
      _errorMessage = 'فشل حذف الطالب: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> addStudent(int studentId, int groupId) async {
    try {
      await SupabaseService.client
          .from('student')
          .update({'id_group': groupId})
          .eq('stud_id', studentId);
      return true;
    } catch (e) {
      _errorMessage = 'فشل إضافة الطالب: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> moveStudent(int studentId, int newGroupId, int? leaderId) async {
    if (leaderId != null && studentId == leaderId) {
      _errorMessage = 'لا يمكن نقل قائد الفريق. يرجى تعيين قائد جديد أولاً.';
      notifyListeners();
      return false;
    }
    try {
      await SupabaseService.client
          .from('student')
          .update({'id_group': newGroupId})
          .eq('stud_id', studentId);
      return true;
    } catch (e) {
      _errorMessage = 'فشل نقل الطالب: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> assignNewLeader(int groupId, int newLeaderId) async {
    try {
      await SupabaseService.client
          .from('groups')
          .update({'group_led_id': newLeaderId})
          .eq('group_id', groupId);
      return true;
    } catch (e) {
      _errorMessage = 'فشل تعيين القائد: $e';
      notifyListeners();
      return false;
    }
  }
}
