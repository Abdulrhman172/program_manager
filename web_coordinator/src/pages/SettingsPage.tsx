import { Save, Lock, Bell, Users, LogOut } from 'lucide-react';
import { Header } from '@/components/Header';
import { Sidebar } from '@/components/Sidebar';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useState } from 'react';

export default function SettingsPage() {
  const [activeTab, setActiveTab] = useState('profile');

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />

      <main className="flex-1 md:mr-64">
        <Header />

        <div className="p-6 space-y-6">
          {/* Page Header */}
          <div>
            <h1 className="text-3xl font-bold text-gray-900">الإعدادات</h1>
            <p className="text-gray-600 mt-1">إدارة إعدادات الحساب والنظام</p>
          </div>

          {/* Tabs */}
          <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
            <div className="flex border-b border-gray-200">
              {[
                { id: 'profile', label: 'الملف الشخصي', icon: Users },
                { id: 'security', label: 'الأمان', icon: Lock },
                { id: 'notifications', label: 'الإشعارات', icon: Bell },
              ].map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`flex items-center gap-2 px-6 py-4 font-medium transition-colors ${
                      activeTab === tab.id
                        ? 'text-blue-600 border-b-2 border-blue-600'
                        : 'text-gray-600 hover:text-gray-900'
                    }`}
                  >
                    <Icon className="w-4 h-4" />
                    {tab.label}
                  </button>
                );
              })}
            </div>

            {/* Tab Content */}
            <div className="p-6">
              {/* Profile Tab */}
              {activeTab === 'profile' && (
                <div className="space-y-6">
                  <div className="flex items-center gap-4 pb-6 border-b border-gray-200">
                    <div className="w-16 h-16 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                      <span className="text-white text-2xl font-bold">م</span>
                    </div>
                    <div>
                      <h3 className="text-lg font-bold text-gray-900">أ.د محمد علي</h3>
                      <p className="text-sm text-gray-600">مسؤول البرنامج</p>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-semibold text-gray-900 mb-2">الاسم الأول</label>
                      <Input
                        type="text"
                        defaultValue="محمد"
                        className="bg-gray-50 border-gray-200"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-900 mb-2">الاسم الأخير</label>
                      <Input
                        type="text"
                        defaultValue="علي"
                        className="bg-gray-50 border-gray-200"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-900 mb-2">البريد الإلكتروني</label>
                      <Input
                        type="email"
                        defaultValue="mohammad@university.edu"
                        className="bg-gray-50 border-gray-200"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-900 mb-2">رقم الهاتف</label>
                      <Input
                        type="tel"
                        defaultValue="+966501234567"
                        className="bg-gray-50 border-gray-200"
                      />
                    </div>
                  </div>

                  <Button className="gap-2">
                    <Save className="w-4 h-4" />
                    حفظ التغييرات
                  </Button>
                </div>
              )}

              {/* Security Tab */}
              {activeTab === 'security' && (
                <div className="space-y-6">
                  <div>
                    <h3 className="text-lg font-bold text-gray-900 mb-4">تغيير كلمة المرور</h3>
                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-semibold text-gray-900 mb-2">كلمة المرور الحالية</label>
                        <Input
                          type="password"
                          placeholder="أدخل كلمة المرور الحالية"
                          className="bg-gray-50 border-gray-200"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-900 mb-2">كلمة المرور الجديدة</label>
                        <Input
                          type="password"
                          placeholder="أدخل كلمة المرور الجديدة"
                          className="bg-gray-50 border-gray-200"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-900 mb-2">تأكيد كلمة المرور</label>
                        <Input
                          type="password"
                          placeholder="أعد إدخال كلمة المرور الجديدة"
                          className="bg-gray-50 border-gray-200"
                        />
                      </div>
                      <Button className="gap-2">
                        <Lock className="w-4 h-4" />
                        تحديث كلمة المرور
                      </Button>
                    </div>
                  </div>

                  <div className="border-t border-gray-200 pt-6">
                    <h3 className="text-lg font-bold text-gray-900 mb-4">الجلسات النشطة</h3>
                    <div className="bg-gray-50 rounded-lg p-4">
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="font-semibold text-gray-900">الجهاز الحالي</p>
                          <p className="text-sm text-gray-600">Chrome على Windows</p>
                        </div>
                        <span className="text-xs text-gray-500">نشط الآن</span>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* Notifications Tab */}
              {activeTab === 'notifications' && (
                <div className="space-y-6">
                  <div className="space-y-4">
                    {[
                      { label: 'إشعارات البحوث الجديدة', description: 'تنبيهات عند تقديم بحوث جديدة' },
                      { label: 'تحديثات المراحل', description: 'إشعارات بتحديثات مراحل البحث' },
                      { label: 'الموافقات والرفضات', description: 'إخطارات بقرارات الاعتماد' },
                      { label: 'التقارير الأسبوعية', description: 'التقارير الدورية عن حالة النظام' },
                    ].map((item, index) => (
                      <div key={index} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                        <div>
                          <p className="font-semibold text-gray-900">{item.label}</p>
                          <p className="text-sm text-gray-600">{item.description}</p>
                        </div>
                        <input
                          type="checkbox"
                          defaultChecked
                          className="w-5 h-5 rounded border-gray-300 text-blue-600"
                        />
                      </div>
                    ))}
                  </div>

                  <Button className="gap-2">
                    <Save className="w-4 h-4" />
                    حفظ تفضيلات الإشعارات
                  </Button>
                </div>
              )}
            </div>
          </div>

          {/* Danger Zone */}
          <div className="bg-red-50 border border-red-200 rounded-lg p-6">
            <h3 className="text-lg font-bold text-red-900 mb-4">منطقة الخطر</h3>
            <p className="text-sm text-red-700 mb-4">
              تسجيل الخروج من جميع الأجهزة والجلسات
            </p>
            <Button
              variant="outline"
              className="gap-2 text-red-600 hover:bg-red-50 border-red-200"
            >
              <LogOut className="w-4 h-4" />
              تسجيل الخروج من جميع الأجهزة
            </Button>
          </div>
        </div>
      </main>
    </div>
  );
}
