import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';
import { hotelsAPI } from '../../../services/api';

const CreatePropertyModal = ({ isOpen, onClose, onCreateProperty }) => {
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    address: '',
    city: '',
    country: '',
    starRating: '3',
    latitude: 0,
    longitude: 0,
    featured: false,
    available: true,
    phoneNumber: '',
    email: '',
    website: '',
    checkInTime: '15:00',
    checkOutTime: '11:00'
  });

  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const countryOptions = [
    { value: 'United States', label: 'United States' },
    { value: 'Canada', label: 'Canada' },
    { value: 'United Kingdom', label: 'United Kingdom' },
    { value: 'Cambodia', label: 'Cambodia' },
    { value: 'Thailand', label: 'Thailand' },
    { value: 'Vietnam', label: 'Vietnam' },
    { value: 'Singapore', label: 'Singapore' },
    { value: 'Malaysia', label: 'Malaysia' },
    { value: 'Australia', label: 'Australia' },
    { value: 'Germany', label: 'Germany' },
    { value: 'France', label: 'France' },
    { value: 'Italy', label: 'Italy' },
    { value: 'Spain', label: 'Spain' }
  ];

  const ratingOptions = [
    { value: 1, label: '1 Star' },
    { value: 2, label: '2 Stars' },
    { value: 3, label: '3 Stars' },
    { value: 4, label: '4 Stars' },
    { value: 5, label: '5 Stars' }
  ];

  const handleInputChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors?.[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData?.name?.trim()) newErrors.name = 'Property name is required';
    if (!formData?.address?.trim()) newErrors.address = 'Address is required';
    if (!formData?.city?.trim()) newErrors.city = 'City is required';
    if (!formData?.country?.trim()) newErrors.country = 'Country is required';

    setErrors(newErrors);
    return Object.keys(newErrors)?.length === 0;
  };

  const handleSubmit = async (e) => {
    e?.preventDefault();

    if (!validateForm()) return;

    setIsSubmitting(true);

    try {
      // Prepare hotel data matching backend structure
      const hotelData = {
        name: formData.name,
        description: formData.description || '',
        address: formData.address,
        city: formData.city,
        country: formData.country,
        latitude: formData.latitude || 0,
        longitude: formData.longitude || 0,
        pricePerNight: 0, // Default to 0, will be set by room types
        starRating: parseInt(formData.starRating),
        guestRating: 0.0,
        totalReviews: 0,
        images: [],
        amenities: [],
        featured: formData.featured,
        available: formData.available,
        phoneNumber: formData.phoneNumber || null,
        email: formData.email || null,
        website: formData.website || null,
        checkInTime: formData.checkInTime || null,
        checkOutTime: formData.checkOutTime || null
      };

      // Call real API
      const response = await hotelsAPI.create(hotelData);

      if (response.success) {
        // Notify parent component
        if (onCreateProperty) {
          onCreateProperty(response.data);
        }

        // Close modal
        onClose();

        // Reset form
        setFormData({
          name: '',
          description: '',
          address: '',
          city: '',
          country: '',
          starRating: '3',
          latitude: 0,
          longitude: 0,
          featured: false,
          available: true,
          phoneNumber: '',
          email: '',
          website: '',
          checkInTime: '15:00',
          checkOutTime: '11:00'
        });

        // Show success message
        alert('Hotel created successfully!');
      }
    } catch (error) {
      console.error('Error creating property:', error);
      setErrors({ general: error.message || 'Failed to create property. Please try again.' });
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 z-300 flex items-center justify-center p-4">
      <div className="bg-card rounded-lg w-full max-w-4xl max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-border">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
              <Icon name="Building2" size={20} color="white" />
            </div>
            <div>
              <h2 className="text-xl font-semibold text-foreground">Create New Property</h2>
              <p className="text-sm text-muted-foreground">Add a new hotel property to your portfolio</p>
            </div>
          </div>
          <Button
            variant="ghost"
            size="sm"
            iconName="X"
            onClick={onClose}
          />
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 overflow-y-auto max-h-[calc(90vh-140px)]">
          {/* Error Message */}
          {errors?.general && (
            <div className="mb-4 p-3 bg-error/10 border border-error/20 rounded-md flex items-center space-x-2">
              <Icon name="AlertCircle" size={16} className="text-error flex-shrink-0" />
              <span className="text-sm text-error">{errors?.general}</span>
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Basic Information */}
            <div className="space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Info" size={20} className="mr-2" />
                Basic Information
              </h3>

              <Input
                label="Property Name"
                type="text"
                value={formData?.name}
                onChange={(e) => handleInputChange('name', e?.target?.value)}
                error={errors?.name}
                required
                placeholder="e.g., Grand Plaza Hotel"
              />

              <div className="space-y-2">
                <label className="text-sm font-medium text-foreground">Description</label>
                <textarea
                  value={formData?.description}
                  onChange={(e) => handleInputChange('description', e?.target?.value)}
                  rows={3}
                  className="w-full px-3 py-2 border border-border rounded-md text-sm"
                  placeholder="Brief description of your property..."
                />
              </div>

              <Select
                label="Star Rating"
                options={ratingOptions}
                value={formData?.starRating}
                onChange={(value) => handleInputChange('starRating', value)}
                required
              />
            </div>

            {/* Address Information */}
            <div className="space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="MapPin" size={20} className="mr-2" />
                Address Information
              </h3>

              <Input
                label="Street Address"
                type="text"
                value={formData?.address}
                onChange={(e) => handleInputChange('address', e?.target?.value)}
                error={errors?.address}
                required
                placeholder="123 Main Street"
              />

              <Input
                label="City"
                type="text"
                value={formData?.city}
                onChange={(e) => handleInputChange('city', e?.target?.value)}
                error={errors?.city}
                required
                placeholder="Phnom Penh"
              />

              <Select
                label="Country"
                options={countryOptions}
                value={formData?.country}
                onChange={(value) => handleInputChange('country', value)}
                error={errors?.country}
                required
              />

              <div className="grid grid-cols-2 gap-4">
                <Input
                  label="Latitude (Optional)"
                  type="number"
                  step="any"
                  value={formData?.latitude}
                  onChange={(e) => handleInputChange('latitude', parseFloat(e?.target?.value) || 0)}
                  placeholder="11.5564"
                />

                <Input
                  label="Longitude (Optional)"
                  type="number"
                  step="any"
                  value={formData?.longitude}
                  onChange={(e) => handleInputChange('longitude', parseFloat(e?.target?.value) || 0)}
                  placeholder="104.9282"
                />
              </div>
            </div>

            {/* Contact Information */}
            <div className="space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Phone" size={20} className="mr-2" />
                Contact Information
              </h3>

              <Input
                label="Phone Number"
                type="tel"
                value={formData?.phoneNumber}
                onChange={(e) => handleInputChange('phoneNumber', e?.target?.value)}
                placeholder="+855 12 345 678"
              />

              <Input
                label="Email Address"
                type="email"
                value={formData?.email}
                onChange={(e) => handleInputChange('email', e?.target?.value)}
                placeholder="info@hotel.com"
              />

              <Input
                label="Website URL"
                type="url"
                value={formData?.website}
                onChange={(e) => handleInputChange('website', e?.target?.value)}
                placeholder="https://www.hotel.com"
              />
            </div>

            {/* Operational Settings */}
            <div className="space-y-4">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Clock" size={20} className="mr-2" />
                Operational Settings
              </h3>

              <Input
                label="Check-in Time"
                type="time"
                value={formData?.checkInTime}
                onChange={(e) => handleInputChange('checkInTime', e?.target?.value)}
              />

              <Input
                label="Check-out Time"
                type="time"
                value={formData?.checkOutTime}
                onChange={(e) => handleInputChange('checkOutTime', e?.target?.value)}
              />
            </div>

            {/* Property Settings */}
            <div className="space-y-4 lg:col-span-2">
              <h3 className="text-lg font-medium text-foreground flex items-center">
                <Icon name="Settings" size={20} className="mr-2" />
                Property Settings
              </h3>

              <div className="flex items-center space-x-6">
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData?.featured}
                    onChange={(e) => handleInputChange('featured', e?.target?.checked)}
                    className="rounded border-border text-primary focus:ring-primary"
                  />
                  <span className="text-sm text-foreground">Featured Property</span>
                </label>

                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData?.available}
                    onChange={(e) => handleInputChange('available', e?.target?.checked)}
                    className="rounded border-border text-primary focus:ring-primary"
                  />
                  <span className="text-sm text-foreground">Available for Booking</span>
                </label>
              </div>

              <div className="p-4 bg-muted/50 border border-border rounded-md">
                <p className="text-sm text-muted-foreground">
                  <Icon name="Info" size={14} className="inline mr-1" />
                  After creating the property, you can add rooms, amenities, and photos from the property details page.
                </p>
              </div>
            </div>
          </div>
        </form>

        {/* Footer */}
        <div className="flex items-center justify-end space-x-3 p-6 border-t border-border">
          <Button
            variant="outline"
            onClick={onClose}
            disabled={isSubmitting}
          >
            Cancel
          </Button>
          <Button
            variant="default"
            iconName="Plus"
            iconPosition="left"
            loading={isSubmitting}
            onClick={handleSubmit}
          >
            Create Property
          </Button>
        </div>
      </div>
    </div>
  );
};

export default CreatePropertyModal;