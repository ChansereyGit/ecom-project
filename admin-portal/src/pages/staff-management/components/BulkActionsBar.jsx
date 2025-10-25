import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Select from '../../../components/ui/Select';

const BulkActionsBar = ({ selectedStaff, onBulkAction, onClearSelection }) => {
  const [selectedAction, setSelectedAction] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const actionOptions = [
    { value: '', label: 'Select action...' },
    { value: 'activate', label: 'Activate Accounts' },
    { value: 'deactivate', label: 'Deactivate Accounts' },
    { value: 'update-role', label: 'Update Role' },
    { value: 'update-department', label: 'Update Department' },
    { value: 'reset-password', label: 'Reset Passwords' },
    { value: 'export', label: 'Export Data' },
    { value: 'delete', label: 'Delete Accounts' }
  ];

  const handleExecuteAction = async () => {
    if (!selectedAction || selectedStaff?.length === 0) return;

    setIsLoading(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 1000)); // Simulate API call
      onBulkAction(selectedAction, selectedStaff);
      setSelectedAction('');
    } catch (error) {
      console.error('Bulk action failed:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const getActionIcon = (action) => {
    const iconMap = {
      activate: 'CheckCircle',
      deactivate: 'XCircle',
      'update-role': 'UserCheck',
      'update-department': 'Building2',
      'reset-password': 'Key',
      export: 'Download',
      delete: 'Trash2'
    };
    return iconMap?.[action] || 'Settings';
  };

  const getActionVariant = (action) => {
    if (action === 'delete') return 'destructive';
    if (action === 'deactivate') return 'warning';
    return 'default';
  };

  if (selectedStaff?.length === 0) return null;

  return (
    <div className="bg-accent/10 border border-accent/20 rounded-lg p-4 mb-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <div className="flex items-center space-x-2">
            <Icon name="CheckSquare" size={20} className="text-accent" />
            <span className="text-sm font-medium text-foreground">
              {selectedStaff?.length} staff member{selectedStaff?.length !== 1 ? 's' : ''} selected
            </span>
          </div>

          <div className="flex items-center space-x-3">
            <Select
              placeholder="Choose bulk action"
              options={actionOptions}
              value={selectedAction}
              onChange={setSelectedAction}
              className="w-48"
            />

            <Button
              variant={getActionVariant(selectedAction)}
              size="sm"
              iconName={getActionIcon(selectedAction)}
              iconPosition="left"
              onClick={handleExecuteAction}
              disabled={!selectedAction || isLoading}
              loading={isLoading}
            >
              Execute
            </Button>
          </div>
        </div>

        <div className="flex items-center space-x-2">
          <button
            onClick={onClearSelection}
            className="text-sm text-muted-foreground hover:text-foreground transition-colors"
          >
            Clear selection
          </button>
        </div>
      </div>
      {selectedAction && (
        <div className="mt-3 p-3 bg-muted/50 rounded-md">
          <div className="flex items-start space-x-2">
            <Icon name="Info" size={16} className="text-accent mt-0.5" />
            <div className="text-sm">
              <p className="font-medium text-foreground mb-1">
                {selectedAction === 'delete' && 'Warning: This action cannot be undone'}
                {selectedAction === 'deactivate' && 'Staff members will lose system access'}
                {selectedAction === 'activate' && 'Staff members will regain system access'}
                {selectedAction === 'reset-password' && 'Temporary passwords will be sent via email'}
                {selectedAction === 'export' && 'Staff data will be exported to CSV format'}
                {(selectedAction === 'update-role' || selectedAction === 'update-department') && 'Additional configuration required'}
              </p>
              <p className="text-muted-foreground">
                This action will affect {selectedStaff?.length} staff member{selectedStaff?.length !== 1 ? 's' : ''}.
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default BulkActionsBar;