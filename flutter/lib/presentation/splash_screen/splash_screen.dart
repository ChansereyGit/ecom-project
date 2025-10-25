import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_icon_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Show splash for at least 2 seconds for better UX
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // Check if user has valid token
      final isValid = await _authService.validateToken();

      if (!mounted) return;

      if (isValid) {
        // Token is valid, go to home
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/hotel-search-home',
          (route) => false,
        );
      } else {
        // Token invalid or doesn't exist, go to login
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login-screen',
          (route) => false,
        );
      }
    } catch (e) {
      // On error, go to login
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login-screen',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'hotel',
                color: colorScheme.primary,
                size: 60,
              ),
            ),
            SizedBox(height: 4.h),
            
            // App Name
            Text(
              'HotelBooker',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            
            // Tagline
            Text(
              'Find Your Perfect Stay',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 6.h),
            
            // Loading Indicator
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
