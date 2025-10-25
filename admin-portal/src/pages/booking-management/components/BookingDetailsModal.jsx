import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import BookingStatusBadge from './BookingStatusBadge';
import PaymentStatusBadge from './PaymentStatusBadge';
import Image from '../../../components/AppImage';

const BookingDetailsModal = ({ isOpen, onClose, booking, onEdit, onCancel, onCheckIn }) => {
  const [activeTab, setActiveTab] = useState('details');

  if (!isOpen || !booking) return null;

  const formatDate = (dateString) => {
    return new Date(dateString)?.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    })?.format(amount);
  };

  const tabs = [
    { id: 'details', label: 'Booking Details', icon: 'FileText' },
    { id: 'guest', label: 'Guest Info', icon: 'User' },
    { id: 'payment', label: 'Payment', icon: 'CreditCard' },
    { id: 'history', label: 'History', icon: 'Clock' }
  ];

  const mockHistory = [
    {
      id: 1,
      action: 'Booking Created',
      timestamp: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
      user: 'System',
      details: 'Booking created via mobile app'
    },
    {
      id: 2,
      action: 'Payment Processed',
      timestamp: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000 + 5 * 60 * 1000),
      user: 'Payment Gateway',
      details: 'Credit card payment of $360.00 processed successfully'
    },
    {
      id: 3,
      action: 'Confirmation Sent',
      timestamp: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000 + 10 * 60 * 1000),
      user: 'System',
      details: 'Confirmation email sent to guest'
    }
  ];

  const renderTabContent = () => {
    switch (activeTab) {
      case 'details':
        return (
          <div className="space-y-6">
            {/* Booking Overview */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Booking ID</label>
                  <div className="text-lg font-semibold text-foreground">#{booking?.id}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Status</label>
                  <div className="mt-1">
                    <BookingStatusBadge status={booking?.status} />
                  </div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Created</label>
                  <div className="text-foreground">{formatDate(booking?.createdAt)}</div>
                </div>
              </div>
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Check-in</label>
                  <div className="text-foreground">{formatDate(booking?.checkIn)}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Check-out</label>
                  <div className="text-foreground">{formatDate(booking?.checkOut)}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Duration</label>
                  <div className="text-foreground">{booking?.nights} night{booking?.nights > 1 ? 's' : ''}</div>
                </div>
              </div>
            </div>
            {/* Room Details */}
            <div className="border-t border-border pt-6">
              <h4 className="text-lg font-medium text-foreground mb-4">Room Details</h4>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-4">
                  <div>
                    <label className="text-sm font-medium text-muted-foreground">Room Type</label>
                    <div className="text-foreground font-medium">{booking?.room?.type}</div>
                  </div>
                  <div>
                    <label className="text-sm font-medium text-muted-foreground">Room Number</label>
                    <div className="text-foreground">{booking?.room?.number}</div>
                  </div>
                </div>
                <div className="space-y-4">
                  <div>
                    <label className="text-sm font-medium text-muted-foreground">Guests</label>
                    <div className="text-foreground">{booking?.guests} guest{booking?.guests > 1 ? 's' : ''}</div>
                  </div>
                  <div>
                    <label className="text-sm font-medium text-muted-foreground">Rate per Night</label>
                    <div className="text-foreground">{formatCurrency(booking?.room?.rate)}</div>
                  </div>
                </div>
              </div>
            </div>
            {/* Special Requests */}
            {booking?.specialRequests && (
              <div className="border-t border-border pt-6">
                <h4 className="text-lg font-medium text-foreground mb-4">Special Requests</h4>
                <div className="bg-muted/50 rounded-lg p-4">
                  <p className="text-foreground">{booking?.specialRequests}</p>
                </div>
              </div>
            )}
          </div>
        );

      case 'guest':
        return (
          <div className="space-y-6">
            {/* Guest Profile */}
            <div className="flex items-center space-x-4">
              <div className="w-16 h-16 bg-muted rounded-full overflow-hidden flex-shrink-0">
                <Image
                  src={booking?.guest?.avatar}
                  alt={booking?.guest?.avatarAlt}
                  className="w-full h-full object-cover"
                />
              </div>
              <div>
                <h3 className="text-xl font-semibold text-foreground">{booking?.guest?.name}</h3>
                <p className="text-muted-foreground">{booking?.guest?.email}</p>
              </div>
            </div>
            {/* Contact Information */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Email</label>
                  <div className="text-foreground">{booking?.guest?.email}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Phone</label>
                  <div className="text-foreground">{booking?.guest?.phone}</div>
                </div>
              </div>
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Address</label>
                  <div className="text-foreground">{booking?.guest?.address || 'Not provided'}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Guest Type</label>
                  <div className="text-foreground">{booking?.guest?.type || 'Regular'}</div>
                </div>
              </div>
            </div>
            {/* Previous Bookings */}
            <div className="border-t border-border pt-6">
              <h4 className="text-lg font-medium text-foreground mb-4">Previous Bookings</h4>
              <div className="text-sm text-muted-foreground">
                This guest has made 3 previous bookings with us.
              </div>
            </div>
          </div>
        );

      case 'payment':
        return (
          <div className="space-y-6">
            {/* Payment Status */}
            <div className="flex items-center justify-between">
              <h3 className="text-lg font-medium text-foreground">Payment Information</h3>
              <PaymentStatusBadge 
                status={booking?.payment?.status} 
                amount={booking?.payment?.amount}
              />
            </div>
            {/* Payment Details */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Payment Method</label>
                  <div className="text-foreground">{booking?.payment?.method}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Transaction ID</label>
                  <div className="text-foreground font-mono text-sm">{booking?.payment?.transactionId}</div>
                </div>
              </div>
              <div className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Amount Paid</label>
                  <div className="text-foreground font-semibold">{formatCurrency(booking?.payment?.amount)}</div>
                </div>
                <div>
                  <label className="text-sm font-medium text-muted-foreground">Payment Date</label>
                  <div className="text-foreground">{formatDate(booking?.payment?.date)}</div>
                </div>
              </div>
            </div>
            {/* Billing Breakdown */}
            <div className="border-t border-border pt-6">
              <h4 className="text-lg font-medium text-foreground mb-4">Billing Breakdown</h4>
              <div className="bg-muted/50 rounded-lg p-4 space-y-3">
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Room Rate ({booking?.nights} nights)</span>
                  <span className="text-foreground">{formatCurrency(booking?.room?.rate * booking?.nights)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Taxes & Fees</span>
                  <span className="text-foreground">{formatCurrency(booking?.total * 0.12)}</span>
                </div>
                <div className="border-t border-border pt-3">
                  <div className="flex justify-between font-semibold">
                    <span className="text-foreground">Total Amount</span>
                    <span className="text-foreground">{formatCurrency(booking?.total)}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        );

      case 'history':
        return (
          <div className="space-y-6">
            <h3 className="text-lg font-medium text-foreground">Booking History</h3>
            <div className="space-y-4">
              {mockHistory?.map((entry) => (
                <div key={entry?.id} className="flex items-start space-x-4 pb-4 border-b border-border last:border-b-0">
                  <div className="w-8 h-8 bg-accent/10 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                    <Icon name="Clock" size={14} className="text-accent" />
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center justify-between mb-1">
                      <h4 className="font-medium text-foreground">{entry?.action}</h4>
                      <span className="text-xs text-muted-foreground">
                        {entry?.timestamp?.toLocaleDateString()} {entry?.timestamp?.toLocaleTimeString()}
                      </span>
                    </div>
                    <p className="text-sm text-muted-foreground mb-1">{entry?.details}</p>
                    <p className="text-xs text-muted-foreground">by {entry?.user}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-500 p-4">
      <div className="bg-card border border-border rounded-lg w-full max-w-4xl max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-border">
          <div>
            <h2 className="text-xl font-semibold text-foreground">Booking Details</h2>
            <p className="text-sm text-muted-foreground">#{booking?.id}</p>
          </div>
          <div className="flex items-center space-x-2">
            {booking?.status === 'confirmed' && (
              <Button
                variant="outline"
                size="sm"
                onClick={() => onCheckIn(booking)}
                iconName="LogIn"
                iconPosition="left"
              >
                Check In
              </Button>
            )}
            <Button
              variant="outline"
              size="sm"
              onClick={() => onEdit(booking)}
              iconName="Edit"
              iconPosition="left"
            >
              Edit
            </Button>
            {['confirmed', 'pending']?.includes(booking?.status) && (
              <Button
                variant="destructive"
                size="sm"
                onClick={() => onCancel(booking)}
                iconName="X"
                iconPosition="left"
              >
                Cancel
              </Button>
            )}
            <Button
              variant="ghost"
              size="sm"
              onClick={onClose}
              iconName="X"
            />
          </div>
        </div>

        {/* Tabs */}
        <div className="border-b border-border">
          <nav className="flex space-x-8 px-6">
            {tabs?.map((tab) => (
              <button
                key={tab?.id}
                onClick={() => setActiveTab(tab?.id)}
                className={`
                  flex items-center space-x-2 py-4 border-b-2 font-medium text-sm transition-colors
                  ${activeTab === tab?.id
                    ? 'border-accent text-accent' :'border-transparent text-muted-foreground hover:text-foreground'
                  }
                `}
              >
                <Icon name={tab?.icon} size={16} />
                <span>{tab?.label}</span>
              </button>
            ))}
          </nav>
        </div>

        {/* Content */}
        <div className="overflow-y-auto max-h-[calc(90vh-200px)] p-6">
          {renderTabContent()}
        </div>
      </div>
    </div>
  );
};

export default BookingDetailsModal;