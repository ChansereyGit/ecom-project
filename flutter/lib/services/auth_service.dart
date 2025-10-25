import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _api.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        final authData = response.data['data'];
        final token = authData['accessToken'];
        final user = User.fromJson(authData['user']);

        // Save token and user
        await _api.setAuthToken(token);
        await _saveUser(user);

        return {
          'success': true,
          'user': user,
          'message': response.data['message']
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Login failed'
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Login failed'
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

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await _api.post('/auth/register', data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      });

      if (response.data['success']) {
        final authData = response.data['data'];
        final token = authData['accessToken'];
        final user = User.fromJson(authData['user']);

        // Save token and user
        await _api.setAuthToken(token);
        await _saveUser(user);

        return {
          'success': true,
          'user': user,
          'message': response.data['message']
        };
      }
      return {
        'success': false,
        'message': response.data['message'] ?? 'Registration failed'
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Registration failed'
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

  Future<void> logout() async {
    await _api.clearToken();
    await _clearUser();
  }

  Future<bool> isLoggedIn() async {
    final token = await _api.getToken();
    return token != null;
  }

  Future<bool> validateToken() async {
    try {
      final token = await _api.getToken();
      if (token == null) {
        return false;
      }

      // Try to fetch current user to validate token
      final response = await _api.get('/auth/me');
      
      if (response.data['success']) {
        // Token is valid, update stored user
        final user = User.fromJson(response.data['data']);
        await _saveUser(user);
        return true;
      }
      
      // Token invalid, clear it
      await logout();
      return false;
    } catch (e) {
      // On any error (expired token, network, etc.), clear and return false
      await logout();
      return false;
    }
  }

  // User management
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}
