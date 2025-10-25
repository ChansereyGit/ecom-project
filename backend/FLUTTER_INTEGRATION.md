# Flutter Integration Guide

## Quick Start

Your Flutter app is ready to connect! Here's how to integrate with this backend.

## 1. Create API Service in Flutter

Create `lib/services/api_service.dart`:

```dart
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1';
  final Dio _dio;
  
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  
  // Set auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  // Remove auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }
  
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
```

## 2. Create Models

### User Model (`lib/models/user.dart`)

```dart
class User {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool emailVerified;
  
  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.emailVerified,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      emailVerified: json['emailVerified'],
    );
  }
}
```

### Hotel Model (`lib/models/hotel.dart`)

```dart
class Hotel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final double pricePerNight;
  final double guestRating;
  final int totalReviews;
  final int starRating;
  final List<String> images;
  final List<String> amenities;
  final bool featured;
  
  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    required this.pricePerNight,
    required this.guestRating,
    required this.totalReviews,
    required this.starRating,
    required this.images,
    required this.amenities,
    required this.featured,
  });
  
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      pricePerNight: json['pricePerNight'].toDouble(),
      guestRating: json['guestRating'].toDouble(),
      totalReviews: json['totalReviews'],
      starRating: json['starRating'],
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      featured: json['featured'],
    );
  }
}
```

## 3. Create Auth Service

Create `lib/services/auth_service.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';
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
        
        // Save token
        await _saveToken(token);
        _api.setAuthToken(token);
        
        return {'success': true, 'user': user};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
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
        
        await _saveToken(token);
        _api.setAuthToken(token);
        
        return {'success': true, 'user': user};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _api.clearAuthToken();
  }
  
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
```

## 4. Create Hotel Service

Create `lib/services/hotel_service.dart`:

```dart
import 'api_service.dart';
import '../models/hotel.dart';

class HotelService {
  final ApiService _api = ApiService();
  
  Future<List<Hotel>> searchHotels({
    String? location,
    String? checkInDate,
    String? checkOutDate,
    int? guests,
    int? rooms,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final response = await _api.post('/hotels/search', data: {
        'location': location,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'guests': guests,
        'rooms': rooms,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      });
      
      if (response.data['success']) {
        final List<dynamic> hotelsJson = response.data['data'];
        return hotelsJson.map((json) => Hotel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching hotels: $e');
      return [];
    }
  }
  
  Future<Hotel?> getHotelById(String hotelId) async {
    try {
      final response = await _api.get('/hotels/$hotelId');
      
      if (response.data['success']) {
        return Hotel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('Error getting hotel: $e');
      return null;
    }
  }
  
  Future<List<Hotel>> getFeaturedHotels() async {
    try {
      final response = await _api.get('/hotels/featured');
      
      if (response.data['success']) {
        final List<dynamic> hotelsJson = response.data['data'];
        return hotelsJson.map((json) => Hotel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting featured hotels: $e');
      return [];
    }
  }
}
```

## 5. Update Login Screen

Update your `lib/presentation/login_screen/login_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, AppRoutes.hotelSearchHome);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 6. Testing

1. Start the backend: `mvn spring-boot:run`
2. Run your Flutter app
3. Try logging in with test credentials
4. Search for hotels
5. View hotel details
6. Create a booking

## API Response Format

All responses follow this format:

```json
{
  "success": true,
  "message": "Success",
  "data": { ... },
  "timestamp": "2024-01-01T12:00:00"
}
```

## Error Handling

```dart
try {
  final response = await _api.get('/hotels/search');
  if (response.data['success']) {
    // Handle success
  } else {
    // Handle API error
    print(response.data['message']);
  }
} on DioException catch (e) {
  // Handle network error
  if (e.response != null) {
    print('Error: ${e.response?.data['message']}');
  } else {
    print('Network error: ${e.message}');
  }
}
```

## Next Steps

1. Implement booking flow
2. Add payment integration
3. Add user profile management
4. Implement favorites/wishlist
5. Add reviews and ratings
