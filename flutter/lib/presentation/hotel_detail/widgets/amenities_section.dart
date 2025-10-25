import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AmenitiesSection extends StatelessWidget {
  final List<Map<String, dynamic>> amenities;

  const AmenitiesSection({
    super.key,
    required this.amenities,
  });

  void _showAmenityDetails(BuildContext context, Map<String, dynamic> amenity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AmenityDetailsModal(amenity: amenity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Group amenities by category
    final groupedAmenities = <String, List<Map<String, dynamic>>>{};
    for (final amenity in amenities) {
      final category = amenity['category'] as String;
      groupedAmenities.putIfAbsent(category, () => []).add(amenity);
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities & Services',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...groupedAmenities.entries.map((entry) {
            return _buildAmenityCategory(context, entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAmenityCategory(
    BuildContext context,
    String category,
    List<Map<String, dynamic>> categoryAmenities,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            children: categoryAmenities.map((amenity) {
              return _buildAmenityItem(context, amenity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(BuildContext context, Map<String, dynamic> amenity) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onLongPress: () => _showAmenityDetails(context, amenity),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getAmenityIcon(amenity['name'] as String, colorScheme.primary),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                amenity['name'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (amenity['premium'] as bool? ?? false) ...[
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.warningLight,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getAmenityIcon(String amenityName, Color color) {
    String iconName;
    switch (amenityName.toLowerCase()) {
      case 'free wifi':
      case 'wifi':
        iconName = 'wifi';
        break;
      case 'swimming pool':
      case 'pool':
        iconName = 'pool';
        break;
      case 'fitness center':
      case 'gym':
        iconName = 'fitness_center';
        break;
      case 'parking':
      case 'free parking':
        iconName = 'local_parking';
        break;
      case 'restaurant':
        iconName = 'restaurant';
        break;
      case 'room service':
        iconName = 'room_service';
        break;
      case 'spa':
        iconName = 'spa';
        break;
      case 'bar':
        iconName = 'local_bar';
        break;
      case 'air conditioning':
      case 'ac':
        iconName = 'ac_unit';
        break;
      case 'laundry':
        iconName = 'local_laundry_service';
        break;
      case 'concierge':
        iconName = 'concierge_meds';
        break;
      case 'business center':
        iconName = 'business_center';
        break;
      case 'pet friendly':
        iconName = 'pets';
        break;
      default:
        iconName = 'check_circle';
    }

    return CustomIconWidget(
      iconName: iconName,
      color: color,
      size: 20,
    );
  }
}

class _AmenityDetailsModal extends StatelessWidget {
  final Map<String, dynamic> amenity;

  const _AmenityDetailsModal({
    required this.amenity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Amenity header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _getAmenityIcon(
                    amenity['name'] as String, colorScheme.primary),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amenity['name'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      amenity['category'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (amenity['premium'] as bool? ?? false)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Premium',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 3.h),

          // Description
          if (amenity['description'] != null) ...[
            Text(
              'Description',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              amenity['description'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Hours or additional info
          if (amenity['hours'] != null) ...[
            Text(
              'Hours',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              amenity['hours'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _getAmenityIcon(String amenityName, Color color) {
    String iconName;
    switch (amenityName.toLowerCase()) {
      case 'free wifi':
      case 'wifi':
        iconName = 'wifi';
        break;
      case 'swimming pool':
      case 'pool':
        iconName = 'pool';
        break;
      case 'fitness center':
      case 'gym':
        iconName = 'fitness_center';
        break;
      case 'parking':
      case 'free parking':
        iconName = 'local_parking';
        break;
      case 'restaurant':
        iconName = 'restaurant';
        break;
      case 'room service':
        iconName = 'room_service';
        break;
      case 'spa':
        iconName = 'spa';
        break;
      case 'bar':
        iconName = 'local_bar';
        break;
      case 'air conditioning':
      case 'ac':
        iconName = 'ac_unit';
        break;
      case 'laundry':
        iconName = 'local_laundry_service';
        break;
      case 'concierge':
        iconName = 'concierge_meds';
        break;
      case 'business center':
        iconName = 'business_center';
        break;
      case 'pet friendly':
        iconName = 'pets';
        break;
      default:
        iconName = 'check_circle';
    }

    return CustomIconWidget(
      iconName: iconName,
      color: color,
      size: 20,
    );
  }
}
