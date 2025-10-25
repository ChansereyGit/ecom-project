import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppLogoWidget extends StatelessWidget {
  final double? size;
  final bool showText;

  const AppLogoWidget({
    super.key,
    this.size,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 20.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(logoSize * 0.2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'hotel',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: logoSize * 0.5,
            ),
          ),
        ),

        if (showText) ...[
          SizedBox(height: 2.h),
          // App Name
          Text(
            'HotelBooker',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 0.5.h),
          // Tagline
          Text(
            'Your perfect stay awaits',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}
