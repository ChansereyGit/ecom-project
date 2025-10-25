# Complete Property Management System

## Overview
Full-featured hotel and room management system with CRUD operations, status tracking, and real-time updates.

## Features Summary

### ✅ Hotel Management (General Info)
- **Create**: Add new hotels with full details
- **Read**: View hotel information across tabs
- **Update**: Edit all hotel fields including status
- **Delete**: Remove hotels with confirmation
- **Status**: Active, Maintenance, Inactive with color-coded badges

### ✅ Room Management (Room Types)
- **Create**: Add room types with amenities and images
- **Read**: View rooms in card layout with details
- **Update**: Edit room details, pricing, inventory
- **Delete**: Remove room types with confirmation
- **Images**: URL-based image management
- **Amenities**: Checkbox selection from predefined list

### ✅ User Interface
- **Responsive**: Works on desktop, tablet, mobile
- **Real-time**: Immediate UI updates after operations
- **Validation**: Form validation prevents invalid data
- **Feedback**: Success/error messages for all operations
- **Loading States**: Visual feedback during API calls

## Complete Feature List

### Hotel Features
1. Basic Information
   - Name, description, star rating
   - Currency selection
   - Status management (Active/Maintenance/Inactive)

2. Address Information
   - Street address, city, state, ZIP
   - Country selection

3. Contact Information
   - Phone number, email, website

4. Operational Settings
   - Check-in/check-out times

5. Actions
   - Edit mode with save/cancel
   - Delete with confirmation
   - Real-time status badge updates

### Room Features
1. Basic Information
   - Room type (from predefined list)
   - Description
   - Price per night
   - Bed type selection

2. Capacity & Inventory
   - Max guests
   - Total rooms
   - Available rooms
   - Room size (sq m)

3. Visual Content
   - Multiple image URLs
   - Image preview in cards
   - "+X more" indicator for multiple images

4. Amenities
   - 20+ predefined amenities
   - Checkbox selection
   - Display first 3 + count

5. Additional Options
   - Breakfast included
   - Free cancellation

6. Actions
   - Edit modal with pre-filled data
   - Delete with confirmation
   - Real-time list updates

## Technical Stack

### Backend
- **Framework**: Spring Boot 3.x
- **Database**: PostgreSQL
- **API**: RESTful with ApiResponse wrapper
- **Security**: JWT authentication
- **Validation**: Bean validation

### Frontend
- **Framework**: React 18 with Vite
- **Styling**: Tailwind CSS
- **Icons**: Lucide React
- **HTTP Client**: Axios with interceptors
- **State**: React hooks (useState, useEffect)

## API Endpoints

### Hotels
```
GET    /hotels                    - List all hotels
GET    /hotels/{id}               - Get hotel by ID
POST   /hotels                    - Create hotel
PUT    /hotels/{id}               - Update hotel
DELETE /hotels/{id}               - Delete hotel
GET    /hotels/featured           - Get featured hotels
POST   /hotels/search             - Search hotels
```

### Rooms
```
GET    /hotels/{hotelId}/rooms              - List hotel rooms
POST   /hotels/{hotelId}/rooms              - Create room
PUT    /hotels/{hotelId}/rooms/{roomId}     - Update room
DELETE /hotels/{hotelId}/rooms/{roomId}     - Delete room
```

## Database Schema

### Hotels Table
```sql
CREATE TABLE hotels (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    price_per_night DOUBLE PRECISION NOT NULL,
    guest_rating DOUBLE PRECISION DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    star_rating INTEGER NOT NULL,
    featured BOOLEAN DEFAULT false,
    available BOOLEAN DEFAULT true,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    phone_number VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(255),
    check_in_time VARCHAR(10),
    check_out_time VARCHAR(10),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Rooms Table
```sql
CREATE TABLE rooms (
    id VARCHAR(255) PRIMARY KEY,
    hotel_id VARCHAR(255) NOT NULL,
    room_type VARCHAR(255) NOT NULL,
    description TEXT,
    price_per_night DOUBLE PRECISION NOT NULL,
    max_guests INTEGER NOT NULL,
    total_rooms INTEGER NOT NULL,
    available_rooms INTEGER NOT NULL,
    size DOUBLE PRECISION,
    bed_type VARCHAR(50),
    has_breakfast BOOLEAN DEFAULT false,
    free_cancellation BOOLEAN DEFAULT false,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);
```

## File Structure

```
admin-portal/
├── src/
│   ├── pages/
│   │   └── property-management/
│   │       ├── index.jsx                    # Main component
│   │       └── components/
│   │           ├── PropertyListPanel.jsx    # Hotel list sidebar
│   │           ├── PropertyDetailsPanel.jsx # Main content area
│   │           ├── GeneralInfoTab.jsx       # Hotel edit form
│   │           ├── RoomTypesTab.jsx         # Room list & management
│   │           ├── CreatePropertyModal.jsx  # New hotel modal
│   │           ├── AddRoomModal.jsx         # New/edit room modal
│   │           └── ImageUrlInput.jsx        # Image URL manager
│   ├── services/
│   │   └── api.js                           # API client
│   └── constants/
│       └── amenities.js                     # Predefined lists

backend/
├── src/main/java/com/hotelbooker/
│   ├── hotel/
│   │   ├── controller/
│   │   │   └── HotelController.java         # REST endpoints
│   │   ├── service/
│   │   │   └── HotelService.java            # Business logic
│   │   ├── entity/
│   │   │   ├── Hotel.java                   # Hotel entity
│   │   │   └── Room.java                    # Room entity
│   │   ├── dto/
│   │   │   ├── HotelDto.java                # Hotel DTO
│   │   │   └── RoomDto.java                 # Room DTO
│   │   └── repository/
│   │       ├── HotelRepository.java         # Hotel data access
│   │       └── RoomRepository.java          # Room data access
│   └── config/
│       └── WebConfig.java                   # CORS configuration
```

## Setup Instructions

### 1. Database Setup
```bash
# Create database
createdb hotel_booker

# Run migrations
psql -U postgres -d hotel_booker -f backend/ADD_HOTEL_STATUS.sql
```

### 2. Backend Setup
```bash
cd backend

# Configure database in application-dev.yml
# Set JWT secret in .env

# Run backend
./mvnw spring-boot:run
```

### 3. Frontend Setup
```bash
cd admin-portal

# Install dependencies
npm install

# Configure API URL in .env
echo "VITE_API_URL=http://localhost:8080/api/v1" > .env

# Run frontend
npm run dev
```

### 4. Login
```
Email: admin@hotel.com
Password: admin123
```

## Usage Guide

### Creating a Hotel
1. Click "Add New" in Properties panel
2. Fill in all required fields
3. Click "Create Property"
4. Hotel appears in list

### Editing a Hotel
1. Select hotel from list
2. Click "Edit" button
3. Modify fields
4. Click "Save Changes"

### Deleting a Hotel
1. Select hotel from list
2. Click "Delete" button
3. Confirm deletion

### Adding a Room
1. Select hotel
2. Go to "Room Types" tab
3. Click "Add Room Type"
4. Fill form
5. Click "Add Room Type"

### Editing a Room
1. Go to "Room Types" tab
2. Click "Edit" on room card
3. Modify fields
4. Click "Update Room"

### Deleting a Room
1. Go to "Room Types" tab
2. Click "Delete" on room card
3. Confirm deletion

## Best Practices

### Data Entry
- Use descriptive room type names
- Add multiple images for better presentation
- Select relevant amenities only
- Set realistic prices
- Keep descriptions concise but informative

### Image URLs
- Use Unsplash for free stock photos
- Ensure URLs are publicly accessible
- Use HTTPS URLs for security
- Test URLs before saving

### Status Management
- Set to "Maintenance" during renovations
- Set to "Inactive" when temporarily closed
- Keep "Active" for operational hotels

### Inventory Management
- Update available rooms regularly
- Don't exceed total rooms
- Set realistic max guests per room

## Troubleshooting

### Common Issues

**Issue**: Changes don't save
- Check network connection
- Verify JWT token is valid
- Check browser console for errors

**Issue**: Images don't display
- Verify URL is publicly accessible
- Check for CORS issues
- Use HTTPS URLs

**Issue**: Validation errors
- Check all required fields are filled
- Verify numeric fields have valid values
- Ensure available ≤ total rooms

**Issue**: Delete doesn't work
- Confirm in dialog
- Check for foreign key constraints
- Verify permissions

## Future Enhancements

### Planned Features
- [ ] Bulk operations (edit/delete multiple)
- [ ] Image upload (vs URL-based)
- [ ] Rich text editor for descriptions
- [ ] Drag-and-drop image reordering
- [ ] Room availability calendar
- [ ] Pricing rules and seasons
- [ ] Analytics dashboard
- [ ] Export/import data
- [ ] Change history/audit log
- [ ] Multi-language support

### Performance Improvements
- [ ] Pagination for large lists
- [ ] Image lazy loading
- [ ] Debounced search
- [ ] Optimistic UI updates
- [ ] Caching strategies

## Documentation

- `HOTEL_STATUS_IMPLEMENTATION.md` - Status feature details
- `ROOM_MANAGEMENT_API.md` - API documentation
- `EDIT_DELETE_IMPLEMENTATION.md` - Edit/delete feature details
- `TEST_EDIT_DELETE.md` - Testing guide
- `PROPERTY_MANAGEMENT_SUMMARY.md` - Feature summary

## Support

For issues or questions:
1. Check documentation files
2. Review browser console for errors
3. Check backend logs
4. Verify database state
5. Test API endpoints directly

## License

This project is part of the Hotel Booking System.
