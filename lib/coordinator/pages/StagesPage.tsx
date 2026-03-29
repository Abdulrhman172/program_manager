import { Plus, Edit, Trash2, Calendar, Users } from 'lucide-react';
import { Header } from '@/components/Header';
import { Sidebar } from '@/components/Sidebar';
import { Button } from '@/components/ui/button';
import { useState } from 'react';

interface Stage {
  id: string;
  name: string;
  description: string;
  startDate: string;
  endDate: string;
  status: 'active' | 'completed' | 'pending';
  tasksCount: number;
}

const mockStages: Stage[] = [
  {
    id: '1',
    name: 'المرحلة الأولى - اختيار الموضوع',
    description: 'اختيار موضوع البحث والموافقة عليه من قبل المشرف',
    startDate: '01/01/2026',
    endDate: '28/03/2026',
    status: 'completed',
    tasksCount: 45,
  },
  {
    id: '2',
    name: 'المرحلة الثانية - إجازة الخطة',
    description: 'تقديم وإجازة خطة البحث من قبل لجنة التقييم',
    startDate: '29/03/2026',
    endDate: '25/01/2026',
    status: 'active',
    tasksCount: 38,
  },
  {
    id: '3',
    name: 'المرحلة الثالثة - مناقشة الخطة',
    description: 'مناقشة الخطة مع لجنة التقييم وتقديم الملاحظات',
    startDate: '26/01/2026',
    endDate: '15/02/2026',
    status: 'pending',
    tasksCount: 0,
  },
  {
    id: '4',
    name: 'المرحلة الرابعة - تنفيذ البحث',
    description: 'تنفيذ البحث وجمع البيانات والمعلومات',
    startDate: '16/02/2026',
    endDate: '30/04/2026',
    status: 'pending',
    tasksCount: 0,
  },
  {
    id: '5',
    name: 'المرحلة الخامسة - المناقشة النهائية',
    description: 'المناقشة النهائية وتقييم البحث',
    startDate: '01/05/2026',
    endDate: '30/05/2026',
    status: 'pending',
    tasksCount: 0,
  },
];

const statusConfig = {
  completed: { color: 'bg-green-50', textColor: 'text-green-700', label: 'مكتملة' },
  active: { color: 'bg-blue-50', textColor: 'text-blue-700', label: 'نشطة' },
  pending: { color: 'bg-gray-50', textColor: 'text-gray-700', label: 'قادمة' },
};

export default function StagesPage() {
  const [stages] = useState<Stage[]>(mockStages);

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />

      <main className="flex-1 md:mr-64">
        <Header />

        <div className="p-6 space-y-6">
          {/* Page Header */}
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">إدارة المراحل</h1>
              <p className="text-gray-600 mt-1">إدارة مراحل البحث والمواعيد النهائية</p>
            </div>
            <Button className="gap-2">
              <Plus className="w-4 h-4" />
              إضافة مرحلة جديدة
            </Button>
          </div>

          {/* Stages Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-1 gap-6">
            {stages.map((stage) => {
              const config = statusConfig[stage.status];
              return (
                <div
                  key={stage.id}
                  className="bg-white rounded-lg border border-gray-200 p-6 shadow-sm hover:shadow-md transition-shadow"
                >
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <h3 className="text-lg font-bold text-gray-900">{stage.name}</h3>
                      <p className="text-sm text-gray-600 mt-1">{stage.description}</p>
                    </div>
                    <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold ${config.color} ${config.textColor}`}>
                      {config.label}
                    </span>
                  </div>

                  <div className="grid grid-cols-2 gap-4 mb-4 py-4 border-t border-b border-gray-200">
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-gray-400" />
                      <div>
                        <p className="text-xs text-gray-500">تاريخ البداية</p>
                        <p className="text-sm font-semibold text-gray-900">{stage.startDate}</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-gray-400" />
                      <div>
                        <p className="text-xs text-gray-500">تاريخ الانتهاء</p>
                        <p className="text-sm font-semibold text-gray-900">{stage.endDate}</p>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Users className="w-4 h-4 text-gray-400" />
                      <span className="text-sm text-gray-600">{stage.tasksCount} مهمة</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button variant="ghost" size="icon" className="h-8 w-8">
                        <Edit className="w-4 h-4 text-blue-600" />
                      </Button>
                      <Button variant="ghost" size="icon" className="h-8 w-8">
                        <Trash2 className="w-4 h-4 text-red-600" />
                      </Button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </main>
    </div>
  );
}
