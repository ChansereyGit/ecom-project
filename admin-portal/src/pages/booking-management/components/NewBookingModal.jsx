import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';

const NewBookingModal = ({ isOpen, onClose, onSubmit }) => {
  const [formData, setFormData] = useState({
    // Guest Information
    guestName: '',
    guestEmail: '',
    guestPhone: '',
    guestAddress: '',
    
    // Booking Details
    checkIn: '',
    checkOut: '',
    roomType: '',
    roomNumber: '',
    guests: 1,
    
    // Special Requests
    specialRequests: '',
    
    // Payment
    paymentMethod: '',
    paymentStatus: 'pending'
  });

  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const roomTypeOptions = [
    { value: '', label: 'Select Room Type' },
    { value: 'standard', label: 'Standard Room - $120/night' },
    { value: 'deluxe', label: 'Deluxe Room - $180/night' },
    { value: 'suite', label: 'Suite - $250/night' },
    { value: 'presidential', label: 'Presidential Suite - $450/night' },
    { value: 'family', label: 'Family Room - $200/night' }
  ];

  const roomNumberOptions = [
    { value: '', label: 'Select Room Number' },
    { value: '101', label: 'Room 101' },
    { value: '102', label: 'Room 102' },
    { value: '201', label: 'Room 201' },
    { value: '202', label: 'Room 202' },
    { value: '301', label: 'Room 301' },
    { value: '302', label: 'Room 302' }
  ];

  const paymentMethodOptions = [
    { value: '', label: 'Select Payment Method' },
    { value: 'credit-card', label: 'Credit Card' },
    { value: 'debit-card', label: 'Debit Card' },
    { value: 'cash', label: 'Cash' },
    { value: 'bank-transfer', label: 'Bank Transfer' }
  ];

  const guestCountOptions = [
    { value: 1, label: '1 Guest' },
    { value: 2, label: '2 Guests' },
    { value: 3, label: '3 Guests' },
    { value: 4, label: '4 Guests' },
    { value: 5, label: '5 Guests' },
    { value: 6, label: '6 Guests' }
  ];

  const handleInputChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors?.[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  const calculateTotal = () => {
    if (!formData?.checkIn || !formData?.checkOut || !formData?.roomType) return 0;
    
    const checkIn = new Date(formData.checkIn);
    const checkOut = new Date(formData.checkOut);
    const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
    
    const rates = {
      standard: 120,
      deluxe: 180,
      suite: 250,
      presidential: 450,
      family: 200
    };
    
    return nights * (rates?.[formData?.roomType] || 0);
  };

  const validateForm = () => {
    const newErrors = {};
    
    if (!formData?.guestName?.trim()) newErrors.guestName = 'Guest name is required';
    if (!formData?.guestEmail?.trim()) newErrors.guestEmail = 'Email is required';
    if (!formData?.guestPhone?.trim()) newErrors.guestPhone = 'Phone number is required';
    if (!formData?.checkIn) newErrors.checkIn = 'Check-in date is required';
    if (!formData?.checkOut) newErrors.checkOut = 'Check-out date is required';
    if (!formData?.roomType) newErrors.roomType = 'Room type is required';
    if (!formData?.roomNumber) newErrors.roomNumber = 'Room number is required';
    if (!formData?.paymentMethod) newErrors.paymentMethod = 'Payment method is required';
    
    if (formData?.checkIn && formData?.checkOut) {
      const checkIn = new Date(formData.checkIn);
      const checkOut = new Date(formData.checkOut);
      if (checkOut <= checkIn) {
        newErrors.checkOut = 'Check-out must be after check-in date';
      }
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors)?.length === 0;
  };

  const handleSubmit = async (e) => {
    e?.preventDefault();
    
    if (!validateForm()) return;
    
    setIsSubmitting(true);
    
    try {
      const bookingData = {
        ...formData,
        total: calculateTotal(),
        id: `BK${Date.now()}`,
        status: 'confirmed',
        createdAt: new Date()?.toISOString()
      };
      
      await onSubmit(bookingData);
      onClose();
      
      // Reset form
      setFormData({
        guestName: '',
        guestEmail: '',
        guestPhone: '',
        guestAddress: '',
        checkIn: '',
        checkOut: '',
        roomType: '',
        roomNumber: '',
        guests: 1,
        specialRequests: '',
        paymentMethod: '',
        paymentStatus: 'pending'
      });
    } catch (error) {
      console.error('Error creating booking:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-500 p-4">
      <div className="bg-card border border-border rounded-lg w-full max-w-4xl max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-border">
          <h2 className="text-xl font-semibold text-foreground">Create New Booking</h2>
          <Button
            variant="ghost"
            size="sm"
            onClick={onClose}
            iconName="X"
          />
        </div>

        {/* Content */}
        <div className="overflow-y-auto max-h-[calc(90vh-140px)]">
          <form onSubmit={handleSubmit} className="p-6 space-y-6">
            {/* Guest Information */}
            <div>
              <h3 className="text-lg font-medium text-foreground mb-4">Guest Information</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <Input
                  label="Full Name"
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
                <Input
                  label="Phone Number"
                  type="tel"
                  placeholder="+1 (555) 123-4567"
                  value={formData?.guestPhone}
                  onChange={(e) => handleInputChange('guestPhone', e?.target?.value)}
                  error={errors?.guestPhone}
                  required
                />
                <Input
                  label="Address"
                  type="text"
                  placeholder="Enter address (optional)"
                  value={formData?.guestAddress}
                  onChange={(e) => handleInputChange('guestAddress', e?.target?.value)}
                />
              </div>
            </div>

            {/* Booking Details */}
            <div>
              <h3 className="text-lg font-medium text-foreground mb-4">Booking Details</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <Input
                  label="Check-in Date"
                  type="date"
                  value={formData?.checkIn}
                  onChange={(e) => handleInputChange('checkIn', e?.target?.value)}
                  error={errors?.checkIn}
                  required
                />
                <Input
                  label="Check-out Date"
                  type="date"
                  value={formData?.checkOut}
                  onChange={(e) => handleInputChange('checkOut', e?.target?.value)}
                  error={errors?.checkOut}
                  required
                />
                <Select
                  label="Number of Guests"
                  options={guestCountOptions}
                  value={formData?.guests}
                  onChange={(value) => handleInputChange('guests', value)}
                />
                <Select
                  label="Room Type"
                  options={roomTypeOptions}
                  value={formData?.roomType}
                  onChange={(value) => handleInputChange('roomType', value)}
                  error={errors?.roomType}
                  required
                />
                <Select
                  label="Room Number"
                  options={roomNumberOptions}
                  value={formData?.roomNumber}
                  onChange={(value) => handleInputChange('roomNumber', value)}
                  error={errors?.roomNumber}
                  required
                />
                <Select
                  label="Payment Method"
                  options={paymentMethodOptions}
                  value={formData?.paymentMethod}
                  onChange={(value) => handleInputChange('paymentMethod', value)}
                  error={errors?.paymentMethod}
                  required
                />
              </div>
            </div>

            {/* Special Requests */}
            <div>
              <h3 className="text-lg font-medium text-foreground mb-4">Special Requests</h3>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Additional Notes
                  </label>
                  <textarea
                    className="w-full px-3 py-2 border border-border rounded-md bg-input text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent resize-none"
                    rows={3}
                    placeholder="Any special requests or notes..."
                    value={formData?.specialRequests}
                    onChange={(e) => handleInputChange('specialRequests', e?.target?.value)}
                  />
                </div>
              </div>
            </div>

            {/* Booking Summary */}
            {(formData?.checkIn && formData?.checkOut && formData?.roomType) && (
              <div className="bg-muted/50 rounded-lg p-4">
                <h3 className="text-lg font-medium text-foreground mb-3">Booking Summary</h3>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Check-in:</span>
                    <span className="text-foreground">
                      {new Date(formData.checkIn)?.toLocaleDateString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Check-out:</span>
                    <span className="text-foreground">
                      {new Date(formData.checkOut)?.toLocaleDateString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Nights:</span>
                    <span className="text-foreground">
                      {Math.ceil((new Date(formData.checkOut) - new Date(formData.checkIn)) / (1000 * 60 * 60 * 24))}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Room:</span>
                    <span className="text-foreground">
                      {roomTypeOptions?.find(opt => opt?.value === formData?.roomType)?.label}
                    </span>
                  </div>
                  <div className="border-t border-border pt-2 mt-2">
                    <div className="flex justify-between font-semibold">
                      <span className="text-foreground">Total Amount:</span>
                      <span className="text-foreground">
                        ${calculateTotal()?.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </form>
        </div>

        {/* Footer */}
        <div className="flex items-center justify-end space-x-3 px-6 py-4 border-t border-border">
          <Button
            variant="outline"
            onClick={onClose}
            disabled={isSubmitting}
          >
            Cancel
          </Button>
          <Button
            variant="default"
            onClick={handleSubmit}
            loading={isSubmitting}
            iconName="Plus"
            iconPosition="left"
          >
            Create Booking
          </Button>
        </div>
      </div>
    </div>
  );
};

export default NewBookingModal;