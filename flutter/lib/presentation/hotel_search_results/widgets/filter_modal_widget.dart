import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const FilterModalWidget({
    super.key,
    required this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  late RangeValues _priceRange;
  late double _maxDistance;
  late Set<int> _selectedStars;
  late Set<String> _selectedAmenities;
  late double _minGuestRating;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 50.0,
      (_filters['maxPrice'] as double?) ?? 500.0,
    );
    _maxDistance = (_filters['maxDistance'] as double?) ?? 10.0;
    _selectedStars = Set.from(_filters['stars'] as List? ?? []);
    _selectedAmenities = Set.from(_filters['amenities'] as List? ?? []);
    _minGuestRating = (_filters['minGuestRating'] as double?) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Filters'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRangeSection(context),
            SizedBox(height: 4.h),
            _buildStarRatingSection(context),
            SizedBox(height: 4.h),
            _buildDistanceSection(context),
            SizedBox(height: 4.h),
            _buildGuestRatingSection(context),
            SizedBox(height: 4.h),
            _buildAmenitiesSection(context),
            SizedBox(height: 8.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range (per night)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStarRatingSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Star Rating',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [1, 2, 3, 4, 5].map((stars) {
            final isSelected = _selectedStars.contains(stars);
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                      stars,
                      (index) => CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.warningLight,
                            size: 16,
                          )),
                  if (stars < 5) ...[
                    SizedBox(width: 1.w),
                    Text('& up'),
                  ],
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedStars.add(stars);
                  } else {
                    _selectedStars.remove(stars);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDistanceSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance from City Center',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Slider(
          value: _maxDistance,
          min: 0,
          max: 50,
          divisions: 10,
          label: '${_maxDistance.round()} km',
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
        ),
        Text(
          'Up to ${_maxDistance.round()} km',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildGuestRatingSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Rating',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Slider(
          value: _minGuestRating,
          min: 0,
          max: 10,
          divisions: 10,
          label: '${_minGuestRating.toStringAsFixed(1)}+',
          onChanged: (value) {
            setState(() {
              _minGuestRating = value;
            });
          },
        ),
        Text(
          '${_minGuestRating.toStringAsFixed(1)}+ rating',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(BuildContext context) {
    final theme = Theme.of(context);
    final amenities = [
      'Free WiFi',
      'Pool',
      'Gym',
      'Spa',
      'Restaurant',
      'Bar',
      'Room Service',
      'Parking',
      'Pet Friendly',
      'Business Center',
      'Airport Shuttle',
      'Laundry',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: amenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _priceRange = const RangeValues(50.0, 500.0);
      _maxDistance = 10.0;
      _selectedStars.clear();
      _selectedAmenities.clear();
      _minGuestRating = 0.0;
    });
  }

  void _applyFilters() {
    final filters = {
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'maxDistance': _maxDistance,
      'stars': _selectedStars.toList(),
      'amenities': _selectedAmenities.toList(),
      'minGuestRating': _minGuestRating,
    };

    widget.onFiltersChanged?.call(filters);
    Navigator.pop(context);
  }
}
