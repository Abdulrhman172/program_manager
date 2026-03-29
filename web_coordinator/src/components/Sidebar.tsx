import { 
  BarChart3, 
  Users, 
  BookOpen, 
  Settings, 
  LogOut,
  Menu,
  X,
  CheckCircle,
  FileText,
  Bell,
  LayoutGrid
} from 'lucide-react';
import { useState } from 'react';
import { useLocation } from 'wouter';
import { Button } from '@/components/ui/button';

interface SidebarItem {
  id: string;
  label: string;
  icon: React.ReactNode;
  href: string;
  badge?: number;
}

const sidebarItems: SidebarItem[] = [
  {
    id: 'dashboard',
    label: 'لوحة التحكم',
    icon: <LayoutGrid className="w-5 h-5" />,
    href: '/',
  },
  {
    id: 'stages',
    label: 'إدارة المراحل',
    icon: <BarChart3 className="w-5 h-5" />,
    href: '/stages',
  },
  {
    id: 'students',
    label: 'الطلاب والمشرفين',
    icon: <Users className="w-5 h-5" />,
    href: '/students',
  },
  {
    id: 'research',
    label: 'الاطلاع على البحوث',
    icon: <BookOpen className="w-5 h-5" />,
    href: '/research',
  },
  {
    id: 'approval',
    label: 'اعتماد البحوث',
    icon: <CheckCircle className="w-5 h-5" />,
    href: '/approval',
  },
  {
    id: 'documents',
    label: 'إدارة الوثائق',
    icon: <FileText className="w-5 h-5" />,
    href: '/documents',
  },
  {
    id: 'notifications',
    label: 'الإشعارات',
    icon: <Bell className="w-5 h-5" />,
    href: '/notifications',
    badge: 3,
  },
  {
    id: 'settings',
    label: 'الإعدادات',
    icon: <Settings className="w-5 h-5" />,
    href: '/settings',
  },
];

export function Sidebar() {
  const [isOpen, setIsOpen] = useState(false);
  const [, setLocation] = useLocation();
  const [activeItem, setActiveItem] = useState('dashboard');

  return (
    <>
      {/* Mobile Toggle Button */}
      <Button
        variant="ghost"
        size="icon"
        className="fixed top-4 right-4 z-40 md:hidden"
        onClick={() => setIsOpen(!isOpen)}
      >
        {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
      </Button>

      {/* Sidebar */}
      <aside
        className={`fixed right-0 top-0 h-screen w-64 bg-white border-l border-gray-200 shadow-lg transition-transform duration-300 z-30 md:translate-x-0 ${
          isOpen ? 'translate-x-0' : 'translate-x-full'
        }`}
      >
        {/* Header */}
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-blue-600 flex items-center justify-center">
              <span className="text-white font-bold text-lg">ح</span>
            </div>
            <div>
              <h1 className="font-bold text-lg text-gray-900">نظام الإدارة</h1>
              <p className="text-xs text-gray-500">مسؤول البرنامج</p>
            </div>
          </div>
        </div>

        {/* Navigation Items */}
        <nav className="flex-1 overflow-y-auto p-4">
          <ul className="space-y-2">
            {sidebarItems.map((item) => (
              <li key={item.id}>
                <button
                  onClick={() => {
                    setActiveItem(item.id);
                    setLocation(item.href);
                    setIsOpen(false);
                  }}
                  className={`w-full flex items-center justify-between gap-3 px-4 py-3 rounded-lg transition-colors ${
                    activeItem === item.id
                      ? 'bg-blue-50 text-blue-600 font-semibold'
                      : 'text-gray-700 hover:bg-gray-50'
                  }`}
                >
                  <span className="flex items-center gap-3 flex-1">
                    {item.icon}
                    <span className="text-sm">{item.label}</span>
                  </span>
                  {item.badge && (
                    <span className="bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                      {item.badge}
                    </span>
                  )}
                </button>
              </li>
            ))}
          </ul>
        </nav>

        {/* Footer */}
        <div className="border-t border-gray-200 p-4 space-y-2">
          <div className="px-4 py-2 bg-gray-50 rounded-lg">
            <p className="text-xs text-gray-600">مسجل الدخول كـ</p>
            <p className="font-semibold text-sm text-gray-900">أ.د محمد علي</p>
          </div>
          <Button
            variant="outline"
            className="w-full justify-start gap-2 text-red-600 hover:text-red-700 hover:bg-red-50"
          >
            <LogOut className="w-4 h-4" />
            تسجيل الخروج
          </Button>
        </div>
      </aside>

      {/* Mobile Overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black bg-opacity-50 z-20 md:hidden"
          onClick={() => setIsOpen(false)}
        />
      )}
    </>
  );
}
