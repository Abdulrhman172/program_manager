import { AlertCircle, CheckCircle, Info } from 'lucide-react';

interface NotificationCardProps {
  type: 'warning' | 'success' | 'info';
  title: string;
  description: string;
  timestamp?: string;
}

const typeConfig = {
  warning: {
    bgColor: 'bg-red-50',
    borderColor: 'border-red-200',
    titleColor: 'text-red-900',
    textColor: 'text-red-700',
    icon: <AlertCircle className="w-5 h-5" />,
  },
  success: {
    bgColor: 'bg-green-50',
    borderColor: 'border-green-200',
    titleColor: 'text-green-900',
    textColor: 'text-green-700',
    icon: <CheckCircle className="w-5 h-5" />,
  },
  info: {
    bgColor: 'bg-blue-50',
    borderColor: 'border-blue-200',
    titleColor: 'text-blue-900',
    textColor: 'text-blue-700',
    icon: <Info className="w-5 h-5" />,
  },
};

export function NotificationCard({
  type,
  title,
  description,
  timestamp,
}: NotificationCardProps) {
  const config = typeConfig[type];

  return (
    <div
      className={`${config.bgColor} ${config.borderColor} border rounded-lg p-4 flex gap-3`}
    >
      <div className={config.textColor}>{config.icon}</div>
      <div className="flex-1">
        <h4 className={`font-semibold text-sm ${config.titleColor}`}>{title}</h4>
        <p className={`text-sm mt-1 ${config.textColor}`}>{description}</p>
        {timestamp && (
          <p className="text-xs text-gray-500 mt-2">{timestamp}</p>
        )}
      </div>
    </div>
  );
}
