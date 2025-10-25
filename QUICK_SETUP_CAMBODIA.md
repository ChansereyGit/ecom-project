# Quick Setup - Cambodia Hotels & Bookings

## 🚀 5-Minute Setup

### Step 1: Add Cambodia Hotels (1 minute)

```bash
# Option A: Using the script (easiest)
./ADD_CAMBODIA_HOTELS.sh

# Option B: Using psql with root user (from your config)
psql -U root -d hotelbooker -f backend/CAMBODIA_HOTELS.sql

# Option C: Using psql interactive
psql -U root -d hotelbooker
\i backend/CAMBODIA_HOTELS.sql
\q

# Verify it worked:
psql -U root -d hotelbooker -c "SELECT COUNT(*) FROM hotels WHERE country='Cambodia';"
# Should show: 12
```

**⚠️ Got an error?** See `FIX_CAMBODIA_HOTELS_ERROR.md` for solutions.

### Step 2: Restart Backend (1 minute)

```bash
cd backend
./mvnw spring-boot:run
```

Wait for: `Started HotelBookingApplication`

### Step 3: Run Flutter App (1 minute)

```bash
cd flutter
flutter run
```

### Step 4: Test Everything (2 minutes)

#### Test 1: Search Cambodia Hotels
1. Login to app
2. Search "Siem Reap"
3. See 3 hotels

#### Test 2: Dynamic Pricing
1. Search with 1 room, 2 guests → Note price
2. Search with 2 rooms, 4 guests → See different price

#### Test 3: Make Booking
1. Select hotel
2. Book room
3. Complete payment (4242 4242 4242 4242)
4. See success

#### Test 4: View Bookings
1. Tap bookings icon (📖) in top right
2. See your booking in "Upcoming" tab
3. View details
4. Try cancel (optional)

## ✅ Verification Checklist

- [ ] Cambodia hotels appear in search
- [ ] Prices change with rooms/guests
- [ ] Can complete booking
- [ ] Booking appears in My Bookings
- [ ] Can view booking details
- [ ] Can cancel booking

## 🐛 Troubleshooting

### Hotels Not Showing?
```bash
# Check if data was inserted
psql -U postgres -d hotelbooker -c "SELECT COUNT(*) FROM hotels WHERE country='Cambodia';"
# Should show: 12
```

### Pricing Not Dynamic?
- Restart backend after code changes
- Check backend logs for errors

### Bookings Screen Not Working?
```bash
# Rebuild Flutter app
cd flutter
flutter clean
flutter pub get
flutter run
```

### Backend Errors?
```bash
# Check logs
cd backend
./mvnw clean install
./mvnw spring-boot:run
```

## 📍 Test Locations

Search these to see Cambodia hotels:
- **Siem Reap** - 3 hotels (temples area)
- **Phnom Penh** - 3 hotels (capital)
- **Preah Sihanouk** - 3 hotels (beaches)
- **Kampot** - 3 hotels (riverside)

## 💡 Quick Tips

1. **Dynamic Pricing Formula:**
   - Base price × Rooms × Room discount × Guest multiplier
   - 2+ rooms = 5% discount
   - 3+ guests = 10% increase

2. **Booking Status:**
   - CONFIRMED = Payment successful
   - PENDING = Processing
   - CANCELLED = User cancelled

3. **Date Validation:**
   - Can book today or future dates
   - Check-out must be after check-in

## 🎯 Demo Script (2 minutes)

```
1. "Let me show you our Cambodia hotels..."
   → Search "Siem Reap"
   
2. "Notice how pricing adjusts dynamically..."
   → Change rooms from 1 to 2
   → Show price difference
   
3. "Let's complete a booking..."
   → Select hotel → Book → Pay
   
4. "And here's the booking management..."
   → Open My Bookings
   → Show details
```

---

**Setup Time**: 5 minutes
**Demo Time**: 2 minutes
**Total**: 7 minutes

✅ You're ready to go!
