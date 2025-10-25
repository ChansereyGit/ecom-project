import React from 'react';

import Button from '../../../components/ui/Button';
import Select from '../../../components/ui/Select';

const CalendarHeader = ({ 
  currentDate, 
  onDateChange, 
  viewMode, 
  onViewModeChange, 
  filters, 
  onFiltersChange 
}) => {
  const viewOptions = [
    { value: 'daily', label: 'Daily View' },
    { value: 'weekly', label: 'Weekly View' },
    { value: 'monthly', label: 'Monthly View' }
  ];

  const roomTypeOptions = [
    { value: 'all', label: 'All Room Types' },
    { value: 'standard', label: 'Standard' },
    { value: 'deluxe', label: 'Deluxe' },
    { value: 'suite', label: 'Suite' },
    { value: 'presidential', label: 'Presidential' }
  ];

  const statusOptions = [
    { value: 'all', label: 'All Status' },
    { value: 'available', label: 'Available' },
    { value: 'occupied', label: 'Occupied' },
    { value: 'reserved', label: 'Reserved' },
    { value: 'maintenance', label: 'Maintenance' },
    { value: 'blocked', label: 'Blocked' }
  ];

  const navigateDate = (direction) => {
    const newDate = new Date(currentDate);
    if (viewMode === 'daily') {
      newDate?.setDate(newDate?.getDate() + (direction === 'next' ? 1 : -1));
    } else if (viewMode === 'weekly') {
      newDate?.setDate(newDate?.getDate() + (direction === 'next' ? 7 : -7));
    } else {
      newDate?.setMonth(newDate?.getMonth() + (direction === 'next' ? 1 : -1));
    }
    onDateChange(newDate);
  };

  const goToToday = () => {
    onDateChange(new Date());
  };

  const formatDateRange = () => {
    const options = { month: 'long', year: 'numeric' };
    if (viewMode === 'daily') {
      return currentDate?.toLocaleDateString('en-US', { 
        weekday: 'long', 
        month: 'long', 
        day: 'numeric', 
        year: 'numeric' 
      });
    } else if (viewMode === 'weekly') {
      const startOfWeek = new Date(currentDate);
      startOfWeek?.setDate(currentDate?.getDate() - currentDate?.getDay());
      const endOfWeek = new Date(startOfWeek);
      endOfWeek?.setDate(startOfWeek?.getDate() + 6);
      
      return `${startOfWeek?.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - ${endOfWeek?.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}`;
    }
    return currentDate?.toLocaleDateString('en-US', options);
  };

  return (
    <div className="bg-card border-b border-border p-6">
      <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
        {/* Date Navigation */}
        <div className="flex items-center space-x-4">
          <div className="flex items-center space-x-2">
            <Button
              variant="outline"
              size="sm"
              iconName="ChevronLeft"
              onClick={() => navigateDate('prev')}
            />
            <Button
              variant="outline"
              size="sm"
              iconName="ChevronRight"
              onClick={() => navigateDate('next')}
            />
          </div>
          
          <div className="flex items-center space-x-3">
            <h2 className="text-xl font-semibold text-foreground">
              {formatDateRange()}
            </h2>
            <Button
              variant="ghost"
              size="sm"
              onClick={goToToday}
            >
              Today
            </Button>
          </div>
        </div>

        {/* View Controls and Filters */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3">
          {/* View Mode Selector */}
          <Select
            options={viewOptions}
            value={viewMode}
            onChange={onViewModeChange}
            className="w-full sm:w-40"
          />

          {/* Room Type Filter */}
          <Select
            options={roomTypeOptions}
            value={filters?.roomType}
            onChange={(value) => onFiltersChange({ ...filters, roomType: value })}
            className="w-full sm:w-44"
          />

          {/* Status Filter */}
          <Select
            options={statusOptions}
            value={filters?.status}
            onChange={(value) => onFiltersChange({ ...filters, status: value })}
            className="w-full sm:w-36"
          />

          {/* Quick Actions */}
          <div className="flex items-center space-x-2">
            <Button
              variant="outline"
              size="sm"
              iconName="Settings"
              iconPosition="left"
            >
              Bulk Actions
            </Button>
            <Button
              variant="outline"
              size="sm"
              iconName="Download"
              iconPosition="left"
            >
              Export
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CalendarHeader;