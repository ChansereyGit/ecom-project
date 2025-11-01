import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to keyboard visibility changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MediaQuery.of(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleLoginSuccess() {
    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to hotel search home
    Navigator.pushReplacementNamed(context, '/hotel-search-home');
  }

  void _handleSocialLoginSuccess() {
    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to hotel search home
    Navigator.pushReplacementNamed(context, '/hotel-search-home');
  }

  void _handleForgotPassword() {
    // Show forgot password dialog or navigate to forgot password screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Password reset functionality will be available soon. Please contact support for assistance.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignUp() {
    // Navigate to register screen
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      children: [
                        // Top spacing
                        SizedBox(height: 12.h),

                        // App Logo
                        const AppLogoWidget(showText: true),

                        SizedBox(height: 1.h),

                        // Welcome Text
                        Column(
                          children: [
                            // Text(
                            //   'Welcome Back',
                            //   style: TextStyle(
                            //     fontSize: 28.sp,
                            //     fontWeight: FontWeight.w700,
                            //     color:
                            //         AppTheme.lightTheme.colorScheme.onSurface,
                            //     letterSpacing: -0.5,
                            //   ),
                            // ),
                            SizedBox(height: 1.h),
                            // Text(
                            //   'Sign in to continue your hotel booking journey',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     fontSize: 14.sp,
                            //     fontWeight: FontWeight.w400,
                            //     color: AppTheme
                            //         .lightTheme.colorScheme.primary,
                            //     height: 1.4,
                            //   ),
                            // ),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Login Form
                        LoginFormWidget(
                          onLoginPressed: _handleLoginSuccess,
                          onForgotPasswordPressed: _handleForgotPassword,
                        ),

                        SizedBox(height: 2.h),

                        // Social Login
                        SocialLoginWidget(
                          onGoogleLogin: _handleSocialLoginSuccess,
                          onAppleLogin: _handleSocialLoginSuccess,
                          onFacebookLogin: _handleSocialLoginSuccess,
                        ),

                        // Flexible spacer to push sign up to bottom
                        const Spacer(),

                        // Sign Up Link
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New user? ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleSignUp,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
