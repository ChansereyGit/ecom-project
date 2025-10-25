import React from 'react';
import Icon from '../../../components/AppIcon';

const BookingStatusBadge = ({ status, size = 'default' }) => {
  const getStatusConfig = (status) => {
    const configs = {
      confirmed: {
        label: 'Confirmed',
        icon: 'CheckCircle',
        bgColor: 'bg-success/10',
        textColor: 'text-success',
        borderColor: 'border-success/20'
      },
      pending: {
        label: 'Pending',
        icon: 'Clock',
        bgColor: 'bg-warning/10',
        textColor: 'text-warning',
        borderColor: 'border-warning/20'
      },
      'checked-in': {
        label: 'Checked In',
        icon: 'LogIn',
        bgColor: 'bg-accent/10',
        textColor: 'text-accent',
        borderColor: 'border-accent/20'
      },
      'checked-out': {
        label: 'Checked Out',
        icon: 'LogOut',
        bgColor: 'bg-muted',
        textColor: 'text-muted-foreground',
        borderColor: 'border-muted'
      },
      cancelled: {
        label: 'Cancelled',
        icon: 'XCircle',
        bgColor: 'bg-error/10',
        textColor: 'text-error',
        borderColor: 'border-error/20'
      },
      'no-show': {
        label: 'No Show',
        icon: 'AlertTriangle',
        bgColor: 'bg-error/10',
        textColor: 'text-error',
        borderColor: 'border-error/20'
      }
    };

    return configs?.[status] || {
      label: status,
      icon: 'Circle',
      bgColor: 'bg-muted',
      textColor: 'text-muted-foreground',
      borderColor: 'border-muted'
    };
  };

  const config = getStatusConfig(status);
  
  const sizeClasses = {
    sm: 'px-2 py-1 text-xs',
    default: 'px-3 py-1 text-sm',
    lg: 'px-4 py-2 text-base'
  };

  const iconSizes = {
    sm: 12,
    default: 14,
    lg: 16
  };

  return (
    <span className={`
      inline-flex items-center space-x-1 rounded-full border font-medium
      ${config?.bgColor} ${config?.textColor} ${config?.borderColor}
      ${sizeClasses?.[size]}
    `}>
      <Icon name={config?.icon} size={iconSizes?.[size]} />
      <span>{config?.label}</span>
    </span>
  );
};

export default BookingStatusBadge;