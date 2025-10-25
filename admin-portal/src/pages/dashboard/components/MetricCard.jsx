import React from 'react';
import Icon from '../../../components/AppIcon';

const MetricCard = ({ 
  title, 
  value, 
  change, 
  changeType, 
  icon, 
  iconColor = 'text-primary',
  trend = 'up'
}) => {
  const getTrendIcon = () => {
    if (changeType === 'neutral') return 'Minus';
    return trend === 'up' ? 'TrendingUp' : 'TrendingDown';
  };

  const getTrendColor = () => {
    if (changeType === 'neutral') return 'text-muted-foreground';
    if (changeType === 'positive') return 'text-success';
    return 'text-error';
  };

  return (
    <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1 hover:shadow-elevation-2 transition-shadow">
      <div className="flex items-center justify-between mb-4">
        <div className={`w-12 h-12 rounded-lg bg-muted flex items-center justify-center ${iconColor}`}>
          <Icon name={icon} size={24} />
        </div>
        <div className={`flex items-center space-x-1 ${getTrendColor()}`}>
          <Icon name={getTrendIcon()} size={16} />
          <span className="text-sm font-medium">{change}</span>
        </div>
      </div>
      
      <div className="space-y-1">
        <h3 className="text-2xl font-bold text-foreground">{value}</h3>
        <p className="text-sm text-muted-foreground">{title}</p>
      </div>
    </div>
  );
};

export default MetricCard;