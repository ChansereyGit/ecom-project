import React, { useState } from 'react';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';
import Button from '../../../components/ui/Button';
import Icon from '../../../components/AppIcon';

const BookingFilters = ({ onFiltersChange, totalResults = 0 }) => {
  const [filters, setFilters] = useState({
    dateRange: { start: '', end: '' },
    guestName: '',
    roomType: '',
    bookingStatus: '',
    paymentStatus: ''
  });

  const roomTypeOptions = [
    { value: '', label: 'All Room Types' },
    { value: 'standard', label: 'Standard Room' },
    { value: 'deluxe', label: 'Deluxe Room' },
    { value: 'suite', label: 'Suite' },
    { value: 'presidential', label: 'Presidential Suite' },
    { value: 'family', label: 'Family Room' }
  ];

  const bookingStatusOptions = [
    { value: '', label: 'All Statuses' },
    { value: 'confirmed', label: 'Confirmed' },
    { value: 'pending', label: 'Pending' },
    { value: 'checked-in', label: 'Checked In' },
    { value: 'checked-out', label: 'Checked Out' },
    { value: 'cancelled', label: 'Cancelled' },
    { value: 'no-show', label: 'No Show' }
  ];

  const paymentStatusOptions = [
    { value: '', label: 'All Payment Status' },
    { value: 'paid', label: 'Paid' },
    { value: 'pending', label: 'Pending' },
    { value: 'partial', label: 'Partial' },
    { value: 'refunded', label: 'Refunded' },
    { value: 'failed', label: 'Failed' }
  ];

  const handleFilterChange = (key, value) => {
    const newFilters = { ...filters, [key]: value };
    setFilters(newFilters);
    onFiltersChange(newFilters);
  };

  const handleDateRangeChange = (type, value) => {
    const newDateRange = { ...filters?.dateRange, [type]: value };
    const newFilters = { ...filters, dateRange: newDateRange };
    setFilters(newFilters);
    onFiltersChange(newFilters);
  };

  const clearAllFilters = () => {
    const clearedFilters = {
      dateRange: { start: '', end: '' },
      guestName: '',
      roomType: '',
      bookingStatus: '',
      paymentStatus: ''
    };
    setFilters(clearedFilters);
    onFiltersChange(clearedFilters);
  };

  const hasActiveFilters = () => {
    return filters?.guestName || 
           filters?.roomType || 
           filters?.bookingStatus || 
           filters?.paymentStatus ||
           filters?.dateRange?.start ||
           filters?.dateRange?.end;
  };

  return (
    <div className="bg-card border border-border rounded-lg p-6 mb-6">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold text-foreground">Filter Bookings</h3>
        <div className="flex items-center space-x-4">
          <span className="text-sm text-muted-foreground">
            {totalResults} results found
          </span>
          {hasActiveFilters() && (
            <Button
              variant="ghost"
              size="sm"
              onClick={clearAllFilters}
              iconName="X"
              iconPosition="left"
            >
              Clear Filters
            </Button>
          )}
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
        {/* Date Range */}
        <div className="xl:col-span-2">
          <label className="block text-sm font-medium text-foreground mb-2">
            Date Range
          </label>
          <div className="grid grid-cols-2 gap-2">
            <Input
              type="date"
              placeholder="Check-in"
              value={filters?.dateRange?.start}
              onChange={(e) => handleDateRangeChange('start', e?.target?.value)}
            />
            <Input
              type="date"
              placeholder="Check-out"
              value={filters?.dateRange?.end}
              onChange={(e) => handleDateRangeChange('end', e?.target?.value)}
            />
          </div>
        </div>

        {/* Guest Name */}
        <div>
          <Input
            label="Guest Name"
            type="text"
            placeholder="Search by guest name"
            value={filters?.guestName}
            onChange={(e) => handleFilterChange('guestName', e?.target?.value)}
          />
        </div>

        {/* Room Type */}
        <div>
          <Select
            label="Room Type"
            options={roomTypeOptions}
            value={filters?.roomType}
            onChange={(value) => handleFilterChange('roomType', value)}
          />
        </div>

        {/* Booking Status */}
        <div>
          <Select
            label="Booking Status"
            options={bookingStatusOptions}
            value={filters?.bookingStatus}
            onChange={(value) => handleFilterChange('bookingStatus', value)}
          />
        </div>

        {/* Payment Status */}
        <div>
          <Select
            label="Payment Status"
            options={paymentStatusOptions}
            value={filters?.paymentStatus}
            onChange={(value) => handleFilterChange('paymentStatus', value)}
          />
        </div>
      </div>
      {/* Active Filters Display */}
      {hasActiveFilters() && (
        <div className="mt-4 pt-4 border-t border-border">
          <div className="flex flex-wrap gap-2">
            <span className="text-sm text-muted-foreground mr-2">Active filters:</span>
            
            {filters?.dateRange?.start && (
              <span className="inline-flex items-center px-2 py-1 bg-accent/10 text-accent text-xs rounded-md">
                From: {new Date(filters.dateRange.start)?.toLocaleDateString()}
                <button
                  onClick={() => handleDateRangeChange('start', '')}
                  className="ml-1 hover:text-accent/80"
                >
                  <Icon name="X" size={12} />
                </button>
              </span>
            )}
            
            {filters?.dateRange?.end && (
              <span className="inline-flex items-center px-2 py-1 bg-accent/10 text-accent text-xs rounded-md">
                To: {new Date(filters.dateRange.end)?.toLocaleDateString()}
                <button
                  onClick={() => handleDateRangeChange('end', '')}
                  className="ml-1 hover:text-accent/80"
                >
                  <Icon name="X" size={12} />
                </button>
              </span>
            )}
            
            {filters?.guestName && (
              <span className="inline-flex items-center px-2 py-1 bg-accent/10 text-accent text-xs rounded-md">
                Guest: {filters?.guestName}
                <button
                  onClick={() => handleFilterChange('guestName', '')}
                  className="ml-1 hover:text-accent/80"
                >
                  <Icon name="X" size={12} />
                </button>
              </span>
            )}
            
            {filters?.roomType && (
              <span className="inline-flex items-center px-2 py-1 bg-accent/10 text-accent text-xs rounded-md">
                Room: {roomTypeOptions?.find(opt => opt?.value === filters?.roomType)?.label}
                <button
                  onClick={() => handleFilterChange('roomType', '')}
                  className="ml-1 hover:text-accent/80"
                >
                  <Icon name="X" size={12} />
                </button>
              </span>
            )}
            
            {filters?.bookingStatus && (
              <span className="inline-flex items-center px-2 py-1 bg-accent/10 text-accent text-xs rounded-md">
                Status: {bookingStatusOptions?.find(opt => opt?.value === filters?.bookingStatus)?.label}
                <button
                  onClick={() => handleFilterChange('bookingStatus', '')}
                  className="ml-1 hover:text-accent/80"
                >
                  <Icon name="X" size={12} />
                </button>
              </span>
            )}
            
            {filters?.paymentStatus && (
              <span className="inline-flex items-center px-2 py-1 bg-accent/10 text-accent text-xs rounded-md">
                Payment: {paymentStatusOptions?.find(opt => opt?.value === filters?.paymentStatus)?.label}
                <button
                  onClick={() => handleFilterChange('paymentStatus', '')}
                  className="ml-1 hover:text-accent/80"
                >
                  <Icon name="X" size={12} />
                </button>
              </span>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default BookingFilters;