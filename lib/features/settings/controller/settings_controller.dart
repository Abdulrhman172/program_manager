import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../../core/services/supabase_service.dart';
import '../../auth/model/program_manager_model.dart';

class SettingsController extends ChangeNotifier {
  ProgramManagerModel? _currentUser;
  ProgramManagerModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  // Profile Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  // Password Form Controllers
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SettingsController() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final prmaId = prefs.getInt('prma_id');

      if (prmaId == null) {
        _errorMessage = 'لم يتم العثور على بيانات المستخدم';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await SupabaseService.client
          .from('ProgramManager')
          .select()
          .eq('prma_id', prmaId)
          .maybeSingle();

      if (response != null) {
        _currentUser = ProgramManagerModel.fromJson(response);
        nameController.text = _currentUser!.prmaName;
        emailController.text = _currentUser!.prmaEmail;
        phoneController.text = '0${_currentUser!.prmaPhoneNum}';
        
        if (_currentUser!.prmaImage != null) {
          await prefs.setString('prma_image', _currentUser!.prmaImage!);
        } else {
          await prefs.remove('prma_image');
        }
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء جلب البيانات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    if (_currentUser == null) return;
    
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      int? parsedPhone = int.tryParse(phoneController.text.trim());
      if (parsedPhone == null) {
        _errorMessage = 'رقم الهاتف غير صالح';
        _isLoading = false;
        notifyListeners();
        return;
      }

      await SupabaseService.client.from('ProgramManager').update({
        'prma_name': nameController.text.trim(),
        'prma_email': emailController.text.trim(),
        'prma_phone_num': parsedPhone,
      }).eq('prma_id', _currentUser!.prmaId);

      _successMessage = 'تم حفظ التغييرات بنجاح';
      await _loadProfile();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء حفظ التغييرات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadImage() async {
    if (_currentUser == null) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final bytes = await image.readAsBytes();
      final fileExt = path.extension(image.path);
      final fileName = '${_currentUser!.prmaId}_${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'profile_pictures/$fileName';

      // 1. Upload to Supabase Storage (assuming bucket is 'profiles')
      // Note: Make sure the 'profiles' bucket exists in your Supabase project and is public.
      await SupabaseService.client.storage
          .from('profiles')
          .uploadBinary(filePath, bytes);

      // 2. Get Public URL
      final imageUrl = SupabaseService.client.storage
          .from('profiles')
          .getPublicUrl(filePath);

      // 3. Update Database
      await SupabaseService.client.from('ProgramManager').update({
        'prma_image': imageUrl,
      }).eq('prma_id', _currentUser!.prmaId);

      _successMessage = 'تم تحديث الصورة الشخصية بنجاح';
      await _loadProfile();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء رفع الصورة: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteImage() async {
    if (_currentUser == null || _currentUser!.prmaImage == null) return;

    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      // 1. Delete from storage (extract filename from URL)
      final imageUrl = _currentUser!.prmaImage!;
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      // URL format: .../storage/v1/object/public/profiles/profile_pictures/filename.jpg
      final fileName = pathSegments.last;
      final filePath = 'profile_pictures/$fileName';

      await SupabaseService.client.storage
          .from('profiles')
          .remove([filePath]);

      // 2. Update Database to null
      await SupabaseService.client.from('ProgramManager').update({
        'prma_image': null,
      }).eq('prma_id', _currentUser!.prmaId);

      _successMessage = 'تم حذف الصورة الشخصية بنجاح';
      await _loadProfile();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء حذف الصورة: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword() async {
    if (_currentUser == null) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      _errorMessage = 'كلمة المرور الجديدة غير متطابقة';
      notifyListeners();
      return;
    }
    if (newPasswordController.text.trim().isEmpty) {
      _errorMessage = 'يرجى إدخال كلمة المرور الجديدة';
      notifyListeners();
      return;
    }

    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      // 1. Verify old password
      final verifyResponse = await SupabaseService.client
          .from('ProgramManager')
          .select('prma_pass')
          .eq('prma_id', _currentUser!.prmaId)
          .maybeSingle();

      if (verifyResponse == null || verifyResponse['prma_pass'] != currentPasswordController.text) {
        _errorMessage = 'كلمة المرور الحالية غير صحيحة';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 2. Update to new password
      await SupabaseService.client.from('ProgramManager').update({
        'prma_pass': newPasswordController.text.trim(),
      }).eq('prma_id', _currentUser!.prmaId);

      _successMessage = 'تم تحديث كلمة المرور بنجاح';
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تغيير كلمة المرور: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> deleteAccount(String pin) async {
    if (_currentUser == null) return false;
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      // 1. Verify PIN (password)
      final verifyResponse = await SupabaseService.client
          .from('ProgramManager')
          .select('prma_pass')
          .eq('prma_id', _currentUser!.prmaId)
          .maybeSingle();

      if (verifyResponse == null || verifyResponse['prma_pass'] != pin) {
        _errorMessage = 'الرمز غير صحيح، تعذر الحذف';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 2. Disable account instead of hard delete to preserve history (or delete if preferred)
      await SupabaseService.client.from('ProgramManager').update({
        'prma_isactive': false,
      }).eq('prma_id', _currentUser!.prmaId);
      
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء الحذف: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
