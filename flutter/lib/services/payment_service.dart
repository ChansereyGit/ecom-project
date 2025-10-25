import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'api_service.dart';
import '../config/stripe_config.dart';

class PaymentService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    String? bookingId,
    String? description,
    Map<String, String>? metadata,
  }) async {
    try {
      final response = await _api.post('/payments/create-intent', data: {
        'amount': amount,
        'currency': currency,
        if (bookingId != null) 'bookingId': bookingId,
        if (description != null) 'description': description,
        if (metadata != null) 'metadata': metadata,
      });

      if (response.data['success']) {
        return {
          'success': true,
          'data': response.data['data'],
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to create payment intent'
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to create payment intent'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String currency,
    String? bookingId,
    String? description,
  }) async {
    try {
      // Step 1: Create payment intent on backend
      final intentResult = await createPaymentIntent(
        amount: amount,
        currency: currency,
        bookingId: bookingId,
        description: description,
      );

      if (!intentResult['success']) {
        return intentResult;
      }

      final paymentIntentData = intentResult['data'];
      final clientSecret = paymentIntentData['clientSecret'];
      final paymentIntentId = paymentIntentData['paymentIntentId'];

      // Step 2: Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: StripeConfig.merchantDisplayName,
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: null,
          customerId: null,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF6366F1),
            ),
          ),
        ),
      );

      // Step 3: Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Step 4: Confirm payment on backend
      final confirmResult = await confirmPayment(paymentIntentId);

      if (confirmResult['success']) {
        return {
          'success': true,
          'paymentIntentId': paymentIntentId,
          'payment': confirmResult['data'],
          'message': 'Payment successful'
        };
      }

      return {
        'success': false,
        'message': confirmResult['message']?.toString() ?? 'Payment confirmation failed'
      };
    } on StripeException catch (e) {
      return {
        'success': false,
        'message': _handleStripeError(e),
        'cancelled': e.error.code == FailureCode.Canceled,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Payment failed: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      final response = await _api.post('/payments/confirm/$paymentIntentId');

      if (response.data['success']) {
        return {
          'success': true,
          'data': response.data['data'],
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to confirm payment'
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to confirm payment'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> getPaymentByBookingId(String bookingId) async {
    try {
      final response = await _api.get('/payments/booking/$bookingId');

      if (response.data['success']) {
        return {
          'success': true,
          'payment': response.data['data'],
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to get payment'
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to get payment'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> getUserPayments() async {
    try {
      final response = await _api.get('/payments/my-payments');

      if (response.data['success']) {
        return {
          'success': true,
          'payments': response.data['data'],
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to get payments'
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to get payments'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  String _handleStripeError(StripeException error) {
    switch (error.error.code) {
      case FailureCode.Canceled:
        return 'Payment was cancelled';
      case FailureCode.Failed:
        return 'Payment failed. Please try again.';
      case FailureCode.Timeout:
        return 'Payment timed out. Please try again.';
      default:
        return error.error.localizedMessage ?? 'Payment failed';
    }
  }
}
