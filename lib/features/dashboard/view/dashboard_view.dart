import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final padding = isMobile ? 12.0 : 24.0;
              return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'مرحباً بك في لوحة التحكم',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: isMobile ? 18 : 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'نظرة عامة على نظام إدارة أبحاث التخرج',
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
                const SizedBox(height: 32),

                // Stats Cards
                if (controller.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (controller.errorMessage != null)
                  Center(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final columns = width < 480 ? 2 : (width < 900 ? 2 : 4);
                      final ratio = width < 480 ? 1.5 : (width < 900 ? 1.8 : 2.0);
                      return GridView.count(
                        crossAxisCount: columns,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        shrinkWrap: true,
                        childAspectRatio: ratio,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _SimpleStatCard(
                            title: 'الأبحاث النشطة حالياً',
                            value: controller.activeResearchesCount.toString(),
                            icon: Icons.check_circle_outline,
                          ),
                          _SimpleStatCard(
                            title: 'عدد المشرفين المفعلين',
                            value: controller.supervisorsCount.toString(),
                            icon: Icons.person_outline,
                          ),
                          _SimpleStatCard(
                            title: 'عدد الطلاب المسجلين',
                            value: controller.studentsCount.toString(),
                            icon: Icons.people_outline,
                          ),
                          _SimpleStatCard(
                            title: 'عدد الأبحاث المكتملة',
                            value: controller.finishedResearchesCount.toString(),
                            icon: Icons.description_outlined,
                          ),
                        ],
                      );
                    },
                  ),
                const SizedBox(height: 32),

                // Current Stages Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'المراحل الحالية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.stages.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: const Center(
                      child: Text(
                        'لا توجد مراحل حالياً',
                        style: TextStyle(color: AppColors.gray500, fontSize: 16),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.stages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final stage = controller.stages[index];
                      final isActive = stage.status == 'نشطة';
                      String dateInfo = '';
                      if (stage.status == 'نشطة' || stage.status == 'منتهية') {
                        dateInfo = '${stage.status} - تنتهي في ${stage.endDate}';
                      } else if (stage.status == 'قادمة') {
                        dateInfo = '${stage.status} - تبدأ في ${stage.startDate}';
                      } else {
                        dateInfo = stage.status;
                      }
                      
                      return _StageCard(
                        title: stage.title,
                        dateInfo: dateInfo,
                        isActive: isActive,
                      );
                    },
                  ),
              ],
            ),
          );
            },
          ),
        );
      },
    );
  }
}

class _SimpleStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SimpleStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9), // Light gray background for icon
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF64748B), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}


class _StageCard extends StatelessWidget {
  final String title;
  final String dateInfo;
  final bool isActive;

  const _StageCard({
    required this.title,
    required this.dateInfo,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xFF86EFAC) : AppColors.gray200,
        ),
        boxShadow: isActive 
          ? [BoxShadow(color: const Color(0xFF86EFAC).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))]
          : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // التاريخ أو الحالة على اليسار
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dateInfo,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.success : AppColors.gray600,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // العنوان والنقطة على اليمين
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isActive ? AppColors.foreground : AppColors.gray700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success : AppColors.gray300,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? const Color(0xFFDCFCE7) : AppColors.gray200,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
