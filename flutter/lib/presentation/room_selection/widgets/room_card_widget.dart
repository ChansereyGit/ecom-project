import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class RoomCardWidget extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onExpand;
  final bool isExpanded;

  const RoomCardWidget({
    super.key,
    required this.roomData,
    required this.isSelected,
    required this.onTap,
    required this.onExpand,
    required this.isExpanded,
  });

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(RoomCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAvailable = (widget.roomData['isAvailable'] as bool?) ?? true;
    final hasOffer = (widget.roomData['hasOffer'] as bool?) ?? false;
    final discountPercentage =
        (widget.roomData['discountPercentage'] as int?) ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isSelected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.2),
          width: widget.isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRoomHeader(
              context, colorScheme, isAvailable, hasOffer, discountPercentage),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _expandAnimation,
                child: child,
              );
            },
            child: widget.isExpanded
                ? _buildExpandedContent(context, colorScheme)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomHeader(BuildContext context, ColorScheme colorScheme,
      bool isAvailable, bool hasOffer, int discountPercentage) {
    return InkWell(
      onTap: isAvailable ? widget.onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: widget.isSelected,
                            onChanged:
                                isAvailable ? (value) => widget.onTap() : null,
                            activeColor: colorScheme.primary,
                          ),
                          Expanded(
                            child: Text(
                              widget.roomData['name'] as String? ?? 'Room',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isAvailable
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'bed',
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            widget.roomData['bedType'] as String? ??
                                '1 King Bed',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'people',
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.roomData['maxOccupancy'] ?? 2} guests',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: widget.roomData['imageUrl'] as String? ??
                            'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
                        width: 20.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (hasOffer && discountPercentage > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            '-$discountPercentage%',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasOffer && discountPercentage > 0) ...[
                        Text(
                          widget.roomData['originalPrice'] as String? ??
                              '\$399',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                      ],
                      Row(
                        children: [
                          Text(
                            widget.roomData['pricePerNight'] as String? ??
                                '\$299',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isAvailable
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '/night',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Total: ${widget.roomData['totalPrice'] as String? ?? '\$897'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (!isAvailable)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sold Out',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.errorLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else ...[
                      GestureDetector(
                        onTap: widget.onExpand,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomIconWidget(
                            iconName: widget.isExpanded
                                ? 'keyboard_arrow_up'
                                : 'keyboard_arrow_down',
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.roomData['availableRooms'] ?? 3} left',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          SizedBox(height: 2.h),
          _buildPhotoGallery(context, colorScheme),
          SizedBox(height: 3.h),
          _buildRoomDetails(context, colorScheme),
          SizedBox(height: 3.h),
          _buildAmenities(context, colorScheme),
          SizedBox(height: 3.h),
          _buildPolicies(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(BuildContext context, ColorScheme colorScheme) {
    final photos = (widget.roomData['photos'] as List?) ??
        [
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?fm=jpg&q=60&w=3000',
          'https://images.unsplash.com/photo-1566665797739-1674de7a421a?fm=jpg&q=60&w=3000',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000',
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Photos',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 20.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (context, index) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: photos[index] as String,
                  width: 30.w,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomDetails(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Details',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                context,
                'Room Size',
                widget.roomData['roomSize'] as String? ?? '35 m²',
                'square_foot',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                context,
                'View',
                widget.roomData['view'] as String? ?? 'City View',
                'visibility',
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                context,
                'Floor',
                widget.roomData['floor'] as String? ?? '12-15',
                'layers',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                context,
                'Bathroom',
                widget.roomData['bathroom'] as String? ?? 'Private',
                'bathtub',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenities(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final amenities = (widget.roomData['amenities'] as List?) ??
        [
          {'name': 'Free WiFi', 'icon': 'wifi'},
          {'name': 'Coffee Machine', 'icon': 'coffee_maker'},
          {'name': 'Balcony', 'icon': 'balcony'},
          {'name': 'Air Conditioning', 'icon': 'ac_unit'},
          {'name': 'Mini Bar', 'icon': 'local_bar'},
          {'name': 'Safe', 'icon': 'lock'},
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Amenities',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 3.w,
          runSpacing: 1.h,
          children: amenities.map((amenity) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: (amenity['icon'] as String?) ?? 'check_circle',
                  size: 16,
                  color: AppTheme.successLight,
                ),
                SizedBox(width: 1.w),
                Text(
                  amenity['name'] as String? ?? '',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPolicies(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Policies',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        _buildPolicyItem(
          context,
          'Cancellation',
          widget.roomData['cancellationPolicy'] as String? ??
              'Free cancellation until 24 hours before check-in',
          'cancel',
          AppTheme.successLight,
        ),
        SizedBox(height: 1.h),
        _buildPolicyItem(
          context,
          'Payment',
          widget.roomData['paymentPolicy'] as String? ??
              'Pay at hotel or online',
          'payment',
          colorScheme.primary,
        ),
        SizedBox(height: 1.h),
        _buildPolicyItem(
          context,
          'Breakfast',
          widget.roomData['breakfastIncluded'] as bool? ?? false
              ? 'Breakfast included'
              : 'Breakfast not included',
          'restaurant',
          (widget.roomData['breakfastIncluded'] as bool? ?? false)
              ? AppTheme.successLight
              : colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildPolicyItem(BuildContext context, String title,
      String description, String iconName, Color iconColor) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 16,
          color: iconColor,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}