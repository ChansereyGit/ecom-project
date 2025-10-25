# Test Hotel Status Feature

## Quick Test Steps

### 1. Apply Database Migration

```bash
# Connect to your PostgreSQL database
psql -U postgres -d hotel_booker

# Run the migration
\i backend/ADD_HOTEL_STATUS.sql

# Or copy-paste the SQL commands from ADD_HOTEL_STATUS.sql
```

### 2. Start Backend

```bash
cd backend
./mvnw spring-boot:run
```

Wait for the message: "Started HotelBookerApplication"

### 3. Start Admin Portal

```bash
cd admin-portal
npm run dev
```

Open browser at: http://localhost:5174

### 4. Test Status Feature

1. **Login** with admin credentials:
   - Email: `admin@hotel.com`
   - Password: `admin123`

2. **Navigate to Properties**:
   - Click "Properties" in the sidebar

3. **View Status Badges**:
   - Look at the property list on the left
   - Each hotel should show a status badge:
     - 🟢 Green "Active" badge
     - 🟠 Orange "Maintenance" badge  
     - 🔴 Red "Inactive" badge

4. **Edit Hotel Status**:
   - Select a hotel from the list
   - Click the "Edit" button (top right)
   - Go to "General Info" tab
   - Find "Property Status" dropdown (below Currency)
   - Change the status (Active → Maintenance → Inactive)
   - Click "Save Changes"

5. **Verify Changes**:
   - Check that the status badge in the property list updates
   - Refresh the page to ensure it persists
   - Try changing status for multiple hotels

### 5. Test API Directly (Optional)

```bash
# Get all hotels (should include status field)
curl http://localhost:8080/api/hotels

# Update hotel status
curl -X PUT http://localhost:8080/api/hotels/{hotelId} \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Test Hotel",
    "status": "MAINTENANCE",
    ...other fields...
  }'
```

## Expected Results

✅ Status dropdown appears in General Info tab  
✅ Status badges show correct colors in property list  
✅ Status changes persist after save  
✅ Status is included in API responses  
✅ Database has status column with valid values  

## Troubleshooting

**Issue**: Status dropdown not showing
- Solution: Clear browser cache and refresh

**Issue**: Status not saving
- Solution: Check browser console for errors
- Verify JWT token is valid
- Check backend logs

**Issue**: Database error
- Solution: Make sure migration ran successfully
- Check if status column exists: `\d hotels` in psql

**Issue**: Status badge not updating
- Solution: Refresh the page
- Check if onUpdate callback is working
