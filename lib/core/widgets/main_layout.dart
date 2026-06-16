import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

import '../theme/app_theme.dart';
import 'app_drawer.dart';
import '../../features/supervisors/controller/supervisors_controller.dart';
import '../../features/stages/controller/stages_controller.dart';
import '../../features/approval/controller/approval_controller.dart';
import '../../features/research/controller/research_controller.dart';
import '../../features/teams/controller/teams_controller.dart';


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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => SupervisorsController()),
        ChangeNotifierProvider(create: (_) => StagesController()),
        ChangeNotifierProvider(create: (_) => ApprovalController()),
        ChangeNotifierProvider(create: (_) => ResearchController()),
        ChangeNotifierProvider(create: (_) => TeamsController()),

      ],
      child: Consumer<DashboardController>(
        builder: (context, controller, _) {
          return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildTopBar(context, controller),
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
    ),
  );
}


  PreferredSizeWidget _buildTopBar(BuildContext context, DashboardController controller) {
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
      title: _buildTopBarContent(context, controller.userName, controller.userImage),
    );
  }

  Widget _buildTopBarContent(BuildContext context, String userName, String? userImage) {
    return SingleChildScrollView(
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
              // معلومات المستخدم مع إمكانية النقر
              InkWell(
                onTap: () {
                  Provider.of<DashboardController>(context, listen: false).setCurrentRoute('/settings');
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                          const Text(
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
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          image: userImage != null
                              ? DecorationImage(
                                  image: NetworkImage(userImage),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: userImage == null
                            ? const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // زر تسجيل الخروج
              OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('تسجيل الخروج'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }
}
