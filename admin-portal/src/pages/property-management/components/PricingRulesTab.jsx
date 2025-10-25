import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';

const PricingRulesTab = ({ property, onUpdate, isEditing }) => {
  const [activeRuleType, setActiveRuleType] = useState('seasonal');
  const [showAddForm, setShowAddForm] = useState(false);

  const ruleTypes = [
    { id: 'seasonal', label: 'Seasonal Pricing', icon: 'Calendar' },
    { id: 'occupancy', label: 'Occupancy-Based', icon: 'TrendingUp' },
    { id: 'length', label: 'Length of Stay', icon: 'Clock' },
    { id: 'special', label: 'Special Events', icon: 'Star' }
  ];

  const mockSeasonalRules = [
    {
      id: 1,
      name: 'Summer Peak Season',
      description: 'High demand summer months with premium pricing',
      startDate: '2024-06-01',
      endDate: '2024-08-31',
      adjustmentType: 'percentage',
      adjustmentValue: 25,
      roomTypes: ['all'],
      isActive: true,
      priority: 1
    },
    {
      id: 2,
      name: 'Holiday Premium',
      description: 'Christmas and New Year premium rates',
      startDate: '2024-12-20',
      endDate: '2025-01-05',
      adjustmentType: 'fixed',
      adjustmentValue: 50,
      roomTypes: ['deluxe', 'suite'],
      isActive: true,
      priority: 2
    },
    {
      id: 3,
      name: 'Off-Season Discount',
      description: 'Lower rates during quiet months',
      startDate: '2024-01-15',
      endDate: '2024-03-15',
      adjustmentType: 'percentage',
      adjustmentValue: -15,
      roomTypes: ['all'],
      isActive: true,
      priority: 3
    }
  ];

  const mockOccupancyRules = [
    {
      id: 1,
      name: 'High Occupancy Premium',
      description: 'Increase rates when occupancy exceeds 85%',
      threshold: 85,
      adjustmentType: 'percentage',
      adjustmentValue: 15,
      isActive: true
    },
    {
      id: 2,
      name: 'Low Occupancy Discount',
      description: 'Reduce rates when occupancy falls below 40%',
      threshold: 40,
      adjustmentType: 'percentage',
      adjustmentValue: -10,
      isActive: false
    }
  ];

  const mockLengthRules = [
    {
      id: 1,
      name: 'Weekly Stay Discount',
      description: '7+ nights stay discount',
      minNights: 7,
      adjustmentType: 'percentage',
      adjustmentValue: -12,
      isActive: true
    },
    {
      id: 2,
      name: 'Extended Stay Discount',
      description: '14+ nights stay discount',
      minNights: 14,
      adjustmentType: 'percentage',
      adjustmentValue: -20,
      isActive: true
    }
  ];

  const mockSpecialRules = [
    {
      id: 1,
      name: 'Conference Week Premium',
      description: 'Tech conference in city - high demand',
      startDate: '2024-11-15',
      endDate: '2024-11-22',
      adjustmentType: 'percentage',
      adjustmentValue: 35,
      isActive: true
    }
  ];

  const adjustmentTypeOptions = [
    { value: 'percentage', label: 'Percentage (%)' },
    { value: 'fixed', label: 'Fixed Amount ($)' }
  ];

  const roomTypeOptions = [
    { value: 'all', label: 'All Room Types' },
    { value: 'standard', label: 'Standard Rooms' },
    { value: 'deluxe', label: 'Deluxe Rooms' },
    { value: 'suite', label: 'Suites' }
  ];

  const PricingRuleCard = ({ rule, type }) => (
    <div className="bg-card border border-border rounded-lg p-4 hover:shadow-elevation-1 transition-shadow">
      <div className="flex items-start justify-between mb-3">
        <div className="flex-1">
          <div className="flex items-center space-x-2 mb-1">
            <h4 className="font-medium text-foreground">{rule?.name}</h4>
            <div className={`
              px-2 py-1 rounded-full text-xs font-medium
              ${rule?.isActive 
                ? 'bg-success/10 text-success' :'bg-muted text-muted-foreground'
              }
            `}>
              {rule?.isActive ? 'Active' : 'Inactive'}
            </div>
          </div>
          <p className="text-sm text-muted-foreground mb-2">{rule?.description}</p>
          
          {/* Rule-specific details */}
          <div className="flex flex-wrap gap-4 text-xs text-muted-foreground">
            {(rule?.startDate && rule?.endDate) && (
              <span className="flex items-center">
                <Icon name="Calendar" size={12} className="mr-1" />
                {new Date(rule.startDate)?.toLocaleDateString()} - {new Date(rule.endDate)?.toLocaleDateString()}
              </span>
            )}
            {rule?.minNights && (
              <span className="flex items-center">
                <Icon name="Clock" size={12} className="mr-1" />
                {rule?.minNights}+ nights
              </span>
            )}
            {rule?.threshold && (
              <span className="flex items-center">
                <Icon name="TrendingUp" size={12} className="mr-1" />
                {rule?.threshold}% occupancy
              </span>
            )}
          </div>
        </div>

        <div className="text-right ml-4">
          <div className={`
            text-lg font-semibold
            ${rule?.adjustmentValue > 0 ? 'text-error' : 'text-success'}
          `}>
            {rule?.adjustmentValue > 0 ? '+' : ''}{rule?.adjustmentValue}
            {rule?.adjustmentType === 'percentage' ? '%' : '$'}
          </div>
          <div className="text-xs text-muted-foreground">
            {rule?.adjustmentType === 'percentage' ? 'adjustment' : 'per night'}
          </div>
        </div>
      </div>

      {isEditing && (
        <div className="flex items-center justify-between pt-3 border-t border-border">
          <div className="flex items-center space-x-2">
            <Button
              variant="outline"
              size="sm"
              iconName="Edit"
            >
              Edit
            </Button>
            <Button
              variant="ghost"
              size="sm"
              iconName={rule?.isActive ? 'PauseCircle' : 'PlayCircle'}
            >
              {rule?.isActive ? 'Disable' : 'Enable'}
            </Button>
          </div>
          <Button
            variant="destructive"
            size="sm"
            iconName="Trash2"
          >
            Delete
          </Button>
        </div>
      )}
    </div>
  );

  const AddRuleForm = () => (
    <div className="bg-card border border-border rounded-lg p-6">
      <div className="flex items-center justify-between mb-4">
        <h4 className="font-medium text-foreground">
          Add New {ruleTypes?.find(t => t?.id === activeRuleType)?.label} Rule
        </h4>
        <Button
          variant="ghost"
          size="sm"
          iconName="X"
          onClick={() => setShowAddForm(false)}
        />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Input
          label="Rule Name"
          type="text"
          placeholder="e.g., Summer Peak Season"
          required
        />

        <Select
          label="Adjustment Type"
          options={adjustmentTypeOptions}
          placeholder="Select adjustment type"
          required
        />

        <Input
          label="Adjustment Value"
          type="number"
          placeholder="25"
          step="0.01"
          required
        />

        {(activeRuleType === 'seasonal' || activeRuleType === 'special') && (
          <>
            <Input
              label="Start Date"
              type="date"
              required
            />
            <Input
              label="End Date"
              type="date"
              required
            />
          </>
        )}

        {activeRuleType === 'occupancy' && (
          <Input
            label="Occupancy Threshold (%)"
            type="number"
            placeholder="85"
            min="0"
            max="100"
            required
          />
        )}

        {activeRuleType === 'length' && (
          <Input
            label="Minimum Nights"
            type="number"
            placeholder="7"
            min="1"
            required
          />
        )}

        <Select
          label="Apply to Room Types"
          options={roomTypeOptions}
          placeholder="Select room types"
          required
        />

        <div className="md:col-span-2">
          <Input
            label="Description"
            type="text"
            placeholder="Brief description of this pricing rule"
          />
        </div>
      </div>

      <div className="flex justify-end space-x-2 mt-6">
        <Button
          variant="outline"
          onClick={() => setShowAddForm(false)}
        >
          Cancel
        </Button>
        <Button
          variant="default"
          iconName="Plus"
          iconPosition="left"
        >
          Add Rule
        </Button>
      </div>
    </div>
  );

  const getRulesForType = (type) => {
    switch (type) {
      case 'seasonal':
        return mockSeasonalRules;
      case 'occupancy':
        return mockOccupancyRules;
      case 'length':
        return mockLengthRules;
      case 'special':
        return mockSpecialRules;
      default:
        return [];
    }
  };

  const currentRules = getRulesForType(activeRuleType);

  return (
    <div className="p-6">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h3 className="text-lg font-medium text-foreground flex items-center">
              <Icon name="DollarSign" size={20} className="mr-2" />
              Pricing Rules & Strategies
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              Configure dynamic pricing rules for {property?.name}
            </p>
          </div>

          {isEditing && (
            <Button
              variant="default"
              iconName="Plus"
              iconPosition="left"
              onClick={() => setShowAddForm(true)}
            >
              Add Rule
            </Button>
          )}
        </div>

        {/* Rule Type Tabs */}
        <div className="flex flex-wrap gap-2 mb-6 p-1 bg-muted rounded-lg">
          {ruleTypes?.map((type) => (
            <button
              key={type?.id}
              onClick={() => setActiveRuleType(type?.id)}
              className={`
                flex items-center space-x-2 px-4 py-2 rounded-md text-sm font-medium transition-colors
                ${activeRuleType === type?.id
                  ? 'bg-background text-foreground shadow-sm'
                  : 'text-muted-foreground hover:text-foreground hover:bg-background/50'
                }
              `}
            >
              <Icon name={type?.icon} size={16} />
              <span>{type?.label}</span>
              <span className="text-xs bg-muted-foreground/20 px-1.5 py-0.5 rounded-full">
                {getRulesForType(type?.id)?.length}
              </span>
            </button>
          ))}
        </div>

        <div className="space-y-4">
          {showAddForm && <AddRuleForm />}
          
          {currentRules?.length === 0 ? (
            <div className="text-center py-12">
              <Icon name="DollarSign" size={48} className="mx-auto text-muted-foreground mb-4" />
              <h4 className="text-lg font-medium text-foreground mb-2">
                No {ruleTypes?.find(t => t?.id === activeRuleType)?.label} Rules
              </h4>
              <p className="text-muted-foreground mb-4">
                Create your first pricing rule to optimize revenue
              </p>
              {isEditing && (
                <Button
                  variant="default"
                  iconName="Plus"
                  iconPosition="left"
                  onClick={() => setShowAddForm(true)}
                >
                  Add Rule
                </Button>
              )}
            </div>
          ) : (
            currentRules?.map((rule) => (
              <PricingRuleCard key={rule?.id} rule={rule} type={activeRuleType} />
            ))
          )}
        </div>

        {!isEditing && currentRules?.length > 0 && (
          <div className="mt-6 p-4 bg-muted/50 rounded-lg border border-border">
            <div className="flex items-center text-sm text-muted-foreground">
              <Icon name="Info" size={16} className="mr-2" />
              Enable edit mode to create, modify, or delete pricing rules
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default PricingRulesTab;