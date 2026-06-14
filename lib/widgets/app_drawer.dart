import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatefulWidget {
  final Function(String) onItemSelected;
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.onItemSelected,
    required this.currentRoute,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final List<DrawerItem> items = [
    DrawerItem(
      id: 'dashboard',
      label: 'لوحة التحكم',
      icon: Icons.dashboard,
      route: '/',
    ),
    DrawerItem(
      id: 'stages',
      label: 'إدارة المراحل',
      icon: Icons.bar_chart,
      route: '/stages',
    ),
    DrawerItem(
      id: 'students',
      label: 'الطلاب والمشرفين',
      icon: Icons.people,
      route: '/students',
    ),
    DrawerItem(
      id: 'research',
      label: 'الاطلاع على البحوث',
      icon: Icons.book,
      route: '/research',
    ),
    DrawerItem(
      id: 'approval',
      label: 'اعتماد البحوث',
      icon: Icons.check_circle,
      route: '/approval',
    ),
    DrawerItem(
      id: 'documents',
      label: 'إدارة الوثائق',
      icon: Icons.description,
      route: '/documents',
    ),
    DrawerItem(
      id: 'notifications',
      label: 'الإشعارات',
      icon: Icons.notifications,
      route: '/notifications',
      badge: 3,
    ),
    DrawerItem(
      id: 'settings',
      label: 'الإعدادات',
      icon: Icons.settings,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.sidebarPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'ح',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نظام الإدارة',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'مسؤول البرنامج',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = widget.currentRoute == item.route;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFEFF6FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isActive
                          ? AppColors.sidebarPrimary
                          : AppColors.gray700,
                      size: 20,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? AppColors.sidebarPrimary
                            : AppColors.gray700,
                      ),
                    ),
                    trailing: item.badge != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.badge.toString(),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      widget.onItemSelected(item.route);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مسجل الدخول كـ',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'أ.د محمد علي',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('تسجيل الخروج'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
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

class DrawerItem {
  final String id;
  final String label;
  final IconData icon;
  final String route;
  final int? badge;

  DrawerItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.badge,
  });
}
