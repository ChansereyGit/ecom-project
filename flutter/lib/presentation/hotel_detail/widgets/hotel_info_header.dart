import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HotelInfoHeader extends StatelessWidget {
  final String hotelName;
  final int starRating;
  final String location;
  final double guestRating;
  final int reviewCount;
  final List<String> keyAmenities;

  const HotelInfoHeader({
    super.key,
    required this.hotelName,
    required this.starRating,
    required this.location,
    required this.guestRating,
    required this.reviewCount,
    required this.keyAmenities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel name and star rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotelName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: List.generate(
                        5,
                        (index) => CustomIconWidget(
                          iconName: index < starRating ? 'star' : 'star_border',
                          color: index < starRating
                              ? AppTheme.warningLight
                              : colorScheme.outline,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle favorite toggle
                },
                icon: CustomIconWidget(
                  iconName: 'favorite_border',
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Location
          GestureDetector(
            onTap: () {
              // Handle view on map
            },
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  'View on Map',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: colorScheme.primary,
                  size: 16,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Guest rating and reviews
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  guestRating.toStringAsFixed(1),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Row(
                children: List.generate(
                  5,
                  (index) => CustomIconWidget(
                    iconName:
                        index < guestRating.floor() ? 'star' : 'star_border',
                    color: AppTheme.warningLight,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '($reviewCount reviews)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Key amenities
          Text(
            'Key Amenities',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 4.w,
            runSpacing: 2.h,
            children: keyAmenities.map((amenity) {
              return _buildAmenityChip(context, amenity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(BuildContext context, String amenity) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData iconData;
    switch (amenity.toLowerCase()) {
      case 'wifi':
        iconData = Icons.wifi;
        break;
      case 'pool':
        iconData = Icons.pool;
        break;
      case 'gym':
        iconData = Icons.fitness_center;
        break;
      case 'parking':
        iconData = Icons.local_parking;
        break;
      case 'restaurant':
        iconData = Icons.restaurant;
        break;
      case 'spa':
        iconData = Icons.spa;
        break;
      case 'bar':
        iconData = Icons.local_bar;
        break;
      case 'room service':
        iconData = Icons.room_service;
        break;
      default:
        iconData = Icons.check_circle;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 16,
            color: colorScheme.primary,
          ),
          SizedBox(width: 1.w),
          Text(
            amenity,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
