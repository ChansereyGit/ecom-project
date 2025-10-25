import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StickyBookingBar extends StatelessWidget {
  final String price;
  final String priceUnit;
  final bool isAvailable;
  final VoidCallback? onBookNow;

  const StickyBookingBar({
    super.key,
    required this.price,
    required this.priceUnit,
    required this.isAvailable,
    this.onBookNow,
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          priceUnit,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (!isAvailable)
                      Text(
                        'Limited availability',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isAvailable ? onBookNow : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAvailable ? colorScheme.primary : colorScheme.outline,
                    foregroundColor: isAvailable
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: isAvailable ? 2 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isAvailable) ...[
                        Text(
                          'Book Now',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ] else ...[
                        Text(
                          'Not Available',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
