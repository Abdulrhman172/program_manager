import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/stage_model.dart';

class StagesScreen extends StatefulWidget {
  const StagesScreen({super.key});

  @override
  State<StagesScreen> createState() => _StagesScreenState();
}

class _StagesScreenState extends State<StagesScreen> {
  final List<Stage> stages = [
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

  Color _getStatusColor(String status) {
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

  Color _getStatusTextColor(String status) {
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

  String _getStatusLabel(String status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المراحل'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إدارة المراحل',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'إدارة مراحل البحث والمواعيد النهائية',
                        style: TextStyle(color: AppColors.gray600),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة مرحلة جديدة'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stages List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  final stage = stages[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stage.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stage.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(stage.status),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getStatusLabel(stage.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusTextColor(stage.status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),

                          // Dates
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'تاريخ البداية',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stage.startDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'تاريخ الانتهاء',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stage.endDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'المهام',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${stage.tasksCount} مهمة',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('تعديل'),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.delete, size: 16),
                                label: const Text('حذف'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
