import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class HotelCardWidget extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final VoidCallback? onViewMap;

  const HotelCardWidget({
    super.key,
    required this.hotel,
    this.onTap,
    this.onFavorite,
    this.onShare,
    this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(hotel['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onFavorite?.call(),
              backgroundColor: AppTheme.warningLight,
              foregroundColor: Colors.white,
              icon: Icons.favorite_border,
              label: 'Save',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onViewMap?.call(),
              backgroundColor: AppTheme.successLight,
              foregroundColor: Colors.white,
              icon: Icons.map,
              label: 'Map',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showQuickPreview(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
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
                _buildImageSection(context),
                _buildContentSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: CustomImageWidget(
            imageUrl: hotel['image'] as String,
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2.h,
          right: 3.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.warningLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  hotel['rating'].toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hotel['name'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.w),
              _buildStarRating(context),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  hotel['location'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${hotel['distance']} km from center',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getRatingColor(hotel['guestRating'] as double),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  hotel['guestRating'].toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                hotel['reviewText'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '(${hotel['reviewCount']} reviews)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hotel['amenities'] != null) ...[
                Expanded(
                  child: Wrap(
                    spacing: 1.w,
                    children: (hotel['amenities'] as List)
                        .take(3)
                        .map((amenity) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                amenity as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hotel['originalPrice'] != null) ...[
                    Text(
                      hotel['originalPrice'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  Text(
                    hotel['price'] as String,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'per night',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(BuildContext context) {
    final stars = hotel['stars'] as int;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < stars ? 'star' : 'star_border',
          color: index < stars ? AppTheme.warningLight : Colors.grey,
          size: 16,
        );
      }),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 9.0) return AppTheme.successLight;
    if (rating >= 8.0) return AppTheme.warningLight;
    if (rating >= 7.0) return Colors.orange;
    return Colors.red;
  }

  void _showQuickPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CustomImageWidget(
                imageUrl: hotel['image'] as String,
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['name'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    hotel['description'] as String? ??
                        'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/hotel-detail');
                      },
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}