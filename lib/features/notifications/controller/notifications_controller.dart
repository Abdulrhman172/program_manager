import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../model/notification_model.dart';

/// Controller for the Notifications screen.
/// Manages notification data, read status, and deletion logic.
class NotificationsController extends ChangeNotifier {
  List<AppNotification> _notifications = [
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

  List<AppNotification> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.read).length;

  void markAsRead(String id) {
    _notifications = _notifications.map((n) {
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
    notifyListeners();
  }

  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => AppNotification(
              id: n.id,
              title: n.title,
              message: n.message,
              type: n.type,
              timestamp: n.timestamp,
              read: true,
            ))
        .toList();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void deleteAll() {
    _notifications.clear();
    notifyListeners();
  }

  Color getTypeColor(String type) {
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

  Color getTypeTextColor(String type) {
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

  IconData getTypeIcon(String type) {
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
}
