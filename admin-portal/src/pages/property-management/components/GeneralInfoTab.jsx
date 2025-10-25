import React, { useState, useEffect } from 'react';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';
import Icon from '../../../components/AppIcon';

const GeneralInfoTab = ({ property, onUpdate, isEditing }) => {
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    address: '',
    city: '',
    state: '',
    zipCode: '',
    country: '',
    phone: '',
    email: '',
    website: '',
    rating: '',
    checkInTime: '',
    checkOutTime: '',
    currency: 'USD',
    status: 'ACTIVE'
  });

  useEffect(() => {
    // Only update form data when not editing to avoid conflicts
    if (property && !isEditing) {
      setFormData({
        name: property?.name || '',
        description: property?.description || '',
        address: property?.address || '',
        city: property?.city || '',
        state: property?.state || '',
        zipCode: property?.zipCode || '',
        country: property?.country || '',
        phone: property?.phone || '',
        email: property?.email || '',
        website: property?.website || '',
        rating: property?.rating?.toString() || '',
        checkInTime: property?.checkInTime || '',
        checkOutTime: property?.checkOutTime || '',
        currency: property?.currency || 'USD',
        status: property?.status || 'ACTIVE'
      });
    }
  }, [property, isEditing]);

  const handleInputChange = (field, value) => {
    const newFormData = { ...formData, [field]: value };
    setFormData(newFormData);
    
    // Notify parent of changes
    if (isEditing && onUpdate) {
      onUpdate(field, value);
    }
  };

  const ratingOptions = [
    { value: '1', label: '1 Star' },
    { value: '2', label: '2 Stars' },
    { value: '3', label: '3 Stars' },
    { value: '4', label: '4 Stars' },
    { value: '5', label: '5 Stars' }
  ];

  const currencyOptions = [
    { value: 'USD', label: 'US Dollar (USD)' },
    { value: 'EUR', label: 'Euro (EUR)' },
    { value: 'GBP', label: 'British Pound (GBP)' },
    { value: 'CAD', label: 'Canadian Dollar (CAD)' },
    { value: 'AUD', label: 'Australian Dollar (AUD)' }
  ];

  const statusOptions = [
    { value: 'ACTIVE', label: 'Active' },
    { value: 'MAINTENANCE', label: 'Maintenance' },
    { value: 'INACTIVE', label: 'Inactive' }
  ];

  const countryOptions = [
    { value: 'US', label: 'United States' },
    { value: 'CA', label: 'Canada' },
    { value: 'GB', label: 'United Kingdom' },
    { value: 'AU', label: 'Australia' },
    { value: 'DE', label: 'Germany' },
    { value: 'FR', label: 'France' },
    { value: 'IT', label: 'Italy' },
    { value: 'ES', label: 'Spain' }
  ];

  return (
    <div className="p-6">
      <div className="max-w-4xl mx-auto">
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
              disabled={!isEditing}
              required
            />

            <div className="space-y-2">
              <label className="text-sm font-medium text-foreground">Description</label>
              <textarea
                value={formData?.description}
                onChange={(e) => handleInputChange('description', e?.target?.value)}
                disabled={!isEditing}
                rows={4}
                className="w-full px-3 py-2 border border-border rounded-md text-sm disabled:opacity-50 disabled:cursor-not-allowed"
                placeholder="Enter property description..."
              />
            </div>

            <Select
              label="Star Rating"
              options={ratingOptions}
              value={formData?.rating}
              onChange={(value) => handleInputChange('rating', value)}
              disabled={!isEditing}
              required
            />

            <Select
              label="Currency"
              options={currencyOptions}
              value={formData?.currency}
              onChange={(value) => handleInputChange('currency', value)}
              disabled={!isEditing}
              required
            />

            <Select
              label="Property Status"
              options={statusOptions}
              value={formData?.status}
              onChange={(value) => handleInputChange('status', value)}
              disabled={!isEditing}
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
              disabled={!isEditing}
              required
            />

            <div className="grid grid-cols-2 gap-4">
              <Input
                label="City"
                type="text"
                value={formData?.city}
                onChange={(e) => handleInputChange('city', e?.target?.value)}
                disabled={!isEditing}
                required
              />

              <Input
                label="State/Province"
                type="text"
                value={formData?.state}
                onChange={(e) => handleInputChange('state', e?.target?.value)}
                disabled={!isEditing}
                required
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <Input
                label="ZIP/Postal Code"
                type="text"
                value={formData?.zipCode}
                onChange={(e) => handleInputChange('zipCode', e?.target?.value)}
                disabled={!isEditing}
                required
              />

              <Select
                label="Country"
                options={countryOptions}
                value={formData?.country}
                onChange={(value) => handleInputChange('country', value)}
                disabled={!isEditing}
                required
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
              value={formData?.phone}
              onChange={(e) => handleInputChange('phone', e?.target?.value)}
              disabled={!isEditing}
              required
            />

            <Input
              label="Email Address"
              type="email"
              value={formData?.email}
              onChange={(e) => handleInputChange('email', e?.target?.value)}
              disabled={!isEditing}
              required
            />

            <Input
              label="Website URL"
              type="url"
              value={formData?.website}
              onChange={(e) => handleInputChange('website', e?.target?.value)}
              disabled={!isEditing}
              placeholder="https://www.example.com"
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
              disabled={!isEditing}
              required
            />

            <Input
              label="Check-out Time"
              type="time"
              value={formData?.checkOutTime}
              onChange={(e) => handleInputChange('checkOutTime', e?.target?.value)}
              disabled={!isEditing}
              required
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default GeneralInfoTab;