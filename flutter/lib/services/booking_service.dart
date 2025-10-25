import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/booking.dart';
import '../models/room.dart';

class BookingService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getHotelRooms(String hotelId) async {
    try {
      final response = await _api.get('/hotels/$hotelId/rooms');

      if (response.data['success']) {
        final List<dynamic> roomsJson = response.data['data'];
        final rooms = roomsJson.map((json) => Room.fromJson(json)).toList();
        return {'success': true, 'rooms': rooms};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to load rooms'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createBooking(Booking booking) async {
    try {
      final response = await _api.post('/bookings', data: {
        'hotelId': booking.hotelId,
        'roomId': booking.roomId,
        'checkInDate': booking.checkInDate,
        'checkOutDate': booking.checkOutDate,
        'numberOfGuests': booking.numberOfGuests,
        'numberOfRooms': booking.numberOfRooms,
        'specialRequests': booking.specialRequests,
        'guestName': booking.guestName,
        'guestEmail': booking.guestEmail,
        'guestPhone': booking.guestPhone,
      });

      if (response.data['success']) {
        final bookingData = Booking.fromJson(response.data['data']);
        return {'success': true, 'booking': bookingData};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to create booking'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getUserBookings() async {
    try {
      final response = await _api.get('/bookings');

      if (response.data['success']) {
        final List<dynamic> bookingsJson = response.data['data'];
        final bookings =
            bookingsJson.map((json) => Booking.fromJson(json)).toList();
        return {'success': true, 'bookings': bookings};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to load bookings'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      final response = await _api.post('/bookings/$bookingId/cancel');

      if (response.data['success']) {
        final bookingData = Booking.fromJson(response.data['data']);
        return {'success': true, 'booking': bookingData};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to cancel booking'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error. Please check your connection.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }
}
