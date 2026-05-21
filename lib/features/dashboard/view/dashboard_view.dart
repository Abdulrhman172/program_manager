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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'مرحباً بك في لوحة التحكم',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'نظرة عامة على نظام إدارة أبحاث التخرج',
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),

                // Stats Cards
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return GridView.count(
                      crossAxisCount: isMobile ? 1 : (constraints.maxWidth < 900 ? 2 : 4),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      childAspectRatio: isMobile ? 2.5 : 1.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        _SimpleStatCard(
                          title: 'المراحل النشطة حالياً',
                          value: '2',
                          icon: Icons.check_circle_outline,
                        ),
                        _SimpleStatCard(
                          title: 'عدد المشرفين المفعلين',
                          value: '28',
                          icon: Icons.person_outline,
                        ),
                        _SimpleStatCard(
                          title: 'عدد الطلاب المسجلين',
                          value: '135',
                          icon: Icons.people_outline,
                        ),
                        _SimpleStatCard(
                          title: 'عدد أبحاث التخرج',
                          value: '45',
                          icon: Icons.description_outlined,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Notifications Section
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'الإشعارات الهامة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      _NotificationItem(
                        title: 'أبحاث جديدة تحتاج للاعتماد',
                        subtitle: 'هناك 12 بحث تخرج في انتظار اعتماد المرحلة الأولى',
                        time: 'منذ ساعتين',
                        bgColor: Color(0xFFFFF7ED), // Orange light
                        accentColor: Color(0xFFEA580C), // Orange
                      ),
                      SizedBox(height: 12),
                      _NotificationItem(
                        title: 'انتهاء موعد المرحلة الثانية',
                        subtitle: 'سينتهي موعد تسليم المرحلة الثانية خلال 5 أيام',
                        time: 'منذ 5 ساعات',
                        bgColor: Color(0xFFEFF6FF), // Blue light
                        accentColor: AppColors.primary,
                      ),
                      SizedBox(height: 12),
                      _NotificationItem(
                        title: 'تم تفعيل مشرف جديد',
                        subtitle: 'تم تفعيل د. سالم أحمد كمشرف أكاديمي في النظام',
                        time: 'أمس',
                        bgColor: Color(0xFFF0FDF4), // Green light
                        accentColor: AppColors.success,
                      ),
                    ],
                  ),
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
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    reverse: true, // RTL layout
                    children: const [
                      _StageCard(
                        title: 'المرحلة الأولى - اختيار عنوان البحث',
                        dateInfo: 'نشطة - تنتهي في 28/02/2026',
                        isActive: true,
                      ),
                      SizedBox(width: 16),
                      _StageCard(
                        title: 'المرحلة الثانية - إنجاز الخطة',
                        dateInfo: 'نشطة - تنتهي في 25/03/2026',
                        isActive: true,
                      ),
                      SizedBox(width: 16),
                      _StageCard(
                        title: 'المرحلة الثالثة - مناقشة الخطة',
                        dateInfo: 'قادمة - تبدأ في 26/03/2026',
                        isActive: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color bgColor;
  final Color accentColor;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.bgColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          right: BorderSide(color: accentColor, width: 4), // Accent border on the right
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
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
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? const Color(0xFF86EFAC) : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.success : AppColors.gray400,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dateInfo,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.success : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
