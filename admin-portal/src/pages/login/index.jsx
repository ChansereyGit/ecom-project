import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import LoginForm from './components/LoginForm';
import LoginBackground from './components/LoginBackground';
import LoginCredentialsHelper from './components/LoginCredentialsHelper';

const LoginPage = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Check if user is already logged in
    const userData = localStorage.getItem('hotelAdmin_user');
    if (userData) {
      try {
        const user = JSON.parse(userData);
        // Check if session is still valid (optional: add expiry logic)
        if (user?.email && user?.role) {
          navigate('/dashboard');
        }
      } catch (error) {
        // Clear invalid session data
        localStorage.removeItem('hotelAdmin_user');
      }
    }
  }, [navigate]);

  return (
    <div className="min-h-screen bg-background flex">
      {/* Left Side - Login Form */}
      <div className="w-full lg:w-1/2 flex flex-col justify-center px-6 py-12">
        <div className="w-full max-w-md mx-auto">
          <LoginForm />
          <LoginCredentialsHelper />
        </div>
      </div>

      {/* Right Side - Background Image & Content */}
      <LoginBackground />
    </div>
  );
};

export default LoginPage;