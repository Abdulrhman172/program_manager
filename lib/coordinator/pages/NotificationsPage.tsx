import { Bell, Trash2, Archive } from 'lucide-react';
import { Header } from '@/components/Header';
import { Sidebar } from '@/components/Sidebar';
import { Button } from '@/components/ui/button';
import { useState } from 'react';

interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'info' | 'warning' | 'success' | 'error';
  timestamp: string;
  read: boolean;
}

const mockNotifications: Notification[] = [
  {
    id: '1',
    title: 'بحث جديد قيد الانتظار',
    message: 'تم تقديم بحث جديد من الطالب أحمد محمد علي بعنوان "نظام إدارة المكتبات الذكية"',
    type: 'info',
    timestamp: 'منذ 5 دقائق',
    read: false,
  },
  {
    id: '2',
    title: 'تحديث المرحلة الثانية',
    message: 'تم تحديث موعد انتهاء المرحلة الثانية إلى 25/01/2026',
    type: 'warning',
    timestamp: 'منذ ساعة',
    read: false,
  },
  {
    id: '3',
    title: 'اعتماد بحث بنجاح',
    message: 'تم اعتماد بحث "نظام أمان الشبكات المتقدم" بنجاح',
    type: 'success',
    timestamp: 'منذ 3 ساعات',
    read: true,
  },
  {
    id: '4',
    title: 'تنبيه: مشرف غير متاح',
    message: 'المشرف أ.د محمد السلام غير متاح حالياً للإشراف على مشاريع جديدة',
    type: 'error',
    timestamp: 'أمس',
    read: true,
  },
  {
    id: '5',
    title: 'تقرير أسبوعي',
    message: 'تم إنشاء التقرير الأسبوعي لحالة البحوث والمشاريع',
    type: 'info',
    timestamp: 'أمس',
    read: true,
  },
];

const typeConfig = {
  info: { bgColor: 'bg-blue-50', borderColor: 'border-blue-200', textColor: 'text-blue-700', icon: '📋' },
  warning: { bgColor: 'bg-yellow-50', borderColor: 'border-yellow-200', textColor: 'text-yellow-700', icon: '⚠️' },
  success: { bgColor: 'bg-green-50', borderColor: 'border-green-200', textColor: 'text-green-700', icon: '✓' },
  error: { bgColor: 'bg-red-50', borderColor: 'border-red-200', textColor: 'text-red-700', icon: '✕' },
};

export default function NotificationsPage() {
  const [notifications, setNotifications] = useState<Notification[]>(mockNotifications);

  const handleMarkAsRead = (id: string) => {
    setNotifications(
      notifications.map(n => n.id === id ? { ...n, read: true } : n)
    );
  };

  const handleDelete = (id: string) => {
    setNotifications(notifications.filter(n => n.id !== id));
  };

  const unreadCount = notifications.filter(n => !n.read).length;

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />

      <main className="flex-1 md:mr-64">
        <Header />

        <div className="p-6 space-y-6">
          {/* Page Header */}
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">الإشعارات</h1>
              <p className="text-gray-600 mt-1">إدارة جميع الإشعارات والتنبيهات</p>
            </div>
            {unreadCount > 0 && (
              <div className="bg-blue-50 border border-blue-200 rounded-lg px-4 py-2">
                <p className="text-sm font-semibold text-blue-700">
                  {unreadCount} إشعار غير مقروء
                </p>
              </div>
            )}
          </div>

          {/* Notifications List */}
          <div className="space-y-3">
            {notifications.map((notification) => {
              const config = typeConfig[notification.type];
              return (
                <div
                  key={notification.id}
                  className={`${config.bgColor} ${config.borderColor} border rounded-lg p-4 transition-all hover:shadow-md ${
                    !notification.read ? 'ring-2 ring-offset-2 ring-blue-300' : ''
                  }`}
                >
                  <div className="flex items-start gap-4">
                    <span className="text-2xl">{config.icon}</span>
                    <div className="flex-1">
                      <div className="flex items-start justify-between mb-2">
                        <div>
                          <h3 className={`font-semibold text-gray-900 ${config.textColor}`}>
                            {notification.title}
                          </h3>
                          {!notification.read && (
                            <span className="inline-block mt-1 px-2 py-1 bg-blue-600 text-white text-xs rounded-full">
                              جديد
                            </span>
                          )}
                        </div>
                        <span className="text-xs text-gray-500">{notification.timestamp}</span>
                      </div>
                      <p className="text-sm text-gray-700 mb-3">{notification.message}</p>
                      <div className="flex gap-2">
                        {!notification.read && (
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() => handleMarkAsRead(notification.id)}
                            className="text-xs"
                          >
                            <Bell className="w-3 h-3 mr-1" />
                            وضع علامة كمقروء
                          </Button>
                        )}
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => handleDelete(notification.id)}
                          className="text-xs text-red-600 hover:bg-red-50"
                        >
                          <Trash2 className="w-3 h-3 mr-1" />
                          حذف
                        </Button>
                      </div>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          {notifications.length === 0 && (
            <div className="bg-white rounded-lg border border-gray-200 p-12 text-center">
              <Bell className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-gray-900 mb-2">لا توجد إشعارات</h3>
              <p className="text-gray-600">جميع إشعاراتك محدثة. سيتم إخطارك بأي تحديثات جديدة.</p>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
