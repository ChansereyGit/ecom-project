import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../models/hotel.dart';
import '../../models/room.dart';
import './widgets/booking_summary_widget.dart';
import './widgets/room_card_widget.dart';
import './widgets/room_filter_widget.dart';

class RoomSelection extends StatefulWidget {
  const RoomSelection({super.key});

  @override
  State<RoomSelection> createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {
  int? _selectedRoomIndex;
  int? _expandedRoomIndex;
  Map<String, dynamic> _filters = {
    'showAll': true,
    'availableOnly': false,
    'offersOnly': false,
    'sortBy': 'price',
  };
  bool _isRefreshing = false;
  
  // Data from navigation
  Hotel? _hotel;
  List<Room> _rooms = [];
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 2;
  int _numberOfRooms = 1;

  // Mock data for rooms
  final List<Map<String, dynamic>> _roomsData = [
    {
      'id': 1,
      'name': 'Deluxe King Room',
      'bedType': '1 King Bed',
      'maxOccupancy': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
      'pricePerNight': '\$299',
      'totalPrice': '\$897',
      'originalPrice': '\$399',
      'isAvailable': true,
      'availableRooms': 3,
      'hasOffer': true,
      'discountPercentage': 25,
      'roomSize': '35 m²',
      'view': 'City View',
      'floor': '12-15',
      'bathroom': 'Private',
      'photos': [
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000',
      ],
      'amenities': [
        {'name': 'Free WiFi', 'icon': 'wifi'},
        {'name': 'Coffee Machine', 'icon': 'coffee_maker'},
        {'name': 'Balcony', 'icon': 'balcony'},
        {'name': 'Air Conditioning', 'icon': 'ac_unit'},
        {'name': 'Mini Bar', 'icon': 'local_bar'},
        {'name': 'Safe', 'icon': 'lock'},
      ],
      'cancellationPolicy': 'Free cancellation until 24 hours before check-in',
      'paymentPolicy': 'Pay at hotel or online',
      'breakfastIncluded': true,
    },
    {
      'id': 2,
      'name': 'Superior Twin Room',
      'bedType': '2 Twin Beds',
      'maxOccupancy': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
      'pricePerNight': '\$249',
      'totalPrice': '\$747',
      'isAvailable': true,
      'availableRooms': 5,
      'hasOffer': false,
      'discountPercentage': 0,
      'roomSize': '30 m²',
      'view': 'Garden View',
      'floor': '8-11',
      'bathroom': 'Private',
      'photos': [
        'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
      ],
      'amenities': [
        {'name': 'Free WiFi', 'icon': 'wifi'},
        {'name': 'Coffee Machine', 'icon': 'coffee_maker'},
        {'name': 'Air Conditioning', 'icon': 'ac_unit'},
        {'name': 'Mini Bar', 'icon': 'local_bar'},
        {'name': 'Safe', 'icon': 'lock'},
      ],
      'cancellationPolicy': 'Free cancellation until 48 hours before check-in',
      'paymentPolicy': 'Pay at hotel only',
      'breakfastIncluded': false,
    },
    {
      'id': 3,
      'name': 'Executive Suite',
      'bedType': '1 King Bed + Sofa',
      'maxOccupancy': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000',
      'pricePerNight': '\$449',
      'totalPrice': '\$1,347',
      'originalPrice': '\$599',
      'isAvailable': true,
      'availableRooms': 2,
      'hasOffer': true,
      'discountPercentage': 25,
      'roomSize': '55 m²',
      'view': 'Ocean View',
      'floor': '16-20',
      'bathroom': 'Private + Guest',
      'photos': [
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
      ],
      'amenities': [
        {'name': 'Free WiFi', 'icon': 'wifi'},
        {'name': 'Coffee Machine', 'icon': 'coffee_maker'},
        {'name': 'Balcony', 'icon': 'balcony'},
        {'name': 'Air Conditioning', 'icon': 'ac_unit'},
        {'name': 'Mini Bar', 'icon': 'local_bar'},
        {'name': 'Safe', 'icon': 'lock'},
        {'name': 'Living Area', 'icon': 'chair'},
        {'name': 'Work Desk', 'icon': 'desk'},
      ],
      'cancellationPolicy': 'Free cancellation until 24 hours before check-in',
      'paymentPolicy': 'Pay at hotel or online',
      'breakfastIncluded': true,
    },
    {
      'id': 4,
      'name': 'Standard Double Room',
      'bedType': '1 Double Bed',
      'maxOccupancy': 2,
      'imageUrl':
          'https://images.unsplash.com/photo-1590490360182-c33d57733427?fm=jpg&q=60&w=3000',
      'pricePerNight': '\$199',
      'totalPrice': '\$597',
      'isAvailable': false,
      'availableRooms': 0,
      'hasOffer': false,
      'discountPercentage': 0,
      'roomSize': '25 m²',
      'view': 'City View',
      'floor': '5-7',
      'bathroom': 'Private',
      'photos': [
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?fm=jpg&q=60&w=3000',
      ],
      'amenities': [
        {'name': 'Free WiFi', 'icon': 'wifi'},
        {'name': 'Air Conditioning', 'icon': 'ac_unit'},
        {'name': 'Safe', 'icon': 'lock'},
      ],
      'cancellationPolicy': 'Free cancellation until 48 hours before check-in',
      'paymentPolicy': 'Pay at hotel only',
      'breakfastIncluded': false,
    },
    {
      'id': 5,
      'name': 'Family Room',
      'bedType': '1 King + 2 Single Beds',
      'maxOccupancy': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?fm=jpg&q=60&w=3000',
      'pricePerNight': '\$349',
      'totalPrice': '\$1,047',
      'isAvailable': true,
      'availableRooms': 1,
      'hasOffer': false,
      'discountPercentage': 0,
      'roomSize': '45 m²',
      'view': 'Garden View',
      'floor': '3-6',
      'bathroom': 'Private',
      'photos': [
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?fm=jpg&q=60&w=3000',
        'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
      ],
      'amenities': [
        {'name': 'Free WiFi', 'icon': 'wifi'},
        {'name': 'Coffee Machine', 'icon': 'coffee_maker'},
        {'name': 'Air Conditioning', 'icon': 'ac_unit'},
        {'name': 'Mini Bar', 'icon': 'local_bar'},
        {'name': 'Safe', 'icon': 'lock'},
        {'name': 'Extra Space', 'icon': 'open_in_full'},
      ],
      'cancellationPolicy': 'Free cancellation until 24 hours before check-in',
      'paymentPolicy': 'Pay at hotel or online',
      'breakfastIncluded': false,
    },
  ];

  // Mock booking data
  final Map<String, dynamic> _bookingData = {
    'checkInDate': 'Dec 15, 2024',
    'checkOutDate': 'Dec 18, 2024',
    'nights': 3,
    'guests': 2,
    'totalPrice': '\$897',
    'hotelName': 'Grand Plaza Hotel',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataFromArguments();
    });
  }
  
  void _loadDataFromArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      setState(() {
        _hotel = args['hotel'] as Hotel?;
        _rooms = (args['rooms'] as List<Room>?) ?? [];
        _checkInDate = args['checkInDate'] as DateTime?;
        _checkOutDate = args['checkOutDate'] as DateTime?;
        _guests = args['guests'] as int? ?? 2;
        _numberOfRooms = args['numberOfRooms'] as int? ?? 1;
      });
    }
  }
  
  int _calculateNights() {
    if (_checkInDate != null && _checkOutDate != null) {
      return _checkOutDate!.difference(_checkInDate!).inDays;
    }
    return 1;
  }
  
  Map<String, dynamic> _getBookingData() {
    final nights = _calculateNights();
    final selectedRoom = _selectedRoomIndex != null ? _rooms[_selectedRoomIndex!] : null;
    final totalPrice = selectedRoom != null 
        ? selectedRoom.pricePerNight * nights * _numberOfRooms
        : 0.0;
    
    return {
      'checkInDate': _checkInDate != null 
          ? DateFormat('MMM dd, yyyy').format(_checkInDate!)
          : 'Not set',
      'checkOutDate': _checkOutDate != null 
          ? DateFormat('MMM dd, yyyy').format(_checkOutDate!)
          : 'Not set',
      'nights': nights,
      'guests': _guests,
      'totalPrice': '\$${totalPrice.toInt()}',
      'hotelName': _hotel?.name ?? 'Hotel',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredRooms = _getFilteredRooms();
    final bookingData = _getBookingData();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      body: Column(
        children: [
          RoomFilterWidget(
            onFilterChanged: _onFilterChanged,
            currentFilters: _filters,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: colorScheme.primary,
              child: filteredRooms.isEmpty
                  ? _buildEmptyState(context, colorScheme)
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 25.h),
                      itemCount: filteredRooms.length,
                      itemBuilder: (context, index) {
                        final room = filteredRooms[index];
                        final originalIndex = _rooms.indexOf(room);

                        return RoomCardWidget(
                          roomData: _convertRoomToMap(room),
                          isSelected: _selectedRoomIndex == originalIndex,
                          isExpanded: _expandedRoomIndex == originalIndex,
                          onTap: () => _selectRoom(originalIndex),
                          onExpand: () => _toggleExpanded(originalIndex),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomSheet: BookingSummaryWidget(
        bookingData: bookingData,
        hasSelectedRoom: _selectedRoomIndex != null,
        onContinueBooking: _onContinueBooking,
      ),
    );
  }
  
  Map<String, dynamic> _convertRoomToMap(Room room) {
    final nights = _calculateNights();
    final totalPrice = room.pricePerNight * nights * _numberOfRooms;
    
    return {
      'id': room.id,
      'name': room.roomType,
      'bedType': room.bedType,
      'maxOccupancy': room.maxGuests,
      'imageUrl': room.images.isNotEmpty ? room.images[0] : 
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
      'pricePerNight': '\$${room.pricePerNight.toInt()}',
      'totalPrice': '\$${totalPrice.toInt()}',
      'originalPrice': null,
      'isAvailable': room.availableRooms > 0,
      'availableRooms': room.availableRooms,
      'hasOffer': false,
      'discountPercentage': 0,
      'roomSize': room.size != null ? '${room.size!.toInt()} m²' : 'N/A',
      'view': 'City View',
      'floor': 'Various',
      'bathroom': 'Private',
      'photos': room.images.isNotEmpty ? room.images : [
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000'
      ],
      'amenities': room.amenities.map((amenity) => {
        'name': amenity,
        'icon': 'check_circle',
      }).toList(),
      'cancellationPolicy': room.freeCancellation 
          ? 'Free cancellation until 24 hours before check-in'
          : 'Non-refundable',
      'paymentPolicy': 'Pay at hotel or online',
      'breakfastIncluded': room.hasBreakfast,
    };
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'close',
          size: 24,
          color: colorScheme.onSurface,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Room',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _hotel?.name ?? 'Hotel',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'help_outline',
            size: 24,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () => _showHelpDialog(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'hotel',
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 3.h),
            Text(
              'No rooms available',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your dates or filters to see more options',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () => _showDatePicker(context),
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                size: 20,
                color: colorScheme.onPrimary,
              ),
              label: Text(
                'Change Dates',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Room> _getFilteredRooms() {
    List<Room> filtered = List.from(_rooms);

    // Apply filters
    if (_filters['availableOnly'] as bool? ?? false) {
      filtered = filtered.where((room) => room.availableRooms > 0).toList();
    }

    if (_filters['offersOnly'] as bool? ?? false) {
      // No offers in current data model
      filtered = filtered.where((room) => false).toList();
    }

    // Apply sorting
    final sortBy = _filters['sortBy'] as String? ?? 'price';
    switch (sortBy) {
      case 'price':
        filtered.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case 'size':
        filtered.sort((a, b) {
          final sizeA = a.size ?? 0;
          final sizeB = b.size ?? 0;
          return sizeB.compareTo(sizeA);
        });
        break;
      case 'popularity':
        filtered.sort((a, b) => b.availableRooms.compareTo(a.availableRooms));
        break;
    }

    return filtered;
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _filters = filters;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _selectRoom(int index) {
    setState(() {
      _selectedRoomIndex = index;
    });
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedRoomIndex = _expandedRoomIndex == index ? null : index;
    });
  }

  void _onContinueBooking() {
    if (_selectedRoomIndex != null && _hotel != null) {
      final selectedRoom = _rooms[_selectedRoomIndex!];
      final nights = _calculateNights();
      
      Navigator.pushNamed(
        context,
        '/booking-checkout',
        arguments: {
          'hotel': _hotel,
          'room': selectedRoom,
          'checkInDate': _checkInDate,
          'checkOutDate': _checkOutDate,
          'guests': _guests,
          'numberOfRooms': _numberOfRooms,
          'nights': nights,
          'totalPrice': selectedRoom.pricePerNight * nights * _numberOfRooms,
        },
      );
    }
  }

  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Room Selection Help',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Tap on a room to select it\n'
              '• Tap the arrow to see more details\n'
              '• Use filters to narrow your search\n'
              '• Pull down to refresh availability\n'
              '• Green badge shows remaining rooms',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime.now().add(const Duration(days: 7)),
        end: DateTime.now().add(const Duration(days: 10)),
      ),
    ).then((dateRange) {
      if (dateRange != null) {
        setState(() {
          _bookingData['checkInDate'] =
              '${dateRange.start.month}/${dateRange.start.day}/${dateRange.start.year}';
          _bookingData['checkOutDate'] =
              '${dateRange.end.month}/${dateRange.end.day}/${dateRange.end.year}';
          _bookingData['nights'] = dateRange.duration.inDays;
        });
      }
    });
  }
}
