import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final VoidCallback? onCheckInTap;
  final VoidCallback? onCheckOutTap;

  const DatePickerWidget({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    this.onCheckInTap,
    this.onCheckOutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateSection(
              context,
              'Check-in',
              checkInDate,
              onCheckInTap,
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildDateSection(
              context,
              'Check-out',
              checkOutDate,
              onCheckOutTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(
    BuildContext context,
    String label,
    DateTime date,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    '${date.month}/${date.day}/${date.year}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
