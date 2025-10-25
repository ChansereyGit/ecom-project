# 🔗 Backend Integration Guide

## Connecting Your Flutter App to Spring Boot Backend

This guide helps you integrate your Flutter hotel booking app with the Spring Boot backend.

---

## 📚 Complete Documentation

All backend architecture documentation is in the `/docs` folder:

### 🚀 Start Here
1. **[Quick Start Guide](./docs/QUICK_START_GUIDE.md)** - Setup in 30 minutes
2. **[Visual Architecture Summary](./docs/VISUAL_ARCHITECTURE_SUMMARY.md)** - See all approaches visualized

### 🏗️ Choose Your Architecture
3. **[Architecture Comparison](./docs/ARCHITECTURE_COMPARISON.md)** - Detailed comparison
4. **[Approach 1: Monolithic](./docs/1_MONOLITHIC_IMPLEMENTATION.md)** - Simple & fast
5. **[Approach 2: Modular Monolith](./docs/2_MODULAR_MONOLITH_IMPLEMENTATION.md)** ⭐ RECOMMENDED
6. **[Approach 3: Hybrid](./docs/3_HYBRID_APPROACH_IMPLEMENTATION.md)** - Advanced

### 💻 Implementation
7. **[Implementation Roadmap](./docs/IMPLEMENTATION_ROADMAP.md)** - 13-week plan
8. **[Code Examples](./docs/MODULAR_MONOLITH_CODE_EXAMPLES.md)** - Ready-to-use code
9. **[Auth Module](./docs/AUTH_MODULE_COMPLETE.md)** - Authentication
10. **[Hotel Module](./docs/HOTEL_MODULE_COMPLETE.md)** - Hotel management

---

## 🎯 Quick Decision

### For Your Project: Use **Modular Monolith** ⭐

**Why?**
- ✅ Perfect for 1-5 developer teams
- ✅ Clean architecture with clear boundaries
- ✅ Easy to migrate to microservices later
- ✅ Cost-effective ($30-70/month)
- ✅ Can handle 10,000+ users

**Timeline:** 13 weeks (3 months)

---

## 📋 API Endpoints Summary

All endpoints your Flutter app needs are documented in [Backend Architecture Guide](./docs/BACKEND_ARCHITECTURE_GUIDE.md).

### Quick Reference:

#### Authentication
```
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh-token
POST /api/v1/auth/logout
```

#### Hotels
```
GET  /api/v1/hotels/search
GET  /api/v1/hotels/{hotelId}
GET  /api/v1/hotels/{hotelId}/rooms
GET  /api/v1/hotels/popular-destinations
GET  /api/v1/hotels/nearby
```

#### Bookings
```
POST /api/v1/bookings
GET  /api/v1/bookings
GET  /api/v1/bookings/{bookingId}
POST /api/v1/bookings/{bookingId}/cancel
GET  /api/v1/bookings/upcoming
```

#### Payments
```
POST /api/v1/payments/process
GET  /api/v1/payments/{paymentId}
POST /api/v1/payments/{paymentId}/refund
```

#### Reviews
```
GET  /api/v1/reviews/hotel/{hotelId}
POST /api/v1/reviews
GET  /api/v1/reviews/hotel/{hotelId}/stats
```

#### Users
```
GET    /api/v1/users/profile
PUT    /api/v1/users/profile
GET    /api/v1/users/favorites
POST   /api/v1/users/favorites/{hotelId}
DELETE /api/v1/users/favorites/{hotelId}
```

---

## 🔧 Flutter Integration Steps

### Step 1: Create API Service Layer

```dart
// lib/services/api_service.dart
class ApiService {
  final Dio _dio;
  static const String baseUrl = 'http://localhost:8080/api/v1';
  
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ));
  
  // Add interceptors for auth, logging, etc.
}
```

### Step 2: Create DTOs/Models

```dart
// lib/models/hotel.dart
class Hotel {
  final String id;
  final String name;
  final double rating;
  final double pricePerNight;
  
  Hotel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      rating = json['guestRating'],
      pricePerNight = json['pricePerNight'];
}
```

### Step 3: Implement Services

```dart
// lib/services/hotel_service.dart
class HotelService {
  final ApiService _api;
  
  Future<List<Hotel>> searchHotels(SearchParams params) async {
    final response = await _api.get('/hotels/search', params);
    return response.data['hotels']
      .map((json) => Hotel.fromJson(json))
      .toList();
  }
}
```

---

## 🚀 Next Steps

1. **Read the documentation** in `/docs` folder
2. **Choose your architecture** (Recommended: Modular Monolith)
3. **Follow the Quick Start Guide** to setup backend
4. **Implement API integration** in Flutter
5. **Test end-to-end** with your Flutter app

---

## 📖 Documentation Structure

```
docs/
├── README.md                              # Main index
├── QUICK_START_GUIDE.md                   # Start here
├── VISUAL_ARCHITECTURE_SUMMARY.md         # Visual guide
├── ARCHITECTURE_COMPARISON.md             # Compare approaches
├── IMPLEMENTATION_ROADMAP.md              # 13-week plan
├── 1_MONOLITHIC_IMPLEMENTATION.md         # Approach 1
├── 2_MODULAR_MONOLITH_IMPLEMENTATION.md   # Approach 2 ⭐
├── 3_HYBRID_APPROACH_IMPLEMENTATION.md    # Approach 3
├── MODULAR_MONOLITH_CODE_EXAMPLES.md      # Code samples
├── AUTH_MODULE_COMPLETE.md                # Auth implementation
├── HOTEL_MODULE_COMPLETE.md               # Hotel implementation
└── BACKEND_ARCHITECTURE_GUIDE.md          # Complete guide
```

---

## 💡 Pro Tips

1. **Start with MVP** - Implement Auth, Hotel Search, and Booking first
2. **Test as you go** - Don't wait until the end
3. **Use Postman** - Test APIs before integrating with Flutter
4. **Follow the roadmap** - Stick to the 13-week plan
5. **Keep it simple** - Don't over-engineer

---

## 🎓 Learning Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Flutter Dio Package](https://pub.dev/packages/dio)
- [REST API Best Practices](https://restfulapi.net/)

---

## ✅ Checklist

### Backend Setup
- [ ] Read Quick Start Guide
- [ ] Choose architecture (Modular Monolith recommended)
- [ ] Setup development environment
- [ ] Create Spring Boot project
- [ ] Implement Auth module
- [ ] Implement Hotel module
- [ ] Implement Booking module

### Flutter Integration
- [ ] Create API service layer
- [ ] Create models/DTOs
- [ ] Implement authentication
- [ ] Implement hotel search
- [ ] Implement booking flow
- [ ] Test end-to-end

---

**Ready to start? Open [docs/README.md](./docs/README.md) for the complete guide!** 🚀

