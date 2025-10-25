import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BookingSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onContinueBooking;
  final bool hasSelectedRoom;

  const BookingSummaryWidget({
    super.key,
    required this.bookingData,
    required this.onContinueBooking,
    required this.hasSelectedRoom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBookingDetails(context, colorScheme),
              SizedBox(height: 3.h),
              _buildContinueButton(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final checkInDate = bookingData['checkInDate'] as String? ?? 'Dec 15, 2024';
    final checkOutDate =
        bookingData['checkOutDate'] as String? ?? 'Dec 18, 2024';
    final nights = bookingData['nights'] as int? ?? 3;
    final guests = bookingData['guests'] as int? ?? 2;
    final totalPrice = bookingData['totalPrice'] as String? ?? '\$897';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateInfo(
                  context,
                  'Check-in',
                  checkInDate,
                  'login',
                  colorScheme,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: colorScheme.outline.withValues(alpha: 0.3),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              Expanded(
                child: _buildDateInfo(
                  context,
                  'Check-out',
                  checkOutDate,
                  'logout',
                  colorScheme,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                context,
                'Duration',
                '$nights ${nights == 1 ? 'night' : 'nights'}',
                'calendar_today',
                colorScheme,
              ),
              _buildInfoItem(
                context,
                'Guests',
                '$guests ${guests == 1 ? 'guest' : 'guests'}',
                'people',
                colorScheme,
              ),
              _buildPriceInfo(context, totalPrice, colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context, String label, String date,
      String iconName, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 24,
          color: colorScheme.primary,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          date,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value,
      String iconName, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(
      BuildContext context, String totalPrice, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: 'attach_money',
          size: 20,
          color: colorScheme.primary,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Total Price',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          totalPrice,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasSelectedRoom ? onContinueBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasSelectedRoom
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          foregroundColor: hasSelectedRoom
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          padding: EdgeInsets.symmetric(vertical: 4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: hasSelectedRoom ? 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasSelectedRoom ? 'Continue Booking' : 'Select a Room',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: hasSelectedRoom
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            if (hasSelectedRoom) ...[
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'arrow_forward',
                size: 20,
                color: colorScheme.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
