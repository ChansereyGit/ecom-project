import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoomTypesSection extends StatelessWidget {
  final List<Map<String, dynamic>> roomTypes;

  const RoomTypesSection({
    super.key,
    required this.roomTypes,
  });

  void _openRoomSelection(BuildContext context, Map<String, dynamic> room) {
    Navigator.pushNamed(context, '/room-selection');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Types',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: roomTypes.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final room = roomTypes[index];
                return _buildRoomCard(context, room);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Map<String, dynamic> room) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _openRoomSelection(context, room),
      child: Container(
        width: 70.w,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: room['image'] as String,
                width: double.infinity,
                height: 18.h,
                fit: BoxFit.cover,
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room name
                    Text(
                      room['name'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),

                    // Bed type and capacity
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'bed',
                          color: colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            room['bedType'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),

                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'people',
                          color: colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Up to ${room['maxGuests']} guests',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and availability
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              room['price'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: room['available'] as bool
                                ? AppTheme.successLight.withValues(alpha: 0.1)
                                : AppTheme.errorLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            room['available'] as bool ? 'Available' : 'Booked',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: room['available'] as bool
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
