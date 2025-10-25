import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with SingleTickerProviderStateMixin {
  final BookingService _bookingService = BookingService();
  late TabController _tabController;
  
  List<Booking> _allBookings = [];
  List<Booking> _upcomingBookings = [];
  List<Booking> _pastBookings = [];
  List<Booking> _cancelledBookings = [];
  
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _bookingService.getUserBookings();
      
      if (result['success']) {
        final bookings = result['bookings'] as List<Booking>;
        final now = DateTime.now();
        
        setState(() {
          _allBookings = bookings;
          
          // Filter upcoming bookings (check-in date is in the future)
          _upcomingBookings = bookings.where((b) {
            final checkInDate = DateFormat('yyyy-MM-dd').parse(b.checkInDate);
            return checkInDate.isAfter(now) && 
                   b.status != 'CANCELLED';
          }).toList();
          
          // Filter past bookings (check-out date is in the past)
          _pastBookings = bookings.where((b) {
            final checkOutDate = DateFormat('yyyy-MM-dd').parse(b.checkOutDate);
            return checkOutDate.isBefore(now) && 
                   b.status != 'CANCELLED';
          }).toList();
          
          // Filter cancelled bookings
          _cancelledBookings = bookings.where((b) {
            return b.status == 'CANCELLED';
          }).toList();
          
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load bookings';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel your booking at ${booking.hotelName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await _bookingService.cancelBooking(booking.id!);
        
        if (result['success']) {
          Fluttertoast.showToast(
            msg: 'Booking cancelled successfully',
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
          _loadBookings(); // Reload bookings
        } else {
          Fluttertoast.showToast(
            msg: result['message'] ?? 'Failed to cancel booking',
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error: ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: CustomAppBar(
        title: 'My Bookings',
        variant: CustomAppBarVariant.booking,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Upcoming'),
                      if (_upcomingBookings.isNotEmpty) ...[
                        SizedBox(width: 1.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_upcomingBookings.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Tab(text: 'Past'),
                const Tab(text: 'Cancelled'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  )
                : _errorMessage != null
                    ? _buildErrorState()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildBookingsList(_upcomingBookings, 'upcoming'),
                          _buildBookingsList(_pastBookings, 'past'),
                          _buildBookingsList(_cancelledBookings, 'cancelled'),
                        ],
                      ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2, // Bookings tab
        variant: CustomBottomBarVariant.navigation,
      ),
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: colorScheme.error,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Oops!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _loadBookings,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, String type) {
    if (bookings.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index], type);
        },
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String message;
    String iconName;
    
    switch (type) {
      case 'upcoming':
        message = 'No upcoming bookings.\nStart planning your next trip!';
        iconName = 'calendar_today';
        break;
      case 'past':
        message = 'No past bookings yet.\nYour travel history will appear here.';
        iconName = 'history';
        break;
      case 'cancelled':
        message = 'No cancelled bookings.';
        iconName = 'cancel';
        break;
      default:
        message = 'No bookings found.';
        iconName = 'inbox';
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (type == 'upcoming') ...[
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/hotel-search-home');
                },
                child: const Text('Search Hotels'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, String type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final checkInDate = DateFormat('yyyy-MM-dd').parse(booking.checkInDate);
    final checkOutDate = DateFormat('yyyy-MM-dd').parse(booking.checkOutDate);

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Info
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.hotelName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildStatusChip(booking.status),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  booking.roomType,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: colorScheme.outlineVariant),

          // Booking Details
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                _buildDetailRow(
                  'Check-in',
                  DateFormat('MMM dd, yyyy').format(checkInDate),
                  'calendar_today',
                ),
                SizedBox(height: 1.5.h),
                _buildDetailRow(
                  'Check-out',
                  DateFormat('MMM dd, yyyy').format(checkOutDate),
                  'calendar_today',
                ),
                SizedBox(height: 1.5.h),
                _buildDetailRow(
                  'Guests',
                  '${booking.numberOfGuests} guests, ${booking.numberOfRooms} room(s)',
                  'people',
                ),
                SizedBox(height: 1.5.h),
                _buildDetailRow(
                  'Total',
                  '\$${booking.totalPrice.toStringAsFixed(2)}',
                  'payment',
                ),
                if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty) ...[
                  SizedBox(height: 1.5.h),
                  _buildDetailRow(
                    'Special Requests',
                    booking.specialRequests!,
                    'note',
                  ),
                ],
              ],
            ),
          ),

          // Actions
          if (type == 'upcoming') ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelBooking(booking),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                      ),
                      child: const Text('Cancel Booking'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to hotel detail
                        Navigator.pushNamed(
                          context,
                          '/hotel-detail',
                          arguments: {'hotelId': booking.hotelId},
                        );
                      },
                      child: const Text('View Hotel'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        backgroundColor = colorScheme.primary.withValues(alpha: 0.1);
        textColor = colorScheme.primary;
        displayText = 'Confirmed';
        break;
      case 'PENDING':
        backgroundColor = colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = colorScheme.tertiary;
        displayText = 'Pending';
        break;
      case 'CANCELLED':
        backgroundColor = colorScheme.error.withValues(alpha: 0.1);
        textColor = colorScheme.error;
        displayText = 'Cancelled';
        break;
      default:
        backgroundColor = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurfaceVariant;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
