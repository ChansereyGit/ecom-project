# Room Management API

## Overview
API endpoints for managing hotel rooms in the admin portal.

## Endpoints

### 1. Create Room
**POST** `/hotels/{hotelId}/rooms`

Creates a new room for a specific hotel.

**Request Body**:
```json
{
  "roomType": "Deluxe King Room",
  "description": "Spacious room with king bed and city view",
  "pricePerNight": 150.00,
  "maxGuests": 2,
  "totalRooms": 10,
  "availableRooms": 10,
  "size": 35.0,
  "images": [
    "https://images.unsplash.com/photo-1...",
    "https://images.unsplash.com/photo-2..."
  ],
  "amenities": [
    "Air Conditioning",
    "Flat Screen TV",
    "Mini Bar",
    "Safe"
  ],
  "bedType": "King",
  "hasBreakfast": true,
  "freeCancellation": true
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "id": "room-uuid",
    "hotelId": "hotel-uuid",
    "roomType": "Deluxe King Room",
    ...
  },
  "message": null
}
```

### 2. Update Room
**PUT** `/hotels/{hotelId}/rooms/{roomId}`

Updates an existing room.

**Request Body**: Same as Create Room

**Response**: Same as Create Room

### 3. Delete Room
**DELETE** `/hotels/{hotelId}/rooms/{roomId}`

Deletes a room from a hotel.

**Response**:
```json
{
  "success": true,
  "data": null,
  "message": null
}
```

### 4. Get Hotel Rooms
**GET** `/hotels/{hotelId}/rooms`

Retrieves all rooms for a specific hotel.

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "room-uuid-1",
      "hotelId": "hotel-uuid",
      "roomType": "Deluxe King Room",
      ...
    },
    {
      "id": "room-uuid-2",
      "hotelId": "hotel-uuid",
      "roomType": "Standard Twin Room",
      ...
    }
  ],
  "message": null
}
```

## Error Responses

### Hotel Not Found
```json
{
  "success": false,
  "data": null,
  "message": "Hotel not found with id: {hotelId}"
}
```

### Room Not Found
```json
{
  "success": false,
  "data": null,
  "message": "Room not found with id: {roomId}"
}
```

### Room Doesn't Belong to Hotel
```json
{
  "success": false,
  "data": null,
  "message": "Room does not belong to this hotel"
}
```

## Authentication

All room management endpoints require authentication with a valid JWT token:

```
Authorization: Bearer <your-jwt-token>
```

## Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| roomType | String | Yes | Name/type of the room (e.g., "Deluxe King") |
| description | String | No | Detailed room description |
| pricePerNight | Double | Yes | Price per night in hotel's currency |
| maxGuests | Integer | Yes | Maximum number of guests |
| totalRooms | Integer | Yes | Total number of this room type |
| availableRooms | Integer | No | Currently available rooms (defaults to totalRooms) |
| size | Double | No | Room size in square meters |
| images | Array[String] | No | Array of image URLs |
| amenities | Array[String] | No | Array of amenity names |
| bedType | String | No | Type of bed (e.g., "King", "Queen", "Twin") |
| hasBreakfast | Boolean | No | Whether breakfast is included |
| freeCancellation | Boolean | No | Whether free cancellation is available |

## Usage Example

```bash
# Create a room
curl -X POST http://localhost:8080/hotels/hotel-123/rooms \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "roomType": "Deluxe King Room",
    "pricePerNight": 150.00,
    "maxGuests": 2,
    "totalRooms": 10
  }'

# Update a room
curl -X PUT http://localhost:8080/hotels/hotel-123/rooms/room-456 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "roomType": "Deluxe King Room",
    "pricePerNight": 175.00,
    "maxGuests": 2,
    "totalRooms": 10
  }'

# Delete a room
curl -X DELETE http://localhost:8080/hotels/hotel-123/rooms/room-456 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get all rooms for a hotel
curl http://localhost:8080/hotels/hotel-123/rooms
```

## Notes

- When creating a room, if `availableRooms` is not provided, it defaults to `totalRooms`
- Images should be publicly accessible URLs (Unsplash, CDN, etc.)
- Amenities should match the predefined list in the frontend constants
- Deleting a room will also delete all associated bookings (cascade delete)
