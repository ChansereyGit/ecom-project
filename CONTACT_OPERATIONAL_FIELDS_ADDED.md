# ✅ Contact & Operational Fields Added

## Overview

I've added contact information and operational settings to the hotel creation form. These fields are **optional** and won't break your Flutter mobile app.

## New Fields Added

### Contact Information
- **Phone Number** - Hotel contact phone
- **Email** - Hotel contact email
- **Website** - Hotel website URL

### Operational Settings
- **Check-in Time** - Default: 15:00
- **Check-out Time** - Default: 11:00

## Database Changes

### New Columns in `hotels` Table:
```sql
phone_number VARCHAR(50)      -- Optional
email VARCHAR(255)            -- Optional
website VARCHAR(500)          -- Optional
check_in_time VARCHAR(10)     -- Optional, e.g., "15:00"
check_out_time VARCHAR(10)    -- Optional, e.g., "11:00"
```

## Why Flutter App Won't Break

### 1. Fields are Optional
All new fields are nullable in the database. Existing hotels without these fields will work fine.

### 2. Flutter Model Unchanged
Your Flutter `Hotel` model doesn't include these fields, so they're simply ignored:

```dart
// Flutter Hotel model (unchanged)
class Hotel {
  final String id;
  final String name;
  final String description;
  // ... other fields
  // NO phone_number, email, website, check_in_time, check_out_time
}
```

### 3. JSON Parsing is Flexible
When Flutter receives hotel data with extra fields, it ignores them:

```json
{
  "id": "123",
  "name": "Hotel Name",
  "phoneNumber": "+855 12 345 678",  // ← Ignored by Flutter
  "email": "info@hotel.com",         // ← Ignored by Flutter
  "checkInTime": "15:00"             // ← Ignored by Flutter
}
```

## Files Updated

### Backend
1. **Hotel.java** - Added 5 new fields
2. **HotelDto.java** - Added 5 new fields
3. **HotelService.java** - Updated create/update/map methods
4. **ADD_CONTACT_OPERATIONAL_FIELDS.sql** - Database migration

### Frontend (React Admin)
1. **CreatePropertyModal.jsx** - Added form fields
2. **Form state** - Added to formData
3. **API call** - Sends new fields to backend

## How to Apply Changes

### 1. Run Database Migration
```bash
# Connect to PostgreSQL
psql -U your_username -d hotel_booking

# Run migration
\i backend/ADD_CONTACT_OPERATIONAL_FIELDS.sql
```

### 2. Restart Spring Boot
```bash
cd backend
mvn spring-boot:run
```

### 3. Test React Admin
```bash
cd admin-portal
npm run dev

# Open browser
http://localhost:5174/property-management
```

## Testing

### Create Hotel with Contact Info
1. Click "+ Add New"
2. Fill in basic info
3. Fill in contact info:
   - Phone: +855 12 345 678
   - Email: info@hotel.com
   - Website: https://www.hotel.com
4. Set operational times:
   - Check-in: 15:00
   - Check-out: 11:00
5. Click "Create Property"

### Verify in Database
```sql
SELECT 
  name, 
  phone_number, 
  email, 
  website, 
  check_in_time, 
  check_out_time 
FROM hotels 
ORDER BY created_at DESC 
LIMIT 1;
```

### Verify Flutter App Still Works
1. Open Flutter app
2. Search for hotels
3. View hotel details
4. App should work normally (extra fields are ignored)

## API Response Example

### Before (Old Hotels)
```json
{
  "id": "123",
  "name": "Old Hotel",
  "city": "Phnom Penh",
  "phoneNumber": null,
  "email": null,
  "website": null,
  "checkInTime": null,
  "checkOutTime": null
}
```

### After (New Hotels)
```json
{
  "id": "456",
  "name": "New Hotel",
  "city": "Phnom Penh",
  "phoneNumber": "+855 12 345 678",
  "email": "info@newhotel.com",
  "website": "https://www.newhotel.com",
  "checkInTime": "15:00",
  "checkOutTime": "11:00"
}
```

## Backward Compatibility

### ✅ Existing Hotels
- Old hotels without contact info: **Still work**
- Database queries: **Still work**
- Flutter app: **Still works**
- Mobile search: **Still works**

### ✅ New Hotels
- Can include contact info: **Optional**
- Can skip contact info: **Still works**
- Flutter ignores extra fields: **No crash**

## Future Enhancements

### Option 1: Add to Flutter (Later)
If you want to show contact info in Flutter:

```dart
class Hotel {
  // ... existing fields
  final String? phoneNumber;
  final String? email;
  final String? website;
  final String? checkInTime;
  final String? checkOutTime;
  
  Hotel({
    // ... existing params
    this.phoneNumber,
    this.email,
    this.website,
    this.checkInTime,
    this.checkOutTime,
  });
  
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      // ... existing fields
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      website: json['website'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
    );
  }
}
```

### Option 2: Keep Separate (Current)
- Admin portal has full details
- Mobile app shows essential info only
- Both work independently

## Security Notes

### Email Validation
The form validates email format in the frontend. Backend accepts any string.

### Phone Number Format
No strict validation. Accepts international formats like:
- +855 12 345 678
- +1 (555) 123-4567
- 012-345-678

### Website URL
Accepts any valid URL format:
- https://www.hotel.com
- http://hotel.com
- www.hotel.com

## Summary

✅ **Contact & operational fields added**
✅ **All fields are optional**
✅ **Flutter app won't break**
✅ **Backward compatible**
✅ **Database migration provided**
✅ **Ready to use**

**Your admin portal now has more complete hotel information, and your mobile app continues to work perfectly!** 🎉
