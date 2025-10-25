import React from 'react';
import Icon from '../../../components/AppIcon';

const StaffStats = ({ staffData }) => {
  const totalStaff = staffData?.length;
  const activeStaff = staffData?.filter(staff => staff?.status === 'active')?.length;
  const inactiveStaff = staffData?.filter(staff => staff?.status === 'inactive')?.length;
  const pendingStaff = staffData?.filter(staff => staff?.status === 'pending')?.length;

  const stats = [
    {
      label: 'Total Staff',
      value: totalStaff,
      icon: 'Users',
      color: 'text-primary',
      bgColor: 'bg-primary/10',
      borderColor: 'border-primary/20'
    },
    {
      label: 'Active',
      value: activeStaff,
      icon: 'UserCheck',
      color: 'text-success',
      bgColor: 'bg-success/10',
      borderColor: 'border-success/20'
    },
    {
      label: 'Inactive',
      value: inactiveStaff,
      icon: 'UserX',
      color: 'text-error',
      bgColor: 'bg-error/10',
      borderColor: 'border-error/20'
    },
    {
      label: 'Pending',
      value: pendingStaff,
      icon: 'UserPlus',
      color: 'text-warning',
      bgColor: 'bg-warning/10',
      borderColor: 'border-warning/20'
    }
  ];

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
      {stats?.map((stat, index) => (
        <div
          key={index}
          className={`bg-card border rounded-lg p-4 ${stat?.borderColor}`}
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">{stat?.label}</p>
              <p className="text-2xl font-bold text-foreground mt-1">{stat?.value}</p>
            </div>
            <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${stat?.bgColor}`}>
              <Icon name={stat?.icon} size={24} className={stat?.color} />
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};

export default StaffStats;