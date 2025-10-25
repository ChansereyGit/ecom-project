import React, { useState } from 'react';

import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';

const QuickBookingModal = ({ 
  isOpen, 
  onClose, 
  onSubmit, 
  selectedRoom, 
  selectedDate 
}) => {
  const [formData, setFormData] = useState({
    guestName: '',
    guestEmail: '',
    guestPhone: '',
    checkOut: '',
    adults: 1,
    children: 0,
    specialRequests: '',
    rateType: 'standard'
  });

  const [errors, setErrors] = useState({});

  const rateTypeOptions = [
    { value: 'standard', label: 'Standard Rate' },
    { value: 'corporate', label: 'Corporate Rate' },
    { value: 'government', label: 'Government Rate' },
    { value: 'promotional', label: 'Promotional Rate' }
  ];

  const adultOptions = Array.from({ length: 6 }, (_, i) => ({
    value: i + 1,
    label: `${i + 1} Adult${i > 0 ? 's' : ''}`
  }));

  const childrenOptions = Array.from({ length: 5 }, (_, i) => ({
    value: i,
    label: i === 0 ? 'No Children' : `${i} Child${i > 1 ? 'ren' : ''}`
  }));

  const handleInputChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors?.[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData?.guestName?.trim()) {
      newErrors.guestName = 'Guest name is required';
    }

    if (!formData?.guestEmail?.trim()) {
      newErrors.guestEmail = 'Email is required';
    } else if (!/\S+@\S+\.\S+/?.test(formData?.guestEmail)) {
      newErrors.guestEmail = 'Please enter a valid email';
    }

    if (!formData?.guestPhone?.trim()) {
      newErrors.guestPhone = 'Phone number is required';
    }

    if (!formData?.checkOut) {
      newErrors.checkOut = 'Check-out date is required';
    } else {
      const checkOutDate = new Date(formData.checkOut);
      if (checkOutDate <= selectedDate) {
        newErrors.checkOut = 'Check-out must be after check-in date';
      }
    }

    setErrors(newErrors);
    return Object.keys(newErrors)?.length === 0;
  };

  const handleSubmit = (e) => {
    e?.preventDefault();
    if (validateForm()) {
      // Format data for backend API
      const bookingData = {
        roomInstanceId: selectedRoom?.id,
        checkInDate: selectedDate?.toISOString()?.split('T')?.[0],
        checkOutDate: formData?.checkOut,
        guestName: formData?.guestName,
        guestEmail: formData?.guestEmail,
        guestPhone: formData?.guestPhone,
        numberOfGuests: parseInt(formData?.adults) + parseInt(formData?.children),
        specialRequests: formData?.specialRequests || ''
      };
      onSubmit(bookingData);
      onClose();
    }
  };

  const calculateNights = () => {
    if (!formData?.checkOut) return 0;
    const checkIn = selectedDate;
    const checkOut = new Date(formData.checkOut);
    const diffTime = Math.abs(checkOut - checkIn);
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  };

  const calculateTotal = () => {
    const nights = calculateNights();
    const baseRate = selectedRoom?.baseRate || 0;
    return nights * baseRate;
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-300 p-4">
      <div className="bg-card rounded-lg shadow-elevation-3 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-border">
          <div>
            <h2 className="text-xl font-semibold text-foreground">
              Quick Booking
            </h2>
            <p className="text-sm text-muted-foreground mt-1">
              Room {selectedRoom?.number} • {selectedDate?.toLocaleDateString('en-US', { 
                weekday: 'long', 
                month: 'long', 
                day: 'numeric', 
                year: 'numeric' 
              })}
            </p>
          </div>
          <Button
            variant="ghost"
            size="sm"
            iconName="X"
            onClick={onClose}
          />
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-6">
          {/* Guest Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium text-foreground">Guest Information</h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Input
                label="Guest Name"
                type="text"
                placeholder="Enter guest name"
                value={formData?.guestName}
                onChange={(e) => handleInputChange('guestName', e?.target?.value)}
                error={errors?.guestName}
                required
              />
              
              <Input
                label="Email Address"
                type="email"
                placeholder="guest@example.com"
                value={formData?.guestEmail}
                onChange={(e) => handleInputChange('guestEmail', e?.target?.value)}
                error={errors?.guestEmail}
                required
              />
            </div>

            <Input
              label="Phone Number"
              type="tel"
              placeholder="+1 (555) 123-4567"
              value={formData?.guestPhone}
              onChange={(e) => handleInputChange('guestPhone', e?.target?.value)}
              error={errors?.guestPhone}
              required
            />
          </div>

          {/* Booking Details */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium text-foreground">Booking Details</h3>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <Input
                label="Check-out Date"
                type="date"
                value={formData?.checkOut}
                onChange={(e) => handleInputChange('checkOut', e?.target?.value)}
                error={errors?.checkOut}
                min={selectedDate?.toISOString()?.split('T')?.[0]}
                required
              />
              
              <Select
                label="Adults"
                options={adultOptions}
                value={formData?.adults}
                onChange={(value) => handleInputChange('adults', value)}
              />
              
              <Select
                label="Children"
                options={childrenOptions}
                value={formData?.children}
                onChange={(value) => handleInputChange('children', value)}
              />
            </div>

            <Select
              label="Rate Type"
              options={rateTypeOptions}
              value={formData?.rateType}
              onChange={(value) => handleInputChange('rateType', value)}
            />

            <Input
              label="Special Requests"
              type="text"
              placeholder="Any special requests or notes..."
              value={formData?.specialRequests}
              onChange={(e) => handleInputChange('specialRequests', e?.target?.value)}
            />
          </div>

          {/* Booking Summary */}
          {formData?.checkOut && (
            <div className="bg-muted/50 rounded-lg p-4 space-y-2">
              <h4 className="font-medium text-foreground">Booking Summary</h4>
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Room Type:</span>
                <span className="text-foreground">{selectedRoom?.type}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Nights:</span>
                <span className="text-foreground">{calculateNights()}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Rate per night:</span>
                <span className="text-foreground">${selectedRoom?.baseRate}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Guests:</span>
                <span className="text-foreground">
                  {formData?.adults} adult{formData?.adults > 1 ? 's' : ''}
                  {formData?.children > 0 && `, ${formData?.children} child${formData?.children > 1 ? 'ren' : ''}`}
                </span>
              </div>
              <div className="border-t border-border pt-2 mt-2">
                <div className="flex justify-between font-medium">
                  <span className="text-foreground">Total Amount:</span>
                  <span className="text-foreground">${calculateTotal()}</span>
                </div>
              </div>
            </div>
          )}

          {/* Actions */}
          <div className="flex items-center justify-end space-x-3 pt-4 border-t border-border">
            <Button
              type="button"
              variant="outline"
              onClick={onClose}
            >
              Cancel
            </Button>
            <Button
              type="submit"
              variant="default"
              iconName="Calendar"
              iconPosition="left"
            >
              Create Booking
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default QuickBookingModal;