import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';

const PropertyListPanel = ({ 
  properties, 
  selectedProperty, 
  onSelectProperty, 
  onCreateProperty,
  searchQuery,
  onSearchChange 
}) => {
  const getStatusColor = (status) => {
    const statusLower = status?.toLowerCase();
    switch (statusLower) {
      case 'active':
        return 'bg-success text-success-foreground';
      case 'maintenance':
        return 'bg-warning text-warning-foreground';
      case 'inactive':
        return 'bg-error text-error-foreground';
      default:
        return 'bg-muted text-muted-foreground';
    }
  };

  const getStatusIcon = (status) => {
    const statusLower = status?.toLowerCase();
    switch (statusLower) {
      case 'active':
        return 'CheckCircle';
      case 'maintenance':
        return 'Wrench';
      case 'inactive':
        return 'XCircle';
      default:
        return 'Circle';
    }
  };

  const filteredProperties = properties?.filter(property =>
    property?.name?.toLowerCase()?.includes(searchQuery?.toLowerCase()) ||
    property?.location?.toLowerCase()?.includes(searchQuery?.toLowerCase())
  );

  return (
    <div className="w-full lg:w-80 bg-card border-r border-border flex flex-col h-full">
      {/* Header */}
      <div className="p-6 border-b border-border">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-foreground">Properties</h2>
          <Button
            variant="default"
            size="sm"
            iconName="Plus"
            iconPosition="left"
            onClick={onCreateProperty}
          >
            Add New
          </Button>
        </div>

        {/* Search */}
        <Input
          type="search"
          placeholder="Search properties..."
          value={searchQuery}
          onChange={(e) => onSearchChange(e?.target?.value)}
          className="w-full"
        />
      </div>
      {/* Properties List */}
      <div className="flex-1 overflow-y-auto">
        {filteredProperties?.length === 0 ? (
          <div className="p-6 text-center">
            <Icon name="Building2" size={32} className="mx-auto text-muted-foreground mb-2" />
            <p className="text-sm text-muted-foreground">
              {searchQuery ? 'No properties found' : 'No properties yet'}
            </p>
          </div>
        ) : (
          <div className="p-4 space-y-2">
            {filteredProperties?.map((property) => (
              <button
                key={property?.id}
                onClick={() => onSelectProperty(property)}
                className={`
                  w-full p-4 rounded-lg border text-left transition-all duration-150 micro-press
                  ${selectedProperty?.id === property?.id
                    ? 'border-primary bg-primary/5 shadow-elevation-1'
                    : 'border-border hover:border-primary/50 hover:bg-muted/50'
                  }
                `}
              >
                <div className="flex items-start justify-between mb-2">
                  <h3 className="font-medium text-foreground truncate pr-2">
                    {property?.name}
                  </h3>
                  <div className={`
                    px-2 py-1 rounded-full text-xs font-medium flex items-center space-x-1 flex-shrink-0
                    ${getStatusColor(property?.status)}
                  `}>
                    <Icon name={getStatusIcon(property?.status)} size={12} />
                    <span className="capitalize">{property?.status}</span>
                  </div>
                </div>

                <div className="space-y-1">
                  <div className="flex items-center text-xs text-muted-foreground">
                    <Icon name="MapPin" size={12} className="mr-1" />
                    <span className="truncate">{property?.location}</span>
                  </div>
                  <div className="flex items-center text-xs text-muted-foreground">
                    <Icon name="Bed" size={12} className="mr-1" />
                    <span>{property?.totalRooms} rooms</span>
                    <span className="mx-2">•</span>
                    <Icon name="Star" size={12} className="mr-1" />
                    <span>{property?.rating} stars</span>
                  </div>
                </div>
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default PropertyListPanel;