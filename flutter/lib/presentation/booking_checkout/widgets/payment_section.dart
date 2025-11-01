import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentSection extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  final Function(Map<String, dynamic>) onPaymentDataChanged;

  const PaymentSection({
    super.key,
    required this.paymentData,
    required this.onPaymentDataChanged,
  });

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;
  late TextEditingController _cardHolderController;
  late TextEditingController _billingAddressController;
  late TextEditingController _cityController;
  late TextEditingController _zipController;

  String _selectedPaymentMethod = 'card';
  bool _sameAsBilling = true;
  bool _acceptTerms = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': 'credit_card',
      'available': true,
    },
    {
      'id': 'apple_pay',
      'name': 'Apple Pay',
      'icon': 'apple',
      'available': Platform.isIOS,
    },
    {
      'id': 'google_pay',
      'name': 'Google Pay',
      'icon': 'google',
      'available': Platform.isAndroid,
    },
    {
      'id': 'stripe',
      'name': 'Stripe',
      'icon': 'payment',
      'available': true,
    },
  ];

  final List<String> _cardTypes = ['visa', 'mastercard', 'amex', 'discover'];

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController(
        text: widget.paymentData['cardNumber'] as String? ?? '');
    _expiryController = TextEditingController(
        text: widget.paymentData['expiry'] as String? ?? '');
    _cvvController =
        TextEditingController(text: widget.paymentData['cvv'] as String? ?? '');
    _cardHolderController = TextEditingController(
        text: widget.paymentData['cardHolder'] as String? ?? '');
    _billingAddressController = TextEditingController(
        text: widget.paymentData['billingAddress'] as String? ?? '');
    _cityController = TextEditingController(
        text: widget.paymentData['city'] as String? ?? '');
    _zipController =
        TextEditingController(text: widget.paymentData['zip'] as String? ?? '');
    _selectedPaymentMethod =
        widget.paymentData['paymentMethod'] as String? ?? 'card';
    _sameAsBilling = widget.paymentData['sameAsBilling'] as bool? ?? true;
    _acceptTerms = widget.paymentData['acceptTerms'] as bool? ?? false;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _billingAddressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _updatePaymentData() {
    final updatedData = {
      ...widget.paymentData,
      'paymentMethod': _selectedPaymentMethod,
      'cardNumber': _cardNumberController.text,
      'expiry': _expiryController.text,
      'cvv': _cvvController.text,
      'cardHolder': _cardHolderController.text,
      'billingAddress': _billingAddressController.text,
      'city': _cityController.text,
      'zip': _zipController.text,
      'sameAsBilling': _sameAsBilling,
      'acceptTerms': _acceptTerms,
    };
    widget.onPaymentDataChanged(updatedData);
  }

  String _formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String _formatExpiry(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
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
                    iconName: 'payment',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Payment Method',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Payment Methods
              Column(
                children: _paymentMethods
                    .where((method) => method['available'] as bool)
                    .map((method) {
                  final isSelected = _selectedPaymentMethod == method['id'];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['id'] as String;
                        });
                        _updatePaymentData();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.05)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: method['id'] as String,
                              groupValue: _selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                                _updatePaymentData();
                              },
                            ),
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: method['icon'] as String,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                method['name'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (method['id'] == 'card') ...[
                              Flexible(
                                child: Wrap(
                                  spacing: 1.w,
                                  runSpacing: 0.5.h,
                                  children: _cardTypes.map((cardType) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.5.w, vertical: 0.4.h),
                                      decoration: BoxDecoration(
                                        color:
                                            colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        cardType.toUpperCase(),
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Card Details (only show if card is selected)
              if (_selectedPaymentMethod == 'card') ...[
                SizedBox(height: 2.h),
                Text(
                  'Card Details',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _cardHolderController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    hintText: 'Enter name on card',
                    prefixIcon: CustomIconWidget(
                      iconName: 'person_outline',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Cardholder name is required';
                    }
                    return null;
                  },
                  onChanged: (_) => _updatePaymentData(),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                    prefixIcon: CustomIconWidget(
                      iconName: 'credit_card',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final formatted = _formatCardNumber(newValue.text);
                      return TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null ||
                        value.replaceAll(' ', '').length < 16) {
                      return 'Please enter a valid card number';
                    }
                    return null;
                  },
                  onChanged: (_) => _updatePaymentData(),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          prefixIcon: CustomIconWidget(
                            iconName: 'calendar_today',
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final formatted = _formatExpiry(newValue.text);
                            return TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                  offset: formatted.length),
                            );
                          }),
                        ],
                        validator: (value) {
                          if (value == null || value.length < 5) {
                            return 'Enter MM/YY';
                          }
                          return null;
                        },
                        onChanged: (_) => _updatePaymentData(),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                          prefixIcon: CustomIconWidget(
                            iconName: 'lock_outline',
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return 'Enter CVV';
                          }
                          return null;
                        },
                        onChanged: (_) => _updatePaymentData(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Billing Address
                Text(
                  'Billing Address',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                CheckboxListTile(
                  value: _sameAsBilling,
                  onChanged: (value) {
                    setState(() {
                      _sameAsBilling = value!;
                    });
                    _updatePaymentData();
                  },
                  title: Text(
                    'Same as guest information',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                if (!_sameAsBilling) ...[
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _billingAddressController,
                    decoration: InputDecoration(
                      labelText: 'Street Address',
                      hintText: 'Enter billing address',
                      prefixIcon: CustomIconWidget(
                        iconName: 'location_on',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    validator: !_sameAsBilling
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Billing address is required';
                            }
                            return null;
                          }
                        : null,
                    onChanged: (_) => _updatePaymentData(),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'City',
                            hintText: 'Enter city',
                          ),
                          validator: !_sameAsBilling
                              ? (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'City is required';
                                  }
                                  return null;
                                }
                              : null,
                          onChanged: (_) => _updatePaymentData(),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextFormField(
                          controller: _zipController,
                          decoration: InputDecoration(
                            labelText: 'ZIP Code',
                            hintText: '12345',
                          ),
                          keyboardType: TextInputType.number,
                          validator: !_sameAsBilling
                              ? (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'ZIP required';
                                  }
                                  return null;
                                }
                              : null,
                          onChanged: (_) => _updatePaymentData(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],

              SizedBox(height: 3.h),

              // Security Notice
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
                      iconName: 'security',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure Payment',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Your payment information is encrypted and secure. We use industry-standard SSL encryption.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Terms and Conditions
              CheckboxListTile(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value!;
                  });
                  _updatePaymentData();
                },
                title: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
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

  bool get isFormValid {
    return _acceptTerms &&
        (_selectedPaymentMethod != 'card' ||
            (_cardNumberController.text.replaceAll(' ', '').length == 16 &&
                _expiryController.text.length == 5 &&
                _cvvController.text.length >= 3 &&
                _cardHolderController.text.isNotEmpty));
  }
}
