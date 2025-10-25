import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GuestInformationSection extends StatefulWidget {
  final Map<String, dynamic> guestData;
  final Function(Map<String, dynamic>) onGuestDataChanged;

  const GuestInformationSection({
    super.key,
    required this.guestData,
    required this.onGuestDataChanged,
  });

  @override
  State<GuestInformationSection> createState() =>
      _GuestInformationSectionState();
}

class _GuestInformationSectionState extends State<GuestInformationSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _specialRequestsController;

  String _selectedCountryCode = '+1';
  int _specialRequestsCharCount = 0;
  final int _maxSpecialRequestsLength = 500;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
    {'code': '+49', 'country': 'DE'},
    {'code': '+33', 'country': 'FR'},
    {'code': '+39', 'country': 'IT'},
    {'code': '+34', 'country': 'ES'},
    {'code': '+61', 'country': 'AU'},
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
        text: widget.guestData['firstName'] as String? ?? '');
    _lastNameController = TextEditingController(
        text: widget.guestData['lastName'] as String? ?? '');
    _emailController =
        TextEditingController(text: widget.guestData['email'] as String? ?? '');
    _phoneController =
        TextEditingController(text: widget.guestData['phone'] as String? ?? '');
    _specialRequestsController = TextEditingController(
        text: widget.guestData['specialRequests'] as String? ?? '');
    _selectedCountryCode = widget.guestData['countryCode'] as String? ?? '+1';
    _specialRequestsCharCount = _specialRequestsController.text.length;

    _specialRequestsController.addListener(_updateCharCount);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _specialRequestsCharCount = _specialRequestsController.text.length;
    });
  }

  void _updateGuestData() {
    final updatedData = {
      ...widget.guestData,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'countryCode': _selectedCountryCode,
      'specialRequests': _specialRequestsController.text,
    };
    widget.onGuestDataChanged(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Guest Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter first name',
                        prefixIcon: CustomIconWidget(
                          iconName: 'person_outline',
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateGuestData(),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter last name',
                        prefixIcon: CustomIconWidget(
                          iconName: 'person_outline',
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateGuestData(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter email address',
                  prefixIcon: CustomIconWidget(
                    iconName: 'email',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (_) => _updateGuestData(),
              ),
              SizedBox(height: 2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20.w,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCountryCode,
                      decoration: InputDecoration(
                        labelText: 'Code',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 2.h),
                      ),
                      items: _countryCodes.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['code'],
                          child: Text(
                            '${country['code']} ${country['country']}',
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountryCode = value!;
                        });
                        _updateGuestData();
                      },
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        prefixIcon: CustomIconWidget(
                          iconName: 'phone',
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateGuestData(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                'Special Requests',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _specialRequestsController,
                decoration: InputDecoration(
                  hintText: 'Any special requests or preferences? (Optional)',
                  alignLabelWithHint: true,
                  suffixText:
                      '$_specialRequestsCharCount/$_maxSpecialRequestsLength',
                  suffixStyle: theme.textTheme.bodySmall?.copyWith(
                    color: _specialRequestsCharCount > _maxSpecialRequestsLength
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                maxLines: 4,
                maxLength: _maxSpecialRequestsLength,
                textInputAction: TextInputAction.done,
                onChanged: (_) => _updateGuestData(),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Please ensure all information is accurate as it will be used for your hotel reservation.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
    );
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }
}
