import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../model/stage_model.dart';

/// Controller for the Stages screen.
/// Manages stages data and status-related logic.
class StagesController extends ChangeNotifier {
  final List<Stage> _stages = [
    Stage(
      id: '1',
      name: 'المرحلة الأولى - اختيار الموضوع',
      description: 'اختيار موضوع البحث والموافقة عليه من قبل المشرف',
      startDate: '01/01/2026',
      endDate: '28/03/2026',
      status: 'completed',
      tasksCount: 45,
    ),
    Stage(
      id: '2',
      name: 'المرحلة الثانية - إجازة الخطة',
      description: 'تقديم وإجازة خطة البحث من قبل لجنة التقييم',
      startDate: '29/03/2026',
      endDate: '25/01/2026',
      status: 'active',
      tasksCount: 38,
    ),
    Stage(
      id: '3',
      name: 'المرحلة الثالثة - مناقشة الخطة',
      description: 'مناقشة الخطة مع لجنة التقييم وتقديم الملاحظات',
      startDate: '26/01/2026',
      endDate: '15/02/2026',
      status: 'pending',
      tasksCount: 0,
    ),
    Stage(
      id: '4',
      name: 'المرحلة الرابعة - تنفيذ البحث',
      description: 'تنفيذ البحث وجمع البيانات والمعلومات',
      startDate: '16/02/2026',
      endDate: '30/04/2026',
      status: 'pending',
      tasksCount: 0,
    ),
    Stage(
      id: '5',
      name: 'المرحلة الخامسة - المناقشة النهائية',
      description: 'المناقشة النهائية وتقييم البحث',
      startDate: '01/05/2026',
      endDate: '30/05/2026',
      status: 'pending',
      tasksCount: 0,
    ),
  ];

  List<Stage> get stages => _stages;

  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFFDCFCE7);
      case 'active':
        return const Color(0xFFDEF2FF);
      case 'pending':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'active':
        return AppColors.primary;
      case 'pending':
      default:
        return AppColors.gray700;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'مكتملة';
      case 'active':
        return 'نشطة';
      case 'pending':
      default:
        return 'قادمة';
    }
  }
}
