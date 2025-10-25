import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';

const BookingBlock = ({ booking, onUpdate, compact = false }) => {
  const [isDragging, setIsDragging] = useState(false);

  const getStatusColor = (status) => {
    const statusColors = {
      confirmed: 'bg-success text-success-foreground',
      pending: 'bg-warning text-warning-foreground',
      'checked-in': 'bg-accent text-accent-foreground',
      'checked-out': 'bg-muted text-muted-foreground',
      cancelled: 'bg-error text-error-foreground'
    };
    return statusColors?.[status] || 'bg-muted text-muted-foreground';
  };

  const handleDragStart = (e) => {
    setIsDragging(true);
    e?.dataTransfer?.setData('text/plain', JSON.stringify({
      bookingId: booking?.id,
      type: 'booking'
    }));
  };

  const handleDragEnd = () => {
    setIsDragging(false);
  };

  const handleClick = (e) => {
    e?.stopPropagation();
    // Open booking details modal
    console.log('Open booking details for:', booking?.id);
  };

  const calculateNights = () => {
    const checkIn = new Date(booking.checkIn);
    const checkOut = new Date(booking.checkOut);
    const diffTime = Math.abs(checkOut - checkIn);
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  };

  if (compact) {
    return (
      <div
        className={`
          px-2 py-1 rounded text-xs font-medium cursor-pointer transition-all
          ${getStatusColor(booking?.status)}
          ${isDragging ? 'opacity-50 scale-95' : 'hover:shadow-sm'}
        `}
        draggable
        onDragStart={handleDragStart}
        onDragEnd={handleDragEnd}
        onClick={handleClick}
        title={`${booking?.guestName} - ${booking?.status}`}
      >
        <div className="truncate">{booking?.guestName}</div>
      </div>
    );
  }

  return (
    <div
      className={`
        p-2 rounded-md cursor-pointer transition-all border
        ${getStatusColor(booking?.status)}
        ${isDragging ? 'opacity-50 scale-95' : 'hover:shadow-elevation-1'}
      `}
      draggable
      onDragStart={handleDragStart}
      onDragEnd={handleDragEnd}
      onClick={handleClick}
    >
      <div className="space-y-1">
        {/* Guest Name */}
        <div className="font-medium text-sm truncate">
          {booking?.guestName}
        </div>

        {/* Booking Details */}
        <div className="flex items-center justify-between text-xs opacity-90">
          <span>{calculateNights()}n</span>
          <div className="flex items-center space-x-1">
            {booking?.status === 'confirmed' && (
              <Icon name="CheckCircle" size={12} />
            )}
            {booking?.status === 'pending' && (
              <Icon name="Clock" size={12} />
            )}
            {booking?.status === 'checked-in' && (
              <Icon name="Key" size={12} />
            )}
            {booking?.status === 'cancelled' && (
              <Icon name="XCircle" size={12} />
            )}
          </div>
        </div>

        {/* Additional Info */}
        {booking?.specialRequests && (
          <div className="flex items-center text-xs opacity-75">
            <Icon name="MessageSquare" size={10} className="mr-1" />
            <span className="truncate">Special requests</span>
          </div>
        )}
      </div>
    </div>
  );
};

export default BookingBlock;