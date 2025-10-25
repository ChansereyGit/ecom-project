import React, { useState, useMemo } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';

const RoomStatusPanel = ({ rooms, bookings, onRoomStatusUpdate }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  // Calculate room statistics
  const stats = useMemo(() => {
    const result = {
      available: 0,
      occupied: 0,
      maintenance: 0,
      blocked: 0,
      total: rooms?.length || 0
    };

    rooms?.forEach(room => {
      const status = room?.status?.toLowerCase();
      if (result.hasOwnProperty(status)) {
        result[status]++;
      }
    });

    return result;
  }, [rooms]);

  // Get today's activity
  const todayActivity = useMemo(() => {
    const today = new Date().toISOString().split('T')[0];
    
    const checkIns = bookings?.filter(booking => {
      const checkIn = booking?.checkInDate || booking?.checkIn;
      return checkIn === today;
    }) || [];
    
    const checkOuts = bookings?.filter(booking => {
      const checkOut = booking?.checkOutDate || booking?.checkOut;
      return checkOut === today;
    }) || [];
    
    const currentGuests = bookings?.filter(booking => {
      const checkIn = booking?.checkInDate || booking?.checkIn;
      const checkOut = booking?.checkOutDate || booking?.checkOut;
      return checkIn <= today && checkOut > today;
    }) || [];

    return {
      checkIns: checkIns.length,
      checkOuts: checkOuts.length,
      currentGuests: currentGuests.length
    };
  }, [bookings]);

  // Group rooms by floor
  const roomsByFloor = useMemo(() => {
    const floors = {};
    
    rooms?.forEach(room => {
      const floor = room?.floor || 1;
      if (!floors[floor]) {
        floors[floor] = [];
      }
      floors[floor].push(room);
    });
    
    return Object.entries(floors)
      .sort(([a], [b]) => Number(a) - Number(b))
      .map(([floor, rooms]) => ({ floor, rooms }));
  }, [rooms]);

  const handleStatusChange = async (roomId, newStatus) => {
    try {
      await onRoomStatusUpdate?.(roomId, newStatus);
    } catch (error) {
      console.error('Error updating room status:', error);
    }
  };

  const getStatusIcon = (status) => {
    const iconMap = {
      available: 'Home',
      occupied: 'User',
      maintenance: 'Wrench',
      blocked: 'Ban'
    };
    return iconMap?.[status] || 'Home';
  };

  const getStatusColor = (status) => {
    const colorMap = {
      available: 'text-success',
      occupied: 'text-error',
      maintenance: 'text-warning',
      blocked: 'text-muted-foreground'
    };
    return colorMap?.[status] || 'text-muted-foreground';
  };

  return (
    <div className="bg-card h-full">
      {/* Toggle Button for Mobile */}
      <button
        onClick={() => setIsExpanded(!isExpanded)}
        className="lg:hidden w-full p-4 text-left border-b border-border hover:bg-muted/50 transition-colors"
      >
        <div className="flex items-center justify-between">
          <span className="font-medium text-foreground">Room Status Panel</span>
          <Icon 
            name={isExpanded ? 'ChevronUp' : 'ChevronDown'} 
            size={20} 
            className="text-muted-foreground"
          />
        </div>
      </button>
      {/* Panel Content */}
      <div className={`${isExpanded ? 'block' : 'hidden'} lg:block h-full`}>
        {/* Status Overview */}
        <div className="p-4 border-b border-border">
          <h3 className="text-sm font-semibold text-foreground mb-3">Room Status Overview</h3>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-success/10 rounded-lg p-3">
              <div className="flex items-center space-x-2">
                <Icon name="Home" size={16} className="text-success" />
                <span className="text-sm font-medium text-success">Available</span>
              </div>
              <div className="text-lg font-bold text-success mt-1">{stats?.available}</div>
            </div>
            
            <div className="bg-error/10 rounded-lg p-3">
              <div className="flex items-center space-x-2">
                <Icon name="User" size={16} className="text-error" />
                <span className="text-sm font-medium text-error">Occupied</span>
              </div>
              <div className="text-lg font-bold text-error mt-1">{stats?.occupied}</div>
            </div>
            
            <div className="bg-warning/10 rounded-lg p-3">
              <div className="flex items-center space-x-2">
                <Icon name="Wrench" size={16} className="text-warning" />
                <span className="text-sm font-medium text-warning">Maintenance</span>
              </div>
              <div className="text-lg font-bold text-warning mt-1">{stats?.maintenance}</div>
            </div>
            
            <div className="bg-muted rounded-lg p-3">
              <div className="flex items-center space-x-2">
                <Icon name="Ban" size={16} className="text-muted-foreground" />
                <span className="text-sm font-medium text-muted-foreground">Blocked</span>
              </div>
              <div className="text-lg font-bold text-muted-foreground mt-1">{stats?.blocked}</div>
            </div>
          </div>
        </div>

        {/* Today's Activity */}
        <div className="p-4 border-b border-border">
          <h3 className="text-sm font-semibold text-foreground mb-3">Today's Activity</h3>
          
          <div className="space-y-3">
            <div className="flex items-center justify-between p-2 bg-blue-50 dark:bg-blue-950/20 rounded-lg">
              <div className="flex items-center space-x-2">
                <Icon name="LogIn" size={16} className="text-blue-600" />
                <span className="text-sm text-blue-900 dark:text-blue-100">Check-ins</span>
              </div>
              <span className="text-lg font-bold text-blue-600">{todayActivity.checkIns}</span>
            </div>
            
            <div className="flex items-center justify-between p-2 bg-orange-50 dark:bg-orange-950/20 rounded-lg">
              <div className="flex items-center space-x-2">
                <Icon name="LogOut" size={16} className="text-orange-600" />
                <span className="text-sm text-orange-900 dark:text-orange-100">Check-outs</span>
              </div>
              <span className="text-lg font-bold text-orange-600">{todayActivity.checkOuts}</span>
            </div>
            
            <div className="flex items-center justify-between p-2 bg-purple-50 dark:bg-purple-950/20 rounded-lg">
              <div className="flex items-center space-x-2">
                <Icon name="Users" size={16} className="text-purple-600" />
                <span className="text-sm text-purple-900 dark:text-purple-100">Current Guests</span>
              </div>
              <span className="text-lg font-bold text-purple-600">{todayActivity.currentGuests}</span>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="p-4 border-b border-border">
          <h3 className="text-sm font-semibold text-foreground mb-3">Quick Actions</h3>
          
          <div className="space-y-2">
            <Button
              variant="outline"
              size="sm"
              fullWidth
              iconName="RefreshCw"
              iconPosition="left"
              onClick={() => window.location.reload()}
            >
              Refresh Calendar
            </Button>
            
            <Button
              variant="outline"
              size="sm"
              fullWidth
              iconName="Calendar"
              iconPosition="left"
              onClick={() => {
                const today = new Date();
                console.log('Scroll to today:', today);
              }}
            >
              Go to Today
            </Button>
          </div>
        </div>

        {/* Rooms by Floor */}
        <div className="p-4">
          <h3 className="text-sm font-semibold text-foreground mb-3">Rooms by Floor</h3>
          
          <div className="space-y-4 max-h-96 overflow-y-auto">
            {roomsByFloor?.map(({ floor, rooms: floorRooms }) => (
              <div key={floor} className="space-y-2">
                <div className="flex items-center justify-between px-2">
                  <span className="text-xs font-semibold text-muted-foreground uppercase">
                    Floor {floor}
                  </span>
                  <span className="text-xs text-muted-foreground">
                    {floorRooms.length} room{floorRooms.length !== 1 ? 's' : ''}
                  </span>
                </div>
                
                {floorRooms.map((room) => (
                  <div
                    key={room?.id}
                    className="flex items-center justify-between p-2 rounded-md bg-muted/30 hover:bg-muted/50 transition-colors"
                  >
                    <div className="flex items-center space-x-2">
                      <Icon 
                        name={getStatusIcon(room?.status)} 
                        size={14} 
                        className={getStatusColor(room?.status)}
                      />
                      <div>
                        <div className="font-medium text-sm text-foreground">
                          Room {room?.roomNumber || room?.number}
                        </div>
                        <div className="text-xs text-muted-foreground">
                          {room?.roomType || room?.type}
                        </div>
                      </div>
                    </div>
                    
                    <select
                      value={room?.status?.toLowerCase() || 'available'}
                      onChange={(e) => handleStatusChange(room?.id, e.target.value.toUpperCase())}
                      onClick={(e) => e.stopPropagation()}
                      className="text-xs px-2 py-1 border border-border rounded bg-background text-foreground cursor-pointer hover:bg-muted transition-colors"
                    >
                      <option value="available">Available</option>
                      <option value="occupied">Occupied</option>
                      <option value="maintenance">Maintenance</option>
                      <option value="blocked">Blocked</option>
                    </select>
                  </div>
                ))}
              </div>
            ))}
            
            {roomsByFloor?.length === 0 && (
              <div className="text-center py-8 text-muted-foreground">
                <Icon name="Home" size={32} className="mx-auto mb-2 opacity-50" />
                <p className="text-sm">No rooms available</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default RoomStatusPanel;