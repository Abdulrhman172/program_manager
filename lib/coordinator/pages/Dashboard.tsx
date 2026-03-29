import { BarChart3, Users, BookOpen, CheckCircle } from 'lucide-react';
import { Header } from '@/components/Header';
import { Sidebar } from '@/components/Sidebar';
import { StatCard } from '@/components/StatCard';
import { NotificationCard } from '@/components/NotificationCard';
import { MilestoneCard } from '@/components/MilestoneCard';
import { Button } from '@/components/ui/button';

export default function Dashboard() {
  return (
    <div className="flex min-h-screen bg-gray-50">
      {/* Sidebar */}
      <Sidebar />

      {/* Main Content */}
      <main className="flex-1 md:mr-64">
        {/* Header */}
        <Header />

        {/* Content */}
        <div className="p-6 space-y-6">
          {/* Welcome Section */}
          <div className="bg-gradient-to-r from-blue-600 to-blue-700 rounded-lg p-8 text-white shadow-lg">
            <h1 className="text-3xl font-bold mb-2">مرحباً بك في لوحة التحكم</h1>
            <p className="text-blue-100">نظرة عامة على إدارة أبحاث التخرج والمتابعة</p>
          </div>

          {/* Statistics Section */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <StatCard
              icon={<BookOpen className="w-6 h-6" />}
              label="إجمالي البحوث"
              value={45}
              change={12}
              changeLabel="منذ الشهر الماضي"
              color="blue"
            />
            <StatCard
              icon={<Users className="w-6 h-6" />}
              label="الطلاب المسجلين"
              value={135}
              change={8}
              changeLabel="نشطين هذا الفصل"
              color="green"
            />
            <StatCard
              icon={<CheckCircle className="w-6 h-6" />}
              label="المشرفين"
              value={28}
              change={-2}
              changeLabel="متاح للإشراف"
              color="orange"
            />
            <StatCard
              icon={<BarChart3 className="w-6 h-6" />}
              label="المراحل المكتملة"
              value={2}
              changeLabel="من 5 مراحل"
              color="red"
            />
          </div>

          {/* Notifications Section */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2">
              <div className="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-lg font-bold text-gray-900">الإشعارات الهامة</h2>
                  <Button variant="ghost" size="sm">عرض الكل</Button>
                </div>

                <div className="space-y-3">
                  <NotificationCard
                    type="warning"
                    title="أبحاث بحاجة إلى مراجعة"
                    description="هناك 12 بحث تنتظر مراجعة المرحلة الأولى"
                    timestamp="منذ ساعة"
                  />
                  <NotificationCard
                    type="info"
                    title="موعد المرحلة الثانية اقترب"
                    description="يتبقى 5 أيام لانتهاء المرحلة الثانية من المشروع"
                    timestamp="منذ 3 ساعات"
                  />
                  <NotificationCard
                    type="success"
                    title="تم اعتماد مشروع جديد"
                    description="تم اعتماد مشروع 'نظام إدارة المكتبات الذكية' بنجاح"
                    timestamp="أمس"
                  />
                </div>
              </div>
            </div>

            {/* Quick Actions */}
            <div className="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
              <h2 className="text-lg font-bold text-gray-900 mb-4">الإجراءات السريعة</h2>
              <div className="space-y-3">
                <Button className="w-full justify-start" variant="outline">
                  إضافة طالب جديد
                </Button>
                <Button className="w-full justify-start" variant="outline">
                  إضافة مشرف
                </Button>
                <Button className="w-full justify-start" variant="outline">
                  اعتماد بحث
                </Button>
                <Button className="w-full justify-start" variant="outline">
                  إنشاء مرحلة جديدة
                </Button>
              </div>
            </div>
          </div>

          {/* Milestones Section */}
          <div className="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
            <h2 className="text-lg font-bold text-gray-900 mb-4">المراحل الرئيسية</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <MilestoneCard
                stage="المرحلة الأولى - اختيار الموضوع"
                status="completed"
                date="28/03/2026"
                description="اختيار موضوع البحث والموافقة عليه"
              />
              <MilestoneCard
                stage="المرحلة الثانية - إجازة الخطة"
                status="in-progress"
                date="25/01/2026"
                description="تقديم وإجازة خطة البحث"
              />
              <MilestoneCard
                stage="المرحلة الثالثة - مناقشة الخطة"
                status="pending"
                date="قادمة"
                description="مناقشة الخطة مع لجنة التقييم"
              />
              <MilestoneCard
                stage="المرحلة الرابعة - تنفيذ البحث"
                status="pending"
                date="قادمة"
                description="تنفيذ البحث وجمع البيانات"
              />
              <MilestoneCard
                stage="المرحلة الخامسة - المناقشة النهائية"
                status="pending"
                date="قادمة"
                description="المناقشة النهائية وتقييم البحث"
              />
            </div>
          </div>

          {/* Recent Activities */}
          <div className="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
            <h2 className="text-lg font-bold text-gray-900 mb-4">الأنشطة الأخيرة</h2>
            <div className="space-y-3">
              <div className="flex items-center justify-between py-3 border-b border-gray-200">
                <div>
                  <p className="font-semibold text-gray-900">تم اعتماد بحث جديد</p>
                  <p className="text-sm text-gray-500">بحث: نظام إدارة المكتبات الذكية</p>
                </div>
                <span className="text-xs text-gray-500">منذ ساعة</span>
              </div>
              <div className="flex items-center justify-between py-3 border-b border-gray-200">
                <div>
                  <p className="font-semibold text-gray-900">تم إضافة طالب جديد</p>
                  <p className="text-sm text-gray-500">الطالب: أحمد محمد علي</p>
                </div>
                <span className="text-xs text-gray-500">منذ 3 ساعات</span>
              </div>
              <div className="flex items-center justify-between py-3">
                <div>
                  <p className="font-semibold text-gray-900">تم تحديث المرحلة الثانية</p>
                  <p className="text-sm text-gray-500">تاريخ الانتهاء: 25/01/2026</p>
                </div>
                <span className="text-xs text-gray-500">أمس</span>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
