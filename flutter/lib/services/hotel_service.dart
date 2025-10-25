import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/hotel.dart';

class HotelService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> searchHotels({
    String? location,
    String? checkInDate,
    String? checkOutDate,
    int? guests,
    int? rooms,
    double? minPrice,
    double? maxPrice,
    int? minStarRating,
    double? minGuestRating,
  }) async {
    try {
      final response = await _api.post('/hotels/search', data: {
        if (location != null) 'location': location,
        if (checkInDate != null) 'checkInDate': checkInDate,
        if (checkOutDate != null) 'checkOutDate': checkOutDate,
        if (guests != null) 'guests': guests,
        if (rooms != null) 'rooms': rooms,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (minStarRating != null) 'minStarRating': minStarRating,
        if (minGuestRating != null) 'minGuestRating': minGuestRating,
      });

      if (response.data['success']) {
        final List<dynamic> hotelsJson = response.data['data'];
        final hotels = hotelsJson.map((json) => Hotel.fromJson(json)).toList();
        return {'success': true, 'hotels': hotels};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to search hotels'
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

  Future<Map<String, dynamic>> getFeaturedHotels() async {
    try {
      final response = await _api.get('/hotels/featured');

      if (response.data['success']) {
        final List<dynamic> hotelsJson = response.data['data'];
        final hotels = hotelsJson.map((json) => Hotel.fromJson(json)).toList();
        return {'success': true, 'hotels': hotels};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message':
              e.response?.data['message'] ?? 'Failed to load featured hotels'
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

  Future<Map<String, dynamic>> getHotelById(String hotelId) async {
    try {
      final response = await _api.get('/hotels/$hotelId');

      if (response.data['success']) {
        final hotel = Hotel.fromJson(response.data['data']);
        return {'success': true, 'hotel': hotel};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to load hotel details'
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

  Future<Map<String, dynamic>> getPopularDestinations() async {
    try {
      final response = await _api.get('/hotels/destinations');

      if (response.data['success']) {
        final List<String> destinations =
            List<String>.from(response.data['data']);
        return {'success': true, 'destinations': destinations};
      }
      return {'success': false, 'message': response.data['message']};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message':
              e.response?.data['message'] ?? 'Failed to load destinations'
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
