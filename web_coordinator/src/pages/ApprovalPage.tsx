import { Check, X, FileText, User, Calendar } from 'lucide-react';
import { Header } from '@/components/Header';
import { Sidebar } from '@/components/Sidebar';
import { Button } from '@/components/ui/button';
import { useState } from 'react';

interface ResearchProject {
  id: string;
  title: string;
  studentName: string;
  advisor: string;
  submissionDate: string;
  stage: string;
  status: 'pending' | 'approved' | 'rejected';
}

const mockProjects: ResearchProject[] = [
  {
    id: '1',
    title: 'نظام إدارة المكتبات الذكية',
    studentName: 'أحمد محمد علي',
    advisor: 'أ.د محمد السلام',
    submissionDate: '15/03/2026',
    stage: 'المرحلة الأولى',
    status: 'pending',
  },
  {
    id: '2',
    title: 'تطبيق الذكاء الاصطناعي في التعليم',
    studentName: 'فاطمة خالد إبراهيم',
    advisor: 'أ.د سارة محمود',
    submissionDate: '10/03/2026',
    stage: 'المرحلة الثانية',
    status: 'pending',
  },
  {
    id: '3',
    title: 'نظام أمان الشبكات المتقدم',
    studentName: 'محمود علي حسن',
    advisor: 'أ.د علي أحمد',
    submissionDate: '05/03/2026',
    stage: 'المرحلة الأولى',
    status: 'approved',
  },
];

export default function ApprovalPage() {
  const [projects, setProjects] = useState<ResearchProject[]>(mockProjects);

  const handleApprove = (id: string) => {
    setProjects(projects.map(p => p.id === id ? { ...p, status: 'approved' } : p));
  };

  const handleReject = (id: string) => {
    setProjects(projects.map(p => p.id === id ? { ...p, status: 'rejected' } : p));
  };

  const pendingProjects = projects.filter(p => p.status === 'pending');
  const approvedProjects = projects.filter(p => p.status === 'approved');
  const rejectedProjects = projects.filter(p => p.status === 'rejected');

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />

      <main className="flex-1 md:mr-64">
        <Header />

        <div className="p-6 space-y-6">
          {/* Page Header */}
          <div>
            <h1 className="text-3xl font-bold text-gray-900">اعتماد البحوث</h1>
            <p className="text-gray-600 mt-1">مراجعة واعتماد البحوث المقدمة من الطلاب</p>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <p className="text-sm text-gray-600 mb-2">قيد المراجعة</p>
              <p className="text-3xl font-bold text-orange-600">{pendingProjects.length}</p>
            </div>
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <p className="text-sm text-gray-600 mb-2">المعتمدة</p>
              <p className="text-3xl font-bold text-green-600">{approvedProjects.length}</p>
            </div>
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <p className="text-sm text-gray-600 mb-2">المرفوضة</p>
              <p className="text-3xl font-bold text-red-600">{rejectedProjects.length}</p>
            </div>
          </div>

          {/* Pending Projects */}
          {pendingProjects.length > 0 && (
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <h2 className="text-lg font-bold text-gray-900 mb-4">البحوث قيد المراجعة</h2>
              <div className="space-y-4">
                {pendingProjects.map((project) => (
                  <div
                    key={project.id}
                    className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
                  >
                    <div className="flex items-start justify-between mb-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-2">
                          <FileText className="w-5 h-5 text-blue-600" />
                          <h3 className="text-lg font-semibold text-gray-900">{project.title}</h3>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm text-gray-600">
                          <div className="flex items-center gap-2">
                            <User className="w-4 h-4" />
                            <span>{project.studentName}</span>
                          </div>
                          <div className="flex items-center gap-2">
                            <User className="w-4 h-4" />
                            <span>{project.advisor}</span>
                          </div>
                          <div className="flex items-center gap-2">
                            <Calendar className="w-4 h-4" />
                            <span>{project.submissionDate}</span>
                          </div>
                        </div>
                      </div>
                      <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-orange-50 text-orange-700">
                        {project.stage}
                      </span>
                    </div>

                    <div className="flex gap-2 pt-4 border-t border-gray-200">
                      <Button
                        onClick={() => handleApprove(project.id)}
                        className="gap-2 bg-green-600 hover:bg-green-700"
                      >
                        <Check className="w-4 h-4" />
                        اعتماد
                      </Button>
                      <Button
                        onClick={() => handleReject(project.id)}
                        variant="outline"
                        className="gap-2 text-red-600 hover:bg-red-50"
                      >
                        <X className="w-4 h-4" />
                        رفض
                      </Button>
                      <Button variant="outline" className="gap-2 flex-1">
                        <FileText className="w-4 h-4" />
                        عرض التفاصيل
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Approved Projects */}
          {approvedProjects.length > 0 && (
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <h2 className="text-lg font-bold text-gray-900 mb-4">البحوث المعتمدة</h2>
              <div className="space-y-2">
                {approvedProjects.map((project) => (
                  <div key={project.id} className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                    <div>
                      <p className="font-semibold text-gray-900">{project.title}</p>
                      <p className="text-sm text-gray-600">{project.studentName}</p>
                    </div>
                    <span className="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-700">
                      <Check className="w-4 h-4" />
                      معتمد
                    </span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
