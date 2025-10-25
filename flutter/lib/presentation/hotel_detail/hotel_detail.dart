import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../models/hotel.dart';
import '../../models/room.dart';
import '../../services/hotel_service.dart';
import '../../services/booking_service.dart';
import './widgets/amenities_section.dart';
import './widgets/hotel_description.dart';
import './widgets/hotel_image_gallery.dart';
import './widgets/hotel_info_header.dart';
import './widgets/location_map_section.dart';
import './widgets/photo_gallery_grid.dart';
import './widgets/reviews_section.dart';
import './widgets/room_types_section.dart';
import './widgets/sticky_booking_bar.dart';

class HotelDetail extends StatefulWidget {
  const HotelDetail({super.key});

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  final ScrollController _scrollController = ScrollController();
  final HotelService _hotelService = HotelService();
  final BookingService _bookingService = BookingService();
  
  bool _showStickyBar = false;
  bool _isLoading = true;
  bool _isLoadingRooms = false;
  
  // Data from navigation
  String? _hotelId;
  Hotel? _hotel;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int? _guests;
  int? _rooms;
  
  // Loaded data
  List<Room> _availableRooms = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHotelData();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 300;
    if (shouldShow != _showStickyBar) {
      setState(() {
        _showStickyBar = shouldShow;
      });
    }
  }

  Future<void> _loadHotelData() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args == null) {
      setState(() => _isLoading = false);
      return;
    }
    
    setState(() {
      _hotelId = args['hotelId']?.toString();
      _checkInDate = args['checkInDate'] as DateTime?;
      _checkOutDate = args['checkOutDate'] as DateTime?;
      _guests = args['guests'] as int?;
      _rooms = args['rooms'] as int?;
    });
    
    // Try to use passed hotel data first
    final hotelMap = args['hotel'] as Map<String, dynamic>?;
    if (hotelMap != null) {
      _hotel = _convertMapToHotel(hotelMap);
      setState(() => _isLoading = false);
      _loadRooms();
      return;
    }
    
    // Otherwise fetch from API
    if (_hotelId != null) {
      final result = await _hotelService.getHotelById(_hotelId!);
      if (result['success']) {
        setState(() {
          _hotel = result['hotel'] as Hotel;
          _isLoading = false;
        });
        _loadRooms();
      } else {
        setState(() => _isLoading = false);
        _showErrorToast(result['message'] ?? 'Failed to load hotel');
      }
    }
  }
  
  Future<void> _loadRooms() async {
    if (_hotelId == null) return;
    
    setState(() => _isLoadingRooms = true);
    
    final result = await _bookingService.getHotelRooms(_hotelId!);
    if (result['success']) {
      setState(() {
        _availableRooms = result['rooms'] as List<Room>;
        _isLoadingRooms = false;
      });
    } else {
      setState(() => _isLoadingRooms = false);
      _showErrorToast(result['message'] ?? 'Failed to load rooms');
    }
  }
  
  Hotel _convertMapToHotel(Map<String, dynamic> map) {
    return Hotel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      address: map['location'] ?? '',
      city: map['location']?.toString().split(',').first ?? '',
      country: map['location']?.toString().split(',').last.trim() ?? '',
      latitude: null,
      longitude: null,
      pricePerNight: double.tryParse(map['price']?.toString().replaceAll('\$', '') ?? '0') ?? 0,
      guestRating: (map['guestRating'] ?? map['rating'] ?? 0).toDouble(),
      totalReviews: map['reviewCount'] ?? 0,
      starRating: map['stars'] ?? 0,
      images: map['image'] != null ? [map['image']] : [],
      amenities: List<String>.from(map['amenities'] ?? []),
      featured: false,
      available: true,
    );
  }
  
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
    );
  }
  
  void _handleBookNow() {
    if (_hotel == null) {
      _showErrorToast('Hotel data not available');
      return;
    }
    
    // Navigate to room selection if we have rooms, otherwise go to checkout
    if (_availableRooms.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/room-selection',
        arguments: {
          'hotel': _hotel,
          'rooms': _availableRooms,
          'checkInDate': _checkInDate,
          'checkOutDate': _checkOutDate,
          'guests': _guests ?? 2,
          'numberOfRooms': _rooms ?? 1,
        },
      );
    } else {
      Navigator.pushNamed(
        context,
        '/booking-checkout',
        arguments: {
          'hotel': _hotel,
          'checkInDate': _checkInDate,
          'checkOutDate': _checkOutDate,
          'guests': _guests ?? 2,
          'numberOfRooms': _rooms ?? 1,
        },
      );
    }
  }

  void _handleShare() {
    // Handle share functionality
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    // In real app, this would refresh hotel data and availability
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }
    
    if (_hotel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hotel Details')),
        body: Center(
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
                'Hotel not found',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Translucent app bar with hero image
                SliverAppBar(
                  expandedHeight: 35.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'arrow_back_ios',
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _handleShare,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: HotelImageGallery(
                      images: _hotel!.images.isNotEmpty ? _hotel!.images : [
                        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop'
                      ],
                      hotelName: _hotel!.name,
                    ),
                  ),
                ),

                // Hotel content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Hotel info header
                      HotelInfoHeader(
                        hotelName: _hotel!.name,
                        starRating: _hotel!.starRating,
                        location: '${_hotel!.city}, ${_hotel!.country}',
                        guestRating: _hotel!.guestRating,
                        reviewCount: _hotel!.totalReviews,
                        keyAmenities: _hotel!.amenities.take(6).toList(),
                      ),

                      Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        thickness: 1,
                      ),

                      // Hotel description
                      HotelDescription(
                        description: _hotel!.description,
                      ),

                      Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        thickness: 1,
                      ),

                      // Photo gallery
                      if (_hotel!.images.length > 1)
                        PhotoGalleryGrid(
                          photos: _hotel!.images,
                          hotelName: _hotel!.name,
                        ),

                      if (_hotel!.images.length > 1)
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          thickness: 1,
                        ),

                      // Room types
                      if (_availableRooms.isNotEmpty)
                        RoomTypesSection(
                          roomTypes: _availableRooms.map((room) => {
                            'id': room.id,
                            'name': room.roomType,
                            'bedType': room.bedType,
                            'maxGuests': room.maxGuests,
                            'price': '\$${room.pricePerNight.toInt()}/night',
                            'available': room.availableRooms > 0,
                            'image': room.images.isNotEmpty ? room.images[0] : _hotel!.images.first,
                          }).toList(),
                        ),

                      if (_availableRooms.isNotEmpty)
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          thickness: 1,
                        ),

                      // Amenities
                      if (_hotel!.amenities.isNotEmpty)
                        AmenitiesSection(
                          amenities: _hotel!.amenities.map((amenity) => {
                            'name': amenity,
                            'category': 'General',
                            'premium': false,
                            'description': amenity,
                            'hours': '24/7 Available',
                          }).toList(),
                        ),

                      if (_hotel!.amenities.isNotEmpty)
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          thickness: 1,
                        ),

                      // Reviews
                      ReviewsSection(
                        overallRating: _hotel!.guestRating,
                        totalReviews: _hotel!.totalReviews,
                        ratingBreakdown: {
                          'Cleanliness': _hotel!.guestRating,
                          'Service': _hotel!.guestRating - 0.1,
                          'Location': _hotel!.guestRating - 0.2,
                          'Value': _hotel!.guestRating - 0.3,
                          'Amenities': _hotel!.guestRating - 0.1,
                        },
                        recentReviews: [],
                      ),

                      Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        thickness: 1,
                      ),

                      // Location and map
                      if (_hotel!.latitude != null && _hotel!.longitude != null)
                        LocationMapSection(
                          latitude: _hotel!.latitude!,
                          longitude: _hotel!.longitude!,
                          hotelName: _hotel!.name,
                          address: _hotel!.address,
                          nearbyAttractions: [],
                        ),

                      // Bottom padding for sticky bar
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky booking bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              offset: _showStickyBar ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 300),
              child: StickyBookingBar(
                price: '\$${_hotel!.pricePerNight.toInt()}',
                priceUnit: '/night',
                isAvailable: _hotel!.available,
                onBookNow: _handleBookNow,
              ),
            ),
          ),

          // Floating action button for quick booking
          if (!_showStickyBar)
            Positioned(
              bottom: 2.h,
              right: 4.w,
              child: FloatingActionButton.extended(
                onPressed: _handleBookNow,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(
                  'Book',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
