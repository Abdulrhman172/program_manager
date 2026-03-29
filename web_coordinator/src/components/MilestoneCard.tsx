import { Calendar, CheckCircle, Clock } from 'lucide-react';

interface MilestoneCardProps {
  stage: string;
  status: 'completed' | 'in-progress' | 'pending';
  date: string;
  description?: string;
}

const statusConfig = {
  completed: {
    bgColor: 'bg-green-50',
    borderColor: 'border-green-200',
    textColor: 'text-green-700',
    icon: <CheckCircle className="w-4 h-4" />,
    label: 'مكتمل',
  },
  'in-progress': {
    bgColor: 'bg-blue-50',
    borderColor: 'border-blue-200',
    textColor: 'text-blue-700',
    icon: <Clock className="w-4 h-4" />,
    label: 'قيد الإنجاز',
  },
  pending: {
    bgColor: 'bg-gray-50',
    borderColor: 'border-gray-200',
    textColor: 'text-gray-700',
    icon: <Calendar className="w-4 h-4" />,
    label: 'قادم',
  },
};

export function MilestoneCard({
  stage,
  status,
  date,
  description,
}: MilestoneCardProps) {
  const config = statusConfig[status];

  return (
    <div
      className={`${config.bgColor} ${config.borderColor} border rounded-lg p-4`}
    >
      <div className="flex items-start justify-between mb-3">
        <h4 className="font-semibold text-gray-900">{stage}</h4>
        <div className={`flex items-center gap-1 text-xs font-semibold ${config.textColor}`}>
          {config.icon}
          {config.label}
        </div>
      </div>

      <div className="flex items-center gap-2 text-sm text-gray-600 mb-2">
        <Calendar className="w-4 h-4" />
        <span>{date}</span>
      </div>

      {description && (
        <p className="text-sm text-gray-600">{description}</p>
      )}
    </div>
  );
}
