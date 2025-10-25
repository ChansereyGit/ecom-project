import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import BookingBlock from './BookingBlock';
import QuickBookingModal from './QuickBookingModal';

const CalendarGrid = ({ 
  rooms, 
  bookings, 
  currentDate, 
  viewMode, 
  filters,
  onBookingUpdate,
  onBookingCreate 
}) => {
  const [selectedCell, setSelectedCell] = useState(null);
  const [showQuickBooking, setShowQuickBooking] = useState(false);

  // Generate date range based on view mode
  const generateDateRange = () => {
    const dates = [];
    const startDate = new Date(currentDate);
    
    if (viewMode === 'daily') {
      dates?.push(new Date(startDate));
    } else if (viewMode === 'weekly') {
      startDate?.setDate(startDate?.getDate() - startDate?.getDay());
      for (let i = 0; i < 7; i++) {
        const date = new Date(startDate);
        date?.setDate(startDate?.getDate() + i);
        dates?.push(date);
      }
    } else { // monthly
      startDate?.setDate(1);
      const endDate = new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0);
      for (let i = 1; i <= endDate?.getDate(); i++) {
        const date = new Date(startDate.getFullYear(), startDate.getMonth(), i);
        dates?.push(date);
      }
    }
    
    return dates;
  };

  const dateRange = generateDateRange();

  // Filter rooms based on filters
  const filteredRooms = rooms?.filter(room => {
    // Handle both old format (type) and new format (roomTypeName)
    const roomType = room?.roomTypeName || room?.type;
    if (filters?.roomType !== 'all' && roomType !== filters?.roomType) return false;
    if (filters?.status !== 'all' && room?.status?.toLowerCase() !== filters?.status) return false;
    return true;
  });

  // Get bookings for a specific room and date
  const getBookingsForRoomAndDate = (roomId, date) => {
    const dateStr = date?.toISOString()?.split('T')?.[0];
    
    const matchedBookings = bookings?.filter(booking => {
      // Try multiple ways to match the room
      const roomInstanceId = booking?.roomInstanceId || booking?.room_instance_id;
      const bookingRoomId = booking?.roomId || booking?.room_id;
      const roomNumber = booking?.roomNumber || booking?.room_number;
      
      const matchesRoom = roomInstanceId === roomId || 
                         bookingRoomId === roomId ||
                         roomNumber === roomId;
      
      // Check if date falls within booking range
      const checkIn = booking?.checkInDate || booking?.checkInDate || booking?.check_in_date;
      const checkOut = booking?.checkOutDate || booking?.checkOutDate || booking?.check_out_date;
      
      const inRange = checkIn && checkOut && checkIn <= dateStr && checkOut > dateStr;
      
      // Debug logging for first date only
      if (dateStr === dateRange[0]?.toISOString()?.split('T')?.[0]) {
        console.log('Checking booking:', {
          bookingId: booking?.id,
          roomInstanceId,
          roomId,
          matchesRoom,
          checkIn,
          checkOut,
          dateStr,
          inRange
        });
      }
      
      return matchesRoom && inRange;
    });
    
    return matchedBookings;
  };

  // Check if this is the first day of a booking
  const isBookingStart = (booking, date) => {
    const dateStr = date?.toISOString()?.split('T')?.[0];
    const checkIn = booking?.checkInDate || booking?.checkIn;
    return checkIn === dateStr;
  };

  // Calculate how many days a booking spans from this date
  const getBookingSpan = (booking, startDate) => {
    const checkIn = new Date(booking?.checkInDate || booking?.checkIn);
    const checkOut = new Date(booking?.checkOutDate || booking?.checkOut);
    const currentDate = new Date(startDate);
    
    // If this isn't the start date, return 0
    if (checkIn.toISOString().split('T')[0] !== currentDate.toISOString().split('T')[0]) {
      return 0;
    }
    
    // Calculate how many visible days this booking spans
    const visibleDates = dateRange.filter(d => {
      const dStr = d.toISOString().split('T')[0];
      return dStr >= checkIn.toISOString().split('T')[0] && dStr < checkOut.toISOString().split('T')[0];
    });
    
    return visibleDates.length;
  };

  const handleCellClick = (roomId, date) => {
    const roomBookings = getBookingsForRoomAndDate(roomId, date);
    if (roomBookings?.length === 0) {
      setSelectedCell({ roomId, date });
      setShowQuickBooking(true);
    }
  };

  const handleQuickBookingClose = () => {
    setShowQuickBooking(false);
    setSelectedCell(null);
  };

  const handleQuickBookingSubmit = (bookingData) => {
    // bookingData already has the correct format from QuickBookingModal
    onBookingCreate(bookingData);
  };

  const getRoomStatusColor = (status) => {
    const statusColors = {
      available: 'bg-success/10 text-success',
      occupied: 'bg-error/10 text-error',
      maintenance: 'bg-warning/10 text-warning',
      blocked: 'bg-muted text-muted-foreground'
    };
    return statusColors?.[status] || 'bg-muted text-muted-foreground';
  };

  const formatDateHeader = (date) => {
    if (viewMode === 'daily') {
      return date?.toLocaleDateString('en-US', { 
        weekday: 'short', 
        month: 'short', 
        day: 'numeric' 
      });
    } else if (viewMode === 'weekly') {
      return date?.toLocaleDateString('en-US', { 
        weekday: 'short', 
        day: 'numeric' 
      });
    }
    return date?.getDate()?.toString();
  };

  return (
    <>
      <div className="flex-1 overflow-auto bg-background">
        <div className="min-w-full">
          {/* Calendar Header Row */}
          <div className="sticky top-0 z-10 bg-card border-b border-border">
            <div className="flex">
              {/* Room Column Header */}
              <div className="w-48 flex-shrink-0 p-4 border-r border-border bg-muted/50">
                <h3 className="text-sm font-semibold text-foreground">Rooms</h3>
              </div>
              
              {/* Date Headers */}
              <div className="flex flex-1 min-w-0">
                {dateRange?.map((date, index) => (
                  <div 
                    key={index}
                    className="flex-1 min-w-32 p-4 border-r border-border text-center bg-muted/50"
                  >
                    <div className="text-sm font-medium text-foreground">
                      {formatDateHeader(date)}
                    </div>
                    {viewMode !== 'monthly' && (
                      <div className="text-xs text-muted-foreground mt-1">
                        {date?.toLocaleDateString('en-US', { month: 'short' })}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Calendar Body */}
          <div className="divide-y divide-border">
            {filteredRooms?.map((room) => (
              <div key={room?.id} className="flex hover:bg-muted/30 transition-colors">
                {/* Room Info Column */}
                <div className="w-48 flex-shrink-0 p-4 border-r border-border bg-card">
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="font-medium text-foreground">
                        Room {room?.roomNumber || room?.number}
                      </span>
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${getRoomStatusColor(room?.status?.toLowerCase())}`}>
                        {room?.status}
                      </span>
                    </div>
                    <div className="text-sm text-muted-foreground">
                      {room?.roomTypeName || room?.type} • Floor {room?.floor}
                    </div>
                    <div className="text-xs text-muted-foreground">
                      ${room?.pricePerNight || room?.baseRate}/night
                    </div>
                  </div>
                </div>

                {/* Date Cells */}
                <div className="flex flex-1 min-w-0">
                  {dateRange?.map((date, dateIndex) => {
                    const cellBookings = getBookingsForRoomAndDate(room?.id, date);
                    const isToday = date?.toDateString() === new Date()?.toDateString();
                    
                    return (
                      <div 
                        key={dateIndex}
                        className={`
                          flex-1 min-w-32 min-h-20 p-2 border-r border-border cursor-pointer
                          hover:bg-accent/5 transition-colors relative
                          ${isToday ? 'bg-accent/10' : 'bg-card'}
                        `}
                        onClick={() => handleCellClick(room?.id, date)}
                      >
                        {/* Today Indicator */}
                        {isToday && (
                          <div className="absolute top-1 right-1 w-2 h-2 bg-accent rounded-full" />
                        )}
                        {/* Booking Blocks - Only show on first day */}
                        <div className="space-y-1">
                          {cellBookings?.map((booking) => {
                            const span = getBookingSpan(booking, date);
                            const isStart = isBookingStart(booking, date);
                            
                            // Only render on the first day of the booking
                            if (!isStart) return null;
                            
                            return (
                              <div
                                key={booking?.id}
                                className="relative"
                                style={{
                                  width: span > 1 ? `calc(${span * 100}% + ${(span - 1) * 8}px)` : '100%',
                                  zIndex: 10
                                }}
                              >
                                <BookingBlock
                                  booking={{
                                    ...booking,
                                    checkIn: booking?.checkInDate || booking?.checkIn,
                                    checkOut: booking?.checkOutDate || booking?.checkOut
                                  }}
                                  onUpdate={onBookingUpdate}
                                  compact={viewMode === 'monthly'}
                                />
                              </div>
                            );
                          })}
                        </div>
                        {/* Empty Cell Indicator */}
                        {cellBookings?.length === 0 && room?.status?.toLowerCase() === 'available' && (
                          <div className="flex items-center justify-center h-full opacity-0 hover:opacity-100 transition-opacity">
                            <Icon name="Plus" size={16} className="text-muted-foreground" />
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      {/* Quick Booking Modal */}
      {showQuickBooking && selectedCell && (
        <QuickBookingModal
          isOpen={showQuickBooking}
          onClose={handleQuickBookingClose}
          onSubmit={handleQuickBookingSubmit}
          selectedRoom={filteredRooms?.find(r => r?.id === selectedCell?.roomId)}
          selectedDate={selectedCell?.date}
        />
      )}
    </>
  );
};

export default CalendarGrid;