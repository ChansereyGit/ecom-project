# Calendar Troubleshooting Guide

## Error: "Failed to load calendar data"

This error occurs when the frontend can't load rooms or bookings from the backend. Here's how to fix it:

### Step 1: Check if Room Instances Exist

The most common issue is that room instances haven't been created yet.

```bash
# Connect to database
psql -U postgres -d hotel_booker

# Check if room_instances table exists
\dt room_instances

# Check if any room instances exist
SELECT COUNT(*) FROM room_instances;

# If count is 0, you need to create room instances
```

### Step 2: Create Room Instances

**Option A: Quick Setup (Recommended)**
```bash
# This creates 10 room instances per room type
psql -U postgres -d hotel_booker -f backend/CREATE_TEST_ROOM_INSTANCES.sql
```

**Option B: Manual Creation**
```sql
-- Get your room type IDs
SELECT r.id, r.room_type, h.name as hotel_name 
FROM rooms r 
JOIN hotels h ON r.hotel_id = h.id;

-- Create room instances for a specific room type
-- Replace 'YOUR_ROOM_TYPE_ID' with actual ID from above query
INSERT INTO room_instances (id, room_type_id, room_number, floor, status) VALUES
(gen_random_uuid()::text, 'YOUR_ROOM_TYPE_ID', '101', 1, 'AVAILABLE'),
(gen_random_uuid()::text, 'YOUR_ROOM_TYPE_ID', '102', 1, 'AVAILABLE'),
(gen_random_uuid()::text, 'YOUR_ROOM_TYPE_ID', '103', 1, 'AVAILABLE'),
(gen_random_uuid()::text, 'YOUR_ROOM_TYPE_ID', '201', 2, 'AVAILABLE'),
(gen_random_uuid()::text, 'YOUR_ROOM_TYPE_ID', '202', 2, 'AVAILABLE');
```

### Step 3: Verify Room Instances

```sql
-- Check room instances
SELECT 
    ri.room_number,
    ri.floor,
    ri.status,
    r.room_type,
    h.name as hotel_name
FROM room_instances ri
JOIN rooms r ON ri.room_type_id = r.id
JOIN hotels h ON r.hotel_id = h.id
ORDER BY h.name, ri.floor, ri.room_number;
```

### Step 4: Check Backend is Running

```bash
# Check if backend is running
curl http://localhost:8080/api/v1/hotels

# Should return JSON with hotels list
```

### Step 5: Test Calendar API Directly

```bash
# Get a hotel ID first
curl http://localhost:8080/api/v1/hotels

# Test calendar rooms endpoint (replace HOTEL_ID)
curl http://localhost:8080/api/v1/calendar/rooms?hotelId=HOTEL_ID

# Should return room instances
```

### Step 6: Check Browser Console

1. Open browser DevTools (F12)
2. Go to Console tab
3. Look for error messages
4. Check Network tab for failed requests

Common errors:
- **404 Not Found**: Endpoint doesn't exist (backend not updated)
- **500 Internal Server Error**: Backend error (check backend logs)
- **401 Unauthorized**: JWT token expired (re-login)
- **CORS Error**: Backend CORS not configured

### Step 7: Check Backend Logs

```bash
# If running with mvnw
# Look for errors in terminal output

# Common issues:
# - Table doesn't exist: Run CREATE_ROOM_INSTANCES.sql
# - Foreign key constraint: Room type doesn't exist
# - Null pointer: Room instance has no room type
```

## Quick Fix Commands

### 1. Reset and Recreate Everything

```bash
# 1. Drop and recreate room_instances table
psql -U postgres -d hotel_booker << EOF
DROP TABLE IF EXISTS room_instances CASCADE;
EOF

# 2. Run migration
psql -U postgres -d hotel_booker -f backend/CREATE_ROOM_INSTANCES.sql

# 3. Create test data
psql -U postgres -d hotel_booker -f backend/CREATE_TEST_ROOM_INSTANCES.sql

# 4. Restart backend
cd backend
./mvnw spring-boot:run
```

### 2. Verify Setup

```bash
# Check room instances count
psql -U postgres -d hotel_booker -c "SELECT COUNT(*) FROM room_instances;"

# Should show a number > 0
```

### 3. Test API

```bash
# Get hotels
curl http://localhost:8080/api/v1/hotels | jq

# Get rooms for first hotel (replace ID)
curl "http://localhost:8080/api/v1/calendar/rooms?hotelId=YOUR_HOTEL_ID" | jq
```

## Common Issues and Solutions

### Issue 1: "No room instances found"
**Cause**: Room instances table is empty
**Solution**: Run `CREATE_TEST_ROOM_INSTANCES.sql`

### Issue 2: "404 Not Found on /calendar/rooms"
**Cause**: Backend not updated or not running
**Solution**: 
- Restart backend
- Check CalendarController exists
- Verify endpoint mapping

### Issue 3: "500 Internal Server Error"
**Cause**: Database constraint violation or null pointer
**Solution**:
- Check backend logs
- Verify room_type_id exists in rooms table
- Ensure foreign keys are valid

### Issue 4: "CORS Error"
**Cause**: Backend CORS not allowing frontend origin
**Solution**: Check WebConfig.java has correct CORS settings

### Issue 5: "JWT token expired"
**Cause**: Authentication token expired
**Solution**: Logout and login again

### Issue 6: "Cannot read property 'map' of undefined"
**Cause**: API response doesn't have expected structure
**Solution**: Check API response format matches frontend expectations

## Debug Checklist

- [ ] Room instances table exists
- [ ] Room instances have been created
- [ ] Backend is running on port 8080
- [ ] Frontend is running on port 5174
- [ ] JWT token is valid (logged in)
- [ ] Browser console shows no errors
- [ ] Network tab shows successful API calls
- [ ] Backend logs show no errors
- [ ] Database has hotels and room types
- [ ] Room instances are linked to valid room types

## Still Having Issues?

1. **Check all files are saved**
2. **Restart both backend and frontend**
3. **Clear browser cache**
4. **Check database connection**
5. **Verify all migrations ran successfully**

## Test Data Script

If you need to start fresh with test data:

```sql
-- Clear existing data
TRUNCATE room_instances CASCADE;

-- Create test room instances
-- Run CREATE_TEST_ROOM_INSTANCES.sql
```

## Success Indicators

When everything is working:
- ✅ Calendar page loads without errors
- ✅ Hotel dropdown shows hotels
- ✅ Room list shows room numbers (101, 102, etc.)
- ✅ Calendar grid displays
- ✅ Can click cells to create bookings
- ✅ No errors in browser console
- ✅ No errors in backend logs

## Need More Help?

Check these files:
- `CALENDAR_IMPLEMENTATION_COMPLETE.md` - Backend setup
- `CALENDAR_FRONTEND_INTEGRATION_COMPLETE.md` - Frontend setup
- `CREATE_ROOM_INSTANCES.sql` - Database migration
- `CREATE_TEST_ROOM_INSTANCES.sql` - Test data creation
