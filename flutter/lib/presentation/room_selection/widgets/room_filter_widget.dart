import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RoomFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;
  final Map<String, dynamic> currentFilters;

  const RoomFilterWidget({
    super.key,
    required this.onFilterChanged,
    required this.currentFilters,
  });

  @override
  State<RoomFilterWidget> createState() => _RoomFilterWidgetState();
}

class _RoomFilterWidgetState extends State<RoomFilterWidget> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context,
              'All Rooms',
              _filters['showAll'] as bool? ?? true,
              () => _updateFilter(
                  'showAll', !(_filters['showAll'] as bool? ?? true)),
            ),
            SizedBox(width: 2.w),
            _buildFilterChip(
              context,
              'Available Only',
              _filters['availableOnly'] as bool? ?? false,
              () => _updateFilter('availableOnly',
                  !(_filters['availableOnly'] as bool? ?? false)),
            ),
            SizedBox(width: 2.w),
            _buildFilterChip(
              context,
              'Special Offers',
              _filters['offersOnly'] as bool? ?? false,
              () => _updateFilter(
                  'offersOnly', !(_filters['offersOnly'] as bool? ?? false)),
            ),
            SizedBox(width: 2.w),
            _buildSortButton(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final currentSort = _filters['sortBy'] as String? ?? 'price';

    return GestureDetector(
      onTap: () => _showSortOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
            CustomIconWidget(
              iconName: 'sort',
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 1.w),
            Text(
              _getSortLabel(currentSort),
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'price':
        return 'Price';
      case 'size':
        return 'Size';
      case 'popularity':
        return 'Popular';
      default:
        return 'Sort';
    }
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _filters[key] = value;

      // Handle mutual exclusivity for some filters
      if (key == 'showAll' && value == true) {
        _filters['availableOnly'] = false;
        _filters['offersOnly'] = false;
      } else if ((key == 'availableOnly' || key == 'offersOnly') &&
          value == true) {
        _filters['showAll'] = false;
      }
    });

    widget.onFilterChanged(_filters);
  }

  void _showSortOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Sort by',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildSortOption(context, 'Price (Low to High)', 'price'),
              _buildSortOption(context, 'Room Size', 'size'),
              _buildSortOption(context, 'Most Popular', 'popularity'),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = (_filters['sortBy'] as String? ?? 'price') == value;

    return ListTile(
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check',
              size: 20,
              color: colorScheme.primary,
            )
          : null,
      onTap: () {
        _updateFilter('sortBy', value);
        Navigator.pop(context);
      },
    );
  }
}
