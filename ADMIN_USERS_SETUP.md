# ✅ Admin Users Setup - Fixed!

## Problem
The login was failing because the admin users (`admin@hotel.com` and `user@hotel.com`) didn't exist in the database.

## Solution
I've created an automatic user initializer that creates these users when the Spring Boot application starts.

## What Was Added

### 1. AdminUserInitializer.java
A Spring Boot component that automatically creates admin users on startup:
- **Admin User**: `admin@hotel.com` / `admin123` (Role: ADMIN)
- **Regular User**: `user@hotel.com` / `user123` (Role: USER)

### 2. CREATE_ADMIN_USERS.sql
A manual SQL script if you prefer to create users via database directly.

## How It Works

When you start Spring Boot, the `AdminUserInitializer` will:
1. Check if `admin@hotel.com` exists
2. If not, create it with BCrypt hashed password
3. Check if `user@hotel.com` exists
4. If not, create it with BCrypt hashed password
5. Log the results to console

## Restart Spring Boot

```bash
# Stop your current Spring Boot server (Ctrl+C)

# Restart it
cd backend
mvn spring-boot:run
```

You should see in the logs:
```
✅ Created admin user: admin@hotel.com
   Password: admin123
✅ Created regular user: user@hotel.com
   Password: user123
```

Or if they already exist:
```
ℹ️  Admin user already exists: admin@hotel.com
ℹ️  Regular user already exists: user@hotel.com
```

## Test Login

### Option 1: React Admin Portal
```bash
# Open browser
http://localhost:5173/login

# Login as Admin
Email: admin@hotel.com
Password: admin123
Role: ADMIN
```

### Option 2: Direct API Test
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@hotel.com",
    "password": "admin123"
  }'
```

Expected response:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "...",
      "fullName": "Admin User",
      "email": "admin@hotel.com",
      "role": "ADMIN",
      "emailVerified": true
    }
  }
}
```

## Manual SQL Method (Alternative)

If you prefer to create users manually via SQL:

```bash
# Connect to your PostgreSQL database
psql -U your_username -d hotel_booking

# Run the SQL script
\i backend/CREATE_ADMIN_USERS.sql
```

## User Credentials

### Admin Account
- **Email**: `admin@hotel.com`
- **Password**: `admin123`
- **Role**: `ADMIN`
- **Permissions**: Full access to all features

### User Account
- **Email**: `user@hotel.com`
- **Password**: `user123`
- **Role**: `USER`
- **Permissions**: Limited access (view only)

## Security Notes

### Development
These credentials are fine for development and testing.

### Production
**⚠️ IMPORTANT**: Before deploying to production:
1. Change these default passwords
2. Use strong passwords
3. Consider using environment variables
4. Enable 2FA if possible
5. Remove or disable the `AdminUserInitializer` component

To disable auto-creation in production:
```java
@Component
@Profile("!prod") // Only run in non-production environments
@RequiredArgsConstructor
@Slf4j
public class AdminUserInitializer implements CommandLineRunner {
    // ...
}
```

## Troubleshooting

### Still Can't Login?

1. **Check if users were created**:
```sql
SELECT id, full_name, email, role, email_verified 
FROM users 
WHERE email IN ('admin@hotel.com', 'user@hotel.com');
```

2. **Check Spring Boot logs**:
Look for the ✅ or ℹ️ messages about user creation

3. **Verify password encoding**:
The password should be BCrypt hashed, starting with `$2a$`

4. **Check role matches**:
Make sure you select the correct role in the login form

### Database Connection Issues?

Check `application-dev.yml`:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/hotel_booking
    username: your_username
    password: your_password
```

## Summary

✅ **Admin users will be automatically created on Spring Boot startup**
✅ **No manual database work needed**
✅ **Passwords are properly BCrypt hashed**
✅ **Ready to login to React admin portal**

**Just restart Spring Boot and you're good to go!** 🚀
