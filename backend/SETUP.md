# Quick Setup Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies

```bash
# macOS
brew install postgresql@14 redis maven

# Start services
brew services start postgresql@14
brew services start redis
```

### Step 2: Create Database

```bash
# Create database
createdb hotelbooker

# Or using psql
psql postgres
CREATE DATABASE hotelbooker;
\q
```

### Step 3: Run the Application

```bash
cd backend
mvn spring-boot:run
```

You should see:
```
Started HotelBookingApplication in X seconds
```

### Step 4: Test the API

```bash
# Test health
curl http://localhost:8080/api/v1/auth/login

# Should return 401 (expected - no credentials)
```

### Step 5: Connect Flutter App

1. Open your Flutter project
2. Update API base URL to `http://localhost:8080/api/v1`
3. Run the Flutter app
4. Try registering a new user!

## 🎯 Quick Test

### Register a User

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Login

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

You'll get a response with `accessToken` - use this for authenticated requests!

## 📁 Project Structure

```
backend/
├── src/main/java/com/hotelbooker/
│   ├── HotelBookingApplication.java    # Main application
│   ├── auth/                           # 🔐 Auth Module
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   ├── dto/
│   │   └── security/
│   ├── hotel/                          # 🏨 Hotel Module
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   └── dto/
│   ├── booking/                        # 📅 Booking Module
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   └── dto/
│   ├── common/                         # 🔧 Common Utilities
│   │   ├── dto/
│   │   ├── entity/
│   │   └── exception/
│   └── config/                         # ⚙️ Configuration
│       ├── SecurityConfig.java
│       └── CorsConfig.java
├── src/main/resources/
│   ├── application.yml                 # Main config
│   └── application-dev.yml             # Dev config
├── pom.xml                             # Maven dependencies
└── README.md                           # Documentation
```

## 🔑 Key Features

### ✅ Implemented
- User registration & login
- JWT authentication
- Hotel search with filters
- Hotel details & rooms
- Booking creation & management
- Booking cancellation
- CORS configured for Flutter

### 🔄 Coming Soon
- Payment integration
- Reviews & ratings
- Email notifications
- Admin panel

## 🐛 Troubleshooting

### "Connection refused" error
```bash
# Check if PostgreSQL is running
brew services list

# If not running
brew services start postgresql@14
```

### "Port 8080 already in use"
```bash
# Find and kill the process
lsof -ti:8080 | xargs kill -9

# Or change port in application.yml
server:
  port: 8081
```

### "Redis connection failed"
```bash
# Start Redis
brew services start redis

# Test Redis
redis-cli ping
# Should return: PONG
```

## 📱 Flutter Integration

See `FLUTTER_INTEGRATION.md` for detailed Flutter integration guide.

Quick checklist:
- [ ] Backend running on port 8080
- [ ] Can register a user via API
- [ ] Can login via API
- [ ] Flutter app API service configured
- [ ] Test login from Flutter app

## 🎓 Learning Resources

- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [JWT Authentication](https://jwt.io/)
- [PostgreSQL Tutorial](https://www.postgresql.org/docs/)

## 💡 Tips

1. **Use Postman** - Import the API endpoints for easy testing
2. **Check logs** - All errors are logged in the console
3. **Database GUI** - Use pgAdmin or DBeaver to view data
4. **Hot reload** - Code changes auto-restart the app

## 🎯 Next Steps

1. ✅ Backend is running
2. 📱 Integrate with Flutter app
3. 🧪 Test authentication flow
4. 🏨 Test hotel search
5. 📅 Test booking flow
6. 🚀 Deploy to production

Good luck with your project! 🎉
