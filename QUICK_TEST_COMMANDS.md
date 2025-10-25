# 🚀 Quick Test Commands

## Database Setup

```bash
# Create database (if not exists)
createdb hotelbooker

# Or using psql
psql -U root
CREATE DATABASE hotelbooker;
\q
```

## Start Backend

```bash
cd backend
mvn spring-boot:run
```

**Wait for:** `Started HotelBookingApplication in X seconds`

---

## Quick cURL Tests

### 1. Register User
```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "phoneNumber": "+1234567890"
  }'
```

### 2. Login User
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

**Save the token from response!**

### 3. Search Hotels
```bash
curl -X POST http://localhost:8080/api/v1/hotels/search \
  -H "Content-Type: application/json" \
  -d '{
    "location": "New York"
  }'
```

### 4. Create Booking (Replace YOUR_TOKEN)
```bash
curl -X POST http://localhost:8080/api/v1/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "hotelId": "550e8400-e29b-41d4-a716-446655440001",
    "roomId": "660e8400-e29b-41d4-a716-446655440001",
    "checkInDate": "2024-12-20",
    "checkOutDate": "2024-12-25",
    "numberOfGuests": 2,
    "numberOfRooms": 1,
    "guestName": "John Doe",
    "guestEmail": "john@example.com",
    "guestPhone": "+1234567890"
  }'
```

---

## Sample Data SQL

Run this in your PostgreSQL client:

```sql
-- Insert sample hotels
INSERT INTO hotels (id, name, description, address, city, country, 
                    price_per_night, star_rating, guest_rating, 
                    featured, available, created_at, updated_at)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 
 'Grand Plaza Hotel', 
 'Luxury 5-star hotel in the heart of the city', 
 '123 Main Street', 
 'New York', 
 'USA', 
 250.00, 5, 4.8, true, true, NOW(), NOW()),
 
('550e8400-e29b-41d4-a716-446655440002', 
 'Seaside Resort', 
 'Beautiful beachfront resort', 
 '456 Ocean Drive', 
 'Miami', 
 'USA', 
 180.00, 4, 4.5, true, true, NOW(), NOW());

-- Insert amenities
INSERT INTO hotel_amenities (hotel_id, amenity)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440001', 'Pool'),
('550e8400-e29b-41d4-a716-446655440001', 'Gym');

-- Insert rooms
INSERT INTO rooms (id, hotel_id, room_type, description, price_per_night, 
                   max_guests, total_rooms, available_rooms, size, 
                   bed_type, has_breakfast, free_cancellation, 
                   created_at, updated_at)
VALUES 
('660e8400-e29b-41d4-a716-446655440001',
 '550e8400-e29b-41d4-a716-446655440001',
 'Deluxe King Room',
 'Spacious room with city view',
 250.00, 2, 10, 10, 35.0, 'King', true, true, NOW(), NOW());
```

---

## Postman Quick Setup

1. **Create Collection**: "Hotel Booking API"
2. **Add Variable**: 
   - `baseUrl` = `http://localhost:8080/api/v1`
   - `authToken` = (paste token after login)
3. **Import requests** from `POSTMAN_TESTING_GUIDE.md`

---

## Test Checklist

- [ ] Backend running on port 8080
- [ ] Database `hotelbooker` created
- [ ] Can register user
- [ ] Can login user
- [ ] Sample data inserted
- [ ] Can search hotels
- [ ] Can get hotel details
- [ ] Can create booking (with token)
- [ ] Can view bookings (with token)

---

## Troubleshooting

### Backend won't start
```bash
# Check if port 8080 is in use
lsof -ti:8080 | xargs kill -9

# Check PostgreSQL
brew services list
brew services start postgresql@14
```

### Database connection error
- Check username: `root`
- Check password: `Admin`
- Check database exists: `hotelbooker`

### 401 Unauthorized
- Token expired (24 hours)
- Login again to get new token
- Make sure to include `Bearer ` prefix

---

## Quick Reference

| Endpoint | Method | Auth Required |
|----------|--------|---------------|
| `/auth/register` | POST | No |
| `/auth/login` | POST | No |
| `/hotels/search` | POST | No |
| `/hotels/{id}` | GET | No |
| `/hotels/{id}/rooms` | GET | No |
| `/bookings` | POST | Yes |
| `/bookings` | GET | Yes |
| `/bookings/{id}/cancel` | POST | Yes |

---

**Full Guide**: See `POSTMAN_TESTING_GUIDE.md` for detailed step-by-step instructions.
