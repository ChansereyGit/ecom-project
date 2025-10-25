import React, { useState, useEffect } from 'react';
import { Helmet } from 'react-helmet';
import SidebarNavigation from '../../components/ui/SidebarNavigation';
import UserProfileDropdown from '../../components/ui/UserProfileDropdown';
import NotificationIndicator from '../../components/ui/NotificationIndicator';
import Icon from '../../components/AppIcon';
import Button from '../../components/ui/Button';
import { Checkbox } from '../../components/ui/Checkbox';

// Import components
import StaffCard from './components/StaffCard';
import StaffFilters from './components/StaffFilters';
import StaffDetailsPanel from './components/StaffDetailsPanel';
import AddStaffModal from './components/AddStaffModal';
import BulkActionsBar from './components/BulkActionsBar';
import StaffStats from './components/StaffStats';

const StaffManagement = () => {
  const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);
  const [selectedStaff, setSelectedStaff] = useState(null);
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedRole, setSelectedRole] = useState('');
  const [selectedDepartment, setSelectedDepartment] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('');
  const [bulkSelectedStaff, setBulkSelectedStaff] = useState([]);
  const [staffData, setStaffData] = useState([]);

  // Mock staff data
  const mockStaffData = [
  {
    id: 1,
    name: 'Sarah Johnson',
    email: 'sarah.johnson@hoteladmin.com',
    phone: '+1 (555) 123-4567',
    role: 'Hotel Manager',
    department: 'Management',
    employeeId: 'EMP001',
    status: 'active',
    hireDate: '2022-03-15',
    lastLogin: '2 hours ago',
    avatar: "https://images.unsplash.com/photo-1702089050621-62646a2b748f",
    avatarAlt: 'Professional headshot of Sarah Johnson, a woman with shoulder-length brown hair wearing a navy blue blazer'
  },
  {
    id: 2,
    name: 'Michael Chen',
    email: 'michael.chen@hoteladmin.com',
    phone: '+1 (555) 234-5678',
    role: 'Front Desk',
    department: 'Front Office',
    employeeId: 'EMP002',
    status: 'active',
    hireDate: '2023-01-20',
    lastLogin: '1 hour ago',
    avatar: "https://images.unsplash.com/photo-1537107041341-713aaa2a234c",
    avatarAlt: 'Professional headshot of Michael Chen, an Asian man with short black hair wearing a white dress shirt'
  },
  {
    id: 3,
    name: 'Emily Rodriguez',
    email: 'emily.rodriguez@hoteladmin.com',
    phone: '+1 (555) 345-6789',
    role: 'Revenue Manager',
    department: 'Revenue',
    employeeId: 'EMP003',
    status: 'active',
    hireDate: '2022-08-10',
    lastLogin: '30 minutes ago',
    avatar: "https://images.unsplash.com/photo-1635426383245-b3be1d70ce0e",
    avatarAlt: 'Professional headshot of Emily Rodriguez, a Hispanic woman with long dark hair wearing a burgundy blouse'
  },
  {
    id: 4,
    name: 'David Thompson',
    email: 'david.thompson@hoteladmin.com',
    phone: '+1 (555) 456-7890',
    role: 'Administrative',
    department: 'Administration',
    employeeId: 'EMP004',
    status: 'inactive',
    hireDate: '2021-11-05',
    lastLogin: '2 days ago',
    avatar: "https://images.unsplash.com/photo-1674345353728-808da61c917b",
    avatarAlt: 'Professional headshot of David Thompson, a Caucasian man with short blonde hair wearing a gray suit'
  },
  {
    id: 5,
    name: 'Lisa Park',
    email: 'lisa.park@hoteladmin.com',
    phone: '+1 (555) 567-8901',
    role: 'Housekeeping',
    department: 'Housekeeping',
    employeeId: 'EMP005',
    status: 'pending',
    hireDate: '2024-10-01',
    lastLogin: 'Never',
    avatar: "https://images.unsplash.com/photo-1711188053992-5c18a61dca97",
    avatarAlt: 'Professional headshot of Lisa Park, an Asian woman with shoulder-length black hair wearing a light blue uniform'
  },
  {
    id: 6,
    name: 'James Wilson',
    email: 'james.wilson@hoteladmin.com',
    phone: '+1 (555) 678-9012',
    role: 'Maintenance',
    department: 'Maintenance',
    employeeId: 'EMP006',
    status: 'active',
    hireDate: '2023-05-18',
    lastLogin: '4 hours ago',
    avatar: "https://images.unsplash.com/photo-1696347609175-49b310bb8106",
    avatarAlt: 'Professional headshot of James Wilson, an African American man with short hair wearing a navy blue work shirt'
  }];


  useEffect(() => {
    setStaffData(mockStaffData);
  }, []);

  // Filter staff based on search and filters
  const filteredStaff = staffData?.filter((staff) => {
    const matchesSearch = staff?.name?.toLowerCase()?.includes(searchTerm?.toLowerCase()) ||
    staff?.email?.toLowerCase()?.includes(searchTerm?.toLowerCase()) ||
    staff?.employeeId?.toLowerCase()?.includes(searchTerm?.toLowerCase());
    const matchesRole = !selectedRole || staff?.role === selectedRole;
    const matchesDepartment = !selectedDepartment || staff?.department === selectedDepartment;
    const matchesStatus = !selectedStatus || staff?.status === selectedStatus;

    return matchesSearch && matchesRole && matchesDepartment && matchesStatus;
  });

  const handleStaffSelect = (staff) => {
    setSelectedStaff(staff);
  };

  const handleEditStaff = (staff) => {
    console.log('Edit staff:', staff);
    // Implement edit functionality
  };

  const handleViewDetails = (staff) => {
    setSelectedStaff(staff);
  };

  const handleAddStaff = (newStaff) => {
    setStaffData((prev) => [...prev, newStaff]);
    console.log('New staff added:', newStaff);
  };

  const handleBulkAction = (action, selectedIds) => {
    console.log('Bulk action:', action, 'for staff:', selectedIds);
    setBulkSelectedStaff([]);
  };

  const handleBulkSelect = (staffId, checked) => {
    if (checked) {
      setBulkSelectedStaff((prev) => [...prev, staffId]);
    } else {
      setBulkSelectedStaff((prev) => prev?.filter((id) => id !== staffId));
    }
  };

  const handleSelectAll = (checked) => {
    if (checked) {
      setBulkSelectedStaff(filteredStaff?.map((staff) => staff?.id));
    } else {
      setBulkSelectedStaff([]);
    }
  };

  const clearFilters = () => {
    setSearchTerm('');
    setSelectedRole('');
    setSelectedDepartment('');
    setSelectedStatus('');
  };

  return (
    <>
      <Helmet>
        <title>Staff Management - HotelAdmin Pro</title>
        <meta name="description" content="Comprehensive staff management with role-based access control and user administration for hotel operations." />
      </Helmet>
      <div className="min-h-screen bg-background">
        <SidebarNavigation
          isCollapsed={isSidebarCollapsed}
          onToggleCollapse={() => setIsSidebarCollapsed(!isSidebarCollapsed)} />


        <div className={`transition-all duration-300 ${isSidebarCollapsed ? 'md:ml-20' : 'md:ml-240'}`}>
          {/* Header */}
          <header className="bg-card border-b border-border px-6 py-4">
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-2xl font-bold text-foreground">Staff Management</h1>
                <p className="text-muted-foreground mt-1">
                  Manage team access, roles, and permissions for secure hotel operations
                </p>
              </div>

              <div className="flex items-center space-x-4">
                <NotificationIndicator
                  onMarkAsRead={() => console.log('Mark as read')}
                  onMarkAllAsRead={() => console.log('Mark all as read')} />

                <UserProfileDropdown
                  onLogout={() => console.log('Logout')} />

              </div>
            </div>
          </header>

          {/* Main Content */}
          <main className="p-6">
            <div className="max-w-7xl mx-auto">
              {/* Stats */}
              <StaffStats staffData={staffData} />

              {/* Actions Bar */}
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center space-x-4">
                  <Button
                    iconName="Plus"
                    iconPosition="left"
                    onClick={() => setIsAddModalOpen(true)}>

                    Add Staff Member
                  </Button>
                  
                  <Button
                    variant="outline"
                    iconName="Download"
                    iconPosition="left">

                    Export Data
                  </Button>
                </div>

                <div className="flex items-center space-x-2">
                  <span className="text-sm text-muted-foreground">
                    {filteredStaff?.length} of {staffData?.length} staff members
                  </span>
                </div>
              </div>

              {/* Filters */}
              <StaffFilters
                searchTerm={searchTerm}
                onSearchChange={setSearchTerm}
                selectedRole={selectedRole}
                onRoleChange={setSelectedRole}
                selectedDepartment={selectedDepartment}
                onDepartmentChange={setSelectedDepartment}
                selectedStatus={selectedStatus}
                onStatusChange={setSelectedStatus}
                onClearFilters={clearFilters} />


              {/* Bulk Actions */}
              <BulkActionsBar
                selectedStaff={bulkSelectedStaff}
                onBulkAction={handleBulkAction}
                onClearSelection={() => setBulkSelectedStaff([])} />


              {/* Content Layout */}
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-6">
                {/* Staff List */}
                <div className="lg:col-span-2">
                  <div className="bg-card border border-border rounded-lg">
                    {/* List Header */}
                    <div className="flex items-center justify-between p-4 border-b border-border">
                      <div className="flex items-center space-x-3">
                        <Checkbox
                          checked={bulkSelectedStaff?.length === filteredStaff?.length && filteredStaff?.length > 0}
                          onChange={(e) => handleSelectAll(e?.target?.checked)} />

                        <h3 className="font-medium text-foreground">Staff Directory</h3>
                      </div>
                      
                      <div className="flex items-center space-x-2">
                        <button className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-md micro-press">
                          <Icon name="Grid3X3" size={16} />
                        </button>
                        <button className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-md micro-press">
                          <Icon name="List" size={16} />
                        </button>
                      </div>
                    </div>

                    {/* Staff Cards */}
                    <div className="p-4">
                      {filteredStaff?.length === 0 ?
                      <div className="text-center py-12">
                          <Icon name="Users" size={48} className="mx-auto text-muted-foreground mb-4" />
                          <h3 className="text-lg font-medium text-foreground mb-2">No staff members found</h3>
                          <p className="text-muted-foreground mb-4">
                            {searchTerm || selectedRole || selectedDepartment || selectedStatus ?
                          'Try adjusting your filters to see more results.' : 'Get started by adding your first staff member.'
                          }
                          </p>
                          <Button
                          iconName="Plus"
                          iconPosition="left"
                          onClick={() => setIsAddModalOpen(true)}>

                            Add Staff Member
                          </Button>
                        </div> :

                      <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
                          {filteredStaff?.map((staff) =>
                        <div key={staff?.id} className="relative">
                              <div className="absolute top-2 left-2 z-10">
                                <Checkbox
                              checked={bulkSelectedStaff?.includes(staff?.id)}
                              onChange={(e) => handleBulkSelect(staff?.id, e?.target?.checked)} />

                              </div>
                              <StaffCard
                            staff={staff}
                            onEdit={handleEditStaff}
                            onViewDetails={handleViewDetails}
                            isSelected={selectedStaff?.id === staff?.id}
                            onSelect={handleStaffSelect} />

                            </div>
                        )}
                        </div>
                      }
                    </div>
                  </div>
                </div>

                {/* Details Panel */}
                <div className="lg:col-span-1">
                  {selectedStaff ?
                  <StaffDetailsPanel
                    staff={selectedStaff}
                    onClose={() => setSelectedStaff(null)}
                    onEdit={handleEditStaff} /> :


                  <div className="bg-card border border-border rounded-lg p-8 text-center">
                      <Icon name="UserCircle" size={64} className="mx-auto text-muted-foreground mb-4" />
                      <h3 className="text-lg font-medium text-foreground mb-2">Select a Staff Member</h3>
                      <p className="text-muted-foreground">
                        Choose a staff member from the list to view their details, permissions, and activity.
                      </p>
                    </div>
                  }
                </div>
              </div>
            </div>
          </main>
        </div>

        {/* Add Staff Modal */}
        <AddStaffModal
          isOpen={isAddModalOpen}
          onClose={() => setIsAddModalOpen(false)}
          onSave={handleAddStaff} />

      </div>
    </>);

};

export default StaffManagement;