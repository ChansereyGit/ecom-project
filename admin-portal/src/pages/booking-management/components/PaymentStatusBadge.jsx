import React from 'react';
import Icon from '../../../components/AppIcon';

const PaymentStatusBadge = ({ status, amount = null, size = 'default' }) => {
  const getStatusConfig = (status) => {
    const configs = {
      paid: {
        label: 'Paid',
        icon: 'CheckCircle2',
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
      partial: {
        label: 'Partial',
        icon: 'AlertCircle',
        bgColor: 'bg-accent/10',
        textColor: 'text-accent',
        borderColor: 'border-accent/20'
      },
      refunded: {
        label: 'Refunded',
        icon: 'RotateCcw',
        bgColor: 'bg-muted',
        textColor: 'text-muted-foreground',
        borderColor: 'border-muted'
      },
      failed: {
        label: 'Failed',
        icon: 'XCircle',
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
    <div className="flex flex-col items-start space-y-1">
      <span className={`
        inline-flex items-center space-x-1 rounded-full border font-medium
        ${config?.bgColor} ${config?.textColor} ${config?.borderColor}
        ${sizeClasses?.[size]}
      `}>
        <Icon name={config?.icon} size={iconSizes?.[size]} />
        <span>{config?.label}</span>
      </span>
      {amount && (
        <span className="text-xs text-muted-foreground">
          ${amount?.toLocaleString('en-US', { minimumFractionDigits: 2 })}
        </span>
      )}
    </div>
  );
};

export default PaymentStatusBadge;