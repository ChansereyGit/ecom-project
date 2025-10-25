import React from "react";
import { BrowserRouter, Routes as RouterRoutes, Route, Navigate } from "react-router-dom";
import ScrollToTop from "components/ScrollToTop";
import ErrorBoundary from "components/ErrorBoundary";
import NotFound from "pages/NotFound";
import LoginPage from './pages/login';
import BookingManagement from './pages/booking-management';
import Dashboard from './pages/dashboard';
import PropertyManagement from './pages/property-management';
import StaffManagement from './pages/staff-management';
import RoomCalendar from './pages/room-calendar';

// Protected Route Component
const ProtectedRoute = ({ children }) => {
  const userData = localStorage.getItem('hotelAdmin_user');
  
  if (!userData) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
};

const Routes = () => {
  return (
    <BrowserRouter>
      <ErrorBoundary>
      <ScrollToTop />
      <RouterRoutes>
        {/* Public Routes */}
        <Route path="/login" element={<LoginPage />} />
        
        {/* Protected Routes */}
        <Route path="/" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
        <Route path="/dashboard" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
        <Route path="/booking-management" element={<ProtectedRoute><BookingManagement /></ProtectedRoute>} />
        <Route path="/property-management" element={<ProtectedRoute><PropertyManagement /></ProtectedRoute>} />
        <Route path="/staff-management" element={<ProtectedRoute><StaffManagement /></ProtectedRoute>} />
        <Route path="/room-calendar" element={<ProtectedRoute><RoomCalendar /></ProtectedRoute>} />
        
        {/* 404 */}
        <Route path="*" element={<NotFound />} />
      </RouterRoutes>
      </ErrorBoundary>
    </BrowserRouter>
  );
};

export default Routes;
