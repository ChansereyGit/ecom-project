import React, { useState } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';
import Icon from '../../../components/AppIcon';

const RevenueChart = () => {
  const [chartType, setChartType] = useState('line');
  const [timeRange, setTimeRange] = useState('7days');

  const revenueData = {
    '7days': [
      { date: 'Oct 8', revenue: 2400, bookings: 12, occupancy: 85 },
      { date: 'Oct 9', revenue: 1800, bookings: 8, occupancy: 72 },
      { date: 'Oct 10', revenue: 3200, bookings: 15, occupancy: 92 },
      { date: 'Oct 11', revenue: 2800, bookings: 13, occupancy: 88 },
      { date: 'Oct 12', revenue: 3600, bookings: 18, occupancy: 95 },
      { date: 'Oct 13', revenue: 2200, bookings: 10, occupancy: 78 },
      { date: 'Oct 14', revenue: 4100, bookings: 20, occupancy: 98 }
    ],
    '30days': [
      { date: 'Week 1', revenue: 18500, bookings: 85, occupancy: 82 },
      { date: 'Week 2', revenue: 22300, bookings: 102, occupancy: 88 },
      { date: 'Week 3', revenue: 19800, bookings: 91, occupancy: 85 },
      { date: 'Week 4', revenue: 25600, bookings: 118, occupancy: 92 }
    ],
    '90days': [
      { date: 'Aug', revenue: 78500, bookings: 365, occupancy: 84 },
      { date: 'Sep', revenue: 85200, bookings: 398, occupancy: 87 },
      { date: 'Oct', revenue: 92100, bookings: 425, occupancy: 89 }
    ]
  };

  const currentData = revenueData?.[timeRange];
  const totalRevenue = currentData?.reduce((sum, item) => sum + item?.revenue, 0);
  const totalBookings = currentData?.reduce((sum, item) => sum + item?.bookings, 0);
  const avgOccupancy = Math.round(currentData?.reduce((sum, item) => sum + item?.occupancy, 0) / currentData?.length);

  const CustomTooltip = ({ active, payload, label }) => {
    if (active && payload && payload?.length) {
      return (
        <div className="bg-popover border border-border rounded-lg p-3 shadow-elevation-2">
          <p className="text-sm font-medium text-popover-foreground mb-2">{label}</p>
          {payload?.map((entry, index) => (
            <div key={index} className="flex items-center space-x-2">
              <div 
                className="w-3 h-3 rounded-full" 
                style={{ backgroundColor: entry?.color }}
              />
              <span className="text-sm text-muted-foreground">
                {entry?.dataKey === 'revenue' ? `Revenue: $${entry?.value?.toLocaleString()}` :
                 entry?.dataKey === 'bookings' ? `Bookings: ${entry?.value}` :
                 `Occupancy: ${entry?.value}%`}
              </span>
            </div>
          ))}
        </div>
      );
    }
    return null;
  };

  return (
    <div className="bg-card border border-border rounded-lg p-6 shadow-elevation-1">
      <div className="flex items-center justify-between mb-6">
        <h3 className="text-lg font-semibold text-foreground">Revenue Analytics</h3>
        
        <div className="flex items-center space-x-2">
          {/* Time Range Selector */}
          <div className="flex bg-muted rounded-md p-1">
            {[
              { key: '7days', label: '7D' },
              { key: '30days', label: '30D' },
              { key: '90days', label: '90D' }
            ]?.map((range) => (
              <button
                key={range?.key}
                onClick={() => setTimeRange(range?.key)}
                className={`
                  px-3 py-1 text-xs font-medium rounded transition-colors
                  ${timeRange === range?.key 
                    ? 'bg-primary text-primary-foreground' 
                    : 'text-muted-foreground hover:text-foreground'
                  }
                `}
              >
                {range?.label}
              </button>
            ))}
          </div>

          {/* Chart Type Toggle */}
          <div className="flex bg-muted rounded-md p-1">
            <button
              onClick={() => setChartType('line')}
              className={`
                p-2 rounded transition-colors
                ${chartType === 'line' ?'bg-primary text-primary-foreground' :'text-muted-foreground hover:text-foreground'
                }
              `}
            >
              <Icon name="TrendingUp" size={14} />
            </button>
            <button
              onClick={() => setChartType('bar')}
              className={`
                p-2 rounded transition-colors
                ${chartType === 'bar' ?'bg-primary text-primary-foreground' :'text-muted-foreground hover:text-foreground'
                }
              `}
            >
              <Icon name="BarChart3" size={14} />
            </button>
          </div>
        </div>
      </div>
      {/* Summary Stats */}
      <div className="grid grid-cols-3 gap-4 mb-6">
        <div className="text-center">
          <p className="text-2xl font-bold text-foreground">${totalRevenue?.toLocaleString()}</p>
          <p className="text-xs text-muted-foreground">Total Revenue</p>
        </div>
        <div className="text-center">
          <p className="text-2xl font-bold text-foreground">{totalBookings}</p>
          <p className="text-xs text-muted-foreground">Total Bookings</p>
        </div>
        <div className="text-center">
          <p className="text-2xl font-bold text-foreground">{avgOccupancy}%</p>
          <p className="text-xs text-muted-foreground">Avg Occupancy</p>
        </div>
      </div>
      {/* Chart */}
      <div className="h-64" aria-label="Revenue Analytics Chart">
        <ResponsiveContainer width="100%" height="100%">
          {chartType === 'line' ? (
            <LineChart data={currentData}>
              <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" />
              <XAxis 
                dataKey="date" 
                stroke="var(--color-muted-foreground)"
                fontSize={12}
              />
              <YAxis 
                stroke="var(--color-muted-foreground)"
                fontSize={12}
              />
              <Tooltip content={<CustomTooltip />} />
              <Line 
                type="monotone" 
                dataKey="revenue" 
                stroke="var(--color-primary)" 
                strokeWidth={3}
                dot={{ fill: 'var(--color-primary)', strokeWidth: 2, r: 4 }}
                activeDot={{ r: 6, stroke: 'var(--color-primary)', strokeWidth: 2 }}
              />
            </LineChart>
          ) : (
            <BarChart data={currentData}>
              <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" />
              <XAxis 
                dataKey="date" 
                stroke="var(--color-muted-foreground)"
                fontSize={12}
              />
              <YAxis 
                stroke="var(--color-muted-foreground)"
                fontSize={12}
              />
              <Tooltip content={<CustomTooltip />} />
              <Bar 
                dataKey="revenue" 
                fill="var(--color-primary)"
                radius={[4, 4, 0, 0]}
              />
            </BarChart>
          )}
        </ResponsiveContainer>
      </div>
    </div>
  );
};

export default RevenueChart;