import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/app_export.dart';
import '../../../services/auth_service.dart';

class LoginFormWidget extends StatefulWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onForgotPasswordPressed;

  const LoginFormWidget({
    super.key,
    this.onLoginPressed,
    this.onForgotPasswordPressed,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
      _isFormValid = _emailError == null &&
          _passwordError == null &&
          email.isNotEmpty &&
          password.isNotEmpty;
    });
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return null;

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return null;

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final result = await _authService.login(email, password);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        // Show success message
        Fluttertoast.showToast(
          msg: result['message'] ?? 'Login successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Navigate to home
        if (widget.onLoginPressed != null) {
          widget.onLoginPressed!();
        }
      } else {
        // Show error message
        setState(() {
          _emailError = result['message'];
          _passwordError = result['message'];
        });

        Fluttertoast.showToast(
          msg: result['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _emailError = 'An error occurred';
        _passwordError = 'An error occurred';
      });

      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _emailError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'email',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                hintStyle: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          if (_emailError != null) ...[
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: Text(
                _emailError!,
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
          SizedBox(height: 2.h),

          // Password Field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _passwordError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName:
                          _isPasswordVisible ? 'visibility_off' : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                hintStyle: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          if (_passwordError != null) ...[
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: Text(
                _passwordError!,
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
          SizedBox(height: 1.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onForgotPasswordPressed,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                elevation: _isFormValid ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
