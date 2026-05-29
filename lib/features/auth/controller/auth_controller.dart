import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/supabase_service.dart';
import '../model/program_manager_model.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _studentIdError;
  String? get studentIdError => _studentIdError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  bool validate() {
    bool isValid = true;
    _studentIdError = null;
    _passwordError = null;
    _errorMessage = null;

    if (studentIdController.text.trim().isEmpty) {
      _studentIdError = 'يرجى إدخال اسم المستخدم';
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      _passwordError = 'يرجى إدخال كلمة المرور';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<bool> login() async {
    if (!validate()) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('ProgramManager')
          .select()
          .eq('prma_username', studentIdController.text.trim())
          .eq('prma_pass', passwordController.text.trim())
          .eq('prma_isactive', true)
          .maybeSingle();

      _isLoading = false;

      if (response == null) {
        _errorMessage = 'اسم المستخدم أو كلمة المرور غير صحيحة';
        notifyListeners();
        return false;
      }

      final manager = ProgramManagerModel.fromJson(response);

      // حفظ بيانات الجلسة في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('prma_id', manager.prmaId);
      await prefs.setString('prma_name', manager.prmaName);
      await prefs.setString('prma_email', manager.prmaEmail);
      await prefs.setString('prma_username', manager.prmaUsername);
      await prefs.setInt('id_program', manager.idProgram);

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'حدث خطأ في الاتصال، يرجى المحاولة مجدداً';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
