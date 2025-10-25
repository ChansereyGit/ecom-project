import React, { useState, useEffect } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import { Checkbox, CheckboxGroup } from '../../../components/ui/Checkbox';
import { HOTEL_AMENITIES } from '../../../constants/amenities';
import { hotelsAPI } from '../../../services/api';

const AmenitiesTab = ({ property, onUpdate, isEditing }) => {
  const [selectedAmenities, setSelectedAmenities] = useState([]);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    if (property && property.amenities) {
      setSelectedAmenities(property.amenities);
    }
  }, [property]);

  const amenityCategories = [
    {
      id: 'general',
      title: 'General Amenities',
      icon: 'Building2',
      amenities: [
        { id: 'wifi', label: 'Free WiFi', icon: 'Wifi' },
        { id: 'parking', label: 'Free Parking', icon: 'Car' },
        { id: 'reception', label: '24/7 Reception', icon: 'Clock' },
        { id: 'concierge', label: 'Concierge Service', icon: 'Users' },
        { id: 'luggage', label: 'Luggage Storage', icon: 'Package' },
        { id: 'laundry', label: 'Laundry Service', icon: 'Shirt' },
        { id: 'elevator', label: 'Elevator', icon: 'ArrowUp' },
        { id: 'security', label: '24/7 Security', icon: 'Shield' }
      ]
    },
    {
      id: 'room',
      title: 'Room Amenities',
      icon: 'Bed',
      amenities: [
        { id: 'ac', label: 'Air Conditioning', icon: 'Wind' },
        { id: 'tv', label: 'Flat Screen TV', icon: 'Tv' },
        { id: 'minibar', label: 'Mini Bar', icon: 'Coffee' },
        { id: 'safe', label: 'In-room Safe', icon: 'Lock' },
        { id: 'balcony', label: 'Private Balcony', icon: 'Home' },
        { id: 'kitchenette', label: 'Kitchenette', icon: 'ChefHat' },
        { id: 'workspace', label: 'Work Desk', icon: 'Laptop' },
        { id: 'iron', label: 'Iron & Board', icon: 'Zap' }
      ]
    },
    {
      id: 'business',
      title: 'Business Facilities',
      icon: 'Briefcase',
      amenities: [
        { id: 'meeting_room', label: 'Meeting Rooms', icon: 'Users' },
        { id: 'business_center', label: 'Business Center', icon: 'Building' },
        { id: 'conference', label: 'Conference Hall', icon: 'Presentation' },
        { id: 'printing', label: 'Printing Services', icon: 'Printer' },
        { id: 'high_speed_wifi', label: 'High-Speed WiFi', icon: 'Zap' },
        { id: 'projector', label: 'AV Equipment', icon: 'Monitor' }
      ]
    },
    {
      id: 'recreation',
      title: 'Recreation & Wellness',
      icon: 'Dumbbell',
      amenities: [
        { id: 'pool', label: 'Swimming Pool', icon: 'Waves' },
        { id: 'gym', label: 'Fitness Center', icon: 'Dumbbell' },
        { id: 'spa', label: 'Spa & Wellness', icon: 'Heart' },
        { id: 'sauna', label: 'Sauna', icon: 'Thermometer' },
        { id: 'tennis', label: 'Tennis Court', icon: 'Circle' },
        { id: 'golf', label: 'Golf Course', icon: 'Target' },
        { id: 'beach', label: 'Beach Access', icon: 'Sun' },
        { id: 'garden', label: 'Garden Area', icon: 'Trees' }
      ]
    },
    {
      id: 'dining',
      title: 'Dining & Food',
      icon: 'UtensilsCrossed',
      amenities: [
        { id: 'restaurant', label: 'Restaurant', icon: 'UtensilsCrossed' },
        { id: 'room_service', label: 'Room Service', icon: 'ShoppingCart' },
        { id: 'bar', label: 'Bar/Lounge', icon: 'Wine' },
        { id: 'breakfast', label: 'Complimentary Breakfast', icon: 'Coffee' },
        { id: 'cafe', label: 'Café', icon: 'Cup' },
        { id: 'bbq', label: 'BBQ Facilities', icon: 'Flame' }
      ]
    },
    {
      id: 'accessibility',
      title: 'Accessibility',
      icon: 'Accessibility',
      amenities: [
        { id: 'wheelchair_access', label: 'Wheelchair Accessible', icon: 'Accessibility' },
        { id: 'elevator_access', label: 'Elevator Access', icon: 'ArrowUp' },
        { id: 'accessible_bathroom', label: 'Accessible Bathroom', icon: 'Bath' },
        { id: 'braille', label: 'Braille Signage', icon: 'Eye' },
        { id: 'hearing_loop', label: 'Hearing Loop', icon: 'Ear' },
        { id: 'accessible_parking', label: 'Accessible Parking', icon: 'Car' }
      ]
    }
  ];

  const handleAmenityChange = (categoryId, amenityId, checked) => {
    setSelectedAmenities(prev => ({
      ...prev,
      [categoryId]: checked
        ? [...prev?.[categoryId], amenityId]
        : prev?.[categoryId]?.filter(id => id !== amenityId)
    }));
  };

  const getTotalSelectedCount = () => {
    return Object.values(selectedAmenities)?.reduce((total, category) => total + category?.length, 0);
  };

  return (
    <div className="p-6">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h3 className="text-lg font-medium text-foreground flex items-center">
              <Icon name="Wifi" size={20} className="mr-2" />
              Property Amenities
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              Select amenities available at {property?.name} • {getTotalSelectedCount()} selected
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {amenityCategories?.map((category) => (
            <div key={category?.id} className="bg-card border border-border rounded-lg p-6">
              <div className="flex items-center mb-4">
                <div className="w-8 h-8 bg-primary/10 rounded-lg flex items-center justify-center mr-3">
                  <Icon name={category?.icon} size={16} className="text-primary" />
                </div>
                <h4 className="font-medium text-foreground">{category?.title}</h4>
                <span className="ml-auto text-xs text-muted-foreground bg-muted px-2 py-1 rounded-full">
                  {selectedAmenities?.[category?.id]?.length || 0} selected
                </span>
              </div>

              <CheckboxGroup>
                <div className="grid grid-cols-1 gap-3">
                  {category?.amenities?.map((amenity) => (
                    <Checkbox
                      key={amenity?.id}
                      label={
                        <div className="flex items-center">
                          <Icon name={amenity?.icon} size={16} className="mr-2 text-muted-foreground" />
                          {amenity?.label}
                        </div>
                      }
                      checked={selectedAmenities?.[category?.id]?.includes(amenity?.id) || false}
                      onChange={(e) => handleAmenityChange(category?.id, amenity?.id, e?.target?.checked)}
                      disabled={!isEditing}
                    />
                  ))}
                </div>
              </CheckboxGroup>
            </div>
          ))}
        </div>

        {!isEditing && (
          <div className="mt-6 p-4 bg-muted/50 rounded-lg border border-border">
            <div className="flex items-center text-sm text-muted-foreground">
              <Icon name="Info" size={16} className="mr-2" />
              Enable edit mode to modify amenities selection
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default AmenitiesTab;