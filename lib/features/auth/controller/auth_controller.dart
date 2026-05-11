import 'package:flutter/material.dart';

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
      _studentIdError = 'يرجى إدخال الرقم الجامعي';
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
    if (!validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    // محاكاة عملية تسجيل الدخول
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;

    // للتبسيط، سنعتبر أي إدخال صحيح في هذه المرحلة
    // يمكنك لاحقاً إضافة التحقق الفعلي هنا
    if (studentIdController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
      return true; // نجاح تسجيل الدخول
    } else {
      _errorMessage = 'الرقم الجامعي أو كلمة المرور غير صحيحة';
      notifyListeners();
      return false; // فشل تسجيل الدخول
    }
  }

  @override
  void dispose() {
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
