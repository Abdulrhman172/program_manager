import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'drawer_item_model.dart';

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
      icon: Icons.grid_view_rounded,
      route: '/',
    ),
    DrawerItem(
      id: 'students',
      label: 'إنشاء حسابات الطلاب',
      icon: Icons.person_add_alt_1_outlined,
      route: '/students',
    ),
    DrawerItem(
      id: 'supervisors',
      label: 'تفعيل وإيقاف المشرفين',
      icon: Icons.people_outline,
      route: '/supervisors',
    ),
    DrawerItem(
      id: 'stages',
      label: 'إدارة المراحل',
      icon: Icons.list_alt,
      route: '/stages',
    ),
    DrawerItem(
      id: 'approval',
      label: 'اعتماد المرحلة الأولى',
      icon: Icons.check_circle_outline,
      route: '/approval',
    ),
    DrawerItem(
      id: 'research',
      label: 'الاطلاع على الأبحاث',
      icon: Icons.feed_outlined,
      route: '/research',
    ),
    DrawerItem(
      id: 'teams',
      label: 'إدارة الفرق',
      icon: Icons.groups_outlined,
      route: '/teams',
    ),
    DrawerItem(
      id: 'grades',
      label: 'رصد الدرجات',
      icon: Icons.grade_outlined,
      route: '/grades',
    ),
    DrawerItem(
      id: 'settings',
      label: 'الإعدادات',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 250,
      child: Column(
        children: [
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = widget.currentRoute == item.route;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      item.icon,
                      color: isActive ? Colors.white : const Color(0xFF6B7280),
                      size: 20,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                        color: isActive ? Colors.white : const Color(0xFF4B5563),
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
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
