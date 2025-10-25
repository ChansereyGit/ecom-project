import React, { useState, useEffect } from 'react';
import SidebarNavigation from '../../components/ui/SidebarNavigation';
import UserProfileDropdown from '../../components/ui/UserProfileDropdown';
import NotificationIndicator from '../../components/ui/NotificationIndicator';
import CalendarHeader from './components/CalendarHeader';
import CalendarGrid from './components/CalendarGrid';
import CalendarLegend from './components/CalendarLegend';
import RoomStatusPanel from './components/RoomStatusPanel';

import { calendarAPI, hotelsAPI } from '../../services/api';

const RoomCalendar = () => {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [viewMode, setViewMode] = useState('weekly');
  const [showLegend, setShowLegend] = useState(false);
  const [filters, setFilters] = useState({
    roomType: 'all',
    status: 'all'
  });
  const [selectedHotelId, setSelectedHotelId] = useState(null);
  const [rooms, setRooms] = useState([]);
  const [bookings, setBookings] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [hotels, setHotels] = useState([]);

  // Load hotels on mount
  useEffect(() => {
    loadHotels();
  }, []);

  // Load calendar data when hotel or date changes
  useEffect(() => {
    if (selectedHotelId) {
      loadCalendarData();
    }
  }, [selectedHotelId, currentDate, viewMode]);

  const loadHotels = async () => {
    try {
      const response = await hotelsAPI.getAll();
      if (response.success && response.data?.length > 0) {
        setHotels(response.data);
        // Auto-select first hotel
        setSelectedHotelId(response.data[0].id);
      }
    } catch (error) {
      console.error('Error loading hotels:', error);
    }
  };

  const loadCalendarData = async () => {
    if (!selectedHotelId) {
      // For now, use first hotel or let user select
      // You can add hotel selection dropdown
      return;
    }

    try {
      setIsLoading(true);
      
      // Calculate date range based on view mode
      const { startDate, endDate } = getDateRange(currentDate, viewMode);
      
      console.log('Loading calendar data for hotel:', selectedHotelId);
      console.log('Date range:', startDate, 'to', endDate);
      
      // Load rooms and bookings in parallel
      const [roomsResponse, bookingsResponse] = await Promise.all([
        calendarAPI.getRooms(selectedHotelId),
        calendarAPI.getBookings(selectedHotelId, startDate, endDate)
      ]);

      console.log('Rooms response:', roomsResponse);
      console.log('Bookings response:', bookingsResponse);

      if (roomsResponse.success) {
        const roomData = roomsResponse.data || [];
        console.log('Loaded rooms:', roomData.length, roomData);
        setRooms(roomData);
        
        // If no rooms, show helpful message
        if (roomData.length === 0) {
          alert('No room instances found for this hotel. Please create room instances first.\n\nSee CALENDAR_FRONTEND_INTEGRATION_COMPLETE.md for instructions.');
        }
      } else {
        console.error('Failed to load rooms:', roomsResponse);
      }

      if (bookingsResponse.success) {
        const bookingData = bookingsResponse.data || [];
        console.log('Loaded bookings:', bookingData.length, bookingData);
        setBookings(bookingData);
      } else {
        console.error('Failed to load bookings:', bookingsResponse);
      }
    } catch (error) {
      console.error('Error loading calendar data:', error);
      console.error('Error details:', error.response || error.message);
      alert('Failed to load calendar data: ' + (error.message || 'Unknown error') + '\n\nCheck browser console for details.');
    } finally {
      setIsLoading(false);
    }
  };

  const getDateRange = (date, mode) => {
    const start = new Date(date);
    const end = new Date(date);

    if (mode === 'weekly') {
      // Get start of week (Sunday)
      start.setDate(date.getDate() - date.getDay());
      // Get end of week (Saturday)
      end.setDate(start.getDate() + 6);
    } else if (mode === 'monthly') {
      // Get start of month
      start.setDate(1);
      // Get end of month
      end.setMonth(end.getMonth() + 1);
      end.setDate(0);
    }

    return {
      startDate: start.toISOString().split('T')[0],
      endDate: end.toISOString().split('T')[0]
    };
  };

  // Mock rooms data (fallback if no hotel selected)
  const mockRooms = [
    {
      id: 1,
      number: '101',
      type: 'standard',
      floor: 1,
      status: 'available',
      baseRate: 120,
      capacity: 2
    },
    {
      id: 2,
      number: '102',
      type: 'standard',
      floor: 1,
      status: 'occupied',
      baseRate: 120,
      capacity: 2
    },
    {
      id: 3,
      number: '103',
      type: 'deluxe',
      floor: 1,
      status: 'available',
      baseRate: 180,
      capacity: 3
    },
    {
      id: 4,
      number: '201',
      type: 'deluxe',
      floor: 2,
      status: 'maintenance',
      baseRate: 180,
      capacity: 3
    },
    {
      id: 5,
      number: '202',
      type: 'suite',
      floor: 2,
      status: 'available',
      baseRate: 350,
      capacity: 4
    },
    {
      id: 6,
      number: '203',
      type: 'suite',
      floor: 2,
      status: 'occupied',
      baseRate: 350,
      capacity: 4
    },
    {
      id: 7,
      number: '301',
      type: 'presidential',
      floor: 3,
      status: 'available',
      baseRate: 750,
      capacity: 6
    },
    {
      id: 8,
      number: '302',
      type: 'deluxe',
      floor: 3,
      status: 'blocked',
      baseRate: 180,
      capacity: 3
    }
  ];

  // Mock bookings data (fallback)
  const mockBookings = [
    {
      id: 1,
      roomId: 2,
      guestName: 'John Smith',
      guestEmail: 'john.smith@email.com',
      checkIn: '2024-10-14',
      checkOut: '2024-10-17',
      status: 'checked-in',
      adults: 2,
      children: 0,
      specialRequests: 'Late check-in requested',
      totalAmount: 360
    },
    {
      id: 2,
      roomId: 6,
      guestName: 'Sarah Johnson',
      guestEmail: 'sarah.johnson@email.com',
      checkIn: '2024-10-13',
      checkOut: '2024-10-16',
      status: 'confirmed',
      adults: 2,
      children: 1,
      specialRequests: 'Extra bed for child',
      totalAmount: 1050
    },
    {
      id: 3,
      roomId: 1,
      guestName: 'Michael Brown',
      guestEmail: 'michael.brown@email.com',
      checkIn: '2024-10-15',
      checkOut: '2024-10-18',
      status: 'pending',
      adults: 1,
      children: 0,
      specialRequests: '',
      totalAmount: 360
    },
    {
      id: 4,
      roomId: 3,
      guestName: 'Emily Davis',
      guestEmail: 'emily.davis@email.com',
      checkIn: '2024-10-16',
      checkOut: '2024-10-19',
      status: 'confirmed',
      adults: 2,
      children: 0,
      specialRequests: 'Ocean view preferred',
      totalAmount: 540
    },
    {
      id: 5,
      roomId: 5,
      guestName: 'Robert Wilson',
      guestEmail: 'robert.wilson@email.com',
      checkIn: '2024-10-17',
      checkOut: '2024-10-20',
      status: 'confirmed',
      adults: 3,
      children: 1,
      specialRequests: 'Anniversary celebration',
      totalAmount: 1050
    }
  ];

  const handleBookingUpdate = (bookingId, updates) => {
    setBookings(prev => prev?.map(booking => 
      booking?.id === bookingId 
        ? { ...booking, ...updates }
        : booking
    ));
    console.log('Booking updated:', bookingId, updates);
  };

  const handleBookingCreate = async (bookingData) => {
    try {
      const response = await calendarAPI.createQuickBooking(bookingData);
      
      if (response.success) {
        alert('Booking created successfully!');
        // Reload calendar data
        await loadCalendarData();
      }
    } catch (error) {
      console.error('Error creating booking:', error);
      alert('Failed to create booking: ' + (error.message || 'Unknown error'));
    }
  };

  const calculateBookingTotal = (bookingData) => {
    const room = rooms?.find(r => r?.id === bookingData?.roomId);
    if (!room) return 0;
    
    const checkIn = new Date(bookingData.checkIn);
    const checkOut = new Date(bookingData.checkOut);
    const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
    
    return nights * room?.baseRate;
  };

  const handleRoomStatusUpdate = async (roomId, newStatus) => {
    try {
      const response = await calendarAPI.updateRoomStatus(roomId, newStatus);
      
      if (response.success) {
        alert('Room status updated successfully!');
        // Reload calendar data
        await loadCalendarData();
      }
    } catch (error) {
      console.error('Error updating room status:', error);
      alert('Failed to update room status');
    }
  };



  const handleLogout = () => {
    console.log('User logged out');
    // In a real app, this would handle logout logic
  };

  useEffect(() => {
    // Set up real-time updates listener
    const interval = setInterval(() => {
      // In a real app, this would fetch latest booking updates
      console.log('Checking for real-time updates...');
    }, 30000); // Check every 30 seconds

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="min-h-screen bg-background">
      {/* Sidebar Navigation */}
      <SidebarNavigation 
        isCollapsed={sidebarCollapsed}
        onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
      />

      {/* Main Content */}
      <div className={`flex flex-col min-h-screen transition-all duration-300 ${sidebarCollapsed ? 'md:ml-20' : 'md:ml-240'}`}>
        {/* Top Header */}
        <header className="bg-card border-b border-border px-6 py-4 flex-shrink-0">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div>
                <h1 className="text-2xl font-bold text-foreground">Room Calendar</h1>
                <p className="text-sm text-muted-foreground mt-1">
                  Visual room availability and booking management
                </p>
              </div>
              
              {/* Hotel Selector */}
              {hotels.length > 0 && (
                <select
                  value={selectedHotelId || ''}
                  onChange={(e) => setSelectedHotelId(e.target.value)}
                  className="px-3 py-2 border border-border rounded-md text-sm bg-background"
                >
                  {hotels.map(hotel => (
                    <option key={hotel.id} value={hotel.id}>
                      {hotel.name}
                    </option>
                  ))}
                </select>
              )}
            </div>
            
            <div className="flex items-center space-x-4">
              <NotificationIndicator 
                onMarkAsRead={(id) => console.log('Mark as read:', id)}
                onMarkAllAsRead={() => console.log('Mark all as read')}
              />
              <UserProfileDropdown onLogout={handleLogout} />
            </div>
          </div>
        </header>

        {/* Calendar Content */}
        <div className="flex h-[calc(100vh-80px)]">
          {/* Main Calendar Area */}
          <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
            <CalendarHeader
              currentDate={currentDate}
              onDateChange={setCurrentDate}
              viewMode={viewMode}
              onViewModeChange={setViewMode}
              filters={filters}
              onFiltersChange={setFilters}
            />
            
            <div className="flex-1 overflow-auto">
              <CalendarGrid
                rooms={rooms}
                bookings={bookings}
                currentDate={currentDate}
                viewMode={viewMode}
                filters={filters}
                onBookingUpdate={handleBookingUpdate}
                onBookingCreate={handleBookingCreate}
              />
            </div>
          </div>

          {/* Room Status Panel */}
          <div className="w-80 flex-shrink-0 border-l border-border overflow-y-auto">
            <RoomStatusPanel
              rooms={rooms}
              bookings={bookings}
              onRoomStatusUpdate={handleRoomStatusUpdate}
            />
          </div>
        </div>
      </div>

      {/* Calendar Legend */}
      <CalendarLegend
        isVisible={showLegend}
        onToggle={() => setShowLegend(!showLegend)}
      />
    </div>
  );
};

export default RoomCalendar;