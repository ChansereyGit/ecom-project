import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../models/hotel.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/hotel_card_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/skeleton_hotel_card_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class HotelSearchResults extends StatefulWidget {
  const HotelSearchResults({super.key});

  @override
  State<HotelSearchResults> createState() => _HotelSearchResultsState();
}

class _HotelSearchResultsState extends State<HotelSearchResults> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isMapView = false;
  SortOption _currentSort = SortOption.popularity;
  Map<String, dynamic> _currentFilters = {};
  List<Map<String, dynamic>> _hotels = [];
  List<Map<String, dynamic>> _filteredHotels = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasMoreData = false; // No pagination from backend yet

  // Search parameters from navigation
  String _searchLocation = "";
  String _searchDates = "";
  String _searchGuests = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load data after first frame to get navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataFromArguments();
    });
  }
  
  void _loadDataFromArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      final hotels = args['hotels'] as List<Hotel>?;
      final location = args['location'] as String?;
      final checkInDate = args['checkInDate'] as DateTime?;
      final checkOutDate = args['checkOutDate'] as DateTime?;
      final guests = args['guests'] as int?;
      final rooms = args['rooms'] as int?;
      
      setState(() {
        _searchLocation = location ?? 'Unknown';
        
        if (checkInDate != null && checkOutDate != null) {
          final formatter = DateFormat('MMM dd');
          _searchDates = '${formatter.format(checkInDate)} - ${formatter.format(checkOutDate)}';
        }
        
        if (guests != null && rooms != null) {
          _searchGuests = '$guests guest${guests > 1 ? 's' : ''}, $rooms room${rooms > 1 ? 's' : ''}';
        }
        
        if (hotels != null && hotels.isNotEmpty) {
          _hotels = hotels.map((hotel) => _convertHotelToMap(hotel)).toList();
          _filteredHotels = List.from(_hotels);
        } else {
          _hotels = [];
          _filteredHotels = [];
        }
      });
    }
  }
  
  Map<String, dynamic> _convertHotelToMap(Hotel hotel) {
    return {
      'id': hotel.id,
      'name': hotel.name,
      'location': '${hotel.city}, ${hotel.country}',
      'distance': '0.5', // We don't have distance from API yet
      'stars': hotel.starRating,
      'rating': hotel.guestRating,
      'guestRating': hotel.guestRating,
      'reviewText': hotel.guestRating >= 4.5 ? 'Excellent' : hotel.guestRating >= 4.0 ? 'Very Good' : 'Good',
      'reviewCount': hotel.totalReviews,
      'price': '\$${hotel.pricePerNight.toInt()}',
      'originalPrice': null,
      'image': hotel.images.isNotEmpty ? hotel.images[0] : 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'amenities': hotel.amenities,
      'description': hotel.description,
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreHotels();
      }
    }
  }

  // Removed _loadInitialData - now using data from navigation arguments

  Future<void> _loadMoreHotels() async {
    // Pagination not implemented yet - all results loaded at once
    return;
  }

  Future<void> _refreshResults() async {
    HapticFeedback.lightImpact();
    
    // Just refresh the current data
    setState(() {
      _applyFiltersAndSort();
    });

    Fluttertoast.showToast(
      msg: "Results refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  List<Map<String, dynamic>> _generateMockHotels({int startId = 1}) {
    final hotelNames = [
      "The Plaza Hotel",
      "Grand Central Hotel",
      "Manhattan Luxury Suites",
      "Brooklyn Bridge Inn",
      "Times Square Boutique",
      "Central Park View Hotel",
      "Hudson River Resort",
      "Fifth Avenue Grand",
      "SoHo Designer Hotel",
      "Wall Street Executive",
      "Chelsea Modern Hotel",
      "Upper East Side Inn",
      "Tribeca Luxury Lodge",
      "Greenwich Village Boutique",
      "Financial District Hotel",
      "Midtown Executive Suites",
      "Lower Manhattan Inn",
      "Broadway Theater Hotel",
      "Empire State Suites",
      "Rockefeller Center Hotel",
    ];

    final locations = [
      "Midtown Manhattan",
      "Times Square",
      "Central Park",
      "Brooklyn Heights",
      "SoHo",
      "Chelsea",
      "Upper East Side",
      "Tribeca",
      "Greenwich Village",
      "Financial District",
      "Lower Manhattan",
      "Theater District",
    ];

    final amenities = [
      ["Free WiFi", "Pool", "Gym"],
      ["Spa", "Restaurant", "Bar"],
      ["Room Service", "Parking", "Pet Friendly"],
      ["Business Center", "Airport Shuttle", "Laundry"],
      ["Free WiFi", "Restaurant", "Gym", "Spa"],
      ["Pool", "Bar", "Room Service", "Parking"],
    ];

    final images = [
      "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&h=600&fit=crop",
    ];

    return List.generate(_itemsPerPage, (index) {
      final id = startId + index;
      final basePrice = 150 + (index * 25) + (id * 10);
      final hasDiscount = index % 3 == 0;
      final originalPrice = hasDiscount ? basePrice + 50 : null;

      return {
        "id": id,
        "name": hotelNames[index % hotelNames.length],
        "location": locations[index % locations.length],
        "distance": (0.5 + (index * 0.3)).toStringAsFixed(1),
        "stars": 3 + (index % 3),
        "rating": 4.0 + (index % 2),
        "guestRating": 7.5 + (index % 3) * 0.8,
        "reviewText": index % 2 == 0 ? "Excellent" : "Very Good",
        "reviewCount": 150 + (index * 50),
        "price": "\$${basePrice}",
        "originalPrice": originalPrice != null ? "\$${originalPrice}" : null,
        "image": images[index % images.length],
        "amenities": amenities[index % amenities.length],
        "description":
            "Experience luxury and comfort in the heart of ${locations[index % locations.length]}. This elegant hotel offers world-class amenities and exceptional service for the discerning traveler.",
      };
    });
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_hotels);

    // Apply filters
    if (_currentFilters.isNotEmpty) {
      filtered =
          filtered.where((hotel) {
            // Price filter
            if (_currentFilters['minPrice'] != null ||
                _currentFilters['maxPrice'] != null) {
              final price = double.parse(
                (hotel['price'] as String).replaceAll('\$', ''),
              );
              final minPrice = _currentFilters['minPrice'] as double? ?? 0;
              final maxPrice =
                  _currentFilters['maxPrice'] as double? ?? double.infinity;
              if (price < minPrice || price > maxPrice) return false;
            }

            // Star rating filter
            if (_currentFilters['stars'] != null &&
                (_currentFilters['stars'] as List).isNotEmpty) {
              final hotelStars = hotel['stars'] as int;
              if (!(_currentFilters['stars'] as List).contains(hotelStars))
                return false;
            }

            // Distance filter
            if (_currentFilters['maxDistance'] != null) {
              final distance = double.parse(hotel['distance'] as String);
              if (distance > (_currentFilters['maxDistance'] as double))
                return false;
            }

            // Guest rating filter
            if (_currentFilters['minGuestRating'] != null) {
              final guestRating = hotel['guestRating'] as double;
              if (guestRating < (_currentFilters['minGuestRating'] as double))
                return false;
            }

            // Amenities filter
            if (_currentFilters['amenities'] != null &&
                (_currentFilters['amenities'] as List).isNotEmpty) {
              final hotelAmenities = hotel['amenities'] as List;
              final requiredAmenities = _currentFilters['amenities'] as List;
              if (!requiredAmenities.every(
                (amenity) => hotelAmenities.contains(amenity),
              ))
                return false;
            }

            return true;
          }).toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case SortOption.price:
        filtered.sort((a, b) {
          final priceA = double.parse(
            (a['price'] as String).replaceAll('\$', ''),
          );
          final priceB = double.parse(
            (b['price'] as String).replaceAll('\$', ''),
          );
          return priceA.compareTo(priceB);
        });
        break;
      case SortOption.distance:
        filtered.sort((a, b) {
          final distanceA = double.parse(a['distance'] as String);
          final distanceB = double.parse(b['distance'] as String);
          return distanceA.compareTo(distanceB);
        });
        break;
      case SortOption.rating:
        filtered.sort((a, b) {
          final ratingA = a['guestRating'] as double;
          final ratingB = b['guestRating'] as double;
          return ratingB.compareTo(ratingA);
        });
        break;
      case SortOption.popularity:
        filtered.sort((a, b) {
          final reviewsA = a['reviewCount'] as int;
          final reviewsB = b['reviewCount'] as int;
          return reviewsB.compareTo(reviewsA);
        });
        break;
    }

    setState(() {
      _filteredHotels = filtered;
    });
  }

  List<String> _getActiveFilterChips() {
    List<String> chips = [];

    if (_currentFilters['minPrice'] != null ||
        _currentFilters['maxPrice'] != null) {
      final min = _currentFilters['minPrice'] as double? ?? 0;
      final max = _currentFilters['maxPrice'] as double? ?? 1000;
      chips.add('\$${min.round()}-\$${max.round()}');
    }

    if (_currentFilters['stars'] != null &&
        (_currentFilters['stars'] as List).isNotEmpty) {
      final stars = (_currentFilters['stars'] as List).cast<int>();
      chips.add('${stars.join(',')} stars');
    }

    if (_currentFilters['maxDistance'] != null) {
      chips.add('< ${(_currentFilters['maxDistance'] as double).round()}km');
    }

    if (_currentFilters['minGuestRating'] != null &&
        (_currentFilters['minGuestRating'] as double) > 0) {
      chips.add(
        '${(_currentFilters['minGuestRating'] as double).toStringAsFixed(1)}+ rating',
      );
    }

    if (_currentFilters['amenities'] != null &&
        (_currentFilters['amenities'] as List).isNotEmpty) {
      final amenities = (_currentFilters['amenities'] as List).cast<String>();
      chips.addAll(amenities.take(2));
      if (amenities.length > 2) {
        chips.add('+${amenities.length - 2} more');
      }
    }

    return chips;
  }

  void _removeFilter(String chipLabel) {
    setState(() {
      if (chipLabel.contains('\$')) {
        _currentFilters.remove('minPrice');
        _currentFilters.remove('maxPrice');
      } else if (chipLabel.contains('stars')) {
        _currentFilters.remove('stars');
      } else if (chipLabel.contains('km')) {
        _currentFilters.remove('maxDistance');
      } else if (chipLabel.contains('rating')) {
        _currentFilters.remove('minGuestRating');
      } else if (chipLabel.contains('more')) {
        _currentFilters.remove('amenities');
      } else {
        // Remove specific amenity
        final amenities =
            (_currentFilters['amenities'] as List?)?.cast<String>() ?? [];
        amenities.remove(chipLabel);
        if (amenities.isEmpty) {
          _currentFilters.remove('amenities');
        } else {
          _currentFilters['amenities'] = amenities;
        }
      }
      _applyFiltersAndSort();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isMapView ? 'list' : 'map',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
              HapticFeedback.lightImpact();
            },
            tooltip: _isMapView ? 'List View' : 'Map View',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'sort',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showSortBottomSheet,
            tooltip: 'Sort',
          ),
        ],
      ),
      body: _isMapView ? _buildMapView() : _buildListView(),
    );
  }

  Widget _buildListView() {
    return Column(
      children: [
        SearchHeaderWidget(
          location: _searchLocation,
          dates: _searchDates,
          guests: _searchGuests,
          onEditSearch:
              () => Navigator.pushNamed(context, '/hotel-search-home'),
        ),
        _buildFilterSection(),
        _buildResultsHeader(),
        Expanded(
          child:
              _isLoading
                  ? _buildSkeletonList()
                  : RefreshIndicator(
                    onRefresh: _refreshResults,
                    child:
                        _filteredHotels.isEmpty
                            ? _buildEmptyState()
                            : _buildHotelsList(),
                  ),
        ),
      ],
    );
  }

  Widget _buildMapView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'map',
              color: colorScheme.primary,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Map View',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Interactive map with hotel locations\nand price overlays',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isMapView = false;
                });
              },
              child: const Text('Back to List View'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    final activeFilters = _getActiveFilterChips();

    if (activeFilters.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChipWidget(label: 'Filter', onTap: _showFilterModal),
                    FilterChipWidget(label: 'Price', onTap: _showFilterModal),
                    FilterChipWidget(label: 'Stars', onTap: _showFilterModal),
                    FilterChipWidget(
                      label: 'Distance',
                      onTap: _showFilterModal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChipWidget(
                        label: 'Filter',
                        onTap: _showFilterModal,
                      ),
                      ...activeFilters.map(
                        (filter) => FilterChipWidget(
                          label: filter,
                          isSelected: true,
                          isDismissible: true,
                          onRemove: () => _removeFilter(filter),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredHotels.length} hotels found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelsList() {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _filteredHotels.length + (_isLoadingMore ? 3 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredHotels.length) {
          return const SkeletonHotelCardWidget();
        }

        final hotel = _filteredHotels[index];
        return HotelCardWidget(
          hotel: hotel,
          onTap: () {
            // Pass hotel data and search params to detail screen
            Navigator.pushNamed(
              context,
              '/hotel-detail',
              arguments: {
                'hotelId': hotel['id'],
                'hotel': hotel,
                'checkInDate': (ModalRoute.of(context)?.settings.arguments as Map?)?['checkInDate'],
                'checkOutDate': (ModalRoute.of(context)?.settings.arguments as Map?)?['checkOutDate'],
                'guests': (ModalRoute.of(context)?.settings.arguments as Map?)?['guests'],
                'rooms': (ModalRoute.of(context)?.settings.arguments as Map?)?['rooms'],
              },
            );
          },
          onFavorite: () {
            HapticFeedback.lightImpact();
            Fluttertoast.showToast(
              msg: "Added to favorites",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
          onShare: () {
            HapticFeedback.lightImpact();
            Fluttertoast.showToast(
              msg: "Sharing ${hotel['name']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
          onViewMap: () {
            setState(() {
              _isMapView = true;
            });
          },
        );
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const SkeletonHotelCardWidget(),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No hotels found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your filters or search criteria to find more hotels.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentFilters.clear();
                        _applyFiltersAndSort();
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () =>
                            Navigator.pushNamed(context, '/hotel-search-home'),
                    child: const Text('New Search'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => SortBottomSheetWidget(
            selectedSort: _currentSort,
            onSortChanged: (sort) {
              setState(() {
                _currentSort = sort;
                _applyFiltersAndSort();
              });
            },
          ),
    );
  }

  void _showFilterModal() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FilterModalWidget(
              currentFilters: _currentFilters,
              onFiltersChanged: (filters) {
                setState(() {
                  _currentFilters = filters;
                  _applyFiltersAndSort();
                });
              },
            ),
      ),
    );
  }
}
