import React, { useState, useEffect } from 'react';
import SidebarNavigation from '../../components/ui/SidebarNavigation';
import UserProfileDropdown from '../../components/ui/UserProfileDropdown';
import NotificationIndicator from '../../components/ui/NotificationIndicator';
import PropertyListPanel from './components/PropertyListPanel';
import PropertyDetailsPanel from './components/PropertyDetailsPanel';
import CreatePropertyModal from './components/CreatePropertyModal';
import Icon from '../../components/AppIcon';
import { hotelsAPI } from '../../services/api';

const PropertyManagement = () => {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const [selectedProperty, setSelectedProperty] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [properties, setProperties] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // Mock properties data
  const mockProperties = [
    {
      id: 1,
      name: 'Grand Plaza Hotel',
      description: 'Luxury hotel in the heart of downtown with premium amenities and exceptional service',
      location: 'New York, NY',
      address: '123 Broadway Avenue',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'US',
      phone: '+1 (555) 123-4567',
      email: 'info@grandplaza.com',
      website: 'https://www.grandplaza.com',
      rating: 5,
      status: 'active',
      totalRooms: 150,
      checkInTime: '15:00',
      checkOutTime: '11:00',
      currency: 'USD',
      createdAt: '2024-01-15T10:00:00Z'
    },
    {
      id: 2,
      name: 'Seaside Resort & Spa',
      description: 'Beachfront resort offering relaxation and luxury with ocean views',
      location: 'Miami, FL',
      address: '456 Ocean Drive',
      city: 'Miami',
      state: 'FL',
      zipCode: '33139',
      country: 'US',
      phone: '+1 (555) 987-6543',
      email: 'reservations@seasideresort.com',
      website: 'https://www.seasideresort.com',
      rating: 4,
      status: 'active',
      totalRooms: 200,
      checkInTime: '16:00',
      checkOutTime: '12:00',
      currency: 'USD',
      createdAt: '2024-02-20T14:30:00Z'
    },
    {
      id: 3,
      name: 'Mountain View Lodge',
      description: 'Cozy mountain retreat perfect for nature lovers and outdoor enthusiasts',
      location: 'Denver, CO',
      address: '789 Mountain Trail',
      city: 'Denver',
      state: 'CO',
      zipCode: '80202',
      country: 'US',
      phone: '+1 (555) 456-7890',
      email: 'info@mountainviewlodge.com',
      website: 'https://www.mountainviewlodge.com',
      rating: 3,
      status: 'maintenance',
      totalRooms: 75,
      checkInTime: '15:00',
      checkOutTime: '11:00',
      currency: 'USD',
      createdAt: '2024-03-10T09:15:00Z'
    },
    {
      id: 4,
      name: 'Urban Business Hotel',
      description: 'Modern business hotel with state-of-the-art conference facilities',
      location: 'Chicago, IL',
      address: '321 Business District',
      city: 'Chicago',
      state: 'IL',
      zipCode: '60601',
      country: 'US',
      phone: '+1 (555) 234-5678',
      email: 'bookings@urbanbusiness.com',
      website: 'https://www.urbanbusiness.com',
      rating: 4,
      status: 'inactive',
      totalRooms: 120,
      checkInTime: '14:00',
      checkOutTime: '12:00',
      currency: 'USD',
      createdAt: '2024-04-05T16:45:00Z'
    }
  ];

  // Load hotels from API
  useEffect(() => {
    loadHotels();
  }, []);

  const loadHotels = async () => {
    try {
      setIsLoading(true);
      const response = await hotelsAPI.getAll();
      
      if (response.success) {
        setProperties(response.data || []);
        if (response.data && response.data.length > 0) {
          setSelectedProperty(response.data[0]);
        }
      }
    } catch (error) {
      console.error('Error loading hotels:', error);
      alert('Failed to load hotels. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSelectProperty = (property) => {
    setSelectedProperty(property);
    setIsEditing(false);
  };

  const handleCreateProperty = async (newProperty) => {
    // Reload hotels list to get the newly created hotel
    await loadHotels();
    setShowCreateModal(false);
    
    // Select the newly created property
    if (newProperty) {
      setSelectedProperty(newProperty);
    }
  };

  const handleUpdateProperty = async (updatedProperty) => {
    try {
      const response = await hotelsAPI.update(updatedProperty.id, updatedProperty);
      
      if (response.success) {
        setProperties(prev => 
          prev?.map(p => p?.id === updatedProperty?.id ? response.data : p)
        );
        setSelectedProperty(response.data);
        alert('Property updated successfully!');
      }
    } catch (error) {
      console.error('Error updating property:', error);
      throw error; // Re-throw to let the caller handle it
    }
  };

  const handleDeleteProperty = async (propertyId) => {
    if (!window.confirm('Are you sure you want to delete this property? This action cannot be undone.')) {
      return;
    }

    try {
      await hotelsAPI.delete(propertyId);
      setProperties(prev => prev?.filter(p => p?.id !== propertyId));
      
      if (selectedProperty?.id === propertyId) {
        const remainingProperties = properties?.filter(p => p?.id !== propertyId);
        setSelectedProperty(remainingProperties[0] || null);
      }
      
      alert('Property deleted successfully!');
    } catch (error) {
      console.error('Error deleting property:', error);
      alert('Failed to delete property: ' + error.message);
    }
  };

  const handleToggleEdit = () => {
    setIsEditing(!isEditing);
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Sidebar Navigation */}
      <SidebarNavigation 
        isCollapsed={sidebarCollapsed}
        onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
      />

      {/* Main Content */}
      <div className={`transition-all duration-300 ${sidebarCollapsed ? 'md:ml-20' : 'md:ml-240'}`}>
        {/* Top Header */}
        <header className="bg-card border-b border-border px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center">
                  <Icon name="Building2" size={20} color="white" />
                </div>
                <div>
                  <h1 className="text-xl font-semibold text-foreground">Property Management</h1>
                  <p className="text-sm text-muted-foreground">
                    Manage hotel properties and room inventory
                  </p>
                </div>
              </div>
            </div>

            <div className="flex items-center space-x-4">
              <NotificationIndicator 
                onMarkAsRead={() => {}}
                onMarkAllAsRead={() => {}}
              />
              <UserProfileDropdown 
                onLogout={() => {}}
              />
            </div>
          </div>
        </header>

        {/* Content Area */}
        <div className="flex h-[calc(100vh-80px)]">
          {/* Property List Panel */}
          <PropertyListPanel
            properties={properties}
            selectedProperty={selectedProperty}
            onSelectProperty={handleSelectProperty}
            onCreateProperty={() => setShowCreateModal(true)}
            searchQuery={searchQuery}
            onSearchChange={setSearchQuery}
          />

          {/* Property Details Panel */}
          <PropertyDetailsPanel
            property={selectedProperty}
            onUpdateProperty={handleUpdateProperty}
            onDeleteProperty={handleDeleteProperty}
            isEditing={isEditing}
            onToggleEdit={handleToggleEdit}
          />
        </div>
      </div>

      {/* Create Property Modal */}
      <CreatePropertyModal
        isOpen={showCreateModal}
        onClose={() => setShowCreateModal(false)}
        onCreateProperty={handleCreateProperty}
      />
    </div>
  );
};

export default PropertyManagement;