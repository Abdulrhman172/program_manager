import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../model/supervisor_model.dart';

class SupervisorsController extends ChangeNotifier {
  List<SupervisorModel> _supervisors = [];
  List<SupervisorModel> _filteredSupervisors = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;
  bool _isFormVisible = false;
  bool _isEditing = false;
  int? _editingId;
  bool _isSaving = false;
  String? _formError;
  bool _obscurePassword = true;

  RealtimeChannel? _subscription;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<SupervisorModel> get supervisors => _filteredSupervisors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFormVisible => _isFormVisible;
  bool get isEditing => _isEditing;
  bool get isSaving => _isSaving;
  String? get formError => _formError;
  bool get obscurePassword => _obscurePassword;

  int get totalSupervisors => _supervisors.length;
  int get activeSupervisors => _supervisors.where((s) => s.isActive).length;
  int get inactiveSupervisors => _supervisors.where((s) => !s.isActive).length;

  SupervisorsController() {
    fetchSupervisors();
    _setupRealtime();
  }

  void _setupRealtime() {
    _subscription = SupabaseService.client
        .channel('public:supervisor')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'supervisor',
          callback: (payload) {
            fetchSupervisors();
          },
        )
        .subscribe();
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
          .eq('program_id', idProgram)
          .order('created_at', ascending: false);

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
      if (!_isDisposed) {
        _supervisors[index].isActive = !newValue;
        _filterList();
        notifyListeners();
      }
    }
  }

  void openAddForm() {
    _isEditing = false;
    _editingId = null;
    _formError = null;
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    usernameController.clear();
    passwordController.clear();
    _isFormVisible = true;
    notifyListeners();
  }

  void openEditForm(SupervisorModel supervisor) {
    _isEditing = true;
    _editingId = supervisor.id;
    _formError = null;
    nameController.text = supervisor.name;
    emailController.text = supervisor.email;
    phoneController.text = supervisor.phoneNum ?? '';
    usernameController.text = supervisor.username ?? '';
    passwordController.text = supervisor.password ?? '';
    _isFormVisible = true;
    notifyListeners();
  }

  void closeForm() {
    _isFormVisible = false;
    _formError = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> saveSupervisor() async {
    // Validation
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        (!_isEditing && passwordController.text.trim().isEmpty)) {
      _formError = 'يرجى تعبئة جميع الحقول الإلزامية (الاسم، البريد، اسم المستخدم، كلمة المرور)';
      notifyListeners();
      return;
    }

    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram == null) {
        _formError = 'لم يتم تحديد البرنامج';
        _isSaving = false;
        notifyListeners();
        return;
      }

      final data = <String, dynamic>{
        'sprvsr_name': nameController.text.trim(),
        'sprvsr_email': emailController.text.trim(),
        'sprvsr_phone_num': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'sprvsr_username': usernameController.text.trim(),
        'program_id': idProgram,
      };

      if (passwordController.text.trim().isNotEmpty) {
        data['sprvsr_password'] = passwordController.text.trim();
      }

      if (_isEditing && _editingId != null) {
        await SupabaseService.client
            .from('supervisor')
            .update(data)
            .eq('sprvsr_id', _editingId!)
            .eq('program_id', idProgram);
      } else {
        data['sprvsr_isactive'] = true;
        data['sprvsr_project_num'] = 0;
        await SupabaseService.client.from('supervisor').insert(data);
      }

      closeForm();
      await fetchSupervisors();
    } catch (e) {
      _formError = 'حدث خطأ أثناء الحفظ: ${e.toString()}';
    } finally {
      if (!_isDisposed) {
        _isSaving = false;
        notifyListeners();
      }
    }
  }

  Future<void> deleteSupervisor(int id, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram == null) return;

      await SupabaseService.client
          .from('supervisor')
          .delete()
          .eq('sprvsr_id', id)
          .eq('program_id', idProgram);

      _supervisors.removeWhere((s) => s.id == id);
      _filterList();
      notifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        _errorMessage = 'حدث خطأ أثناء الحذف: ${e.toString()}';
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
    _subscription?.unsubscribe();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
