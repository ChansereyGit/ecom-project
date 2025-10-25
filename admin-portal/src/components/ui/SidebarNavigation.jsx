import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import Icon from '../AppIcon';

const SidebarNavigation = ({ isCollapsed = false, onToggleCollapse }) => {
  const location = useLocation();
  const navigate = useNavigate();
  const [isMobileOpen, setIsMobileOpen] = useState(false);

  const navigationItems = [
    {
      label: 'Dashboard',
      path: '/dashboard',
      icon: 'LayoutDashboard',
      description: 'Overview and metrics'
    },
    {
      label: 'Bookings',
      path: '/booking-management',
      icon: 'Calendar',
      description: 'Reservation management'
    },
    {
      label: 'Calendar',
      path: '/room-calendar',
      icon: 'CalendarDays',
      description: 'Room availability'
    },
    {
      label: 'Properties',
      path: '/property-management',
      icon: 'Building2',
      description: 'Property configuration'
    },
    {
      label: 'Staff',
      path: '/staff-management',
      icon: 'Users',
      description: 'User administration'
    }
  ];

  const handleNavigation = (path) => {
    navigate(path);
    setIsMobileOpen(false);
  };

  const isActiveRoute = (path) => {
    return location?.pathname === path;
  };

  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth >= 768) {
        setIsMobileOpen(false);
      }
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const sidebarContent = (
    <div className="flex flex-col h-full bg-card border-r border-border">
      {/* Logo Section */}
      <div className="flex items-center px-6 py-6 border-b border-border">
        <div className="flex items-center space-x-3">
          <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center">
            <Icon name="Hotel" size={20} color="white" />
          </div>
          {!isCollapsed && (
            <div className="flex flex-col">
              <span className="text-lg font-semibold text-foreground">HotelAdmin</span>
              <span className="text-xs text-muted-foreground">Pro</span>
            </div>
          )}
        </div>
      </div>

      {/* Navigation Items */}
      <nav className="flex-1 px-4 py-6 space-y-2">
        {navigationItems?.map((item) => {
          const isActive = isActiveRoute(item?.path);
          
          return (
            <button
              key={item?.path}
              onClick={() => handleNavigation(item?.path)}
              className={`
                w-full flex items-center px-3 py-3 rounded-md text-left transition-all duration-150 micro-press
                ${isActive 
                  ? 'bg-primary text-primary-foreground shadow-elevation-1' 
                  : 'text-muted-foreground hover:text-foreground hover:bg-muted'
                }
                ${isCollapsed ? 'justify-center' : 'justify-start'}
              `}
              title={isCollapsed ? item?.label : undefined}
            >
              <Icon 
                name={item?.icon} 
                size={20} 
                className={`flex-shrink-0 ${!isCollapsed ? 'mr-3' : ''}`}
              />
              {!isCollapsed && (
                <div className="flex flex-col min-w-0">
                  <span className="text-sm font-medium truncate">{item?.label}</span>
                  <span className={`text-xs truncate ${isActive ? 'text-primary-foreground/80' : 'text-muted-foreground'}`}>
                    {item?.description}
                  </span>
                </div>
              )}
            </button>
          );
        })}
      </nav>

      {/* Collapse Toggle (Desktop) */}
      {onToggleCollapse && (
        <div className="hidden md:block px-4 py-4 border-t border-border">
          <button
            onClick={onToggleCollapse}
            className="w-full flex items-center justify-center px-3 py-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-md transition-colors micro-press"
            title={isCollapsed ? 'Expand sidebar' : 'Collapse sidebar'}
          >
            <Icon 
              name={isCollapsed ? 'ChevronRight' : 'ChevronLeft'} 
              size={16} 
            />
          </button>
        </div>
      )}
    </div>
  );

  return (
    <>
      {/* Mobile Overlay */}
      {isMobileOpen && (
        <div 
          className="fixed inset-0 bg-black/50 z-200 md:hidden"
          onClick={() => setIsMobileOpen(false)}
        />
      )}

      {/* Mobile Toggle Button */}
      <button
        onClick={() => setIsMobileOpen(true)}
        className="fixed top-4 left-4 z-300 md:hidden bg-card border border-border rounded-md p-2 shadow-elevation-2"
      >
        <Icon name="Menu" size={20} />
      </button>

      {/* Desktop Sidebar */}
      <aside 
        className={`
          hidden md:block fixed left-0 top-0 h-full z-100 sidebar-transition
          ${isCollapsed ? 'w-20' : 'w-240'}
        `}
      >
        {sidebarContent}
      </aside>

      {/* Mobile Sidebar */}
      <aside 
        className={`
          fixed left-0 top-0 h-full w-240 z-300 md:hidden transform transition-transform duration-300
          ${isMobileOpen ? 'translate-x-0' : '-translate-x-full'}
        `}
      >
        {sidebarContent}
      </aside>
    </>
  );
};

export default SidebarNavigation;