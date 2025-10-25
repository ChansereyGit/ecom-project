import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SortOption {
  price,
  distance,
  rating,
  popularity,
}

class SortBottomSheetWidget extends StatefulWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption>? onSortChanged;

  const SortBottomSheetWidget({
    super.key,
    required this.selectedSort,
    this.onSortChanged,
  });

  @override
  State<SortBottomSheetWidget> createState() => _SortBottomSheetWidgetState();
}

class _SortBottomSheetWidgetState extends State<SortBottomSheetWidget> {
  late SortOption _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                _buildSortOption(
                  context,
                  SortOption.price,
                  'Price',
                  'Low to High',
                  Icons.attach_money,
                ),
                _buildSortOption(
                  context,
                  SortOption.distance,
                  'Distance',
                  'Closest first',
                  Icons.location_on,
                ),
                _buildSortOption(
                  context,
                  SortOption.rating,
                  'Guest Rating',
                  'Highest rated',
                  Icons.star,
                ),
                _buildSortOption(
                  context,
                  SortOption.popularity,
                  'Popularity',
                  'Most popular',
                  Icons.trending_up,
                ),
                SizedBox(height: 3.h),
                Row(
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
                        onPressed: () {
                          widget.onSortChanged?.call(_selectedSort);
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    SortOption option,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedSort == option;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _getIconName(icon),
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData icon) {
    switch (icon) {
      case Icons.attach_money:
        return 'attach_money';
      case Icons.location_on:
        return 'location_on';
      case Icons.star:
        return 'star';
      case Icons.trending_up:
        return 'trending_up';
      default:
        return 'sort';
    }
  }
}
