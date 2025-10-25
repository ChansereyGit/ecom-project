import React, { useState, useRef, useEffect } from 'react';
import Icon from '../AppIcon';

const NotificationIndicator = ({ notifications = [], onMarkAsRead, onMarkAllAsRead }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [unreadCount, setUnreadCount] = useState(0);
  const dropdownRef = useRef(null);

  // Mock notifications if none provided
  const mockNotifications = [
    {
      id: 1,
      type: 'booking',
      title: 'New Booking Received',
      message: 'Room 205 booked for Oct 15-17, 2024',
      timestamp: new Date(Date.now() - 5 * 60 * 1000), // 5 minutes ago
      isRead: false,
      priority: 'high'
    },
    {
      id: 2,
      type: 'system',
      title: 'System Maintenance',
      message: 'Scheduled maintenance tonight at 2:00 AM',
      timestamp: new Date(Date.now() - 30 * 60 * 1000), // 30 minutes ago
      isRead: false,
      priority: 'medium'
    },
    {
      id: 3,
      type: 'staff',
      title: 'Staff Schedule Updated',
      message: 'Front desk schedule changed for tomorrow',
      timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000), // 2 hours ago
      isRead: true,
      priority: 'low'
    },
    {
      id: 4,
      type: 'revenue',
      title: 'Revenue Alert',
      message: 'Daily revenue target achieved',
      timestamp: new Date(Date.now() - 4 * 60 * 60 * 1000), // 4 hours ago
      isRead: true,
      priority: 'medium'
    }
  ];

  const currentNotifications = notifications?.length > 0 ? notifications : mockNotifications;

  useEffect(() => {
    const count = currentNotifications?.filter(n => !n?.isRead)?.length;
    setUnreadCount(count);
  }, [currentNotifications]);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef?.current && !dropdownRef?.current?.contains(event?.target)) {
        setIsOpen(false);
      }
    };

    const handleEscape = (event) => {
      if (event?.key === 'Escape') {
        setIsOpen(false);
      }
    };

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
      document.addEventListener('keydown', handleEscape);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('keydown', handleEscape);
    };
  }, [isOpen]);

  const getNotificationIcon = (type) => {
    const iconMap = {
      booking: 'Calendar',
      system: 'Settings',
      staff: 'Users',
      revenue: 'TrendingUp',
      alert: 'AlertTriangle'
    };
    return iconMap?.[type] || 'Bell';
  };

  const getPriorityColor = (priority) => {
    const colorMap = {
      high: 'text-error',
      medium: 'text-warning',
      low: 'text-muted-foreground'
    };
    return colorMap?.[priority] || 'text-muted-foreground';
  };

  const formatTimestamp = (timestamp) => {
    const now = new Date();
    const diff = now - timestamp;
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));

    if (minutes < 1) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    return `${days}d ago`;
  };

  const handleNotificationClick = (notification) => {
    if (!notification?.isRead && onMarkAsRead) {
      onMarkAsRead(notification?.id);
    }
  };

  const handleMarkAllAsRead = () => {
    if (onMarkAllAsRead) {
      onMarkAllAsRead();
    }
    setIsOpen(false);
  };

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Notification Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="relative p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-md transition-colors micro-press"
        aria-expanded={isOpen}
        aria-haspopup="true"
        title="Notifications"
      >
        <Icon name="Bell" size={20} />
        
        {/* Unread Badge */}
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 w-5 h-5 bg-error text-error-foreground text-xs font-medium rounded-full flex items-center justify-center status-glow">
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </button>
      {/* Dropdown Panel */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-80 bg-popover border border-border rounded-md shadow-elevation-3 z-300 animate-fade-in">
          {/* Header */}
          <div className="flex items-center justify-between px-4 py-3 border-b border-border">
            <h3 className="text-sm font-semibold text-popover-foreground">
              Notifications
            </h3>
            {unreadCount > 0 && (
              <button
                onClick={handleMarkAllAsRead}
                className="text-xs text-accent hover:text-accent/80 transition-colors"
              >
                Mark all as read
              </button>
            )}
          </div>

          {/* Notifications List */}
          <div className="max-h-96 overflow-y-auto">
            {currentNotifications?.length === 0 ? (
              <div className="px-4 py-8 text-center">
                <Icon name="Bell" size={32} className="mx-auto text-muted-foreground mb-2" />
                <p className="text-sm text-muted-foreground">No notifications</p>
              </div>
            ) : (
              <div className="py-2">
                {currentNotifications?.map((notification) => (
                  <button
                    key={notification?.id}
                    onClick={() => handleNotificationClick(notification)}
                    className={`
                      w-full px-4 py-3 text-left hover:bg-muted transition-colors border-l-2
                      ${notification?.isRead 
                        ? 'border-transparent' :'border-accent bg-accent/5'
                      }
                    `}
                  >
                    <div className="flex items-start space-x-3">
                      {/* Icon */}
                      <div className={`
                        w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5
                        ${notification?.isRead ? 'bg-muted' : 'bg-accent/10'}
                      `}>
                        <Icon 
                          name={getNotificationIcon(notification?.type)} 
                          size={16} 
                          className={getPriorityColor(notification?.priority)}
                        />
                      </div>

                      {/* Content */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between mb-1">
                          <h4 className={`
                            text-sm truncate
                            ${notification?.isRead 
                              ? 'text-muted-foreground' 
                              : 'text-popover-foreground font-medium'
                            }
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

                      {/* Unread Indicator */}
                      {!notification?.isRead && (
                        <div className="w-2 h-2 bg-accent rounded-full flex-shrink-0 mt-2" />
                      )}
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Footer */}
          {currentNotifications?.length > 0 && (
            <div className="px-4 py-3 border-t border-border">
              <button className="w-full text-center text-sm text-accent hover:text-accent/80 transition-colors">
                View all notifications
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default NotificationIndicator;