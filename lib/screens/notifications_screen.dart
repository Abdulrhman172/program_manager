import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> notifications = [
    AppNotification(
      id: '1',
      title: 'أبحاث بحاجة إلى مراجعة',
      message: 'هناك 12 بحث تنتظر مراجعة المرحلة الأولى',
      type: 'warning',
      timestamp: '2026-04-02 10:30',
      read: false,
    ),
    AppNotification(
      id: '2',
      title: 'موعد المرحلة الثانية اقترب',
      message: 'يتبقى 5 أيام لانتهاء المرحلة الثانية من المشروع',
      type: 'info',
      timestamp: '2026-04-02 09:15',
      read: false,
    ),
    AppNotification(
      id: '3',
      title: 'تم اعتماد مشروع جديد',
      message: 'تم اعتماد مشروع "نظام إدارة المكتبات الذكية" بنجاح',
      type: 'success',
      timestamp: '2026-04-01 15:45',
      read: true,
    ),
    AppNotification(
      id: '4',
      title: 'طالب جديد مسجل',
      message: 'تم تسجيل طالب جديد في البرنامج',
      type: 'info',
      timestamp: '2026-04-01 12:20',
      read: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      notifications = notifications.map((n) {
        if (n.id == id) {
          return AppNotification(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            timestamp: n.timestamp,
            read: true,
          );
        }
        return n;
      }).toList();
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'warning':
        return const Color(0xFFFEE2E2);
      case 'success':
        return const Color(0xFFDCFCE7);
      case 'info':
      default:
        return const Color(0xFFDEF2FF);
    }
  }

  Color _getTypeTextColor(String type) {
    switch (type) {
      case 'warning':
        return const Color(0xFFB91C1C);
      case 'success':
        return AppColors.success;
      case 'info':
      default:
        return const Color(0xFF0369A1);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'warning':
        return Icons.error_outline;
      case 'success':
        return Icons.check_circle_outline;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n.read).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        elevation: 0,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  notifications = notifications
                      .map((n) => AppNotification(
                            id: n.id,
                            title: n.title,
                            message: n.message,
                            type: n.type,
                            timestamp: n.timestamp,
                            read: true,
                          ))
                      .toList();
                });
              },
              child: const Text('تحديد الكل كمقروء'),
            ),
        ],
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
                        'الإشعارات',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'لديك $unreadCount إشعارات غير مقروءة',
                        style: const TextStyle(color: AppColors.gray600),
                      ),
                    ],
                  ),
                  if (notifications.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          notifications.clear();
                        });
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('حذف الكل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Notifications List
              if (notifications.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: AppColors.gray300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد إشعارات',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'جميع الإشعارات قد تم حذفها',
                          style: TextStyle(color: AppColors.gray600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: notification.read
                            ? AppColors.white
                            : const Color(0xFFFAFAFA),
                        border: Border.all(
                          color: notification.read
                              ? AppColors.gray200
                              : AppColors.primary,
                          width: notification.read ? 1 : 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getTypeColor(notification.type),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                _getTypeIcon(notification.type),
                                color: _getTypeTextColor(notification.type),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: notification.read
                                                ? FontWeight.normal
                                                : FontWeight.w600,
                                            color: AppColors.foreground,
                                          ),
                                        ),
                                      ),
                                      if (!notification.read)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notification.timestamp,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Actions
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                if (!notification.read)
                                  PopupMenuItem(
                                    onTap: () =>
                                        _markAsRead(notification.id),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.done, size: 18),
                                        SizedBox(width: 8),
                                        Text('وضع علامة كمقروء'),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem(
                                  onTap: () =>
                                      _deleteNotification(notification.id),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete, size: 18),
                                      SizedBox(width: 8),
                                      Text('حذف'),
                                    ],
                                  ),
                                ),
                              ],
                              child: const Icon(Icons.more_vert, size: 18),
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
