# Hotel Booking System - Complete Project Overview

## 🎯 Project Summary

A full-stack hotel booking application inspired by Booking.com, built with:
- **Frontend**: Flutter (Mobile & Web)
- **Backend**: Spring Boot (Modular Monolith)
- **Database**: PostgreSQL
- **Cache**: Redis
- **Auth**: JWT

## 📁 Project Structure

```
hotel-booking-project/
├── flutter/                    # Flutter Frontend
│   ├── lib/
│   │   ├── presentation/      # UI Screens
│   │   │   ├── login_screen/
│   │   │   ├── hotel_search_home/
│   │   │   ├── hotel_search_results/
│   │   │   ├── hotel_detail/
│   │   │   ├── room_selection/
│   │   │   └── booking_checkout/
│   │   ├── services/          # API Services (TO BE CREATED)
│   │   ├── models/            # Data Models (TO BE CREATED)
│   │   ├── widgets/           # Reusable Widgets
│   │   └── routes/            # Navigation
│   └── docs/                  # Documentation
│
└── backend/                   # Spring Boot Backend ✅ CREATED
    ├── src/main/java/com/hotelbooker/
    │   ├── auth/             # 🔐 Authentication Module
    │   ├── hotel/            # 🏨 Hotel Management Module
    │   ├── booking/          # 📅 Booking Module
    │   ├── common/           # 🔧 Shared Utilities
    │   └── config/           # ⚙️ Configuration
    └── src/main/resources/
        └── application.yml   # Configuration
```

## 🏗️ Architecture: Modular Monolith

### Why Modular Monolith?

✅ **Perfect for your project because:**
- Single deployment (easy for academic project)
- Clear module boundaries (good architecture practice)
- Fast development (no microservices overhead)
- Easy to scale later (can extract modules if needed)
- Low cost (~$30-50/month hosting)
- Great for 2-5 person teams

### Module Breakdown

#### 1. Auth Module 🔐
**Purpose**: User authentication and management

**Features**:
- User registration
- Login with JWT
- Password encryption
- Token management

**Endpoints**:
```
POST /api/v1/auth/register
POST /api/v1/auth/login
```

**Files Created**:
- `User.java` - User entity
- `AuthService.java` - Business logic
- `AuthController.java` - REST endpoints
- `JwtService.java` - Token handling
- `UserRepository.java` - Database access

---

#### 2. Hotel Module 🏨
**Purpose**: Hotel search and management

**Features**:
- Search hotels by location
- Filter by price, rating, amenities
- View hotel details
- View available rooms
- Featured hotels
- Popular destinations

**Endpoints**:
```
POST /api/v1/hotels/search
GET  /api/v1/hotels/{id}
GET  /api/v1/hotels/{id}/rooms
GET  /api/v1/hotels/featured
GET  /api/v1/hotels/destinations
```

**Files Created**:
- `Hotel.java` - Hotel entity
- `Room.java` - Room entity
- `HotelService.java` - Business logic
- `HotelController.java` - REST endpoints
- `HotelRepository.java` - Database access

---

#### 3. Booking Module 📅
**Purpose**: Booking management

**Features**:
- Create bookings
- View user bookings
- View upcoming bookings
- Cancel bookings
- Automatic price calculation
- Room availability management

**Endpoints**:
```
POST /api/v1/bookings
GET  /api/v1/bookings
GET  /api/v1/bookings/{id}
GET  /api/v1/bookings/upcoming
POST /api/v1/bookings/{id}/cancel
```

**Files Created**:
- `Booking.java` - Booking entity
- `BookingService.java` - Business logic
- `BookingController.java` - REST endpoints
- `BookingRepository.java` - Database access

---

#### 4. Common Module 🔧
**Purpose**: Shared utilities and DTOs

**Features**:
- API response wrapper
- Global exception handling
- Base entity with timestamps
- Common DTOs

**Files Created**:
- `ApiResponse.java` - Standard response format
- `GlobalExceptionHandler.java` - Error handling
- `BaseEntity.java` - Base for all entities

---

#### 5. Config Module ⚙️
**Purpose**: Application configuration

**Features**:
- Security configuration
- CORS configuration
- JWT configuration

**Files Created**:
- `SecurityConfig.java` - Spring Security setup
- `CorsConfig.java` - CORS for Flutter app

---

## 🔄 Data Flow

### 1. User Registration/Login Flow
```
Flutter App → POST /auth/register
           → AuthController
           → AuthService (validate, encrypt password)
           → UserRepository (save to DB)
           → JwtService (generate token)
           → Return token to Flutter
           → Flutter saves token
```

### 2. Hotel Search Flow
```
Flutter App → POST /hotels/search
           → HotelController
           → HotelService (apply filters)
           → HotelRepository (query DB)
           → Return hotel list to Flutter
           → Flutter displays results
```

### 3. Booking Flow
```
Flutter App → POST /bookings (with JWT token)
           → JwtAuthenticationFilter (validate token)
           → BookingController
           → BookingService (validate, calculate price)
           → Check room availability
           → Update room availability
           → BookingRepository (save booking)
           → Return booking confirmation
```

---

## 🗄️ Database Schema

### Users Table
```sql
users (
  id VARCHAR(36) PRIMARY KEY,
  full_name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255),
  phone_number VARCHAR(20),
  role VARCHAR(20),
  email_verified BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### Hotels Table
```sql
hotels (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(255),
  description TEXT,
  address VARCHAR(255),
  city VARCHAR(100),
  country VARCHAR(100),
  latitude DOUBLE,
  longitude DOUBLE,
  price_per_night DECIMAL(10,2),
  guest_rating DECIMAL(3,2),
  total_reviews INTEGER,
  star_rating INTEGER,
  featured BOOLEAN,
  available BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### Rooms Table
```sql
rooms (
  id VARCHAR(36) PRIMARY KEY,
  hotel_id VARCHAR(36) FOREIGN KEY,
  room_type VARCHAR(100),
  description TEXT,
  price_per_night DECIMAL(10,2),
  max_guests INTEGER,
  total_rooms INTEGER,
  available_rooms INTEGER,
  size DOUBLE,
  bed_type VARCHAR(50),
  has_breakfast BOOLEAN,
  free_cancellation BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### Bookings Table
```sql
bookings (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) FOREIGN KEY,
  hotel_id VARCHAR(36) FOREIGN KEY,
  room_id VARCHAR(36) FOREIGN KEY,
  check_in_date DATE,
  check_out_date DATE,
  number_of_guests INTEGER,
  number_of_rooms INTEGER,
  number_of_nights INTEGER,
  total_price DECIMAL(10,2),
  status VARCHAR(20),
  special_requests TEXT,
  guest_name VARCHAR(255),
  guest_email VARCHAR(255),
  guest_phone VARCHAR(20),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

---

## 🚀 Getting Started

### Backend Setup (5 minutes)

1. **Install dependencies**:
```bash
brew install postgresql@14 redis maven
brew services start postgresql@14
brew services start redis
```

2. **Create database**:
```bash
createdb hotelbooker
```

3. **Run backend**:
```bash
cd backend
mvn spring-boot:run
```

4. **Test**:
```bash
curl http://localhost:8080/api/v1/auth/login
# Should return 401 (expected)
```

### Flutter Integration (Next Steps)

1. **Create API Service** (see `backend/FLUTTER_INTEGRATION.md`)
2. **Create Models** (User, Hotel, Room, Booking)
3. **Update Login Screen** to call backend
4. **Update Hotel Search** to call backend
5. **Update Booking Flow** to call backend

---

## 📅 Development Timeline

### Week 1-2: Backend Foundation ✅ DONE
- [x] Project setup
- [x] Auth module
- [x] Hotel module
- [x] Booking module
- [x] Security configuration

### Week 3-4: Flutter Integration 🔄 NEXT
- [ ] Create API services
- [ ] Create models
- [ ] Update login screen
- [ ] Update hotel search
- [ ] Update booking flow

### Week 5-6: Testing & Polish
- [ ] End-to-end testing
- [ ] Bug fixes
- [ ] UI improvements
- [ ] Performance optimization

### Week 7-8: Additional Features
- [ ] Payment integration
- [ ] Reviews & ratings
- [ ] User profile
- [ ] Favorites/wishlist

### Week 9-10: Deployment
- [ ] Deploy backend (Railway/Heroku)
- [ ] Deploy Flutter web
- [ ] Final testing
- [ ] Documentation

---

## 🎯 MVP Features (Minimum Viable Product)

### Must Have (For Lecturer Demo)
- ✅ User registration & login
- ✅ Hotel search with filters
- ✅ Hotel details & rooms
- ✅ Booking creation
- ✅ View bookings
- ✅ Cancel bookings

### Nice to Have
- Payment integration
- Reviews & ratings
- Email notifications
- Admin panel

---

## 🔒 Security Features

- **Password Encryption**: BCrypt
- **JWT Authentication**: Secure token-based auth
- **CORS**: Configured for Flutter app
- **Input Validation**: All inputs validated
- **SQL Injection Protection**: JPA/Hibernate
- **XSS Protection**: Spring Security

---

## 📊 API Response Format

All APIs return consistent format:

```json
{
  "success": true,
  "message": "Success",
  "data": { ... },
  "timestamp": "2024-01-01T12:00:00"
}
```

**Success Response**:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "eyJhbGc...",
    "user": {
      "id": "123",
      "fullName": "John Doe",
      "email": "john@example.com"
    }
  },
  "timestamp": "2024-01-01T12:00:00"
}
```

**Error Response**:
```json
{
  "success": false,
  "message": "Invalid email or password",
  "timestamp": "2024-01-01T12:00:00"
}
```

---

## 💡 Key Decisions Made

### 1. Why Modular Monolith over Microservices?
- Simpler deployment
- Faster development
- Lower costs
- Easier debugging
- Perfect for academic project
- Can migrate to microservices later

### 2. Why PostgreSQL?
- Robust and reliable
- Great for relational data
- Free and open source
- Excellent Spring Boot support

### 3. Why JWT?
- Stateless authentication
- Works great with mobile apps
- Industry standard
- Easy to implement

### 4. Why Spring Boot?
- Mature ecosystem
- Great documentation
- Easy to learn
- Industry standard
- Excellent for learning

---

## 📚 Documentation

- `backend/README.md` - Backend overview
- `backend/SETUP.md` - Quick setup guide
- `backend/FLUTTER_INTEGRATION.md` - Flutter integration guide
- `flutter/docs/` - Architecture documentation

---

## 🎓 Learning Outcomes

By completing this project, you'll learn:

1. **Backend Development**
   - RESTful API design
   - Spring Boot framework
   - JWT authentication
   - Database design
   - Modular architecture

2. **Frontend Development**
   - Flutter framework
   - State management
   - API integration
   - Responsive design

3. **Full-Stack Integration**
   - API communication
   - Authentication flow
   - Error handling
   - Data modeling

4. **Software Architecture**
   - Modular monolith pattern
   - Separation of concerns
   - Clean code principles
   - Best practices

---

## 🚀 Next Immediate Steps

1. **Test Backend**:
```bash
cd backend
mvn spring-boot:run
```

2. **Create Flutter Services**:
   - Follow `backend/FLUTTER_INTEGRATION.md`
   - Create `lib/services/api_service.dart`
   - Create `lib/services/auth_service.dart`
   - Create `lib/services/hotel_service.dart`

3. **Test Integration**:
   - Register a user from Flutter
   - Login from Flutter
   - Search hotels from Flutter

4. **Iterate**:
   - Fix bugs
   - Add features
   - Improve UI
   - Test thoroughly

---

## 💪 You're Ready!

Your backend is fully set up and ready to integrate with Flutter. The architecture is clean, modular, and scalable. You have:

✅ Complete authentication system
✅ Hotel search and management
✅ Booking system
✅ Clean API design
✅ Comprehensive documentation

**Good luck with your project!** 🎉
