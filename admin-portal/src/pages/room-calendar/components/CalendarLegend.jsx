import React from 'react';
import Icon from '../../../components/AppIcon';

const CalendarLegend = ({ isVisible, onToggle }) => {
  const legendItems = [
    {
      type: 'booking',
      label: 'Booking Status',
      items: [
        { color: 'bg-success', label: 'Confirmed', icon: 'CheckCircle' },
        { color: 'bg-warning', label: 'Pending', icon: 'Clock' },
        { color: 'bg-accent', label: 'Checked In', icon: 'Key' },
        { color: 'bg-muted', label: 'Checked Out', icon: 'LogOut' },
        { color: 'bg-error', label: 'Cancelled', icon: 'XCircle' }
      ]
    },
    {
      type: 'room',
      label: 'Room Status',
      items: [
        { color: 'bg-success/10 text-success', label: 'Available', icon: 'Home' },
        { color: 'bg-error/10 text-error', label: 'Occupied', icon: 'User' },
        { color: 'bg-warning/10 text-warning', label: 'Maintenance', icon: 'Wrench' },
        { color: 'bg-muted text-muted-foreground', label: 'Blocked', icon: 'Ban' }
      ]
    }
  ];

  if (!isVisible) {
    return (
      <button
        onClick={onToggle}
        className="fixed bottom-6 right-6 bg-primary text-primary-foreground p-3 rounded-full shadow-elevation-3 hover:shadow-elevation-2 transition-all micro-press z-200"
        title="Show Legend"
      >
        <Icon name="Info" size={20} />
      </button>
    );
  }

  return (
    <div className="fixed bottom-6 right-6 bg-card border border-border rounded-lg shadow-elevation-3 p-4 w-80 z-200">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-sm font-semibold text-foreground">Calendar Legend</h3>
        <button
          onClick={onToggle}
          className="text-muted-foreground hover:text-foreground transition-colors"
        >
          <Icon name="X" size={16} />
        </button>
      </div>
      {/* Legend Items */}
      <div className="space-y-4">
        {legendItems?.map((section) => (
          <div key={section?.type}>
            <h4 className="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
              {section?.label}
            </h4>
            <div className="space-y-2">
              {section?.items?.map((item, index) => (
                <div key={index} className="flex items-center space-x-3">
                  <div className={`
                    w-4 h-4 rounded flex items-center justify-center
                    ${item?.color}
                  `}>
                    <Icon 
                      name={item?.icon} 
                      size={10} 
                      className={item?.color?.includes('text-') ? '' : 'text-white'}
                    />
                  </div>
                  <span className="text-sm text-foreground">{item?.label}</span>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
      {/* Additional Info */}
      <div className="mt-4 pt-4 border-t border-border">
        <div className="space-y-2 text-xs text-muted-foreground">
          <div className="flex items-center space-x-2">
            <Icon name="MousePointer" size={12} />
            <span>Click empty cells to create bookings</span>
          </div>
          <div className="flex items-center space-x-2">
            <Icon name="Move" size={12} />
            <span>Drag booking blocks to reschedule</span>
          </div>
          <div className="flex items-center space-x-2">
            <Icon name="Eye" size={12} />
            <span>Click bookings to view details</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CalendarLegend;