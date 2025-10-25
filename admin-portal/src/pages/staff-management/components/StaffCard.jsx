import React from 'react';
import Icon from '../../../components/AppIcon';
import Image from '../../../components/AppImage';

const StaffCard = ({ staff, onEdit, onViewDetails, isSelected, onSelect }) => {
  const getStatusColor = (status) => {
    switch (status) {
      case 'active':
        return 'bg-success/10 text-success border-success/20';
      case 'inactive':
        return 'bg-error/10 text-error border-error/20';
      case 'pending':
        return 'bg-warning/10 text-warning border-warning/20';
      default:
        return 'bg-muted text-muted-foreground border-border';
    }
  };

  const getRoleIcon = (role) => {
    const roleIcons = {
      'Hotel Manager': 'Crown',
      'Front Desk': 'Users',
      'Revenue Manager': 'TrendingUp',
      'Administrative': 'FileText',
      'Housekeeping': 'Home',
      'Maintenance': 'Wrench'
    };
    return roleIcons?.[role] || 'User';
  };

  return (
    <div 
      className={`
        bg-card border border-border rounded-lg p-4 hover:shadow-elevation-2 transition-all duration-200 cursor-pointer
        ${isSelected ? 'ring-2 ring-primary border-primary' : ''}
      `}
      onClick={() => onSelect(staff)}
    >
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center space-x-3">
          <div className="relative">
            <div className="w-12 h-12 rounded-full overflow-hidden bg-muted">
              {staff?.avatar ? (
                <Image 
                  src={staff?.avatar} 
                  alt={staff?.avatarAlt}
                  className="w-full h-full object-cover"
                />
              ) : (
                <div className="w-full h-full bg-primary flex items-center justify-center text-primary-foreground font-medium">
                  {staff?.name?.split(' ')?.map(n => n?.[0])?.join('')?.toUpperCase()}
                </div>
              )}
            </div>
            <div className={`
              absolute -bottom-1 -right-1 w-4 h-4 rounded-full border-2 border-card
              ${staff?.status === 'active' ? 'bg-success' : staff?.status === 'inactive' ? 'bg-error' : 'bg-warning'}
            `} />
          </div>
          
          <div className="min-w-0">
            <h3 className="font-medium text-foreground truncate">{staff?.name}</h3>
            <div className="flex items-center space-x-2 mt-1">
              <Icon name={getRoleIcon(staff?.role)} size={14} className="text-muted-foreground" />
              <span className="text-sm text-muted-foreground">{staff?.role}</span>
            </div>
          </div>
        </div>

        <div className="flex items-center space-x-2">
          <button
            onClick={(e) => {
              e?.stopPropagation();
              onEdit(staff);
            }}
            className="p-1 text-muted-foreground hover:text-foreground hover:bg-muted rounded micro-press"
            title="Edit staff member"
          >
            <Icon name="Edit2" size={16} />
          </button>
          
          <button
            onClick={(e) => {
              e?.stopPropagation();
              onViewDetails(staff);
            }}
            className="p-1 text-muted-foreground hover:text-foreground hover:bg-muted rounded micro-press"
            title="View details"
          >
            <Icon name="Eye" size={16} />
          </button>
        </div>
      </div>
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <span className="text-xs text-muted-foreground">Department</span>
          <span className="text-xs font-medium">{staff?.department}</span>
        </div>
        
        <div className="flex items-center justify-between">
          <span className="text-xs text-muted-foreground">Employee ID</span>
          <span className="text-xs font-mono">{staff?.employeeId}</span>
        </div>

        <div className="flex items-center justify-between">
          <span className="text-xs text-muted-foreground">Status</span>
          <span className={`text-xs px-2 py-1 rounded-full border ${getStatusColor(staff?.status)}`}>
            {staff?.status?.charAt(0)?.toUpperCase() + staff?.status?.slice(1)}
          </span>
        </div>

        <div className="flex items-center justify-between">
          <span className="text-xs text-muted-foreground">Last Login</span>
          <span className="text-xs text-muted-foreground">{staff?.lastLogin}</span>
        </div>
      </div>
    </div>
  );
};

export default StaffCard;