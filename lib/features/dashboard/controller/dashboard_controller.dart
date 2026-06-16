import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../stages/model/stage_model.dart';

/// Controller for the Dashboard screen.
/// Manages navigation state and provides dashboard data.
class DashboardController extends ChangeNotifier {
  String _currentRoute = '/';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;
  int _studentsCount = 0;
  int _supervisorsCount = 0;
  int _activeResearchesCount = 0;
  int _finishedResearchesCount = 0;
  
  String _userName = 'مسؤول البرنامج';
  String? _userImage;
  
  List<StageModel> _stages = [];
  
  RealtimeChannel? _subscription;

  String get currentRoute => _currentRoute;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get studentsCount => _studentsCount;
  int get supervisorsCount => _supervisorsCount;
  int get activeResearchesCount => _activeResearchesCount;
  int get finishedResearchesCount => _finishedResearchesCount;
  String get userName => _userName;
  String? get userImage => _userImage;
  List<StageModel> get stages => _stages;

  DashboardController() {
    fetchStats();
    _setupRealtime();
  }

  void _setupRealtime() {
    _subscription = SupabaseService.client.channel('public:dashboard')
      .onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public', table: 'student', callback: (payload) { fetchStats(); })
      .onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public', table: 'supervisor', callback: (payload) { fetchStats(); })
      .onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public', table: 'groups', callback: (payload) { fetchStats(); })
      .onPostgresChanges(event: PostgresChangeEvent.all, schema: 'public', table: 'stages', callback: (payload) { fetchStats(); })
      .subscribe();
  }

  void setCurrentRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  void resetRoute() {
    _currentRoute = '/';
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('prma_name') ?? 'مسؤول البرنامج';
    _userImage = prefs.getString('prma_image');
    if (!_isDisposed) notifyListeners();
  }

  Future<void> fetchStats() async {
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

      _userName = prefs.getString('prma_name') ?? 'مسؤول البرنامج';
      _userImage = prefs.getString('prma_image');

      // 1. عدد الطلاب
      final studentsRes = await SupabaseService.client
          .from('student')
          .select('stud_id')
          .eq('id_program', idProgram);
      _studentsCount = (studentsRes as List).length;

      // 2. عدد المشرفين
      final supervisorsRes = await SupabaseService.client
          .from('supervisor')
          .select('sprvsr_id')
          .eq('program_id', idProgram);
      _supervisorsCount = (supervisorsRes as List).length;

      // 3. الأبحاث النشطة والمكتملة
      final groupsRes = await SupabaseService.client
          .from('groups')
          .select('group_id, id_group_state')
          .eq('id_program', idProgram);
          
      _activeResearchesCount = 0;
      _finishedResearchesCount = 0;
      
      for (var group in (groupsRes as List)) {
        final stateId = group['id_group_state'];
        // حالة 6 تعني مكتمل، أي حالة أخرى غير مؤرشف تعتبر نشطة
        if (stateId == 6) {
          _finishedResearchesCount++;
        } else if (stateId != 3) { // 3 قد تعني مؤرشف حسب الجداول السابقة
          _activeResearchesCount++;
        }
      }

      // 4. المراحل
      final stagesRes = await SupabaseService.client
          .from('stages')
          .select()
          .eq('id_program', idProgram)
          .order('stages_id', ascending: true);
          
      _stages = (stagesRes as List).map((e) => StageModel.fromJson(e)).toList();

    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء جلب الإحصائيات: $e';
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.unsubscribe();
    super.dispose();
  }
}
