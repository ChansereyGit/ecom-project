import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';

const LoginCredentialsHelper = () => {
  const [isExpanded, setIsExpanded] = useState(false);

  const mockCredentials = [
    {
      role: 'Admin Account',
      email: 'admin@hotel.com',
      password: 'admin123',
      roleValue: 'ADMIN',
      description: 'Full system access - manage hotels, rooms, and bookings'
    },
    {
      role: 'User Account',
      email: 'user@hotel.com',
      password: 'user123',
      roleValue: 'USER',
      description: 'Limited access - view dashboard and reports'
    }
  ];

  return (
    <div className="w-full max-w-md mx-auto mt-6">
      <div className="bg-muted/50 border border-border rounded-lg p-4">
        <button
          onClick={() => setIsExpanded(!isExpanded)}
          className="w-full flex items-center justify-between text-left"
        >
          <div className="flex items-center space-x-2">
            <Icon name="Info" size={16} className="text-accent" />
            <span className="text-sm font-medium text-foreground">
              Demo Credentials
            </span>
          </div>
          <Icon 
            name={isExpanded ? 'ChevronUp' : 'ChevronDown'} 
            size={16} 
            className="text-muted-foreground"
          />
        </button>

        {isExpanded && (
          <div className="mt-4 space-y-3">
            <p className="text-xs text-muted-foreground mb-3">
              Use these credentials to explore different role permissions:
            </p>
            
            {mockCredentials?.map((cred, index) => (
              <div key={index} className="bg-card border border-border rounded-md p-3">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm font-medium text-foreground">
                    {cred?.role}
                  </span>
                  <Button
                    variant="ghost"
                    size="xs"
                    onClick={() => {
                      navigator.clipboard?.writeText(`${cred?.email}\n${cred?.password}`);
                    }}
                    iconName="Copy"
                    iconSize={12}
                  >
                    Copy
                  </Button>
                </div>
                <div className="space-y-1 text-xs">
                  <div className="flex items-center space-x-2">
                    <span className="text-muted-foreground">Email:</span>
                    <code className="bg-muted px-1 py-0.5 rounded text-foreground">
                      {cred?.email}
                    </code>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-muted-foreground">Password:</span>
                    <code className="bg-muted px-1 py-0.5 rounded text-foreground">
                      {cred?.password}
                    </code>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="text-muted-foreground">Role:</span>
                    <code className="bg-muted px-1 py-0.5 rounded text-foreground">
                      {cred?.roleValue}
                    </code>
                  </div>
                  <p className="text-muted-foreground mt-1">
                    {cred?.description}
                  </p>
                </div>
              </div>
            ))}
            
            <div className="mt-3 p-2 bg-warning/10 border border-warning/20 rounded-md">
              <p className="text-xs text-warning-foreground">
                <Icon name="AlertTriangle" size={12} className="inline mr-1" />
                These are demo credentials for testing purposes only.
              </p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default LoginCredentialsHelper;