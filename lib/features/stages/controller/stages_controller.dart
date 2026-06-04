import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/supabase_service.dart';
import '../model/stage_model.dart';

class StagesController extends ChangeNotifier {
  List<StageModel> _stages = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  String? _editingStageId;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  List<StageModel> get stages => _stages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get editingStageId => _editingStageId;

  int get totalStages => _stages.length;
  int get activeStages => _stages.where((s) => s.isActive).length;
  int get upcomingStages =>
      _stages.where((s) => s.status == 'قادمة').length;

  StagesController() {
    fetchStages();
  }

  Future<void> fetchStages() async {
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
          .from('stages')
          .select()
          .eq('id_program', idProgram)
          .order('stages_id', ascending: true);

      _stages =
          (response as List).map((e) => StageModel.fromJson(e)).toList();
    } catch (e) {
      _errorMessage = 'حدث خطأ في جلب المراحل: ${e.toString()}';
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void openEditForm(StageModel stage) {
    _editingStageId = stage.id.toString();
    startDateController.text = stage.startDate;
    endDateController.text = stage.endDate;
    notifyListeners();
  }

  void closeEditForm() {
    _editingStageId = null;
    startDateController.clear();
    endDateController.clear();
    notifyListeners();
  }

  Future<void> saveDates(int id) async {
    final index = _stages.indexWhere((s) => s.id == id);
    if (index == -1) return;

    // احفظ القيم قبل مسح الحقول
    final newStartDate = startDateController.text;
    final newEndDate = endDateController.text;

    // احسب ما إذا كانت المرحلة ستصبح نشطة بناءً على التواريخ الجديدة
    bool newIsActive = false;
    if (newStartDate.isNotEmpty && newEndDate.isNotEmpty) {
      try {
        final now = DateTime.now();
        final start = DateTime.parse(newStartDate);
        final end = DateTime.parse(newEndDate).add(const Duration(days: 1));
        newIsActive = now.isAfter(start) && now.isBefore(end);
      } catch (_) {}
    }

    // تحديث محلي
    _stages[index].startDate = newStartDate;
    _stages[index].endDate = newEndDate;

    // أغلق النموذج (هذا يمسح controllers - لذلك نفعل هذا بعد حفظ القيم)
    closeEditForm();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');
      
      if (idProgram != null) {
        await SupabaseService.client.from('stages').update({
          'start_date': newStartDate.isEmpty ? null : newStartDate,
          'end_date': newEndDate.isEmpty ? null : newEndDate,
          'stage_isactive': newIsActive,
        }).eq('stages_id', id).eq('id_program', idProgram);

        // أعد تحميل البيانات لضمان التزامن مع قاعدة البيانات
        await fetchStages();
      }
    } catch (e) {
      if (!_isDisposed) {
        _errorMessage = 'فشل حفظ التواريخ: ${e.toString()}';
        notifyListeners();
      }
    }
  }

  Future<void> pickDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateTime.parse(controller.text);
      }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF16A34A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
