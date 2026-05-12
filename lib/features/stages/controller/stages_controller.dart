import 'package:flutter/material.dart';
import '../model/stage_model.dart';
import 'package:intl/intl.dart';

class StagesController extends ChangeNotifier {
  final List<StageModel> _stages = [
    StageModel(
      id: '1',
      title: 'المرحلة الأولى - اختيار عنوان البحث',
      description: 'اختيار وتحديد عنوان البحث وموضوعه',
      startDate: '01/02/2026',
      endDate: '28/02/2026',
      status: 'نشطة',
    ),
    StageModel(
      id: '2',
      title: 'المرحلة الثانية - إنجاز الخطة',
      description: 'إعداد وإنجاز خطة البحث الكاملة',
      startDate: '01/03/2026',
      endDate: '25/03/2026',
      status: 'نشطة',
    ),
    StageModel(
      id: '3',
      title: 'المرحلة الثالثة - اعتماد الخطة',
      description: 'اعتماد الخطة من قبل المشرف',
      startDate: '26/03/2026',
      endDate: '10/04/2026',
      status: 'قادمة',
    ),
  ];

  String? _editingStageId;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  List<StageModel> get stages => _stages;
  String? get editingStageId => _editingStageId;

  int get totalStages => _stages.length;
  int get activeStages => _stages.where((s) => s.status == 'نشطة').length;
  int get upcomingStages => _stages.where((s) => s.status == 'قادمة').length;

  void openEditForm(StageModel stage) {
    _editingStageId = stage.id;
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

  void saveDates(String id) {
    final index = _stages.indexWhere((s) => s.id == id);
    if (index != -1) {
      _stages[index].startDate = startDateController.text;
      _stages[index].endDate = endDateController.text;
      closeEditForm();
    }
  }

  Future<void> pickDate(BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
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
              primary: Color(0xFF16A34A), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
