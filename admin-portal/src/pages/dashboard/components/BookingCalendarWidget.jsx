import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';

const BookingCalendarWidget = () => {
  const [currentDate, setCurrentDate] = useState(new Date(2024, 9, 14)); // October 14, 2024

  const roomAvailability = [
    { roomNumber: '101', type: 'Standard', status: 'occupied', guest: 'John Smith', checkOut: '2024-10-15' },
    { roomNumber: '102', type: 'Standard', status: 'available', guest: null, checkOut: null },
    { roomNumber: '103', type: 'Deluxe', status: 'maintenance', guest: null, checkOut: null },
    { roomNumber: '201', type: 'Suite', status: 'occupied', guest: 'Sarah Johnson', checkOut: '2024-10-16' },
    { roomNumber: '202', type: 'Suite', status: 'reserved', guest: 'Mike Wilson', checkOut: '2024-10-17' },
    { roomNumber: '203', type: 'Deluxe', status: 'available', guest: null, checkOut: null },
    { roomNumber: '301', type: 'Standard', status: 'occupied', guest: 'Emma Davis', checkOut: '2024-10-15' },
    { roomNumber: '302', type: 'Standard', status: 'cleaning', guest: null, checkOut: null }
  ];

  const getStatusColor = (status) => {
    const colors = {
      occupied: 'bg-error text-error-foreground',
      available: 'bg-success text-success-foreground',
      reserved: 'bg-warning text-warning-foreground',
      maintenance: 'bg-muted text-muted-foreground',
      cleaning: 'bg-accent text-accent-foreground'
    };
    return colors?.[status] || 'bg-muted text-muted-foreground';
  };

  const getStatusIcon = (status) => {
    const icons = {
      occupied: 'User',
      available: 'Check',
      reserved: 'Clock',
      maintenance: 'Wrench',
      cleaning: 'Sparkles'
    };
    return icons?.[status] || 'Home';
  };

  const statusCounts = roomAvailability?.reduce((acc, room) => {
    acc[room.status] = (acc?.[room?.status] || 0) + 1;
    return acc;
  }, {});

  return (
    <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
      <div className="flex items-center justify-between mb-6">
        <h3 className="text-lg font-semibold text-foreground">Room Status Overview</h3>
        <div className="flex items-center space-x-2">
          <button className="p-2 hover:bg-muted rounded-md transition-colors">
            <Icon name="Calendar" size={16} className="text-muted-foreground" />
          </button>
          <button className="p-2 hover:bg-muted rounded-md transition-colors">
            <Icon name="RefreshCw" size={16} className="text-muted-foreground" />
          </button>
        </div>
      </div>
      {/* Status Legend */}
      <div className="flex flex-wrap gap-3 mb-6">
        {Object.entries(statusCounts)?.map(([status, count]) => (
          <div key={status} className="flex items-center space-x-2">
            <div className={`w-3 h-3 rounded-full ${getStatusColor(status)?.split(' ')?.[0]}`} />
            <span className="text-sm text-muted-foreground capitalize">
              {status} ({count})
            </span>
          </div>
        ))}
      </div>
      {/* Room Grid */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
        {roomAvailability?.map((room) => (
          <div
            key={room?.roomNumber}
            className={`
              p-3 rounded-lg border-2 transition-all cursor-pointer hover:shadow-elevation-1
              ${getStatusColor(room?.status)} border-transparent
            `}
          >
            <div className="flex items-center justify-between mb-2">
              <span className="font-semibold text-sm">{room?.roomNumber}</span>
              <Icon name={getStatusIcon(room?.status)} size={14} />
            </div>
            <div className="space-y-1">
              <p className="text-xs opacity-90">{room?.type}</p>
              {room?.guest && (
                <p className="text-xs opacity-80 truncate">{room?.guest}</p>
              )}
              {room?.checkOut && (
                <p className="text-xs opacity-70">Out: {new Date(room.checkOut)?.toLocaleDateString()}</p>
              )}
            </div>
          </div>
        ))}
      </div>
      <div className="mt-6 pt-4 border-t border-border">
        <button className="w-full text-center text-sm text-accent hover:text-accent/80 transition-colors">
          View Full Calendar
        </button>
      </div>
    </div>
  );
};

export default BookingCalendarWidget;