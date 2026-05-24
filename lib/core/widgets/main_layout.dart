import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/dashboard/view/dashboard_view.dart';
import '../../features/students/view/students_view.dart';
import '../../features/supervisors/view/supervisors_view.dart';
import '../../features/stages/view/stages_view.dart';
import '../../features/approval/view/approval_view.dart';
import '../../features/teams/view/teams_view.dart';
import '../../features/settings/view/settings_view.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/research/view/research_view.dart';
import '../../features/grades/view/grades_view.dart';
import '../theme/app_theme.dart';
import 'app_drawer.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  Widget _getScreen(String route) {
    switch (route) {
      case '/':
        return const DashboardView();
      case '/students':
        return const StudentsView();
      case '/supervisors':
        return const SupervisorsView();
      case '/stages':
        return const StagesView();
      case '/approval':
        return const ApprovalView();
      case '/research':
        return const ResearchView();
      case '/teams':
        return const TeamsView();
      case '/grades':
        return const GradesView();
      case '/settings':
        return const SettingsView();
      default:
        return const DashboardView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Consumer<DashboardController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildTopBar(context),
          drawer: !isDesktop
              ? Drawer(
                  child: AppDrawer(
                    currentRoute: controller.currentRoute,
                    onItemSelected: (route) {
                      controller.setCurrentRoute(route);
                      Navigator.pop(context); // Close drawer on mobile
                    },
                  ),
                )
              : null,
          body: Row(
            children: [
              if (isDesktop)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: AppColors.gray200),
                    ),
                  ),
                  child: AppDrawer(
                    currentRoute: controller.currentRoute,
                    onItemSelected: (route) {
                      controller.setCurrentRoute(route);
                    },
                  ),
                ),
              Expanded(
                child: _getScreen(controller.currentRoute),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTopBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      iconTheme: const IconThemeData(color: AppColors.foreground),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.gray200,
          height: 1.0,
        ),
      ),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // For RTL
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // عنوان النظام في اليمين (RTL)
            const Text(
              'نظام إدارة ومتابعة أبحاث التخرج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            
            // الأدوات في اليسار
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الإشعارات
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {},
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
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
                const SizedBox(width: 16),
  
                // معلومات المستخدم
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'د. أحمد محمد علي',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      'مسؤول البرنامج',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                
                // الأيقونة الشخصية
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
  
                // زر تسجيل الخروج
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('تسجيل الخروج'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
