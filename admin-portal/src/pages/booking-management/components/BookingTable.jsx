import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import { Checkbox } from '../../../components/ui/Checkbox';
import BookingStatusBadge from './BookingStatusBadge';
import PaymentStatusBadge from './PaymentStatusBadge';
import Image from '../../../components/AppImage';

const BookingTable = ({ 
  bookings = [], 
  onViewBooking, 
  onEditBooking, 
  onCancelBooking, 
  onCheckIn,
  onBulkAction,
  currentPage = 1,
  totalPages = 1,
  onPageChange,
  sortBy = 'checkIn',
  sortOrder = 'asc',
  onSort
}) => {
  const [selectedBookings, setSelectedBookings] = useState([]);

  const handleSelectAll = (checked) => {
    if (checked) {
      setSelectedBookings(bookings?.map(booking => booking?.id));
    } else {
      setSelectedBookings([]);
    }
  };

  const handleSelectBooking = (bookingId, checked) => {
    if (checked) {
      setSelectedBookings([...selectedBookings, bookingId]);
    } else {
      setSelectedBookings(selectedBookings?.filter(id => id !== bookingId));
    }
  };

  const handleBulkAction = (action) => {
    if (selectedBookings?.length > 0) {
      onBulkAction(action, selectedBookings);
      setSelectedBookings([]);
    }
  };

  const getSortIcon = (column) => {
    if (sortBy !== column) return 'ArrowUpDown';
    return sortOrder === 'asc' ? 'ArrowUp' : 'ArrowDown';
  };

  const handleSort = (column) => {
    const newOrder = sortBy === column && sortOrder === 'asc' ? 'desc' : 'asc';
    onSort(column, newOrder);
  };

  const formatDate = (dateString) => {
    return new Date(dateString)?.toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric'
    });
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    })?.format(amount);
  };

  return (
    <div className="bg-card border border-border rounded-lg overflow-hidden">
      {/* Bulk Actions Bar */}
      {selectedBookings?.length > 0 && (
        <div className="bg-accent/5 border-b border-border px-6 py-3">
          <div className="flex items-center justify-between">
            <span className="text-sm text-foreground">
              {selectedBookings?.length} booking{selectedBookings?.length > 1 ? 's' : ''} selected
            </span>
            <div className="flex items-center space-x-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => handleBulkAction('email')}
                iconName="Mail"
                iconPosition="left"
              >
                Send Email
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => handleBulkAction('export')}
                iconName="Download"
                iconPosition="left"
              >
                Export
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => handleBulkAction('status-update')}
                iconName="Edit"
                iconPosition="left"
              >
                Update Status
              </Button>
            </div>
          </div>
        </div>
      )}
      {/* Desktop Table View */}
      <div className="hidden lg:block overflow-x-auto">
        <table className="w-full">
          <thead className="bg-muted/50 border-b border-border">
            <tr>
              <th className="w-12 px-6 py-4">
                <Checkbox
                  checked={selectedBookings?.length === bookings?.length && bookings?.length > 0}
                  onChange={(e) => handleSelectAll(e?.target?.checked)}
                />
              </th>
              <th className="px-6 py-4 text-left">
                <button
                  onClick={() => handleSort('id')}
                  className="flex items-center space-x-1 text-sm font-medium text-foreground hover:text-accent"
                >
                  <span>Booking ID</span>
                  <Icon name={getSortIcon('id')} size={14} />
                </button>
              </th>
              <th className="px-6 py-4 text-left">
                <button
                  onClick={() => handleSort('guest')}
                  className="flex items-center space-x-1 text-sm font-medium text-foreground hover:text-accent"
                >
                  <span>Guest</span>
                  <Icon name={getSortIcon('guest')} size={14} />
                </button>
              </th>
              <th className="px-6 py-4 text-left">
                <button
                  onClick={() => handleSort('checkIn')}
                  className="flex items-center space-x-1 text-sm font-medium text-foreground hover:text-accent"
                >
                  <span>Check-in / Check-out</span>
                  <Icon name={getSortIcon('checkIn')} size={14} />
                </button>
              </th>
              <th className="px-6 py-4 text-left">Room Details</th>
              <th className="px-6 py-4 text-left">
                <button
                  onClick={() => handleSort('status')}
                  className="flex items-center space-x-1 text-sm font-medium text-foreground hover:text-accent"
                >
                  <span>Status</span>
                  <Icon name={getSortIcon('status')} size={14} />
                </button>
              </th>
              <th className="px-6 py-4 text-left">Payment</th>
              <th className="px-6 py-4 text-left">
                <button
                  onClick={() => handleSort('total')}
                  className="flex items-center space-x-1 text-sm font-medium text-foreground hover:text-accent"
                >
                  <span>Total</span>
                  <Icon name={getSortIcon('total')} size={14} />
                </button>
              </th>
              <th className="px-6 py-4 text-center">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {bookings?.map((booking) => (
              <tr key={booking?.id} className="hover:bg-muted/30 transition-colors">
                <td className="px-6 py-4">
                  <Checkbox
                    checked={selectedBookings?.includes(booking?.id)}
                    onChange={(e) => handleSelectBooking(booking?.id, e?.target?.checked)}
                  />
                </td>
                <td className="px-6 py-4">
                  <div className="font-medium text-foreground">#{booking?.id}</div>
                  <div className="text-xs text-muted-foreground">
                    {formatDate(booking?.createdAt)}
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-muted rounded-full overflow-hidden flex-shrink-0">
                      <Image
                        src={booking?.guest?.avatar}
                        alt={booking?.guest?.avatarAlt}
                        className="w-full h-full object-cover"
                      />
                    </div>
                    <div>
                      <div className="font-medium text-foreground">{booking?.guest?.name}</div>
                      <div className="text-sm text-muted-foreground">{booking?.guest?.email}</div>
                      <div className="text-xs text-muted-foreground">{booking?.guest?.phone}</div>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="space-y-1">
                    <div className="flex items-center space-x-2">
                      <Icon name="Calendar" size={14} className="text-muted-foreground" />
                      <span className="text-sm text-foreground">{formatDate(booking?.checkIn)}</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Icon name="Calendar" size={14} className="text-muted-foreground" />
                      <span className="text-sm text-foreground">{formatDate(booking?.checkOut)}</span>
                    </div>
                    <div className="text-xs text-muted-foreground">
                      {booking?.nights} night{booking?.nights > 1 ? 's' : ''}
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="space-y-1">
                    <div className="font-medium text-foreground">{booking?.room?.type}</div>
                    <div className="text-sm text-muted-foreground">Room {booking?.room?.number}</div>
                    <div className="text-xs text-muted-foreground">
                      {booking?.guests} guest{booking?.guests > 1 ? 's' : ''}
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <BookingStatusBadge status={booking?.status} />
                </td>
                <td className="px-6 py-4">
                  <PaymentStatusBadge 
                    status={booking?.payment?.status} 
                    amount={booking?.payment?.amount}
                  />
                </td>
                <td className="px-6 py-4">
                  <div className="font-semibold text-foreground">
                    {formatCurrency(booking?.total)}
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="flex items-center justify-center space-x-1">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => onViewBooking(booking)}
                      iconName="Eye"
                      title="View Details"
                    />
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => onEditBooking(booking)}
                      iconName="Edit"
                      title="Edit Booking"
                    />
                    {booking?.status === 'confirmed' && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => onCheckIn(booking)}
                        iconName="LogIn"
                        title="Check In"
                      />
                    )}
                    {['confirmed', 'pending']?.includes(booking?.status) && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => onCancelBooking(booking)}
                        iconName="X"
                        title="Cancel Booking"
                      />
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {/* Mobile Card View */}
      <div className="lg:hidden divide-y divide-border">
        {bookings?.map((booking) => (
          <div key={booking?.id} className="p-4">
            <div className="flex items-start justify-between mb-3">
              <div className="flex items-center space-x-3">
                <Checkbox
                  checked={selectedBookings?.includes(booking?.id)}
                  onChange={(e) => handleSelectBooking(booking?.id, e?.target?.checked)}
                />
                <div>
                  <div className="font-medium text-foreground">#{booking?.id}</div>
                  <div className="text-xs text-muted-foreground">
                    {formatDate(booking?.createdAt)}
                  </div>
                </div>
              </div>
              <BookingStatusBadge status={booking?.status} size="sm" />
            </div>

            <div className="flex items-center space-x-3 mb-3">
              <div className="w-12 h-12 bg-muted rounded-full overflow-hidden flex-shrink-0">
                <Image
                  src={booking?.guest?.avatar}
                  alt={booking?.guest?.avatarAlt}
                  className="w-full h-full object-cover"
                />
              </div>
              <div className="flex-1">
                <div className="font-medium text-foreground">{booking?.guest?.name}</div>
                <div className="text-sm text-muted-foreground">{booking?.guest?.email}</div>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4 mb-3 text-sm">
              <div>
                <div className="text-muted-foreground">Check-in</div>
                <div className="font-medium text-foreground">{formatDate(booking?.checkIn)}</div>
              </div>
              <div>
                <div className="text-muted-foreground">Check-out</div>
                <div className="font-medium text-foreground">{formatDate(booking?.checkOut)}</div>
              </div>
              <div>
                <div className="text-muted-foreground">Room</div>
                <div className="font-medium text-foreground">
                  {booking?.room?.type} - {booking?.room?.number}
                </div>
              </div>
              <div>
                <div className="text-muted-foreground">Total</div>
                <div className="font-semibold text-foreground">{formatCurrency(booking?.total)}</div>
              </div>
            </div>

            <div className="flex items-center justify-between">
              <PaymentStatusBadge 
                status={booking?.payment?.status} 
                size="sm"
              />
              <div className="flex items-center space-x-1">
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => onViewBooking(booking)}
                  iconName="Eye"
                />
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => onEditBooking(booking)}
                  iconName="Edit"
                />
                {booking?.status === 'confirmed' && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => onCheckIn(booking)}
                    iconName="LogIn"
                  />
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
      {/* Pagination */}
      {totalPages > 1 && (
        <div className="border-t border-border px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="text-sm text-muted-foreground">
              Page {currentPage} of {totalPages}
            </div>
            <div className="flex items-center space-x-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => onPageChange(currentPage - 1)}
                disabled={currentPage === 1}
                iconName="ChevronLeft"
              />
              <Button
                variant="outline"
                size="sm"
                onClick={() => onPageChange(currentPage + 1)}
                disabled={currentPage === totalPages}
                iconName="ChevronRight"
              />
            </div>
          </div>
        </div>
      )}
      {/* Empty State */}
      {bookings?.length === 0 && (
        <div className="text-center py-12">
          <Icon name="Calendar" size={48} className="mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-medium text-foreground mb-2">No bookings found</h3>
          <p className="text-muted-foreground mb-4">
            No bookings match your current filters. Try adjusting your search criteria.
          </p>
          <Button variant="outline" iconName="RotateCcw" iconPosition="left">
            Reset Filters
          </Button>
        </div>
      )}
    </div>
  );
};

export default BookingTable;