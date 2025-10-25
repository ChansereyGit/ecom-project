import React from 'react';
import Icon from '../../../components/AppIcon';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';

const StaffFilters = ({ 
  searchTerm, 
  onSearchChange, 
  selectedRole, 
  onRoleChange, 
  selectedDepartment, 
  onDepartmentChange,
  selectedStatus,
  onStatusChange,
  onClearFilters 
}) => {
  const roleOptions = [
    { value: '', label: 'All Roles' },
    { value: 'Hotel Manager', label: 'Hotel Manager' },
    { value: 'Front Desk', label: 'Front Desk' },
    { value: 'Revenue Manager', label: 'Revenue Manager' },
    { value: 'Administrative', label: 'Administrative' },
    { value: 'Housekeeping', label: 'Housekeeping' },
    { value: 'Maintenance', label: 'Maintenance' }
  ];

  const departmentOptions = [
    { value: '', label: 'All Departments' },
    { value: 'Management', label: 'Management' },
    { value: 'Front Office', label: 'Front Office' },
    { value: 'Revenue', label: 'Revenue' },
    { value: 'Administration', label: 'Administration' },
    { value: 'Housekeeping', label: 'Housekeeping' },
    { value: 'Maintenance', label: 'Maintenance' }
  ];

  const statusOptions = [
    { value: '', label: 'All Status' },
    { value: 'active', label: 'Active' },
    { value: 'inactive', label: 'Inactive' },
    { value: 'pending', label: 'Pending' }
  ];

  const hasActiveFilters = searchTerm || selectedRole || selectedDepartment || selectedStatus;

  return (
    <div className="bg-card border border-border rounded-lg p-4 space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-medium text-foreground flex items-center">
          <Icon name="Filter" size={16} className="mr-2" />
          Filters
        </h3>
        {hasActiveFilters && (
          <button
            onClick={onClearFilters}
            className="text-xs text-accent hover:text-accent/80 transition-colors"
          >
            Clear all
          </button>
        )}
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Input
          type="search"
          placeholder="Search staff..."
          value={searchTerm}
          onChange={(e) => onSearchChange(e?.target?.value)}
          className="w-full"
        />

        <Select
          placeholder="Filter by role"
          options={roleOptions}
          value={selectedRole}
          onChange={onRoleChange}
        />

        <Select
          placeholder="Filter by department"
          options={departmentOptions}
          value={selectedDepartment}
          onChange={onDepartmentChange}
        />

        <Select
          placeholder="Filter by status"
          options={statusOptions}
          value={selectedStatus}
          onChange={onStatusChange}
        />
      </div>
    </div>
  );
};

export default StaffFilters;