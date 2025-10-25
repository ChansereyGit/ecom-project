import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatefulWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;
  final VoidCallback? onFacebookLogin;

  const SocialLoginWidget({
    super.key,
    this.onGoogleLogin,
    this.onAppleLogin,
    this.onFacebookLogin,
  });

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _isFacebookLoading = false;

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isGoogleLoading = true;
    });

    // Simulate Google authentication
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGoogleLoading = false;
    });

    if (widget.onGoogleLogin != null) {
      widget.onGoogleLogin!();
    }
  }

  Future<void> _handleAppleLogin() async {
    setState(() {
      _isAppleLoading = true;
    });

    // Simulate Apple authentication
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAppleLoading = false;
    });

    if (widget.onAppleLogin != null) {
      widget.onAppleLogin!();
    }
  }

  Future<void> _handleFacebookLogin() async {
    setState(() {
      _isFacebookLoading = true;
    });

    // Simulate Facebook authentication
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isFacebookLoading = false;
    });

    if (widget.onFacebookLogin != null) {
      widget.onFacebookLogin!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _buildSocialButton(
                onPressed: _isGoogleLoading ? null : _handleGoogleLogin,
                isLoading: _isGoogleLoading,
                icon: 'g_translate',
                label: 'Google',
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                borderColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                textColor: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 3.w),

            // Apple Login
            Expanded(
              child: _buildSocialButton(
                onPressed: _isAppleLoading ? null : _handleAppleLogin,
                isLoading: _isAppleLoading,
                icon: 'apple',
                label: 'Apple',
                backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                borderColor: AppTheme.lightTheme.colorScheme.onSurface,
                textColor: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
            SizedBox(width: 3.w),

            // Facebook Login
            Expanded(
              child: _buildSocialButton(
                onPressed: _isFacebookLoading ? null : _handleFacebookLogin,
                isLoading: _isFacebookLoading,
                icon: 'facebook',
                label: 'Facebook',
                backgroundColor: const Color(0xFF1877F2),
                borderColor: const Color(0xFF1877F2),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required String icon,
    required String label,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return SizedBox(
      height: 6.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: icon,
                    color: textColor,
                    size: 18,
                  ),
                  SizedBox(width: 1.w),
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
