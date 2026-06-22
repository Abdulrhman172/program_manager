import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../model/approval_model.dart';

class ApprovalController extends ChangeNotifier {
  List<ApprovalModel> _approvals = [];
  List<ApprovalModel> _filteredApprovals = [];
  String _searchQuery = '';
  String _statusFilter = 'الكل';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;
  
  RealtimeChannel? _subscription;

  List<ApprovalModel> get approvals => _filteredApprovals;
  String get currentFilter => _statusFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get pendingCount =>
      _approvals.where((a) => a.status == 'في الانتظار').length;
  int get approvedCount =>
      _approvals.where((a) => a.status == 'معتمدة').length;
  int get rejectedCount =>
      _approvals.where((a) => a.status == 'مرفوضة').length;

  ApprovalController() {
    fetchApprovals();
    _setupRealtime();
  }

  void _setupRealtime() {
    _subscription = SupabaseService.client
      .channel('public:first_stage')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'first stage',
        callback: (payload) {
          fetchApprovals();
        },
      )
      .subscribe();
  }

  Future<void> fetchApprovals() async {
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

      // نجلب أولاً المجموعات التابعة للبرنامج
      final groupsResponse = await SupabaseService.client
          .from('groups')
          .select('group_id')
          .eq('id_program', idProgram);

      final programGroupIds = (groupsResponse as List)
          .map((g) => (g['group_id'] as num).toInt())
          .toList();

      if (programGroupIds.isEmpty) {
        _approvals = [];
        _filterList();
        return;
      }

      // جلب بيانات المرحلة الأولى المفلترة من قاعدة البيانات مباشرة
      final response = await SupabaseService.client
          .from('first_stage_view')
          .select()
          .not('research_title', 'is', null)
          .eq('sprvsr_approval', true)
          .inFilter('group_id', programGroupIds);

      // تصفية نتائج المرحلة الأولى
      _approvals = (response as List)
          .map((e) => ApprovalModel.fromJson(e))
          .toList();

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

  Future<void> changeStatus(int stage1Id, bool? approved,
      {String? reason}) async {
    final index = _approvals.indexWhere((a) => a.stage1Id == stage1Id);
    if (index == -1) return;

    // تحديث محلي فوري
    _approvals[index].prgrmMngrApproval = approved;
    _approvals[index].rejectionReason = reason;
    _filterList();
    notifyListeners();

    try {
      int? noteId;
      if (approved == false && reason != null && reason.isNotEmpty) {
        // إدخال سبب الرفض في جدول proceduresNotes أولاً
        final noteResponse = await SupabaseService.client
            .from('proceduresNotes')
            .insert({'proed_note_name': reason})
            .select()
            .single();
        noteId = (noteResponse['proced_id'] as num?)?.toInt();
      }

      final updateData = <String, dynamic>{
        'prgrm_mngr_approval': approved,
      };

      if (noteId != null) {
        updateData['id_prgrm_mngr_proced'] = noteId;
      }

      await SupabaseService.client
          .from('first stage')
          .update(updateData)
          .eq('stage1_id', stage1Id);
    } catch (e) {
      // إعادة الحالة السابقة عند الخطأ
      if (!_isDisposed) {
        _approvals[index].prgrmMngrApproval = null;
        _approvals[index].rejectionReason = null;
        _filterList();
        notifyListeners();
      }
    }
  }

  void setFilter(String filter) {
    _statusFilter = filter;
    _filterList();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _filterList();
    notifyListeners();
  }

  void _filterList() {
    var tempList = _approvals;

    if (_statusFilter != 'الكل') {
      tempList = tempList.where((a) => a.status == _statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      tempList = tempList
          .where((approval) =>
              approval.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredApprovals = tempList;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.unsubscribe();
    super.dispose();
  }
}
