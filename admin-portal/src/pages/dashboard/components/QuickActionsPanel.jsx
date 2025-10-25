import React from 'react';
import Button from '../../../components/ui/Button';
import Icon from '../../../components/AppIcon';

const QuickActionsPanel = () => {
  const quickActions = [
    {
      id: 'new-booking',
      title: 'New Booking',
      description: 'Create a new reservation',
      icon: 'Plus',
      variant: 'default',
      action: () => console.log('Navigate to new booking')
    },
    {
      id: 'check-in',
      title: 'Check-in Guest',
      description: 'Process guest arrival',
      icon: 'UserCheck',
      variant: 'success',
      action: () => console.log('Navigate to check-in')
    },
    {
      id: 'room-status',
      title: 'Update Room Status',
      description: 'Manage room availability',
      icon: 'Home',
      variant: 'outline',
      action: () => console.log('Navigate to room management')
    }
  ];

  const systemAlerts = [
    {
      id: 1,
      type: 'maintenance',
      message: 'Room 103 requires maintenance attention',
      priority: 'high',
      timestamp: '10 minutes ago'
    },
    {
      id: 2,
      type: 'booking',
      message: '3 new bookings pending confirmation',
      priority: 'medium',
      timestamp: '25 minutes ago'
    },
    {
      id: 3,
      type: 'system',
      message: 'Daily backup completed successfully',
      priority: 'low',
      timestamp: '1 hour ago'
    }
  ];

  const getPriorityColor = (priority) => {
    const colors = {
      high: 'border-l-error bg-error/5',
      medium: 'border-l-warning bg-warning/5',
      low: 'border-l-success bg-success/5'
    };
    return colors?.[priority] || 'border-l-muted bg-muted/5';
  };

  const getAlertIcon = (type) => {
    const icons = {
      maintenance: 'Wrench',
      booking: 'Calendar',
      system: 'Settings'
    };
    return icons?.[type] || 'Bell';
  };

  return (
    <div className="space-y-6">
      {/* Quick Actions */}
      <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
        <h3 className="text-lg font-semibold text-foreground mb-4">Quick Actions</h3>
        
        <div className="grid gap-4">
          {quickActions?.map((action) => (
            <Button
              key={action?.id}
              variant={action?.variant}
              onClick={action?.action}
              iconName={action?.icon}
              iconPosition="left"
              fullWidth
              className="justify-start h-auto p-4"
            >
              <div className="text-left">
                <div className="font-medium">{action?.title}</div>
                <div className="text-sm opacity-80">{action?.description}</div>
              </div>
            </Button>
          ))}
        </div>
      </div>
      {/* System Alerts */}
      <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-foreground">System Alerts</h3>
          <button className="text-sm text-accent hover:text-accent/80 transition-colors">
            View All
          </button>
        </div>

        <div className="space-y-3">
          {systemAlerts?.map((alert) => (
            <div
              key={alert?.id}
              className={`
                p-3 rounded-lg border-l-4 transition-colors cursor-pointer hover:bg-muted/30
                ${getPriorityColor(alert?.priority)}
              `}
            >
              <div className="flex items-start space-x-3">
                <div className="flex-shrink-0 mt-0.5">
                  <Icon 
                    name={getAlertIcon(alert?.type)} 
                    size={16} 
                    className="text-muted-foreground"
                  />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-foreground">{alert?.message}</p>
                  <p className="text-xs text-muted-foreground mt-1">{alert?.timestamp}</p>
                </div>
                <button className="flex-shrink-0 p-1 hover:bg-muted rounded transition-colors">
                  <Icon name="X" size={14} className="text-muted-foreground" />
                </button>
              </div>
            </div>
          ))}
        </div>

        {systemAlerts?.length === 0 && (
          <div className="text-center py-8">
            <Icon name="CheckCircle" size={32} className="mx-auto text-success mb-2" />
            <p className="text-sm text-muted-foreground">All systems running smoothly</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default QuickActionsPanel;