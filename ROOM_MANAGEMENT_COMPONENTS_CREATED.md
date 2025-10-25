# ✅ Room Management Components - Created!

## Components Completed

### 1. ImageUrlInput Component ✅
**File:** `admin-portal/src/pages/property-management/components/ImageUrlInput.jsx`

**Features:**
- ✅ Add multiple image URLs
- ✅ Live image preview
- ✅ Remove images
- ✅ URL validation
- ✅ Sample URLs for testing
- ✅ Error handling for broken images
- ✅ Image numbering

### 2. AddRoomModal Component ✅
**File:** `admin-portal/src/pages/property-management/components/AddRoomModal.jsx`

**Features:**
- ✅ Complete room form
- ✅ Room type selection (15 types)
- ✅ Pricing and capacity
- ✅ Inventory management
- ✅ Bed type selection (7 types)
- ✅ Image URL input integration
- ✅ Amenities selector (24 amenities)
- ✅ Breakfast & cancellation options
- ✅ Create & Edit modes
- ✅ Form validation
- ✅ API integration

## Remaining Components

### 3. RoomTypesTab Component (Next)
Create: `admin-portal/src/pages/property-management/components/RoomTypesTab.jsx`

```jsx
import React, { useState, useEffect } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import AddRoomModal from './AddRoomModal';
import { roomsAPI } from '../../../services/api';

const RoomTypesTab = ({ hotelId }) => {
  const [rooms, setRooms] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [editingRoom, setEditingRoom] = useState(null);

  useEffect(() => {
    if (hotelId) {
      loadRooms();
    }
  }, [hotelId]);

  const loadRooms = async () => {
    try {
      setIsLoading(true);
      const response = await roomsAPI.getByHotel(hotelId);
      if (response.success) {
        setRooms(response.data || []);
      }
    } catch (error) {
      console.error('Error loading rooms:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleDeleteRoom = async (roomId) => {
    if (!confirm('Are you sure you want to delete this room type?')) return;

    try {
      await roomsAPI.delete(roomId);
      alert('Room deleted successfully!');
      loadRooms();
    } catch (error) {
      alert('Failed to delete room: ' + error.message);
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-foreground">Room Types & Inventory</h3>
          <p className="text-sm text-muted-foreground">
            Manage room types, pricing, and inventory for {hotelId}
          </p>
        </div>
        <Button
          variant="default"
          iconName="Plus"
          onClick={() => setShowAddModal(true)}
        >
          Add Room Type
        </Button>
      </div>

      {/* Rooms List */}
      {rooms.length === 0 ? (
        <div className="text-center py-12 bg-muted/50 rounded-lg border border-border">
          <Icon name="Bed" size={48} className="text-muted-foreground mx-auto mb-4" />
          <h4 className="text-lg font-medium text-foreground mb-2">No room types yet</h4>
          <p className="text-sm text-muted-foreground mb-4">
            Add your first room type to start accepting bookings
          </p>
          <Button
            variant="default"
            iconName="Plus"
            onClick={() => setShowAddModal(true)}
          >
            Add Room Type
          </Button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {rooms.map((room) => (
            <div key={room.id} className="bg-card border border-border rounded-lg overflow-hidden">
              {/* Room Image */}
              <div className="aspect-video bg-muted relative">
                {room.images && room.images.length > 0 ? (
                  <img
                    src={room.images[0]}
                    alt={room.roomType}
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="w-full h-full flex items-center justify-center">
                    <Icon name="Image" size={48} className="text-muted-foreground" />
                  </div>
                )}
                {room.images && room.images.length > 1 && (
                  <div className="absolute bottom-2 right-2 bg-black/70 text-white text-xs px-2 py-1 rounded">
                    +{room.images.length - 1} more
                  </div>
                )}
              </div>

              {/* Room Details */}
              <div className="p-4">
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <h4 className="text-lg font-semibold text-foreground">{room.roomType}</h4>
                    <p className="text-sm text-muted-foreground">{room.bedType}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-xl font-bold text-primary">${room.pricePerNight}</p>
                    <p className="text-xs text-muted-foreground">per night</p>
                  </div>
                </div>

                {room.description && (
                  <p className="text-sm text-muted-foreground mb-3 line-clamp-2">
                    {room.description}
                  </p>
                )}

                {/* Room Stats */}
                <div className="grid grid-cols-3 gap-2 mb-3">
                  <div className="text-center p-2 bg-muted/50 rounded">
                    <Icon name="Users" size={16} className="mx-auto mb-1 text-muted-foreground" />
                    <p className="text-xs font-medium">{room.maxGuests} guests</p>
                  </div>
                  <div className="text-center p-2 bg-muted/50 rounded">
                    <Icon name="Home" size={16} className="mx-auto mb-1 text-muted-foreground" />
                    <p className="text-xs font-medium">{room.totalRooms} rooms</p>
                  </div>
                  <div className="text-center p-2 bg-muted/50 rounded">
                    <Icon name="Check" size={16} className="mx-auto mb-1 text-success" />
                    <p className="text-xs font-medium">{room.availableRooms} available</p>
                  </div>
                </div>

                {/* Amenities */}
                {room.amenities && room.amenities.length > 0 && (
                  <div className="mb-3">
                    <p className="text-xs font-medium text-foreground mb-1">Amenities:</p>
                    <div className="flex flex-wrap gap-1">
                      {room.amenities.slice(0, 3).map((amenity, index) => (
                        <span
                          key={index}
                          className="text-xs bg-muted px-2 py-1 rounded"
                        >
                          {amenity}
                        </span>
                      ))}
                      {room.amenities.length > 3 && (
                        <span className="text-xs text-muted-foreground px-2 py-1">
                          +{room.amenities.length - 3} more
                        </span>
                      )}
                    </div>
                  </div>
                )}

                {/* Features */}
                <div className="flex items-center gap-3 mb-3 text-xs">
                  {room.hasBreakfast && (
                    <span className="flex items-center text-success">
                      <Icon name="Coffee" size={14} className="mr-1" />
                      Breakfast
                    </span>
                  )}
                  {room.freeCancellation && (
                    <span className="flex items-center text-success">
                      <Icon name="Check" size={14} className="mr-1" />
                      Free Cancel
                    </span>
                  )}
                  {room.size && (
                    <span className="flex items-center text-muted-foreground">
                      <Icon name="Maximize" size={14} className="mr-1" />
                      {room.size}m²
                    </span>
                  )}
                </div>

                {/* Actions */}
                <div className="flex gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    iconName="Edit"
                    onClick={() => {
                      setEditingRoom(room);
                      setShowAddModal(true);
                    }}
                    className="flex-1"
                  >
                    Edit
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    iconName="Trash"
                    onClick={() => handleDeleteRoom(room.id)}
                    className="text-error hover:text-error"
                  >
                    Delete
                  </Button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Add/Edit Modal */}
      <AddRoomModal
        isOpen={showAddModal}
        onClose={() => {
          setShowAddModal(false);
          setEditingRoom(null);
        }}
        hotelId={hotelId}
        room={editingRoom}
        onSuccess={() => {
          loadRooms();
          setEditingRoom(null);
        }}
      />
    </div>
  );
};

export default RoomTypesTab;
```

### 4. AmenitiesTab Component (Update Existing)
Update: `admin-portal/src/pages/property-management/components/AmenitiesTab.jsx`

```jsx
import React, { useState, useEffect } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import { HOTEL_AMENITIES } from '../../../constants/amenities';
import { hotelsAPI } from '../../../services/api';

const AmenitiesTab = ({ hotel, onUpdate }) => {
  const [selectedAmenities, setSelectedAmenities] = useState([]);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    if (hotel && hotel.amenities) {
      setSelectedAmenities(hotel.amenities);
    }
  }, [hotel]);

  const handleToggleAmenity = (amenity) => {
    setSelectedAmenities(prev =>
      prev.includes(amenity)
        ? prev.filter(a => a !== amenity)
        : [...prev, amenity]
    );
  };

  const handleSave = async () => {
    try {
      setIsSaving(true);
      const response = await hotelsAPI.update(hotel.id, {
        ...hotel,
        amenities: selectedAmenities
      });

      if (response.success) {
        alert('Amenities updated successfully!');
        onUpdate(response.data);
      }
    } catch (error) {
      alert('Failed to update amenities: ' + error.message);
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-foreground">Hotel Amenities</h3>
          <p className="text-sm text-muted-foreground">
            Select amenities available at your hotel
          </p>
        </div>
        <Button
          variant="default"
          iconName="Save"
          onClick={handleSave}
          loading={isSaving}
        >
          Save Changes
        </Button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
        {HOTEL_AMENITIES.map((amenity) => (
          <label
            key={amenity}
            className={`
              flex items-center space-x-3 p-4 rounded-lg border-2 cursor-pointer transition-all
              ${selectedAmenities.includes(amenity)
                ? 'border-primary bg-primary/5'
                : 'border-border hover:border-primary/50'
              }
            `}
          >
            <input
              type="checkbox"
              checked={selectedAmenities.includes(amenity)}
              onChange={() => handleToggleAmenity(amenity)}
              className="rounded border-border text-primary focus:ring-primary"
            />
            <span className="text-sm font-medium text-foreground">{amenity}</span>
          </label>
        ))}
      </div>

      <div className="p-4 bg-muted/50 border border-border rounded-md">
        <p className="text-sm text-muted-foreground">
          <Icon name="Info" size={14} className="inline mr-1" />
          Selected {selectedAmenities.length} of {HOTEL_AMENITIES.length} amenities
        </p>
      </div>
    </div>
  );
};

export default AmenitiesTab;
```

## Integration Steps

### 1. Update Property Management Index
Add RoomTypesTab to the tabs:

```jsx
// In admin-portal/src/pages/property-management/index.jsx
import RoomTypesTab from './components/RoomTypesTab';

// In the PropertyDetailsPanel component
<Tab value="room-types">
  <RoomTypesTab hotelId={selectedProperty?.id} />
</Tab>
```

### 2. Test the Complete Flow

1. **Start Backend:**
```bash
cd backend
mvn spring-boot:run
```

2. **Start React Admin:**
```bash
cd admin-portal
npm run dev
```

3. **Test Workflow:**
   - Login as admin
   - Go to Property Management
   - Select a hotel
   - Click "Room Types" tab
   - Click "Add Room Type"
   - Fill in the form
   - Add image URLs
   - Select amenities
   - Save
   - View room in list
   - Open Flutter app
   - Search for hotel
   - See rooms with images!

## Summary

✅ **ImageUrlInput** - Complete with preview and validation
✅ **AddRoomModal** - Complete with all fields and API integration
📝 **RoomTypesTab** - Code provided above (copy & create)
📝 **AmenitiesTab** - Code provided above (copy & update)

**All components use URL-based images - no file upload complexity!**

Ready to test! 🚀
