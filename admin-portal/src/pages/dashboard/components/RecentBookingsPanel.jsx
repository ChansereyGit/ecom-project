import React from 'react';
import Icon from '../../../components/AppIcon';
import Image from '../../../components/AppImage';

const RecentBookingsPanel = () => {
  const recentBookings = [
  {
    id: 'BK001',
    guestName: 'Michael Rodriguez',
    guestAvatar: "https://images.unsplash.com/photo-1724128195747-dd25cba7860f",
    guestAvatarAlt: 'Professional headshot of Hispanic man with short black hair in navy suit',
    roomType: 'Deluxe Suite',
    roomNumber: '205',
    checkIn: '2024-10-15',
    checkOut: '2024-10-17',
    status: 'confirmed',
    amount: '$450.00',
    bookingTime: '2 hours ago'
  },
  {
    id: 'BK002',
    guestName: 'Sarah Chen',
    guestAvatar: "https://images.unsplash.com/photo-1668049221564-862149a48e10",
    guestAvatarAlt: 'Professional Asian woman with long black hair smiling in business attire',
    roomType: 'Standard Room',
    roomNumber: '102',
    checkIn: '2024-10-16',
    checkOut: '2024-10-18',
    status: 'pending',
    amount: '$280.00',
    bookingTime: '4 hours ago'
  },
  {
    id: 'BK003',
    guestName: 'David Thompson',
    guestAvatar: "https://images.unsplash.com/photo-1697215968602-77b6b1c1d811",
    guestAvatarAlt: 'Middle-aged Caucasian man with beard wearing casual blue shirt',
    roomType: 'Executive Suite',
    roomNumber: '301',
    checkIn: '2024-10-14',
    checkOut: '2024-10-16',
    status: 'checked-in',
    amount: '$650.00',
    bookingTime: '6 hours ago'
  },
  {
    id: 'BK004',
    guestName: 'Emma Wilson',
    guestAvatar: "https://images.unsplash.com/photo-1621425724464-48f877473f9a",
    guestAvatarAlt: 'Young blonde woman in white blouse smiling at camera',
    roomType: 'Standard Room',
    roomNumber: '108',
    checkIn: '2024-10-18',
    checkOut: '2024-10-20',
    status: 'confirmed',
    amount: '$320.00',
    bookingTime: '8 hours ago'
  },
  {
    id: 'BK005',
    guestName: 'James Park',
    guestAvatar: "https://images.unsplash.com/photo-1629272039203-7d76fdaf1324",
    guestAvatarAlt: 'Asian man in dark suit jacket with professional smile',
    roomType: 'Deluxe Room',
    roomNumber: '203',
    checkIn: '2024-10-19',
    checkOut: '2024-10-21',
    status: 'cancelled',
    amount: '$380.00',
    bookingTime: '1 day ago'
  }];


  const getStatusColor = (status) => {
    const colors = {
      confirmed: 'bg-success/10 text-success border-success/20',
      pending: 'bg-warning/10 text-warning border-warning/20',
      'checked-in': 'bg-accent/10 text-accent border-accent/20',
      cancelled: 'bg-error/10 text-error border-error/20'
    };
    return colors?.[status] || 'bg-muted/10 text-muted-foreground border-muted/20';
  };

  const getStatusIcon = (status) => {
    const icons = {
      confirmed: 'CheckCircle',
      pending: 'Clock',
      'checked-in': 'UserCheck',
      cancelled: 'XCircle'
    };
    return icons?.[status] || 'Circle';
  };

  return (
    <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
      <div className="flex items-center justify-between mb-6">
        <h3 className="text-lg font-semibold text-foreground">Recent Bookings</h3>
        <button className="text-sm text-accent hover:text-accent/80 transition-colors">
          View All
        </button>
      </div>
      <div className="space-y-4">
        {recentBookings?.map((booking) =>
        <div
          key={booking?.id}
          className="flex items-center space-x-4 p-4 rounded-lg hover:bg-muted/50 transition-colors cursor-pointer">

            {/* Guest Avatar */}
            <div className="flex-shrink-0">
              <Image
              src={booking?.guestAvatar}
              alt={booking?.guestAvatarAlt}
              className="w-12 h-12 rounded-full object-cover" />

            </div>

            {/* Booking Details */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between mb-1">
                <h4 className="text-sm font-medium text-foreground truncate">
                  {booking?.guestName}
                </h4>
                <span className="text-sm font-semibold text-foreground">
                  {booking?.amount}
                </span>
              </div>
              
              <div className="flex items-center space-x-2 mb-2">
                <span className="text-xs text-muted-foreground">
                  {booking?.roomType} • Room {booking?.roomNumber}
                </span>
              </div>

              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <span className="text-xs text-muted-foreground">
                    {new Date(booking.checkIn)?.toLocaleDateString()} - {new Date(booking.checkOut)?.toLocaleDateString()}
                  </span>
                </div>
                <span className="text-xs text-muted-foreground">
                  {booking?.bookingTime}
                </span>
              </div>
            </div>

            {/* Status Badge */}
            <div className="flex-shrink-0">
              <div className={`
                flex items-center space-x-1 px-2 py-1 rounded-full border text-xs font-medium
                ${getStatusColor(booking?.status)}
              `}>
                <Icon name={getStatusIcon(booking?.status)} size={12} />
                <span className="capitalize">{booking?.status?.replace('-', ' ')}</span>
              </div>
            </div>
          </div>
        )}
      </div>
      <div className="mt-6 pt-4 border-t border-border">
        <button className="w-full text-center text-sm text-accent hover:text-accent/80 transition-colors">
          Manage All Bookings
        </button>
      </div>
    </div>);

};

export default RecentBookingsPanel;