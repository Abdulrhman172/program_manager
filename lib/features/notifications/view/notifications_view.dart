import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/notifications_controller.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsController(),
      child: Consumer<NotificationsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('الإشعارات'),
              elevation: 0,
              actions: [
                if (controller.unreadCount > 0)
                  TextButton(
                    onPressed: () => controller.markAllAsRead(),
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
                              'لديك ${controller.unreadCount} إشعارات غير مقروءة',
                              style: const TextStyle(color: AppColors.gray600),
                            ),
                          ],
                        ),
                        if (controller.notifications.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => controller.deleteAll(),
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
                    if (controller.notifications.isEmpty)
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
                        itemCount: controller.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = controller.notifications[index];
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
                                      color: controller.getTypeColor(notification.type),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      controller.getTypeIcon(notification.type),
                                      color: controller.getTypeTextColor(notification.type),
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
                                              controller.markAsRead(notification.id),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.done, size: 18),
                                              SizedBox(width: 8),
                                              Text('وضع علامة كمقروء'),
                                            ],
                                          ),
                                        ),
                                      PopupMenuItem(
                                        onTap: () => controller
                                            .deleteNotification(notification.id),
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
        },
      ),
    );
  }
}
