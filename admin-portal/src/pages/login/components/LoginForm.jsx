import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';
import Select from '../../../components/ui/Select';
import { Checkbox } from '../../../components/ui/Checkbox';
import Icon from '../../../components/AppIcon';
import { authAPI } from '../../../services/api';

const LoginForm = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    role: '',
    rememberMe: false
  });
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);

  const roleOptions = [
    { value: 'ADMIN', label: 'Admin - Full Access' },
    { value: 'USER', label: 'User - Limited Access' }
  ];

  const handleInputChange = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
    
    // Clear error when user starts typing
    if (errors?.[field]) {
      setErrors(prev => ({
        ...prev,
        [field]: ''
      }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData?.email) {
      newErrors.email = 'Email address is required';
    } else if (!/\S+@\S+\.\S+/?.test(formData?.email)) {
      newErrors.email = 'Please enter a valid email address';
    }

    if (!formData?.password) {
      newErrors.password = 'Password is required';
    } else if (formData?.password?.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    if (!formData?.role) {
      newErrors.role = 'Please select your role';
    }

    return newErrors;
  };

  const handleSubmit = async (e) => {
    e?.preventDefault();
    
    const validationErrors = validateForm();
    if (Object.keys(validationErrors)?.length > 0) {
      setErrors(validationErrors);
      return;
    }

    setIsLoading(true);
    setErrors({});

    try {
      // Call real API
      const response = await authAPI.login(formData.email, formData.password);
      
      if (response.success) {
        const { token, user } = response.data;
        
        // Check if user has the selected role
        if (user.role !== formData.role) {
          setErrors({
            role: `Access denied. Your account role is ${user.role}, but you selected ${formData.role}.`
          });
          setIsLoading(false);
          return;
        }
        
        // Store token and user info
        const storage = formData.rememberMe ? localStorage : sessionStorage;
        storage.setItem('authToken', token);
        storage.setItem('userRole', user.role);
        storage.setItem('userEmail', user.email);
        
        // Also store in old format for compatibility
        localStorage.setItem('hotelAdmin_user', JSON.stringify({
          email: user.email,
          fullName: user.fullName,
          role: user.role,
          rememberMe: formData.rememberMe,
          loginTime: new Date().toISOString()
        }));
        
        // Navigate based on role
        if (user.role === 'ADMIN') {
          navigate('/property-management');
        } else {
          navigate('/dashboard');
        }
      } else {
        setErrors({
          general: response.message || 'Login failed. Please try again.'
        });
      }
    } catch (error) {
      console.error('Login error:', error);
      setErrors({
        general: error.message || 'Invalid email or password. Please check your credentials and try again.'
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleForgotPassword = () => {
    // Mock forgot password functionality
    alert('Password reset link would be sent to your email address');
  };

  return (
    <div className="w-full max-w-md mx-auto">
      <div className="bg-card border border-border rounded-lg shadow-elevation-2 p-8">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
            <Icon name="Hotel" size={32} color="white" />
          </div>
          <h1 className="text-2xl font-semibold text-foreground mb-2">
            Welcome Back
          </h1>
          <p className="text-muted-foreground">
            Sign in to your HotelAdmin Pro account
          </p>
        </div>

        {/* Login Form */}
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* General Error */}
          {errors?.general && (
            <div className="bg-error/10 border border-error/20 rounded-md p-3 flex items-center space-x-2">
              <Icon name="AlertCircle" size={16} className="text-error flex-shrink-0" />
              <span className="text-sm text-error">{errors?.general}</span>
            </div>
          )}

          {/* Email Input */}
          <Input
            label="Email Address"
            type="email"
            placeholder="Enter your email address"
            value={formData?.email}
            onChange={(e) => handleInputChange('email', e?.target?.value)}
            error={errors?.email}
            required
          />

          {/* Password Input */}
          <Input
            label="Password"
            type="password"
            placeholder="Enter your password"
            value={formData?.password}
            onChange={(e) => handleInputChange('password', e?.target?.value)}
            error={errors?.password}
            required
          />

          {/* Role Selection */}
          <Select
            label="Select Your Role"
            placeholder="Choose your access level"
            options={roleOptions}
            value={formData?.role}
            onChange={(value) => handleInputChange('role', value)}
            error={errors?.role}
            required
          />

          {/* Remember Me */}
          <div className="flex items-center justify-between">
            <Checkbox
              label="Remember me"
              checked={formData?.rememberMe}
              onChange={(e) => handleInputChange('rememberMe', e?.target?.checked)}
            />
            
            <button
              type="button"
              onClick={handleForgotPassword}
              className="text-sm text-accent hover:text-accent/80 transition-colors"
            >
              Forgot password?
            </button>
          </div>

          {/* Submit Button */}
          <Button
            type="submit"
            variant="default"
            size="lg"
            fullWidth
            loading={isLoading}
            iconName="LogIn"
            iconPosition="right"
          >
            Sign In
          </Button>
        </form>

        {/* Security Badge */}
        <div className="mt-8 pt-6 border-t border-border">
          <div className="flex items-center justify-center space-x-2 text-xs text-muted-foreground">
            <Icon name="Shield" size={14} />
            <span>Secured with SSL encryption</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginForm;