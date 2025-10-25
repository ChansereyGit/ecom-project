import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Image from '../../../components/AppImage';
import Button from '../../../components/ui/Button';

const StaffDetailsPanel = ({ staff, onClose, onEdit }) => {
  const [activeTab, setActiveTab] = useState('profile');

  if (!staff) return null;

  const tabs = [
    { id: 'profile', label: 'Profile', icon: 'User' },
    { id: 'permissions', label: 'Permissions', icon: 'Shield' },
    { id: 'activity', label: 'Activity', icon: 'Activity' },
    { id: 'schedule', label: 'Schedule', icon: 'Calendar' }
  ];

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

  const mockPermissions = [
    { module: 'Booking Management', read: true, write: true, delete: false },
    { module: 'Property Settings', read: true, write: false, delete: false },
    { module: 'Financial Reports', read: true, write: false, delete: false },
    { module: 'Guest Data', read: true, write: true, delete: false },
    { module: 'Staff Management', read: false, write: false, delete: false }
  ];

  const mockActivity = [
    { action: 'Updated booking #1234', timestamp: '2 hours ago', type: 'booking' },
    { action: 'Logged into system', timestamp: '3 hours ago', type: 'login' },
    { action: 'Modified room rates', timestamp: '1 day ago', type: 'property' },
    { action: 'Generated revenue report', timestamp: '2 days ago', type: 'report' }
  ];

  const mockSchedule = [
    { date: 'Oct 14, 2024', shift: 'Morning (8:00 AM - 4:00 PM)', status: 'scheduled' },
    { date: 'Oct 15, 2024', shift: 'Evening (4:00 PM - 12:00 AM)', status: 'scheduled' },
    { date: 'Oct 16, 2024', shift: 'Off Day', status: 'off' },
    { date: 'Oct 17, 2024', shift: 'Morning (8:00 AM - 4:00 PM)', status: 'scheduled' }
  ];

  const renderProfileTab = () => (
    <div className="space-y-6">
      <div className="flex items-center space-x-4">
        <div className="w-20 h-20 rounded-full overflow-hidden bg-muted">
          {staff?.avatar ? (
            <Image 
              src={staff?.avatar} 
              alt={staff?.avatarAlt}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full bg-primary flex items-center justify-center text-primary-foreground text-xl font-medium">
              {staff?.name?.split(' ')?.map(n => n?.[0])?.join('')?.toUpperCase()}
            </div>
          )}
        </div>
        
        <div>
          <h2 className="text-xl font-semibold text-foreground">{staff?.name}</h2>
          <p className="text-muted-foreground">{staff?.role}</p>
          <div className={`inline-flex items-center px-2 py-1 rounded-full text-xs border mt-2 ${getStatusColor(staff?.status)}`}>
            {staff?.status?.charAt(0)?.toUpperCase() + staff?.status?.slice(1)}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="space-y-4">
          <h3 className="font-medium text-foreground">Personal Information</h3>
          <div className="space-y-3">
            <div>
              <label className="text-sm text-muted-foreground">Email</label>
              <p className="text-sm font-medium">{staff?.email}</p>
            </div>
            <div>
              <label className="text-sm text-muted-foreground">Phone</label>
              <p className="text-sm font-medium">{staff?.phone}</p>
            </div>
            <div>
              <label className="text-sm text-muted-foreground">Employee ID</label>
              <p className="text-sm font-medium font-mono">{staff?.employeeId}</p>
            </div>
          </div>
        </div>

        <div className="space-y-4">
          <h3 className="font-medium text-foreground">Employment Details</h3>
          <div className="space-y-3">
            <div>
              <label className="text-sm text-muted-foreground">Department</label>
              <p className="text-sm font-medium">{staff?.department}</p>
            </div>
            <div>
              <label className="text-sm text-muted-foreground">Hire Date</label>
              <p className="text-sm font-medium">{staff?.hireDate}</p>
            </div>
            <div>
              <label className="text-sm text-muted-foreground">Last Login</label>
              <p className="text-sm font-medium">{staff?.lastLogin}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  const renderPermissionsTab = () => (
    <div className="space-y-4">
      <h3 className="font-medium text-foreground">System Permissions</h3>
      <div className="space-y-3">
        {mockPermissions?.map((permission, index) => (
          <div key={index} className="flex items-center justify-between p-3 bg-muted/50 rounded-lg">
            <span className="text-sm font-medium">{permission?.module}</span>
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2">
                <Icon 
                  name={permission?.read ? "Check" : "X"} 
                  size={16} 
                  className={permission?.read ? "text-success" : "text-error"} 
                />
                <span className="text-xs text-muted-foreground">Read</span>
              </div>
              <div className="flex items-center space-x-2">
                <Icon 
                  name={permission?.write ? "Check" : "X"} 
                  size={16} 
                  className={permission?.write ? "text-success" : "text-error"} 
                />
                <span className="text-xs text-muted-foreground">Write</span>
              </div>
              <div className="flex items-center space-x-2">
                <Icon 
                  name={permission?.delete ? "Check" : "X"} 
                  size={16} 
                  className={permission?.delete ? "text-success" : "text-error"} 
                />
                <span className="text-xs text-muted-foreground">Delete</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const renderActivityTab = () => (
    <div className="space-y-4">
      <h3 className="font-medium text-foreground">Recent Activity</h3>
      <div className="space-y-3">
        {mockActivity?.map((activity, index) => (
          <div key={index} className="flex items-center space-x-3 p-3 bg-muted/50 rounded-lg">
            <div className="w-8 h-8 bg-accent/10 rounded-full flex items-center justify-center">
              <Icon name="Activity" size={16} className="text-accent" />
            </div>
            <div className="flex-1">
              <p className="text-sm font-medium">{activity?.action}</p>
              <p className="text-xs text-muted-foreground">{activity?.timestamp}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const renderScheduleTab = () => (
    <div className="space-y-4">
      <h3 className="font-medium text-foreground">Work Schedule</h3>
      <div className="space-y-3">
        {mockSchedule?.map((schedule, index) => (
          <div key={index} className="flex items-center justify-between p-3 bg-muted/50 rounded-lg">
            <div>
              <p className="text-sm font-medium">{schedule?.date}</p>
              <p className="text-xs text-muted-foreground">{schedule?.shift}</p>
            </div>
            <div className={`
              px-2 py-1 rounded-full text-xs border
              ${schedule?.status === 'scheduled' ? 'bg-success/10 text-success border-success/20' : 'bg-muted text-muted-foreground border-border'}
            `}>
              {schedule?.status === 'scheduled' ? 'Scheduled' : 'Off'}
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  return (
    <div className="bg-card border border-border rounded-lg h-full flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between p-6 border-b border-border">
        <h2 className="text-lg font-semibold text-foreground">Staff Details</h2>
        <div className="flex items-center space-x-2">
          <Button
            variant="outline"
            size="sm"
            iconName="Edit2"
            onClick={() => onEdit(staff)}
          >
            Edit
          </Button>
          <button
            onClick={onClose}
            className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-md micro-press"
          >
            <Icon name="X" size={20} />
          </button>
        </div>
      </div>
      {/* Tabs */}
      <div className="flex border-b border-border">
        {tabs?.map((tab) => (
          <button
            key={tab?.id}
            onClick={() => setActiveTab(tab?.id)}
            className={`
              flex items-center space-x-2 px-4 py-3 text-sm font-medium border-b-2 transition-colors
              ${activeTab === tab?.id 
                ? 'border-primary text-primary' :'border-transparent text-muted-foreground hover:text-foreground'
              }
            `}
          >
            <Icon name={tab?.icon} size={16} />
            <span>{tab?.label}</span>
          </button>
        ))}
      </div>
      {/* Content */}
      <div className="flex-1 p-6 overflow-y-auto">
        {activeTab === 'profile' && renderProfileTab()}
        {activeTab === 'permissions' && renderPermissionsTab()}
        {activeTab === 'activity' && renderActivityTab()}
        {activeTab === 'schedule' && renderScheduleTab()}
      </div>
    </div>
  );
};

export default StaffDetailsPanel;