import React, { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import Icon from '../AppIcon';

const UserProfileDropdown = ({ onLogout }) => {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef(null);
  const navigate = useNavigate();
  const { user: authUser, logout } = useAuth();

  // Get user data from auth context or localStorage
  const getUserData = () => {
    if (authUser) return authUser;
    
    try {
      const userData = localStorage.getItem('hotelAdmin_user');
      if (userData) {
        return JSON.parse(userData);
      }
    } catch (error) {
      console.error('Error parsing user data:', error);
    }
    
    return null;
  };

  const currentUser = getUserData() || {
    fullName: 'Admin User',
    email: 'admin@hotel.com',
    role: 'ADMIN',
    avatar: null
  };

  const handleLogout = () => {
    if (onLogout) {
      onLogout();
    } else {
      const redirectPath = logout();
      navigate(redirectPath);
    }
    setIsOpen(false);
  };

  const menuItems = [
    {
      label: 'Profile Settings',
      icon: 'User',
      action: () => {
        console.log('Navigate to profile settings');
        setIsOpen(false);
      }
    },
    {
      label: 'Account Preferences',
      icon: 'Settings',
      action: () => {
        console.log('Navigate to account preferences');
        setIsOpen(false);
      }
    },
    {
      label: 'Help & Support',
      icon: 'HelpCircle',
      action: () => {
        console.log('Navigate to help');
        setIsOpen(false);
      }
    },
    {
      type: 'divider'
    },
    {
      label: 'Sign Out',
      icon: 'LogOut',
      action: handleLogout,
      variant: 'danger'
    }
  ];

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

  const getInitials = (name) => {
    if (!name) return 'AD';
    return name?.split(' ')?.map(word => word?.charAt(0))?.join('')?.toUpperCase()?.slice(0, 2);
  };

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Profile Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-3 px-3 py-2 rounded-md hover:bg-muted transition-colors micro-press"
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        {/* Avatar */}
        <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-primary-foreground text-sm font-medium">
          {currentUser?.avatar ? (
            <img 
              src={currentUser?.avatar} 
              alt={currentUser?.name}
              className="w-full h-full rounded-full object-cover"
            />
          ) : (
            getInitials(currentUser?.name)
          )}
        </div>

        {/* User Info */}
        <div className="hidden sm:block text-left min-w-0">
          <div className="text-sm font-medium text-foreground truncate">
            {currentUser?.fullName || currentUser?.name}
          </div>
          <div className="text-xs text-muted-foreground truncate">
            {currentUser?.role === 'ADMIN' ? 'Administrator' : currentUser?.role}
          </div>
        </div>

        {/* Dropdown Arrow */}
        <Icon 
          name="ChevronDown" 
          size={16} 
          className={`text-muted-foreground transition-transform duration-150 ${isOpen ? 'rotate-180' : ''}`}
        />
      </button>
      {/* Dropdown Menu */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-64 bg-popover border border-border rounded-md shadow-elevation-3 z-300 animate-fade-in">
          {/* User Info Header */}
          <div className="px-4 py-3 border-b border-border">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-primary-foreground font-medium">
                {currentUser?.avatar ? (
                  <img 
                    src={currentUser?.avatar} 
                    alt={currentUser?.name}
                    className="w-full h-full rounded-full object-cover"
                  />
                ) : (
                  getInitials(currentUser?.name)
                )}
              </div>
              <div className="min-w-0 flex-1">
                <div className="text-sm font-medium text-popover-foreground truncate">
                  {currentUser?.fullName || currentUser?.name}
                </div>
                <div className="text-xs text-muted-foreground truncate">
                  {currentUser?.email}
                </div>
                <div className="text-xs text-muted-foreground truncate mt-1">
                  {currentUser?.role === 'ADMIN' ? 'Administrator' : currentUser?.role}
                </div>
              </div>
            </div>
          </div>

          {/* Menu Items */}
          <div className="py-2">
            {menuItems?.map((item, index) => {
              if (item?.type === 'divider') {
                return <div key={index} className="my-1 border-t border-border" />;
              }

              return (
                <button
                  key={index}
                  onClick={item?.action}
                  className={`
                    w-full flex items-center px-4 py-2 text-left text-sm transition-colors micro-press
                    ${item?.variant === 'danger' ?'text-error hover:bg-error/10' :'text-popover-foreground hover:bg-muted'
                    }
                  `}
                >
                  <Icon 
                    name={item?.icon} 
                    size={16} 
                    className={`mr-3 ${item?.variant === 'danger' ? 'text-error' : 'text-muted-foreground'}`}
                  />
                  {item?.label}
                </button>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
};

export default UserProfileDropdown;