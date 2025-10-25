import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHeaderWidget extends StatelessWidget {
  final String location;
  final String dates;
  final String guests;
  final VoidCallback? onEditSearch;

  const SearchHeaderWidget({
    super.key,
    required this.location,
    required this.dates,
    required this.guests,
    this.onEditSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hotels in $location',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onEditSearch,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Edit Search',
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildSearchDetail(
                  context,
                  Icons.calendar_today,
                  dates,
                ),
              ),
              SizedBox(width: 4.w),
              _buildSearchDetail(
                context,
                Icons.people,
                guests,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchDetail(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon == Icons.calendar_today ? 'calendar_today' : 'people',
          color: colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
