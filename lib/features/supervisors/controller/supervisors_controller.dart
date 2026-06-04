import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/supabase_service.dart';
import '../model/supervisor_model.dart';

class SupervisorsController extends ChangeNotifier {
  List<SupervisorModel> _supervisors = [];
  List<SupervisorModel> _filteredSupervisors = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<SupervisorModel> get supervisors => _filteredSupervisors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalSupervisors => _supervisors.length;
  int get activeSupervisors => _supervisors.where((s) => s.isActive).length;
  int get inactiveSupervisors => _supervisors.where((s) => !s.isActive).length;

  SupervisorsController() {
    fetchSupervisors();
  }

  Future<void> fetchSupervisors() async {
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

      final response = await SupabaseService.client
          .from('supervisor')
          .select()
          .eq('program_id', idProgram);

      _supervisors =
          (response as List).map((e) => SupervisorModel.fromJson(e)).toList();
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

  Future<void> toggleSupervisorStatus(int id, bool newValue) async {
    final index = _supervisors.indexWhere((s) => s.id == id);
    if (index == -1) return;

    // تحديث محلي فوري للـ UI
    _supervisors[index].isActive = newValue;
    _filterList();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');
      
      if (idProgram != null) {
        await SupabaseService.client
            .from('supervisor')
            .update({'sprvsr_isactive': newValue})
            .eq('sprvsr_id', id)
            .eq('program_id', idProgram);
      }
    } catch (e) {
      // إعادة الحالة السابقة عند الخطأ
      if (!_isDisposed) {
        _supervisors[index].isActive = !newValue;
        _filterList();
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
      _filteredSupervisors = List.from(_supervisors);
    } else {
      _filteredSupervisors = _supervisors
          .where((supervisor) =>
              supervisor.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              supervisor.email
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
