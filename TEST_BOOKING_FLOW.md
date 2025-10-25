# Test the Complete Booking Flow

## Quick Start Guide

### Prerequisites
1. Backend is running on `http://localhost:8080`
2. Database has mock data loaded
3. Flutter app is running
4. You have a test user account

### Step-by-Step Testing

## 1. Start the Backend

```bash
cd backend
./mvnw spring-boot:run
```

Wait for: `Started HotelBookerApplication in X seconds`

## 2. Load Mock Data (if not already loaded)

```bash
cd backend
psql -U postgres -d hotelbooker -f MOCK_DATA.sql
```

Or use your database client to run the SQL script.

## 3. Start Flutter App

```bash
cd flutter
flutter run
```

## 4. Test the Complete Flow

### A. Login
1. Open the app
2. Click "Login" or "Sign In"
3. Use test credentials:
   - Email: `john.doe@example.com`
   - Password: `password123`
4. ✅ Should login successfully

### B. Search for Hotels
1. On home screen, enter:
   - **Location**: `New York` (or any city in your mock data)
   - **Check-in**: Tomorrow's date
   - **Check-out**: 3 days from tomorrow
   - **Guests**: 2
   - **Rooms**: 1
2. Click **"Search"**
3. ✅ Should show list of hotels

### C. View Hotel Details
1. Click on any hotel card (e.g., "Grand Plaza Hotel")
2. ✅ Should navigate to hotel detail screen
3. ✅ Should show:
   - Hotel images in gallery
   - Hotel name and rating
   - Location and amenities
   - Description
   - Available rooms (if any)
   - Reviews section
   - Location map
4. Scroll through the page
5. ✅ Sticky "Book Now" bar should appear when scrolling

### D. Select a Room
1. Click **"Book Now"** button
2. ✅ Should navigate to room selection screen
3. ✅ Should show:
   - Hotel name in header
   - Booking summary (dates, guests)
   - List of available rooms
   - Price per night and total
4. Click on a room card to select it
5. ✅ Room should highlight with checkmark
6. ✅ Bottom summary should update with total price
7. Click **"Continue"** button

### E. Complete Checkout - Step 1: Guest Info
1. ✅ Should navigate to checkout screen
2. ✅ Progress indicator shows step 1 of 3
3. ✅ Guest information should be pre-filled from user profile
4. Fill in any missing fields:
   - First Name
   - Last Name
   - Email
   - Phone Number
   - Special Requests (optional)
5. Click **"Continue to Payment"**

### F. Complete Checkout - Step 2: Payment
1. ✅ Progress indicator shows step 2 of 3
2. Fill in payment details:
   - **Card Number**: `4111111111111111` (test card)
   - **Expiry**: `12/25`
   - **CVV**: `123`
   - **Cardholder Name**: Your name
3. ✅ Check "I accept the terms and conditions"
4. Click **"Review Booking"**

### G. Complete Checkout - Step 3: Confirmation
1. ✅ Progress indicator shows step 3 of 3
2. ✅ Should show review screen with:
   - Guest information summary
   - Payment method summary
   - Important information
3. Review all details
4. Click **"Complete Booking"**
5. ✅ Should show loading indicator
6. ✅ After 2-3 seconds, success dialog appears

### H. Booking Confirmed
1. ✅ Success dialog shows:
   - Green checkmark icon
   - "Booking Confirmed!" message
   - Confirmation email message
   - Booking reference number (e.g., HB123456789)
2. Click **"Done"** or **"View Bookings"**
3. ✅ Should return to home screen

## 5. Verify in Database

```sql
-- Check the booking was created
SELECT * FROM bookings 
ORDER BY created_at DESC 
LIMIT 1;

-- Should show your booking with:
-- - hotel_id
-- - room_id
-- - guest details
-- - dates
-- - status: CONFIRMED
```

## 6. Test Error Scenarios

### A. Network Error
1. Stop the backend server
2. Try to search for hotels
3. ✅ Should show error toast: "Network error. Please check your connection."

### B. Invalid Data
1. Start backend again
2. Go to checkout
3. Leave required fields empty
4. Try to continue
5. ✅ Should show validation errors

### C. Booking Failure
1. Modify backend to return error (optional)
2. Complete checkout
3. ✅ Should show error dialog with retry option

## Expected Results Checklist

- [ ] Can search for hotels successfully
- [ ] Hotel list displays with images and info
- [ ] Can click on hotel to view details
- [ ] Hotel detail page loads completely
- [ ] Available rooms are displayed
- [ ] Can select a room
- [ ] Room selection shows correct pricing
- [ ] Checkout form pre-fills user data
- [ ] Can complete all 3 checkout steps
- [ ] Booking submits to backend successfully
- [ ] Success dialog shows booking reference
- [ ] Booking appears in database
- [ ] Can navigate back to home
- [ ] Error handling works correctly

## Common Issues & Solutions

### Issue: No hotels found
**Solution**: 
- Check backend is running
- Verify mock data is loaded
- Check search location matches data in database
- Look at backend logs for errors

### Issue: No rooms displayed
**Solution**:
- Check `GET /api/hotels/{id}/rooms` endpoint
- Verify rooms exist for the hotel in database
- Check backend logs for errors

### Issue: Booking fails
**Solution**:
- Check user is logged in (JWT token valid)
- Verify all required fields are filled
- Check backend logs for validation errors
- Ensure database constraints are met

### Issue: App crashes on navigation
**Solution**:
- Check Flutter console for errors
- Verify all required arguments are passed
- Run `flutter clean && flutter pub get`
- Restart the app

## API Endpoints to Monitor

While testing, you can monitor these API calls in backend logs:

```
POST /api/hotels/search          → Search hotels
GET  /api/hotels/{id}            → Get hotel details
GET  /api/hotels/{id}/rooms      → Get available rooms
POST /api/bookings               → Create booking
GET  /api/bookings               → Get user bookings
```

## Backend Logs to Watch

```bash
# In backend directory
tail -f logs/application.log

# Look for:
# - Incoming requests
# - SQL queries
# - Response status codes
# - Any errors or exceptions
```

## Database Queries for Verification

```sql
-- Check hotels
SELECT id, name, city FROM hotels;

-- Check rooms for a hotel
SELECT id, room_type, price_per_night, available_rooms 
FROM rooms 
WHERE hotel_id = 1;

-- Check bookings
SELECT id, hotel_name, room_type, check_in_date, check_out_date, status 
FROM bookings 
ORDER BY created_at DESC;

-- Check user
SELECT id, name, email FROM users WHERE email = 'john.doe@example.com';
```

## Performance Testing

### Load Time Expectations
- Hotel search: < 1 second
- Hotel detail load: < 500ms
- Room list load: < 500ms
- Booking submission: < 2 seconds

### Memory Usage
- App should not exceed 200MB RAM
- No memory leaks on navigation
- Images should load progressively

## Next Steps After Testing

1. **If everything works:**
   - ✅ Booking flow is complete!
   - Test with different scenarios
   - Try different hotels and rooms
   - Test with multiple users

2. **If issues found:**
   - Check the error messages
   - Review backend logs
   - Verify database state
   - Check Flutter console
   - Refer to troubleshooting guide

3. **Enhancements to consider:**
   - Add booking history screen
   - Implement booking cancellation
   - Add payment gateway integration
   - Improve error messages
   - Add loading skeletons
   - Implement caching

## Support Resources

- **Backend API Docs**: Check Swagger UI at `http://localhost:8080/swagger-ui.html`
- **Database Schema**: See `backend/src/main/resources/schema.sql`
- **Mock Data**: See `backend/MOCK_DATA.sql`
- **Implementation Guide**: See `COMPLETE_BOOKING_FLOW_IMPLEMENTATION.md`
- **Flow Diagram**: See `BOOKING_FLOW_DIAGRAM.md`

## Success Criteria

✅ **The booking flow is working correctly if:**
1. User can search and find hotels
2. User can view hotel details and rooms
3. User can select a room
4. User can complete checkout process
5. Booking is created in database
6. User receives confirmation
7. All error scenarios are handled gracefully

Congratulations! You now have a fully functional hotel booking system! 🎉
