import React, { useState, useEffect } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';
import ImageUrlInput from './ImageUrlInput';
import { ROOM_AMENITIES, BED_TYPES, ROOM_TYPES } from '../../../constants/amenities';
import { roomsAPI } from '../../../services/api';

const AddRoomModal = ({ isOpen, onClose, hotelId, room = null, onSuccess }) => {
  const [formData, setFormData] = useState({
    roomType: '',
    description: '',
    pricePerNight: '',
    maxGuests: 2,
    totalRooms: 1,
    availableRooms: 1,
    size: '',
    bedType: '',
    hasBreakfast: false,
    freeCancellation: true,
    images: [],
    amenities: []
  });

  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Populate form if editing
  useEffect(() => {
    if (room) {
      setFormData({
        roomType: room.roomType || '',
        description: room.description || '',
        pricePerNight: room.pricePerNight || '',
        maxGuests: room.maxGuests || 2,
        totalRooms: room.totalRooms || 1,
        availableRooms: room.availableRooms || 1,
        size: room.size || '',
        bedType: room.bedType || '',
        hasBreakfast: room.hasBreakfast || false,
        freeCancellation: room.freeCancellation || true,
        images: room.images || [],
        amenities: room.amenities || []
      });
    }
  }, [room]);

  const handleInputChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  const handleAmenityToggle = (amenity) => {
    setFormData(prev => ({
      ...prev,
      amenities: prev.amenities.includes(amenity)
        ? prev.amenities.filter(a => a !== amenity)
        : [...prev.amenities, amenity]
    }));
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.roomType?.trim()) newErrors.roomType = 'Room type is required';
    if (!formData.pricePerNight || formData.pricePerNight <= 0) {
      newErrors.pricePerNight = 'Price must be greater than 0';
    }
    if (!formData.maxGuests || formData.maxGuests < 1) {
      newErrors.maxGuests = 'Max guests must be at least 1';
    }
    if (!formData.totalRooms || formData.totalRooms < 1) {
      newErrors.totalRooms = 'Total rooms must be at least 1';
    }
    if (formData.availableRooms > formData.totalRooms) {
      newErrors.availableRooms = 'Available rooms cannot exceed total rooms';
    }
    if (!formData.bedType) newErrors.bedType = 'Bed type is required';

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) return;

    setIsSubmitting(true);

    try {
      const roomData = {
        roomType: formData.roomType,
        description: formData.description || '',
        pricePerNight: parseFloat(formData.pricePerNight),
        maxGuests: parseInt(formData.maxGuests),
        totalRooms: parseInt(formData.totalRooms),
        availableRooms: parseInt(formData.availableRooms),
        size: formData.size ? parseFloat(formData.size) : null,
        bedType: formData.bedType,
        hasBreakfast: formData.hasBreakfast,
        freeCancellation: formData.freeCancellation,
        images: formData.images,
        amenities: formData.amenities
      };

      let response;
      if (room) {
        // Update existing room
        response = await roomsAPI.update(hotelId, room.id, roomData);
      } else {
        // Create new room
        response = await roomsAPI.create(hotelId, roomData);
      }

      if (response.success) {
        alert(room ? 'Room updated successfully!' : 'Room created successfully!');
        onSuccess();
        onClose();
        
        // Reset form
        setFormData({
          roomType: '',
          description: '',
          pricePerNight: '',
          maxGuests: 2,
          totalRooms: 1,
          availableRooms: 1,
          size: '',
          bedType: '',
          hasBreakfast: false,
          freeCancellation: true,
          images: [],
          amenities: []
        });
      }
    } catch (error) {
      console.error('Error saving room:', error);
      setErrors({ general: error.message || 'Failed to save room. Please try again.' });
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  const roomTypeOptions = ROOM_TYPES.map(type => ({ value: type, label: type }));

  return (
    <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
      <div className="bg-card rounded-lg w-full max-w-4xl max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-border">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
              <Icon name="Bed" size={20} color="white" />
            </div>
            <div>
              <h2 className="text-xl font-semibold text-foreground">
                {room ? 'Edit Room Type' : 'Add New Room Type'}
              </h2>
              <p className="text-sm text-muted-foreground">
                {room ? 'Update room details and inventory' : 'Add a new room type to your hotel'}
              </p>
            </div>
          </div>
          <Button variant="ghost" size="sm" iconName="X" onClick={onClose} />
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 overflow-y-auto max-h-[calc(90vh-140px)]">
          {/* Error Message */}
          {errors.general && (
            <div className="mb-4 p-3 bg-error/10 border border-error/20 rounded-md flex items-center space-x-2">
              <Icon name="AlertCircle" size={16} className="text-error flex-shrink-0" />
              <span className="text-sm text-error">{errors.general}</span>
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Basic Information */}
            <div className="space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Info" size={20} className="mr-2" />
                Basic Information
              </h3>

              <Select
                label="Room Type"
                options={roomTypeOptions}
                value={formData.roomType}
                onChange={(value) => handleInputChange('roomType', value)}
                error={errors.roomType}
                required
              />

              <div className="space-y-2">
                <label className="text-sm font-medium text-foreground">Description</label>
                <textarea
                  value={formData.description}
                  onChange={(e) => handleInputChange('description', e.target.value)}
                  rows={3}
                  className="w-full px-3 py-2 border border-border rounded-md text-sm"
                  placeholder="Brief description of the room..."
                />
              </div>

              <Input
                label="Price Per Night (USD)"
                type="number"
                step="0.01"
                min="0"
                value={formData.pricePerNight}
                onChange={(e) => handleInputChange('pricePerNight', e.target.value)}
                error={errors.pricePerNight}
                required
                placeholder="99.99"
              />

              <Select
                label="Bed Type"
                options={BED_TYPES}
                value={formData.bedType}
                onChange={(value) => handleInputChange('bedType', value)}
                error={errors.bedType}
                required
              />
            </div>

            {/* Capacity & Inventory */}
            <div className="space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Users" size={20} className="mr-2" />
                Capacity & Inventory
              </h3>

              <Input
                label="Max Guests"
                type="number"
                min="1"
                value={formData.maxGuests}
                onChange={(e) => handleInputChange('maxGuests', e.target.value)}
                error={errors.maxGuests}
                required
              />

              <Input
                label="Total Rooms"
                type="number"
                min="1"
                value={formData.totalRooms}
                onChange={(e) => {
                  const total = parseInt(e.target.value);
                  handleInputChange('totalRooms', total);
                  // Auto-adjust available rooms if needed
                  if (formData.availableRooms > total) {
                    handleInputChange('availableRooms', total);
                  }
                }}
                error={errors.totalRooms}
                required
              />

              <Input
                label="Available Rooms"
                type="number"
                min="0"
                max={formData.totalRooms}
                value={formData.availableRooms}
                onChange={(e) => handleInputChange('availableRooms', e.target.value)}
                error={errors.availableRooms}
                required
              />

              <Input
                label="Room Size (sq m)"
                type="number"
                step="0.1"
                min="0"
                value={formData.size}
                onChange={(e) => handleInputChange('size', e.target.value)}
                placeholder="35.5"
              />
            </div>

            {/* Images */}
            <div className="lg:col-span-2">
              <ImageUrlInput
                images={formData.images}
                onChange={(images) => handleInputChange('images', images)}
                label="Room Images"
              />
            </div>

            {/* Amenities */}
            <div className="lg:col-span-2 space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Star" size={20} className="mr-2" />
                Room Amenities
              </h3>

              <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                {ROOM_AMENITIES.map((amenity) => (
                  <label
                    key={amenity}
                    className="flex items-center space-x-2 cursor-pointer p-2 rounded-md hover:bg-muted/50 transition-colors"
                  >
                    <input
                      type="checkbox"
                      checked={formData.amenities.includes(amenity)}
                      onChange={() => handleAmenityToggle(amenity)}
                      className="rounded border-border text-primary focus:ring-primary"
                    />
                    <span className="text-sm text-foreground">{amenity}</span>
                  </label>
                ))}
              </div>
            </div>

            {/* Additional Options */}
            <div className="lg:col-span-2 space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Settings" size={20} className="mr-2" />
                Additional Options
              </h3>

              <div className="flex items-center space-x-6">
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.hasBreakfast}
                    onChange={(e) => handleInputChange('hasBreakfast', e.target.checked)}
                    className="rounded border-border text-primary focus:ring-primary"
                  />
                  <span className="text-sm text-foreground">Includes Breakfast</span>
                </label>

                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.freeCancellation}
                    onChange={(e) => handleInputChange('freeCancellation', e.target.checked)}
                    className="rounded border-border text-primary focus:ring-primary"
                  />
                  <span className="text-sm text-foreground">Free Cancellation</span>
                </label>
              </div>
            </div>
          </div>
        </form>

        {/* Footer */}
        <div className="flex items-center justify-end space-x-3 p-6 border-t border-border">
          <Button variant="outline" onClick={onClose} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button
            variant="default"
            iconName={room ? 'Save' : 'Plus'}
            iconPosition="left"
            loading={isSubmitting}
            onClick={handleSubmit}
          >
            {room ? 'Update Room' : 'Add Room Type'}
          </Button>
        </div>
      </div>
    </div>
  );
};

export default AddRoomModal;
