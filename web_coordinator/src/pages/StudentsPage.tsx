import { Plus, Search, Edit, Trash2, Mail, Phone } from 'lucide-react';
import { Header } from '@/components/Header';
import { Sidebar } from '@/components/Sidebar';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useState } from 'react';

interface Student {
  id: string;
  name: string;
  email: string;
  phone: string;
  specialization: string;
  advisor: string;
  status: 'active' | 'inactive';
}

const mockStudents: Student[] = [
  {
    id: '1',
    name: 'أحمد محمد علي',
    email: 'ahmed@university.edu',
    phone: '+966501234567',
    specialization: 'هندسة البرمجيات',
    advisor: 'أ.د محمد السلام',
    status: 'active',
  },
  {
    id: '2',
    name: 'فاطمة خالد إبراهيم',
    email: 'fatima@university.edu',
    phone: '+966501234568',
    specialization: 'قواعد البيانات',
    advisor: 'أ.د سارة محمود',
    status: 'active',
  },
  {
    id: '3',
    name: 'محمود علي حسن',
    email: 'mahmoud@university.edu',
    phone: '+966501234569',
    specialization: 'الشبكات',
    advisor: 'أ.د علي أحمد',
    status: 'active',
  },
];

export default function StudentsPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [students] = useState<Student[]>(mockStudents);

  const filteredStudents = students.filter(
    (student) =>
      student.name.includes(searchTerm) ||
      student.email.includes(searchTerm) ||
      student.specialization.includes(searchTerm)
  );

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />

      <main className="flex-1 md:mr-64">
        <Header />

        <div className="p-6 space-y-6">
          {/* Page Header */}
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">الطلاب والمشرفين</h1>
              <p className="text-gray-600 mt-1">إدارة بيانات الطلاب والمشرفين الأكاديميين</p>
            </div>
            <Button className="gap-2">
              <Plus className="w-4 h-4" />
              إضافة طالب جديد
            </Button>
          </div>

          {/* Search and Filter */}
          <div className="bg-white rounded-lg border border-gray-200 p-4">
            <div className="flex gap-4">
              <div className="flex-1 relative">
                <Search className="absolute right-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  type="text"
                  placeholder="ابحث عن طالب..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pr-10 bg-gray-50 border-gray-200"
                />
              </div>
            </div>
          </div>

          {/* Students Table */}
          <div className="bg-white rounded-lg border border-gray-200 overflow-hidden shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th className="px-6 py-3 text-right text-sm font-semibold text-gray-900">الاسم</th>
                    <th className="px-6 py-3 text-right text-sm font-semibold text-gray-900">التخصص</th>
                    <th className="px-6 py-3 text-right text-sm font-semibold text-gray-900">المشرف الأكاديمي</th>
                    <th className="px-6 py-3 text-right text-sm font-semibold text-gray-900">البريد الإلكتروني</th>
                    <th className="px-6 py-3 text-right text-sm font-semibold text-gray-900">الحالة</th>
                    <th className="px-6 py-3 text-right text-sm font-semibold text-gray-900">الإجراءات</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200">
                  {filteredStudents.map((student) => (
                    <tr key={student.id} className="hover:bg-gray-50 transition-colors">
                      <td className="px-6 py-4 text-sm font-medium text-gray-900">{student.name}</td>
                      <td className="px-6 py-4 text-sm text-gray-600">{student.specialization}</td>
                      <td className="px-6 py-4 text-sm text-gray-600">{student.advisor}</td>
                      <td className="px-6 py-4 text-sm text-gray-600">
                        <div className="flex items-center gap-2">
                          <Mail className="w-4 h-4 text-gray-400" />
                          {student.email}
                        </div>
                      </td>
                      <td className="px-6 py-4 text-sm">
                        <span className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-green-50 text-green-700">
                          <span className="w-2 h-2 bg-green-600 rounded-full" />
                          نشط
                        </span>
                      </td>
                      <td className="px-6 py-4 text-sm">
                        <div className="flex items-center gap-2">
                          <Button variant="ghost" size="icon" className="h-8 w-8">
                            <Edit className="w-4 h-4 text-blue-600" />
                          </Button>
                          <Button variant="ghost" size="icon" className="h-8 w-8">
                            <Trash2 className="w-4 h-4 text-red-600" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <p className="text-sm text-gray-600 mb-2">إجمالي الطلاب</p>
              <p className="text-3xl font-bold text-gray-900">{filteredStudents.length}</p>
            </div>
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <p className="text-sm text-gray-600 mb-2">الطلاب النشطين</p>
              <p className="text-3xl font-bold text-green-600">{filteredStudents.filter(s => s.status === 'active').length}</p>
            </div>
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <p className="text-sm text-gray-600 mb-2">التخصصات</p>
              <p className="text-3xl font-bold text-blue-600">{new Set(filteredStudents.map(s => s.specialization)).size}</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
