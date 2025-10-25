import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';

const NotificationsPanel = () => {
  const [notifications, setNotifications] = useState([
    {
      id: 1,
      type: 'booking',
      title: 'New Booking Received',
      message: 'Michael Rodriguez booked Deluxe Suite 205 for Oct 15-17',
      timestamp: new Date(Date.now() - 5 * 60 * 1000),
      isRead: false,
      priority: 'high'
    },
    {
      id: 2,
      type: 'checkin',
      title: 'Guest Check-in Reminder',
      message: 'David Thompson expected to check-in at 3:00 PM today',
      timestamp: new Date(Date.now() - 15 * 60 * 1000),
      isRead: false,
      priority: 'medium'
    },
    {
      id: 3,
      type: 'maintenance',
      title: 'Maintenance Request',
      message: 'Room 103 air conditioning requires immediate attention',
      timestamp: new Date(Date.now() - 30 * 60 * 1000),
      isRead: true,
      priority: 'high'
    },
    {
      id: 4,
      type: 'payment',
      title: 'Payment Received',
      message: 'Sarah Chen payment of $280.00 processed successfully',
      timestamp: new Date(Date.now() - 45 * 60 * 1000),
      isRead: true,
      priority: 'low'
    },
    {
      id: 5,
      type: 'system',
      title: 'System Update',
      message: 'Booking system updated with new features',
      timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000),
      isRead: true,
      priority: 'low'
    }
  ]);

  const markAsRead = (id) => {
    setNotifications(prev => 
      prev?.map(notif => 
        notif?.id === id ? { ...notif, isRead: true } : notif
      )
    );
  };

  const markAllAsRead = () => {
    setNotifications(prev => 
      prev?.map(notif => ({ ...notif, isRead: true }))
    );
  };

  const getNotificationIcon = (type) => {
    const icons = {
      booking: 'Calendar',
      checkin: 'UserCheck',
      maintenance: 'Wrench',
      payment: 'CreditCard',
      system: 'Settings'
    };
    return icons?.[type] || 'Bell';
  };

  const getPriorityColor = (priority, isRead) => {
    if (isRead) return 'text-muted-foreground';
    
    const colors = {
      high: 'text-error',
      medium: 'text-warning',
      low: 'text-accent'
    };
    return colors?.[priority] || 'text-muted-foreground';
  };

  const formatTimestamp = (timestamp) => {
    const now = new Date();
    const diff = now - timestamp;
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(diff / (1000 * 60 * 60));

    if (minutes < 1) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    return timestamp?.toLocaleDateString();
  };

  const unreadCount = notifications?.filter(n => !n?.isRead)?.length;

  return (
    <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center space-x-2">
          <h3 className="text-lg font-semibold text-foreground">Notifications</h3>
          {unreadCount > 0 && (
            <span className="bg-error text-error-foreground text-xs font-medium px-2 py-1 rounded-full">
              {unreadCount}
            </span>
          )}
        </div>
        
        <div className="flex items-center space-x-2">
          {unreadCount > 0 && (
            <button
              onClick={markAllAsRead}
              className="text-xs text-accent hover:text-accent/80 transition-colors"
            >
              Mark all read
            </button>
          )}
          <button className="p-1 hover:bg-muted rounded transition-colors">
            <Icon name="Settings" size={16} className="text-muted-foreground" />
          </button>
        </div>
      </div>
      <div className="space-y-3 max-h-80 overflow-y-auto">
        {notifications?.map((notification) => (
          <div
            key={notification?.id}
            onClick={() => markAsRead(notification?.id)}
            className={`
              p-3 rounded-lg border transition-all cursor-pointer
              ${notification?.isRead 
                ? 'border-transparent hover:bg-muted/50' :'border-accent/20 bg-accent/5 hover:bg-accent/10'
              }
            `}
          >
            <div className="flex items-start space-x-3">
              <div className={`
                w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5
                ${notification?.isRead ? 'bg-muted' : 'bg-accent/10'}
              `}>
                <Icon 
                  name={getNotificationIcon(notification?.type)} 
                  size={16} 
                  className={getPriorityColor(notification?.priority, notification?.isRead)}
                />
              </div>

              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between mb-1">
                  <h4 className={`
                    text-sm font-medium truncate
                    ${notification?.isRead ? 'text-muted-foreground' : 'text-foreground'}
                  `}>
                    {notification?.title}
                  </h4>
                  <span className="text-xs text-muted-foreground ml-2 flex-shrink-0">
                    {formatTimestamp(notification?.timestamp)}
                  </span>
                </div>
                <p className="text-xs text-muted-foreground line-clamp-2">
                  {notification?.message}
                </p>
              </div>

              {!notification?.isRead && (
                <div className="w-2 h-2 bg-accent rounded-full flex-shrink-0 mt-2" />
              )}
            </div>
          </div>
        ))}
      </div>
      {notifications?.length === 0 && (
        <div className="text-center py-8">
          <Icon name="Bell" size={32} className="mx-auto text-muted-foreground mb-2" />
          <p className="text-sm text-muted-foreground">No notifications</p>
        </div>
      )}
      <div className="mt-4 pt-4 border-t border-border">
        <button className="w-full text-center text-sm text-accent hover:text-accent/80 transition-colors">
          View All Notifications
        </button>
      </div>
    </div>
  );
};

export default NotificationsPanel;