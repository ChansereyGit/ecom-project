import React, { useState, useEffect } from 'react';
import SidebarNavigation from '../../components/ui/SidebarNavigation';
import UserProfileDropdown from '../../components/ui/UserProfileDropdown';
import NotificationIndicator from '../../components/ui/NotificationIndicator';
import MetricCard from './components/MetricCard';
import BookingCalendarWidget from './components/BookingCalendarWidget';
import RecentBookingsPanel from './components/RecentBookingsPanel';
import RevenueChart from './components/RevenueChart';
import QuickActionsPanel from './components/QuickActionsPanel';
import NotificationsPanel from './components/NotificationsPanel';
import Icon from '../../components/AppIcon';

const Dashboard = () => {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const [currentTime, setCurrentTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 60000); // Update every minute

    return () => clearInterval(timer);
  }, []);

  const handleLogout = () => {
    console.log('Logout functionality');
    // Implement logout logic here
  };

  const todayMetrics = [
    {
      title: "Today\'s Occupancy",
      value: '87%',
      change: '+5.2%',
      changeType: 'positive',
      icon: 'Building2',
      iconColor: 'text-primary',
      trend: 'up'
    },
    {
      title: "Today\'s Revenue",
      value: '$4,125',
      change: '+12.8%',
      changeType: 'positive',
      icon: 'DollarSign',
      iconColor: 'text-success',
      trend: 'up'
    },
    {
      title: 'New Bookings',
      value: '23',
      change: '+8.1%',
      changeType: 'positive',
      icon: 'Calendar',
      iconColor: 'text-accent',
      trend: 'up'
    },
    {
      title: 'Check-ins Today',
      value: '15',
      change: '-2.3%',
      changeType: 'negative',
      icon: 'UserCheck',
      iconColor: 'text-warning',
      trend: 'down'
    }
  ];

  return (
    <div className="min-h-screen bg-background">
      {/* Sidebar Navigation */}
      <SidebarNavigation 
        isCollapsed={sidebarCollapsed}
        onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
      />
      {/* Main Content */}
      <div className={`transition-all duration-300 ${sidebarCollapsed ? 'md:ml-20' : 'md:ml-240'}`}>
        {/* Top Header */}
        <header className="bg-card border-b border-border px-6 py-4 sticky top-0 z-50">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div>
                <h1 className="text-2xl font-bold text-foreground">Dashboard</h1>
                <p className="text-sm text-muted-foreground">
                  Welcome back! Here's what's happening at your hotel today.
                </p>
              </div>
            </div>

            <div className="flex items-center space-x-4">
              {/* Current Time */}
              <div className="hidden sm:block text-right">
                <p className="text-sm font-medium text-foreground">
                  {currentTime?.toLocaleDateString('en-US', { 
                    weekday: 'long', 
                    year: 'numeric', 
                    month: 'long', 
                    day: 'numeric' 
                  })}
                </p>
                <p className="text-xs text-muted-foreground">
                  {currentTime?.toLocaleTimeString('en-US', { 
                    hour: '2-digit', 
                    minute: '2-digit' 
                  })}
                </p>
              </div>

              {/* Notifications */}
              <NotificationIndicator 
                onMarkAsRead={() => console.log('Mark as read')}
                onMarkAllAsRead={() => console.log('Mark all as read')}
              />

              {/* User Profile */}
              <UserProfileDropdown onLogout={handleLogout} />
            </div>
          </div>
        </header>

        {/* Dashboard Content */}
        <main className="p-6 space-y-6">
          {/* Metrics Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {todayMetrics?.map((metric, index) => (
              <MetricCard
                key={index}
                title={metric?.title}
                value={metric?.value}
                change={metric?.change}
                changeType={metric?.changeType}
                icon={metric?.icon}
                iconColor={metric?.iconColor}
                trend={metric?.trend}
              />
            ))}
          </div>

          {/* Main Dashboard Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Left Column - Charts and Calendar */}
            <div className="lg:col-span-2 space-y-6">
              {/* Revenue Chart */}
              <RevenueChart />

              {/* Room Status Calendar */}
              <BookingCalendarWidget />
            </div>

            {/* Right Column - Panels */}
            <div className="space-y-6">
              {/* Quick Actions */}
              <QuickActionsPanel />

              {/* Recent Bookings */}
              <div className="lg:hidden">
                <RecentBookingsPanel />
              </div>
            </div>
          </div>

          {/* Bottom Section */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Recent Bookings - Desktop */}
            <div className="hidden lg:block">
              <RecentBookingsPanel />
            </div>

            {/* Notifications Panel */}
            <NotificationsPanel />
          </div>

          {/* Performance Summary */}
          <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-foreground">Performance Summary</h3>
              <button className="text-sm text-accent hover:text-accent/80 transition-colors">
                View Detailed Report
              </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="text-center">
                <div className="flex items-center justify-center w-12 h-12 bg-success/10 rounded-lg mx-auto mb-3">
                  <Icon name="TrendingUp" size={24} className="text-success" />
                </div>
                <h4 className="text-lg font-semibold text-foreground">Revenue Growth</h4>
                <p className="text-sm text-muted-foreground">
                  Monthly revenue increased by 15.3% compared to last month
                </p>
              </div>

              <div className="text-center">
                <div className="flex items-center justify-center w-12 h-12 bg-accent/10 rounded-lg mx-auto mb-3">
                  <Icon name="Users" size={24} className="text-accent" />
                </div>
                <h4 className="text-lg font-semibold text-foreground">Guest Satisfaction</h4>
                <p className="text-sm text-muted-foreground">
                  Average rating of 4.8/5 stars from recent guest reviews
                </p>
              </div>

              <div className="text-center">
                <div className="flex items-center justify-center w-12 h-12 bg-warning/10 rounded-lg mx-auto mb-3">
                  <Icon name="Calendar" size={24} className="text-warning" />
                </div>
                <h4 className="text-lg font-semibold text-foreground">Booking Trends</h4>
                <p className="text-sm text-muted-foreground">
                  Peak season approaching with 92% occupancy projected
                </p>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};

export default Dashboard;