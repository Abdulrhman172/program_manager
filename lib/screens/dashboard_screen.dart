import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/notification_card.dart';
import '../widgets/milestone_card.dart';
import '../widgets/app_drawer.dart';
import 'students_screen.dart';
import 'stages_screen.dart';
import 'approval_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _currentRoute = '/';

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });

    Widget screen;
    switch (route) {
      case '/students':
        screen = const StudentsScreen();
        break;
      case '/stages':
        screen = const StagesScreen();
        break;
      case '/approval':
        screen = const ApprovalScreen();
        break;
      case '/notifications':
        screen = const NotificationsScreen();
        break;
      case '/settings':
        screen = const SettingsScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) {
      setState(() {
        _currentRoute = '/';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        elevation: 0,
        actions: [
          // Search
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن البحوث أو الطلاب...',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _navigateTo('/notifications'),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // User Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry<dynamic>>[
                const PopupMenuItem(
                  child: Text('الملف الشخصي'),
                ),
                const PopupMenuItem(
                  child: Text('الإعدادات'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  child: Text('تسجيل الخروج'),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF60A5FA),
                            AppColors.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'م',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'أ.د محمد علي',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'مسؤول البرنامج',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.expand_more, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: _currentRoute,
        onItemSelected: _navigateTo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك في لوحة التحكم',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'نظرة عامة على إدارة أبحاث التخرج والمتابعة',
                      style: TextStyle(
                        color: Color(0xFFBFDBFE),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Section
              Text(
                'الإحصائيات',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 1200
                    ? 4
                    : MediaQuery.of(context).size.width > 800
                        ? 2
                        : 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    icon: Icons.book,
                    label: 'إجمالي البحوث',
                    value: 45,
                    change: 12,
                    changeLabel: 'منذ الشهر الماضي',
                    color: 'blue',
                  ),
                  StatCard(
                    icon: Icons.people,
                    label: 'الطلاب المسجلين',
                    value: 135,
                    change: 8,
                    changeLabel: 'نشطين هذا الفصل',
                    color: 'green',
                  ),
                  StatCard(
                    icon: Icons.person_outline,
                    label: 'المشرفين',
                    value: 28,
                    change: -2,
                    changeLabel: 'متاح للإشراف',
                    color: 'orange',
                  ),
                  StatCard(
                    icon: Icons.check_circle,
                    label: 'المراحل المكتملة',
                    value: 2,
                    changeLabel: 'من 5 مراحل',
                    color: 'red',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Notifications and Quick Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الإشعارات الهامة',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        const Column(
                          children: [
                            NotificationCard(
                              type: 'warning',
                              title: 'أبحاث بحاجة إلى مراجعة',
                              description:
                                  'هناك 12 بحث تنتظر مراجعة المرحلة الأولى',
                              timestamp: 'منذ ساعة',
                            ),
                            SizedBox(height: 12),
                            NotificationCard(
                              type: 'info',
                              title: 'موعد المرحلة الثانية اقترب',
                              description:
                                  'يتبقى 5 أيام لانتهاء المرحلة الثانية من المشروع',
                              timestamp: 'منذ 3 ساعات',
                            ),
                            SizedBox(height: 12),
                            NotificationCard(
                              type: 'success',
                              title: 'تم اعتماد مشروع جديد',
                              description:
                                  'تم اعتماد مشروع "نظام إدارة المكتبات الذكية" بنجاح',
                              timestamp: 'أمس',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الإجراءات السريعة',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () => _navigateTo('/students'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                child: const Text('إضافة طالب جديد'),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _navigateTo('/students'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                child: const Text('إضافة مشرف'),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _navigateTo('/approval'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                child: const Text('اعتماد بحث'),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _navigateTo('/stages'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                child: const Text('إنشاء مرحلة جديدة'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Milestones Section
              Text(
                'المراحل الرئيسية',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 1200
                    ? 3
                    : MediaQuery.of(context).size.width > 800
                        ? 2
                        : 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MilestoneCard(
                    stage: 'المرحلة الأولى - اختيار الموضوع',
                    status: 'completed',
                    date: '28/03/2026',
                    description: 'اختيار موضوع البحث والموافقة عليه',
                  ),
                  MilestoneCard(
                    stage: 'المرحلة الثانية - إجازة الخطة',
                    status: 'in-progress',
                    date: '25/01/2026',
                    description: 'تقديم وإجازة خطة البحث',
                  ),
                  MilestoneCard(
                    stage: 'المرحلة الثالثة - مناقشة الخطة',
                    status: 'pending',
                    date: 'قادمة',
                    description: 'مناقشة الخطة مع لجنة التقييم',
                  ),
                  MilestoneCard(
                    stage: 'المرحلة الرابعة - تنفيذ البحث',
                    status: 'pending',
                    date: 'قادمة',
                    description: 'تنفيذ البحث وجمع البيانات',
                  ),
                  MilestoneCard(
                    stage: 'المرحلة الخامسة - المناقشة النهائية',
                    status: 'pending',
                    date: 'قادمة',
                    description: 'المناقشة النهائية وتقييم البحث',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
