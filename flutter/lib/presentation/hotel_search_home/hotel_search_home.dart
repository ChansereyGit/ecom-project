import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../services/hotel_service.dart';
import '../../models/hotel.dart';
import './widgets/date_picker_widget.dart';
import './widgets/guest_selector_widget.dart';
import 'widgets/hotels_near_me_widget.dart';
import './widgets/popular_destinations_widget.dart';
import './widgets/quick_filters_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';

class HotelSearchHome extends StatefulWidget {
  const HotelSearchHome({super.key});

  @override
  State<HotelSearchHome> createState() => _HotelSearchHomeState();
}

class _HotelSearchHomeState extends State<HotelSearchHome> {
  final HotelService _hotelService = HotelService();
  
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));
  int _rooms = 1;
  int _adults = 2;
  int _children = 0;
  bool _isLocationEnabled = true;
  bool _isLoading = false;
  
  List<Hotel> _featuredHotels = [];
  List<String> _popularDestinations = [];
  String? _selectedLocation;

  // Mock data for recent searches
  final List<Map<String, dynamic>> _recentSearches = [
    {'location': 'New York', 'date': '2025-10-09'},
    {'location': 'Los Angeles', 'date': '2025-10-08'},
    {'location': 'Miami', 'date': '2025-10-07'},
    {'location': 'Chicago', 'date': '2025-10-06'},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadFeaturedHotels(),
      _loadPopularDestinations(),
    ]);
  }

  Future<void> _loadFeaturedHotels() async {
    try {
      final result = await _hotelService.getFeaturedHotels();
      
      if (result['success'] && mounted) {
        setState(() {
          _featuredHotels = result['hotels'];
        });
      }
    } catch (e) {
      print('Error loading featured hotels: $e');
    }
  }

  Future<void> _loadPopularDestinations() async {
    try {
      final result = await _hotelService.getPopularDestinations();
      
      if (result['success'] && mounted) {
        setState(() {
          _popularDestinations = result['destinations'];
        });
      }
    } catch (e) {
      print('Error loading destinations: $e');
    }
  }

  // Convert destinations to the format expected by the widget
  List<Map<String, dynamic>> get _destinationsForWidget {
    return _popularDestinations.map((city) {
      return {
        'name': city,
        'hotels': 0, // We don't have count from API
        'image': _getDestinationImage(city),
      };
    }).toList();
  }

  String _getDestinationImage(String city) {
    // Default images for cities
    final images = {
      'New York': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9',
      'Los Angeles': 'https://images.unsplash.com/photo-1534190239940-9ba8944ea261',
      'Miami': 'https://images.unsplash.com/photo-1506966953602-c20cc11f75e3',
    };
    return images[city] ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945';
  }

  // Mock data for quick filters
  final List<Map<String, dynamic>> _quickFilters = [
    {'label': 'Tonight', 'icon': 'tonight_stay'},
    {'label': 'This Weekend', 'icon': 'weekend'},
    {'label': 'Business Travel', 'icon': 'business_center'},
    {'label': 'Family Trip', 'icon': 'family_restroom'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'HotelBooker',
        variant: CustomAppBarVariant.standard,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    _buildSearchSection(),
                    SizedBox(height: 3.h),
                    _buildSearchButton(),
                    SizedBox(height: 4.h),
                    RecentSearchesWidget(
                      recentSearches: _recentSearches,
                      onDismiss: _handleRecentSearchDismiss,
                    ),
                    SizedBox(height: 4.h),
                    QuickFiltersWidget(
                      filters: _quickFilters,
                      onFilterTap: _handleQuickFilterTap,
                    ),
                    SizedBox(height: 4.h),
                    HotelsNearMeWidget(
                      isLocationEnabled: _isLocationEnabled,
                      onTap: _handleHotelsNearMeTap,
                    ),
                    SizedBox(height: 4.h),
                    if (_destinationsForWidget.isNotEmpty)
                      PopularDestinationsWidget(
                        destinations: _destinationsForWidget,
                        onDestinationTap: _handleDestinationTap,
                      ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        variant: CustomBottomBarVariant.navigation,
        currentIndex: 0,
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: _handleSearchBarTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      _selectedLocation ?? 'Where to?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _selectedLocation != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: _selectedLocation != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          DatePickerWidget(
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            onCheckInTap: _handleCheckInTap,
            onCheckOutTap: _handleCheckOutTap,
          ),
          SizedBox(height: 2.h),
          GuestSelectorWidget(
            rooms: _rooms,
            adults: _adults,
            children: _children,
            onTap: _handleGuestSelectorTap,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSearchHotels,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Search Hotels',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await _loadInitialData();
    Fluttertoast.showToast(
      msg: 'Refreshed!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _handleSearchBarTap() async {
    // Open location search with autocomplete
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationSearchBottomSheet(),
    );
    
    if (selected != null) {
      setState(() {
        _selectedLocation = selected;
      });
    }
  }

  void _handleCheckInTap() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
        }
      });
    }
  }

  void _handleCheckOutTap() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  void _handleGuestSelectorTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGuestSelectorBottomSheet(),
    );
  }

  Future<void> _handleSearchHotels() async {
    if (_isLoading) return;

    // Validate location is selected
    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please select a destination',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('Searching hotels with location: $_selectedLocation'); // Debug
      
      final result = await _hotelService.searchHotels(
        location: _selectedLocation,
        checkInDate: _checkInDate.toIso8601String().split('T')[0],
        checkOutDate: _checkOutDate.toIso8601String().split('T')[0],
        guests: _adults + _children,
        rooms: _rooms,
      );

      setState(() => _isLoading = false);

      print('Search result: ${result['success']}, hotels: ${result['hotels']?.length ?? 0}'); // Debug

      if (result['success']) {
        final hotels = result['hotels'] as List<Hotel>;
        
        if (hotels.isEmpty) {
          Fluttertoast.showToast(
            msg: 'No hotels found in $_selectedLocation. Try another city.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.orange,
          );
        } else {
          // Navigate to results with hotels
          Navigator.pushNamed(
            context,
            '/hotel-search-results',
            arguments: {
              'hotels': hotels,
              'location': _selectedLocation,
              'checkInDate': _checkInDate,
              'checkOutDate': _checkOutDate,
              'guests': _adults + _children,
              'rooms': _rooms,
            },
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: result['message'] ?? 'Search failed',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Search error: $e'); // Debug
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  void _handleRecentSearchDismiss(int index) {
    setState(() {
      _recentSearches.removeAt(index);
    });
  }

  void _handleQuickFilterTap(Map<String, dynamic> filter) {
    final String label = filter['label'] as String;
    DateTime newCheckIn = DateTime.now();
    DateTime newCheckOut = DateTime.now().add(const Duration(days: 1));

    switch (label) {
      case 'Tonight':
        newCheckIn = DateTime.now();
        newCheckOut = DateTime.now().add(const Duration(days: 1));
        break;
      case 'This Weekend':
        final now = DateTime.now();
        final daysUntilSaturday = (6 - now.weekday) % 7;
        newCheckIn = now.add(Duration(days: daysUntilSaturday));
        newCheckOut = newCheckIn.add(const Duration(days: 2));
        break;
      case 'Business Travel':
        newCheckIn = DateTime.now().add(const Duration(days: 1));
        newCheckOut = newCheckIn.add(const Duration(days: 3));
        break;
      case 'Family Trip':
        newCheckIn = DateTime.now().add(const Duration(days: 7));
        newCheckOut = newCheckIn.add(const Duration(days: 5));
        break;
    }

    setState(() {
      _checkInDate = newCheckIn;
      _checkOutDate = newCheckOut;
    });

    Navigator.pushNamed(context, '/hotel-search-results');
  }

  void _handleHotelsNearMeTap() {
    if (_isLocationEnabled) {
      Navigator.pushNamed(context, '/hotel-search-results');
    } else {
      _requestLocationPermission();
    }
  }

  Future<void> _handleDestinationTap(Map<String, dynamic> destination) async {
    final cityName = destination['name'] as String;
    setState(() {
      _selectedLocation = cityName;
      _isLoading = true;
    });

    try {
      final result = await _hotelService.searchHotels(
        location: cityName,
        checkInDate: _checkInDate.toIso8601String().split('T')[0],
        checkOutDate: _checkOutDate.toIso8601String().split('T')[0],
        guests: _adults + _children,
        rooms: _rooms,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        final hotels = result['hotels'] as List<Hotel>;
        Navigator.pushNamed(
          context,
          '/hotel-search-results',
          arguments: {
            'hotels': hotels,
            'location': cityName,
            'checkInDate': _checkInDate,
            'checkOutDate': _checkOutDate,
          },
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: 'Failed to search hotels',
        backgroundColor: Colors.red,
      );
    }
  }

  void _requestLocationPermission() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Location Permission',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Allow HotelBooker to access your location to find nearby hotels.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLocationEnabled = true;
              });
              Navigator.pop(context);
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSearchBottomSheet() {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredDestinations = _popularDestinations;
    
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (value) {
                          setModalState(() {
                            if (value.isEmpty) {
                              filteredDestinations = _popularDestinations;
                            } else {
                              filteredDestinations = _popularDestinations
                                  .where((dest) => dest
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          prefixIcon: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setModalState(() {
                                      filteredDestinations = _popularDestinations;
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredDestinations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No destinations found',
                              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try searching for another location',
                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.all(4.w),
                        children: [
                          _buildLocationSuggestion(
                              'Current Location', 'Phnom Penh, Cambodia', 'my_location', 'Phnom Penh'),
                          if (filteredDestinations.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Text(
                                'Popular Destinations',
                                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            ...filteredDestinations.map((destination) {
                              // Determine country based on city
                              String country = 'USA';
                              if (['Siem Reap', 'Phnom Penh', 'Preah Sihanouk', 'Kampot']
                                  .contains(destination)) {
                                country = 'Cambodia';
                              }
                              return _buildLocationSuggestion(
                                destination,
                                country,
                                'location_city',
                                destination,
                              );
                            }).toList(),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationSuggestion(
      String title, String subtitle, String iconName, String cityValue) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      onTap: () {
        Navigator.pop(context, cityValue);
      },
    );
  }

  Widget _buildGuestSelectorBottomSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Guests & Rooms',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      _buildGuestCounter(
                        'Rooms',
                        _rooms,
                        (value) => setModalState(() => _rooms = value),
                        1,
                        5,
                      ),
                      SizedBox(height: 3.h),
                      _buildGuestCounter(
                        'Adults',
                        _adults,
                        (value) => setModalState(() => _adults = value),
                        1,
                        10,
                      ),
                      SizedBox(height: 3.h),
                      _buildGuestCounter(
                        'Children',
                        _children,
                        (value) => setModalState(() => _children = value),
                        0,
                        8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuestCounter(
    String label,
    int value,
    Function(int) onChanged,
    int min,
    int max,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: CustomIconWidget(
                iconName: 'remove_circle_outline',
                color: value > min
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            SizedBox(
              width: 12.w,
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: value < max
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
