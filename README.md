# 🏨 Hotel Booking System

A full-stack hotel booking application inspired by Booking.com, built with Flutter and Spring Boot.

## 📱 Project Overview

- **Frontend**: Flutter (Mobile & Web)
- **Backend**: Spring Boot (Modular Monolith)
- **Database**: PostgreSQL
- **Cache**: Redis
- **Authentication**: JWT

## 🎯 Features

### User Features
- ✅ User registration and login
- ✅ Hotel search with filters (location, price, rating)
- ✅ View hotel details and available rooms
- ✅ Create and manage bookings
- ✅ Cancel bookings
- ✅ View booking history

### Technical Features
- ✅ JWT-based authentication
- ✅ RESTful API design
- ✅ Modular monolith architecture
- ✅ Clean code with separation of concerns
- ✅ Comprehensive error handling
- ✅ Input validation
- ✅ Security best practices

## 🏗️ Architecture

**Modular Monolith** - Perfect balance between simplicity and scalability

```
┌─────────────────────────────────────────┐
│         Flutter Application             │
│  (Mobile & Web)                         │
└──────────────┬──────────────────────────┘
               │ REST API
               │
┌──────────────▼──────────────────────────┐
│      Spring Boot Backend                │
│  ┌────────────────────────────────┐    │
│  │  Auth Module                   │    │
│  │  Hotel Module                  │    │
│  │  Booking Module                │    │
│  └────────────────────────────────┘    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      PostgreSQL Database                │
└─────────────────────────────────────────┘
```

## 📁 Project Structure

```
hotel-booking-project/
├── flutter/                    # Flutter Frontend
│   ├── lib/
│   │   ├── presentation/      # UI Screens
│   │   ├── services/          # API Services
│   │   ├── models/            # Data Models
│   │   └── widgets/           # Reusable Widgets
│   └── docs/                  # Documentation
│
├── backend/                   # Spring Boot Backend
│   ├── src/main/java/com/hotelbooker/
│   │   ├── auth/             # Authentication Module
│   │   ├── hotel/            # Hotel Management Module
│   │   ├── booking/          # Booking Module
│   │   ├── common/           # Shared Utilities
│   │   └── config/           # Configuration
│   └── src/main/resources/
│       └── application.yml   # Configuration
│
└── docs/                      # Project Documentation
    ├── QUICK_START.md
    ├── PROJECT_OVERVIEW.md
    ├── ARCHITECTURE_DIAGRAM.md
    └── IMPLEMENTATION_CHECKLIST.md
```

## 🚀 Quick Start

### Prerequisites

- Java 17+
- PostgreSQL 14+
- Redis 6+
- Maven 3.8+
- Flutter 3.6+

### Backend Setup (5 minutes)

```bash
# Install dependencies (macOS)
brew install postgresql@14 redis maven

# Start services
brew services start postgresql@14
brew services start redis

# Create database
createdb hotelbooker

# Run backend
cd backend
mvn spring-boot:run
```

Backend will be available at: `http://localhost:8080/api/v1`

### Flutter Setup

```bash
cd flutter
flutter pub get
flutter run
```

## 📚 Documentation

### Getting Started
- **[QUICK_START.md](QUICK_START.md)** - Get started in 5 minutes
- **[backend/SETUP.md](backend/SETUP.md)** - Detailed setup guide

### Architecture & Design
- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Complete project overview
- **[ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md)** - Visual architecture diagrams

### Development
- **[IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)** - Track your progress
- **[backend/FLUTTER_INTEGRATION.md](backend/FLUTTER_INTEGRATION.md)** - Flutter integration guide
- **[WHAT_WE_BUILT.md](WHAT_WE_BUILT.md)** - Summary of what's implemented

### Backend Specific
- **[backend/README.md](backend/README.md)** - Backend documentation

## 🔌 API Endpoints

### Authentication
```
POST /api/v1/auth/register    # Register new user
POST /api/v1/auth/login       # Login user
```

### Hotels
```
POST /api/v1/hotels/search         # Search hotels
GET  /api/v1/hotels/{id}           # Get hotel details
GET  /api/v1/hotels/{id}/rooms     # Get available rooms
GET  /api/v1/hotels/featured       # Get featured hotels
GET  /api/v1/hotels/destinations   # Get popular destinations
```

### Bookings (Requires Authentication)
```
POST /api/v1/bookings              # Create booking
GET  /api/v1/bookings              # Get user bookings
GET  /api/v1/bookings/{id}         # Get booking details
GET  /api/v1/bookings/upcoming     # Get upcoming bookings
POST /api/v1/bookings/{id}/cancel  # Cancel booking
```

## 🧪 Testing

### Test with Postman (Recommended)

**Complete step-by-step guide**: [POSTMAN_TESTING_GUIDE.md](POSTMAN_TESTING_GUIDE.md)

Quick steps:
1. Create Postman collection
2. Set base URL: `http://localhost:8080/api/v1`
3. Test registration → login → search hotels → create booking
4. See guide for 15+ test cases with sample data

### Test with cURL

```bash
# Register a user
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Quick commands**: See [QUICK_TEST_COMMANDS.md](QUICK_TEST_COMMANDS.md)

## 🗄️ Database Schema

### Main Tables
- **users** - User accounts and authentication
- **hotels** - Hotel information
- **rooms** - Room types and availability
- **bookings** - Reservation records

## 🔒 Security

- JWT-based authentication
- Password encryption with BCrypt
- CORS configured for Flutter app
- Input validation on all endpoints
- SQL injection protection
- XSS protection

## 📊 Technology Stack

### Backend
- Spring Boot 3.2.0
- Spring Security
- Spring Data JPA
- PostgreSQL
- Redis
- JWT (JSON Web Tokens)
- Maven

### Frontend
- Flutter 3.6+
- Dio (HTTP client)
- Shared Preferences
- Google Fonts
- Sizer (Responsive design)

## 🎓 Learning Outcomes

This project demonstrates:
- RESTful API design
- JWT authentication
- Database design and relationships
- Modular architecture
- Clean code principles
- Full-stack integration
- Security best practices

## 📅 Development Timeline

- **Week 1**: Backend setup ✅ COMPLETE
- **Week 2**: Flutter integration (CURRENT)
- **Week 3**: Testing & polish
- **Week 4**: Additional features & deployment

## 💰 Hosting Cost Estimate

**Development**: Free (local)

**Production**: ~$30-50/month
- Backend hosting: $5-10/month
- PostgreSQL: $10-20/month
- Redis: $5-10/month
- Domain: $10/year

## 🚀 Deployment

### Backend
- Railway (Recommended)
- Heroku
- AWS EC2
- DigitalOcean

### Flutter
- Web: Firebase Hosting, Netlify
- Mobile: Google Play Store, Apple App Store

## 🤝 Contributing

This is an academic project. For questions or issues, refer to the documentation files.

## 📝 License

This project is for educational purposes.

## 👥 Team

Built for academic purposes as a hotel booking system inspired by Booking.com.

## 🎯 Project Status

| Component | Status |
|-----------|--------|
| Backend API | ✅ Complete |
| Authentication | ✅ Complete |
| Hotel Management | ✅ Complete |
| Booking System | ✅ Complete |
| Flutter Integration | 🔄 In Progress |
| Testing | ⏳ Pending |
| Deployment | ⏳ Pending |

## 📞 Support

For setup issues or questions:
1. Check the relevant documentation file
2. Review the troubleshooting section in `backend/SETUP.md`
3. Check the implementation checklist for progress tracking

## 🎉 Acknowledgments

- Inspired by Booking.com
- Built with Spring Boot and Flutter
- Uses industry-standard architecture patterns

---

**Ready to start?** Check out [QUICK_START.md](QUICK_START.md) to get up and running in 5 minutes!

**Need help?** All documentation is in the `/docs` folder and `backend/` directory.

**Track progress?** See [IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)

Good luck with your project! 🚀
