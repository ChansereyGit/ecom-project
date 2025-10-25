import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';
import { Checkbox } from '../../../components/ui/Checkbox';

const AddStaffModal = ({ isOpen, onClose, onSave }) => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    role: '',
    department: '',
    employeeId: '',
    hireDate: '',
    permissions: {
      bookingManagement: { read: false, write: false, delete: false },
      propertySettings: { read: false, write: false, delete: false },
      financialReports: { read: false, write: false, delete: false },
      guestData: { read: false, write: false, delete: false },
      staffManagement: { read: false, write: false, delete: false }
    }
  });

  const [activeTab, setActiveTab] = useState('basic');
  const [isLoading, setIsLoading] = useState(false);

  const roleOptions = [
    { value: 'Hotel Manager', label: 'Hotel Manager' },
    { value: 'Front Desk', label: 'Front Desk' },
    { value: 'Revenue Manager', label: 'Revenue Manager' },
    { value: 'Administrative', label: 'Administrative' },
    { value: 'Housekeeping', label: 'Housekeeping' },
    { value: 'Maintenance', label: 'Maintenance' }
  ];

  const departmentOptions = [
    { value: 'Management', label: 'Management' },
    { value: 'Front Office', label: 'Front Office' },
    { value: 'Revenue', label: 'Revenue' },
    { value: 'Administration', label: 'Administration' },
    { value: 'Housekeeping', label: 'Housekeeping' },
    { value: 'Maintenance', label: 'Maintenance' }
  ];

  const permissionModules = [
    { key: 'bookingManagement', label: 'Booking Management', description: 'View and manage hotel bookings' },
    { key: 'propertySettings', label: 'Property Settings', description: 'Configure hotel properties and rooms' },
    { key: 'financialReports', label: 'Financial Reports', description: 'Access revenue and financial data' },
    { key: 'guestData', label: 'Guest Data', description: 'Manage guest profiles and history' },
    { key: 'staffManagement', label: 'Staff Management', description: 'Manage staff accounts and permissions' }
  ];

  const tabs = [
    { id: 'basic', label: 'Basic Info', icon: 'User' },
    { id: 'permissions', label: 'Permissions', icon: 'Shield' }
  ];

  const handleInputChange = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handlePermissionChange = (module, permission, checked) => {
    setFormData(prev => ({
      ...prev,
      permissions: {
        ...prev?.permissions,
        [module]: {
          ...prev?.permissions?.[module],
          [permission]: checked
        }
      }
    }));
  };

  const handleSubmit = async (e) => {
    e?.preventDefault();
    setIsLoading(true);
    
    try {
      // Generate employee ID if not provided
      const employeeId = formData?.employeeId || `EMP${Date.now()?.toString()?.slice(-6)}`;
      
      const newStaff = {
        ...formData,
        employeeId,
        id: Date.now(),
        status: 'pending',
        avatar: null,
        avatarAlt: `Profile photo of ${formData?.name}`,
        lastLogin: 'Never',
        createdAt: new Date()?.toISOString()
      };

      await new Promise(resolve => setTimeout(resolve, 1000)); // Simulate API call
      onSave(newStaff);
      onClose();
      
      // Reset form
      setFormData({
        name: '',
        email: '',
        phone: '',
        role: '',
        department: '',
        employeeId: '',
        hireDate: '',
        permissions: {
          bookingManagement: { read: false, write: false, delete: false },
          propertySettings: { read: false, write: false, delete: false },
          financialReports: { read: false, write: false, delete: false },
          guestData: { read: false, write: false, delete: false },
          staffManagement: { read: false, write: false, delete: false }
        }
      });
      setActiveTab('basic');
    } catch (error) {
      console.error('Error creating staff:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const renderBasicInfoTab = () => (
    <div className="space-y-4">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Input
          label="Full Name"
          type="text"
          placeholder="Enter full name"
          value={formData?.name}
          onChange={(e) => handleInputChange('name', e?.target?.value)}
          required
        />

        <Input
          label="Email Address"
          type="email"
          placeholder="Enter email address"
          value={formData?.email}
          onChange={(e) => handleInputChange('email', e?.target?.value)}
          required
        />

        <Input
          label="Phone Number"
          type="tel"
          placeholder="Enter phone number"
          value={formData?.phone}
          onChange={(e) => handleInputChange('phone', e?.target?.value)}
          required
        />

        <Input
          label="Employee ID"
          type="text"
          placeholder="Auto-generated if empty"
          value={formData?.employeeId}
          onChange={(e) => handleInputChange('employeeId', e?.target?.value)}
          description="Leave empty to auto-generate"
        />

        <Select
          label="Role"
          placeholder="Select role"
          options={roleOptions}
          value={formData?.role}
          onChange={(value) => handleInputChange('role', value)}
          required
        />

        <Select
          label="Department"
          placeholder="Select department"
          options={departmentOptions}
          value={formData?.department}
          onChange={(value) => handleInputChange('department', value)}
          required
        />

        <Input
          label="Hire Date"
          type="date"
          value={formData?.hireDate}
          onChange={(e) => handleInputChange('hireDate', e?.target?.value)}
          required
          className="md:col-span-2"
        />
      </div>
    </div>
  );

  const renderPermissionsTab = () => (
    <div className="space-y-6">
      <div>
        <h3 className="text-sm font-medium text-foreground mb-2">System Permissions</h3>
        <p className="text-xs text-muted-foreground mb-4">
          Configure what this staff member can access and modify in the system.
        </p>
      </div>

      <div className="space-y-4">
        {permissionModules?.map((module) => (
          <div key={module.key} className="border border-border rounded-lg p-4">
            <div className="mb-3">
              <h4 className="text-sm font-medium text-foreground">{module.label}</h4>
              <p className="text-xs text-muted-foreground">{module.description}</p>
            </div>
            
            <div className="flex items-center space-x-6">
              <Checkbox
                label="Read"
                checked={formData?.permissions?.[module.key]?.read || false}
                onChange={(e) => handlePermissionChange(module.key, 'read', e?.target?.checked)}
              />
              
              <Checkbox
                label="Write"
                checked={formData?.permissions?.[module.key]?.write || false}
                onChange={(e) => handlePermissionChange(module.key, 'write', e?.target?.checked)}
              />
              
              <Checkbox
                label="Delete"
                checked={formData?.permissions?.[module.key]?.delete || false}
                onChange={(e) => handlePermissionChange(module.key, 'delete', e?.target?.checked)}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-500 p-4">
      <div className="bg-card border border-border rounded-lg w-full max-w-4xl max-h-[90vh] flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-lg font-semibold text-foreground">Add New Staff Member</h2>
          <button
            onClick={onClose}
            className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-md micro-press"
          >
            <Icon name="X" size={20} />
          </button>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-border">
          {tabs?.map((tab) => (
            <button
              key={tab?.id}
              onClick={() => setActiveTab(tab?.id)}
              className={`
                flex items-center space-x-2 px-6 py-3 text-sm font-medium border-b-2 transition-colors
                ${activeTab === tab?.id 
                  ? 'border-primary text-primary' :'border-transparent text-muted-foreground hover:text-foreground'
                }
              `}
            >
              <Icon name={tab?.icon} size={16} />
              <span>{tab?.label}</span>
            </button>
          ))}
        </div>

        {/* Form Content */}
        <form onSubmit={handleSubmit} className="flex-1 flex flex-col">
          <div className="flex-1 p-6 overflow-y-auto">
            {activeTab === 'basic' && renderBasicInfoTab()}
            {activeTab === 'permissions' && renderPermissionsTab()}
          </div>

          {/* Footer */}
          <div className="flex items-center justify-end space-x-3 p-6 border-t border-border">
            <Button
              type="button"
              variant="outline"
              onClick={onClose}
              disabled={isLoading}
            >
              Cancel
            </Button>
            <Button
              type="submit"
              loading={isLoading}
              iconName="Plus"
              iconPosition="left"
            >
              Add Staff Member
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AddStaffModal;