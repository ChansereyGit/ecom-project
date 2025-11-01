import React, { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext(null);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check for existing session on mount
    checkAuth();
  }, []);

  const checkAuth = () => {
    try {
      const userData = localStorage.getItem('hotelAdmin_user');
      const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
      
      if (userData && token) {
        const parsedUser = JSON.parse(userData);
        setUser(parsedUser);
      }
    } catch (error) {
      console.error('Auth check error:', error);
      clearAuth();
    } finally {
      setLoading(false);
    }
  };

  const clearAuth = () => {
    // Clear all auth data
    localStorage.removeItem('authToken');
    localStorage.removeItem('userRole');
    localStorage.removeItem('userEmail');
    localStorage.removeItem('hotelAdmin_user');
    sessionStorage.removeItem('authToken');
    sessionStorage.removeItem('userRole');
    sessionStorage.removeItem('userEmail');
    setUser(null);
  };

  const login = (userData, token, rememberMe = false) => {
    // Store token
    const storage = rememberMe ? localStorage : sessionStorage;
    storage.setItem('authToken', token);
    storage.setItem('userRole', userData.role);
    storage.setItem('userEmail', userData.email);
    
    // Store user data
    const userInfo = {
      email: userData.email,
      fullName: userData.fullName,
      role: userData.role,
      rememberMe,
      loginTime: new Date().toISOString()
    };
    
    localStorage.setItem('hotelAdmin_user', JSON.stringify(userInfo));
    setUser(userInfo);
    
    // Return the redirect path - always go to booking management
    return '/booking-management';
  };

  const logout = () => {
    clearAuth();
    // Return the redirect path instead of navigating
    return '/login';
  };

  const value = {
    user,
    loading,
    login,
    logout,
    isAuthenticated: !!user,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
