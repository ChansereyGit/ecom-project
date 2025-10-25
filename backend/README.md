# Hotel Booking System - Backend

Spring Boot backend for the Hotel Booking Flutter application.

## Architecture

This project uses **Modular Monolith** architecture with clear module boundaries:

```
backend/
├── auth/           # Authentication & User Management
├── hotel/          # Hotel & Room Management
├── booking/        # Booking Management
├── common/         # Shared utilities & DTOs
└── config/         # Application configuration
```

## Tech Stack

- **Java 17**
- **Spring Boot 3.2.0**
- **PostgreSQL** - Main database
- **Redis** - Caching
- **JWT** - Authentication
- **Maven** - Build tool

## Prerequisites

- Java 17 or higher
- PostgreSQL 14+
- Redis 6+
- Maven 3.8+

## Setup Instructions

### 1. Install PostgreSQL

```bash
# macOS
brew install postgresql@14
brew services start postgresql@14

# Create database
createdb hotelbooker
```

### 2. Install Redis

```bash
# macOS
brew install redis
brew services start redis
```

### 3. Configure Application

Update `src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/hotelbooker
    username: your_username
    password: your_password
```

### 4. Run the Application

```bash
# Using Maven
mvn spring-boot:run

# Or build and run JAR
mvn clean package
java -jar target/hotel-booking-system-1.0.0.jar
```

The API will be available at: `http://localhost:8080/api/v1`

## API Endpoints

### Authentication
```
POST /api/v1/auth/register    - Register new user
POST /api/v1/auth/login       - Login user
```

### Hotels
```
POST /api/v1/hotels/search         - Search hotels
GET  /api/v1/hotels/{id}           - Get hotel details
GET  /api/v1/hotels/{id}/rooms     - Get hotel rooms
GET  /api/v1/hotels/featured       - Get featured hotels
GET  /api/v1/hotels/destinations   - Get popular destinations
```

### Bookings (Requires Authentication)
```
POST /api/v1/bookings                    - Create booking
GET  /api/v1/bookings                    - Get user bookings
GET  /api/v1/bookings/{id}               - Get booking details
GET  /api/v1/bookings/upcoming           - Get upcoming bookings
POST /api/v1/bookings/{id}/cancel        - Cancel booking
```

## Testing with Flutter

1. Make sure backend is running on `http://localhost:8080`
2. Update Flutter app's API base URL to match
3. Test authentication flow first
4. Then test hotel search and booking

## Sample Data

To add sample hotels for testing, you can use the following SQL:

```sql
INSERT INTO hotels (id, name, description, address, city, country, price_per_night, star_rating, guest_rating, featured, available, created_at, updated_at)
VALUES 
('550e8400-e29b-41d4-a716-446655440000', 'Grand Hotel', 'Luxury hotel in city center', '123 Main St', 'New York', 'USA', 150.00, 5, 4.5, true, true, NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440001', 'Beach Resort', 'Beautiful beachfront resort', '456 Beach Rd', 'Miami', 'USA', 200.00, 4, 4.7, true, true, NOW(), NOW());
```

## Development Tips

1. **Hot Reload**: Use Spring Boot DevTools for automatic restart
2. **Database**: Use H2 for quick testing (change in application.yml)
3. **Logging**: Check logs in console for debugging
4. **API Testing**: Use Postman or curl to test endpoints

## Module Structure

### Auth Module
- User registration and login
- JWT token generation
- Password encryption
- User profile management

### Hotel Module
- Hotel search with filters
- Hotel details
- Room availability
- Featured hotels

### Booking Module
- Create bookings
- View bookings
- Cancel bookings
- Booking validation

## Security

- JWT-based authentication
- Password encryption with BCrypt
- CORS configured for Flutter app
- Role-based access control

## Next Steps

1. ✅ Auth module - DONE
2. ✅ Hotel module - DONE
3. ✅ Booking module - DONE
4. 🔄 Payment integration (Stripe/PayPal)
5. 🔄 Review system
6. 🔄 Email notifications
7. 🔄 Admin panel

## Troubleshooting

### Database Connection Error
```bash
# Check PostgreSQL is running
brew services list

# Restart if needed
brew services restart postgresql@14
```

### Redis Connection Error
```bash
# Check Redis is running
brew services list

# Restart if needed
brew services restart redis
```

### Port Already in Use
```bash
# Change port in application.yml
server:
  port: 8081
```

## Support

For issues or questions, check the Flutter app documentation in `/flutter/docs/`
