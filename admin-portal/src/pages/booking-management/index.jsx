import React, { useState, useEffect } from 'react';
import SidebarNavigation from '../../components/ui/SidebarNavigation';
import UserProfileDropdown from '../../components/ui/UserProfileDropdown';
import NotificationIndicator from '../../components/ui/NotificationIndicator';
import Button from '../../components/ui/Button';
import Icon from '../../components/AppIcon';
import BookingFilters from './components/BookingFilters';
import BookingTable from './components/BookingTable';
import NewBookingModal from './components/NewBookingModal';
import BookingDetailsModal from './components/BookingDetailsModal';
import { bookingsAPI } from '../../services/api';

const BookingManagement = () => {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const [showNewBookingModal, setShowNewBookingModal] = useState(false);
  const [showBookingDetailsModal, setShowBookingDetailsModal] = useState(false);
  const [selectedBooking, setSelectedBooking] = useState(null);
  const [bookings, setBookings] = useState([]);
  const [filteredBookings, setFilteredBookings] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [sortBy, setSortBy] = useState('checkIn');
  const [sortOrder, setSortOrder] = useState('asc');
  const [isLoading, setIsLoading] = useState(true);

  const itemsPerPage = 10;

  // Mock bookings data
  const mockBookings = [
  {
    id: "BK001",
    guest: {
      name: "Sarah Johnson",
      email: "sarah.johnson@email.com",
      phone: "+1 (555) 123-4567",
      address: "123 Main St, New York, NY 10001",
      type: "VIP",
      avatar: "https://images.unsplash.com/photo-1734991032476-bceab8383a59",
      avatarAlt: "Professional headshot of woman with shoulder-length brown hair in business attire"
    },
    checkIn: "2024-10-16",
    checkOut: "2024-10-18",
    nights: 2,
    room: {
      type: "Deluxe Room",
      number: "205",
      rate: 180
    },
    guests: 2,
    status: "confirmed",
    payment: {
      status: "paid",
      method: "Credit Card",
      amount: 360,
      transactionId: "TXN123456789",
      date: "2024-10-14"
    },
    total: 403.20,
    specialRequests: "Late check-in requested, non-smoking room preferred",
    createdAt: "2024-10-12"
  },
  {
    id: "BK002",
    guest: {
      name: "Michael Rodriguez",
      email: "m.rodriguez@email.com",
      phone: "+1 (555) 987-6543",
      address: "456 Oak Ave, Los Angeles, CA 90210",
      type: "Regular",
      avatar: "https://images.unsplash.com/photo-1724128195747-dd25cba7860f",
      avatarAlt: "Professional headshot of Hispanic man with short black hair in navy suit"
    },
    checkIn: "2024-10-15",
    checkOut: "2024-10-20",
    nights: 5,
    room: {
      type: "Suite",
      number: "301",
      rate: 250
    },
    guests: 3,
    status: "checked-in",
    payment: {
      status: "paid",
      method: "Debit Card",
      amount: 1250,
      transactionId: "TXN987654321",
      date: "2024-10-13"
    },
    total: 1400.00,
    specialRequests: "Extra towels and pillows for additional guest",
    createdAt: "2024-10-10"
  },
  {
    id: "BK003",
    guest: {
      name: "Emily Chen",
      email: "emily.chen@email.com",
      phone: "+1 (555) 456-7890",
      address: "789 Pine St, Seattle, WA 98101",
      type: "Regular",
      avatar: "https://images.unsplash.com/photo-1668049221564-862149a48e10",
      avatarAlt: "Professional headshot of Asian woman with long black hair smiling at camera"
    },
    checkIn: "2024-10-17",
    checkOut: "2024-10-19",
    nights: 2,
    room: {
      type: "Standard Room",
      number: "102",
      rate: 120
    },
    guests: 1,
    status: "pending",
    payment: {
      status: "pending",
      method: "Credit Card",
      amount: 240,
      transactionId: "TXN456789123",
      date: "2024-10-14"
    },
    total: 268.80,
    specialRequests: "",
    createdAt: "2024-10-14"
  },
  {
    id: "BK004",
    guest: {
      name: "David Thompson",
      email: "david.thompson@email.com",
      phone: "+1 (555) 321-0987",
      address: "321 Elm St, Chicago, IL 60601",
      type: "VIP",
      avatar: "https://images.unsplash.com/photo-1714974528889-d51109fb6ae9",
      avatarAlt: "Professional headshot of middle-aged man with gray hair in dark suit"
    },
    checkIn: "2024-10-20",
    checkOut: "2024-10-25",
    nights: 5,
    room: {
      type: "Presidential Suite",
      number: "401",
      rate: 450
    },
    guests: 2,
    status: "confirmed",
    payment: {
      status: "partial",
      method: "Bank Transfer",
      amount: 1125,
      transactionId: "TXN789123456",
      date: "2024-10-13"
    },
    total: 2520.00,
    specialRequests: "Airport pickup service requested, champagne welcome package",
    createdAt: "2024-10-11"
  },
  {
    id: "BK005",
    guest: {
      name: "Lisa Anderson",
      email: "lisa.anderson@email.com",
      phone: "+1 (555) 654-3210",
      address: "654 Maple Dr, Miami, FL 33101",
      type: "Regular",
      avatar: "https://images.unsplash.com/photo-1684262855358-88f296a2cfc2",
      avatarAlt: "Professional headshot of blonde woman in white blazer smiling warmly"
    },
    checkIn: "2024-10-12",
    checkOut: "2024-10-14",
    nights: 2,
    room: {
      type: "Family Room",
      number: "105",
      rate: 200
    },
    guests: 4,
    status: "checked-out",
    payment: {
      status: "paid",
      method: "Credit Card",
      amount: 400,
      transactionId: "TXN321654987",
      date: "2024-10-11"
    },
    total: 448.00,
    specialRequests: "Connecting rooms for family with children",
    createdAt: "2024-10-09"
  },
  {
    id: "BK006",
    guest: {
      name: "James Wilson",
      email: "james.wilson@email.com",
      phone: "+1 (555) 789-0123",
      address: "987 Cedar Ln, Boston, MA 02101",
      type: "Regular",
      avatar: "https://images.unsplash.com/photo-1609770653328-a4d1dd377970",
      avatarAlt: "Professional headshot of young man with beard in casual button-down shirt"
    },
    checkIn: "2024-10-18",
    checkOut: "2024-10-21",
    nights: 3,
    room: {
      type: "Deluxe Room",
      number: "208",
      rate: 180
    },
    guests: 1,
    status: "cancelled",
    payment: {
      status: "refunded",
      method: "Credit Card",
      amount: 540,
      transactionId: "TXN654987321",
      date: "2024-10-13"
    },
    total: 604.80,
    specialRequests: "Business center access required",
    createdAt: "2024-10-12"
  }];


  useEffect(() => {
    loadBookings();
  }, []);

  const loadBookings = async () => {
    try {
      setIsLoading(true);
      console.log('Loading bookings from API...');
      const response = await bookingsAPI.getAll();
      
      console.log('API Response:', response);
      
      if (response.success && response.data) {
        const bookingsData = response.data || [];
        console.log('Bookings data:', bookingsData);
        
        // Transform backend data to match frontend format
        const transformedBookings = bookingsData.map(booking => ({
          id: booking.id,
          guest: {
            name: booking.guestName || 'N/A',
            email: booking.guestEmail || 'N/A',
            phone: booking.guestPhone || 'N/A',
            address: 'N/A',
            type: 'Regular',
            avatar: 'https://images.unsplash.com/photo-1578401058525-35aaec0b4658',
            avatarAlt: 'User avatar'
          },
          checkIn: booking.checkInDate,
          checkOut: booking.checkOutDate,
          nights: booking.numberOfNights,
          room: {
            type: booking.roomType || 'Standard Room',
            number: 'N/A',
            rate: booking.totalPrice / booking.numberOfNights
          },
          guests: booking.numberOfGuests,
          status: booking.status?.toLowerCase() || 'pending',
          payment: {
            status: 'pending', // Will be updated from payment service
            method: 'N/A',
            amount: booking.totalPrice,
            transactionId: 'N/A',
            date: booking.createdAt
          },
          total: booking.totalPrice,
          specialRequests: booking.specialRequests || '',
          createdAt: booking.createdAt
        }));
        
        console.log('Transformed bookings:', transformedBookings);
        setBookings(transformedBookings);
        setFilteredBookings(transformedBookings);
      } else {
        console.error('API call failed or no data:', response);
        alert('Failed to load bookings from API. Using mock data. Check console for details.');
        // Fallback to mock data if API fails
        setBookings(mockBookings);
        setFilteredBookings(mockBookings);
      }
    } catch (error) {
      console.error('Error loading bookings:', error);
      console.error('Error details:', error.response || error.message);
      alert('Error loading bookings: ' + (error.message || 'Unknown error') + '. Using mock data.');
      // Fallback to mock data on error
      setBookings(mockBookings);
      setFilteredBookings(mockBookings);
    } finally {
      setIsLoading(false);
    }
  };

  const handleFiltersChange = (filters) => {
    let filtered = [...bookings];

    // Filter by guest name
    if (filters?.guestName) {
      filtered = filtered?.filter((booking) =>
      booking?.guest?.name?.toLowerCase()?.includes(filters?.guestName?.toLowerCase())
      );
    }

    // Filter by room type
    if (filters?.roomType) {
      filtered = filtered?.filter((booking) =>
      booking?.room?.type?.toLowerCase()?.includes(filters?.roomType?.toLowerCase())
      );
    }

    // Filter by booking status
    if (filters?.bookingStatus) {
      filtered = filtered?.filter((booking) => booking?.status === filters?.bookingStatus);
    }

    // Filter by payment status
    if (filters?.paymentStatus) {
      filtered = filtered?.filter((booking) => booking?.payment?.status === filters?.paymentStatus);
    }

    // Filter by date range
    if (filters?.dateRange?.start) {
      filtered = filtered?.filter((booking) =>
      new Date(booking.checkIn) >= new Date(filters.dateRange.start)
      );
    }

    if (filters?.dateRange?.end) {
      filtered = filtered?.filter((booking) =>
      new Date(booking.checkOut) <= new Date(filters.dateRange.end)
      );
    }

    setFilteredBookings(filtered);
    setCurrentPage(1);
  };

  const handleSort = (column, order) => {
    setSortBy(column);
    setSortOrder(order);

    const sorted = [...filteredBookings]?.sort((a, b) => {
      let aValue, bValue;

      switch (column) {
        case 'id':
          aValue = a?.id;
          bValue = b?.id;
          break;
        case 'guest':
          aValue = a?.guest?.name;
          bValue = b?.guest?.name;
          break;
        case 'checkIn':
          aValue = new Date(a.checkIn);
          bValue = new Date(b.checkIn);
          break;
        case 'status':
          aValue = a?.status;
          bValue = b?.status;
          break;
        case 'total':
          aValue = a?.total;
          bValue = b?.total;
          break;
        default:
          return 0;
      }

      if (order === 'asc') {
        return aValue > bValue ? 1 : -1;
      } else {
        return aValue < bValue ? 1 : -1;
      }
    });

    setFilteredBookings(sorted);
  };

  const handleViewBooking = (booking) => {
    setSelectedBooking(booking);
    setShowBookingDetailsModal(true);
  };

  const handleEditBooking = (booking) => {
    console.log('Edit booking:', booking);
    // Implement edit functionality
  };

  const handleCancelBooking = async (booking) => {
    if (window.confirm(`Are you sure you want to cancel booking #${booking?.id}?`)) {
      try {
        const response = await bookingsAPI.cancel(booking.id);
        
        if (response.success) {
          alert('Booking cancelled successfully!');
          await loadBookings(); // Reload bookings
        } else {
          alert('Failed to cancel booking');
        }
      } catch (error) {
        console.error('Error cancelling booking:', error);
        alert('Error cancelling booking');
      }
    }
  };

  const handleCheckIn = async (booking) => {
    if (window.confirm(`Check in guest ${booking?.guest?.name} for booking #${booking?.id}?`)) {
      try {
        const response = await bookingsAPI.checkIn(booking.id);
        
        if (response.success) {
          alert('Guest checked in successfully!');
          await loadBookings(); // Reload bookings
        } else {
          alert('Failed to check in guest');
        }
      } catch (error) {
        console.error('Error checking in guest:', error);
        alert('Error checking in guest');
      }
    }
  };

  const handleCheckOut = async (booking) => {
    if (window.confirm(`Check out guest ${booking?.guest?.name} for booking #${booking?.id}?`)) {
      try {
        const response = await bookingsAPI.checkOut(booking.id);
        
        if (response.success) {
          alert('Guest checked out successfully!');
          await loadBookings(); // Reload bookings
        } else {
          alert('Failed to check out guest');
        }
      } catch (error) {
        console.error('Error checking out guest:', error);
        alert('Error checking out guest');
      }
    }
  };

  const handleNewBooking = (bookingData) => {
    const newBooking = {
      ...bookingData,
      guest: {
        name: bookingData?.guestName,
        email: bookingData?.guestEmail,
        phone: bookingData?.guestPhone,
        address: bookingData?.guestAddress,
        type: "Regular",
        avatar: "https://images.unsplash.com/photo-1578401058525-35aaec0b4658",
        avatarAlt: "Default user avatar placeholder"
      },
      room: {
        type: bookingData?.roomType,
        number: bookingData?.roomNumber,
        rate: 180 // Mock rate
      },
      payment: {
        status: bookingData?.paymentStatus,
        method: bookingData?.paymentMethod,
        amount: bookingData?.total,
        transactionId: `TXN${Date.now()}`,
        date: new Date()?.toISOString()?.split('T')?.[0]
      },
      nights: Math.ceil((new Date(bookingData.checkOut) - new Date(bookingData.checkIn)) / (1000 * 60 * 60 * 24))
    };

    const updatedBookings = [newBooking, ...bookings];
    setBookings(updatedBookings);
    setFilteredBookings(updatedBookings);
  };

  const handleBulkAction = (action, selectedIds) => {
    console.log(`Bulk action: ${action} for bookings:`, selectedIds);
    // Implement bulk actions
  };

  const handlePageChange = (page) => {
    setCurrentPage(page);
  };

  // Pagination
  const totalPages = Math.ceil(filteredBookings?.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const paginatedBookings = filteredBookings?.slice(startIndex, startIndex + itemsPerPage);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <SidebarNavigation
          isCollapsed={sidebarCollapsed}
          onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)} />

        <div className={`transition-all duration-300 ${sidebarCollapsed ? 'md:ml-20' : 'md:ml-240'}`}>
          <div className="flex items-center justify-center min-h-screen">
            <div className="text-center">
              <Icon name="Loader2" size={48} className="mx-auto text-accent animate-spin mb-4" />
              <p className="text-muted-foreground">Loading bookings...</p>
            </div>
          </div>
        </div>
      </div>);

  }

  return (
    <div className="min-h-screen bg-background">
      <SidebarNavigation
        isCollapsed={sidebarCollapsed}
        onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)} />

      <div className={`transition-all duration-300 ${sidebarCollapsed ? 'md:ml-20' : 'md:ml-60'}`}>
        {/* Header */}
        <header className="bg-card border-b border-border px-6 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-semibold text-foreground">Booking Management</h1>
              <p className="text-muted-foreground">
                Manage reservations, check-ins, and guest bookings
              </p>
            </div>
            <div className="flex items-center space-x-4">
              <NotificationIndicator
                onMarkAsRead={() => {}}
                onMarkAllAsRead={() => {}} />

              <UserProfileDropdown
                onLogout={() => {}} />

            </div>
          </div>
        </header>

        {/* Main Content */}
        <main className="p-6">
          {/* Action Bar */}
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center space-x-4">
              <div className="text-sm text-muted-foreground">
                {filteredBookings?.length} of {bookings?.length} bookings
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <Button
                variant="outline"
                iconName="Download"
                iconPosition="left">

                Export
              </Button>
              <Button
                variant="default"
                onClick={() => setShowNewBookingModal(true)}
                iconName="Plus"
                iconPosition="left">

                New Booking
              </Button>
            </div>
          </div>

          {/* Filters */}
          <BookingFilters
            onFiltersChange={handleFiltersChange}
            totalResults={filteredBookings?.length} />


          {/* Bookings Table */}
          <BookingTable
            bookings={paginatedBookings}
            onViewBooking={handleViewBooking}
            onEditBooking={handleEditBooking}
            onCancelBooking={handleCancelBooking}
            onCheckIn={handleCheckIn}
            onCheckOut={handleCheckOut}
            onBulkAction={handleBulkAction}
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={handlePageChange}
            sortBy={sortBy}
            sortOrder={sortOrder}
            onSort={handleSort} />

        </main>
      </div>
      {/* Modals */}
      <NewBookingModal
        isOpen={showNewBookingModal}
        onClose={() => setShowNewBookingModal(false)}
        onSubmit={handleNewBooking} />

      <BookingDetailsModal
        isOpen={showBookingDetailsModal}
        onClose={() => setShowBookingDetailsModal(false)}
        booking={selectedBooking}
        onEdit={handleEditBooking}
        onCancel={handleCancelBooking}
        onCheckIn={handleCheckIn}
        onCheckOut={handleCheckOut} />

    </div>);

};

export default BookingManagement;