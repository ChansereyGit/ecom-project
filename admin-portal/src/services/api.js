// API Service for Hotel Admin Portal
import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api/v1';

// Create axios instance
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
apiClient.interceptors.response.use(
  (response) => {
    return response.data; // Return only data from ApiResponse
  },
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - clear auth and redirect to login
      localStorage.removeItem('authToken');
      localStorage.removeItem('userRole');
      localStorage.removeItem('userEmail');
      sessionStorage.removeItem('authToken');
      sessionStorage.removeItem('userRole');
      sessionStorage.removeItem('userEmail');
      window.location.href = '/login';
    }
    return Promise.reject(error.response?.data || error.message);
  }
);

// Auth API
export const authAPI = {
  login: async (email, password) => {
    const response = await apiClient.post('/auth/login', { email, password });
    return response;
  },
  
  register: async (fullName, email, password, phoneNumber) => {
    const response = await apiClient.post('/auth/register', {
      fullName,
      email,
      password,
      phoneNumber,
    });
    return response;
  },
  
  getCurrentUser: async () => {
    const response = await apiClient.get('/auth/me');
    return response;
  },
};

// Hotels API
export const hotelsAPI = {
  getAll: async () => {
    const response = await apiClient.get('/hotels');
    return response;
  },
  
  getById: async (id) => {
    const response = await apiClient.get(`/hotels/${id}`);
    return response;
  },
  
  create: async (hotelData) => {
    const response = await apiClient.post('/hotels', hotelData);
    return response;
  },
  
  update: async (id, hotelData) => {
    const response = await apiClient.put(`/hotels/${id}`, hotelData);
    return response;
  },
  
  delete: async (id) => {
    const response = await apiClient.delete(`/hotels/${id}`);
    return response;
  },
  
  getFeatured: async () => {
    const response = await apiClient.get('/hotels/featured');
    return response;
  },
  
  search: async (searchParams) => {
    const response = await apiClient.post('/hotels/search', searchParams);
    return response;
  },
};

// Rooms API
export const roomsAPI = {
  getByHotel: async (hotelId) => {
    const response = await apiClient.get(`/hotels/${hotelId}/rooms`);
    return response;
  },
  
  create: async (hotelId, roomData) => {
    const response = await apiClient.post(`/hotels/${hotelId}/rooms`, roomData);
    return response;
  },
  
  update: async (hotelId, roomId, roomData) => {
    const response = await apiClient.put(`/hotels/${hotelId}/rooms/${roomId}`, roomData);
    return response;
  },
  
  delete: async (hotelId, roomId) => {
    const response = await apiClient.delete(`/hotels/${hotelId}/rooms/${roomId}`);
    return response;
  },
};

// Calendar API
export const calendarAPI = {
  getRooms: async (hotelId) => {
    const response = await apiClient.get(`/calendar/rooms?hotelId=${hotelId}`);
    return response;
  },
  
  getBookings: async (hotelId, startDate, endDate) => {
    const response = await apiClient.get(
      `/calendar/bookings?hotelId=${hotelId}&startDate=${startDate}&endDate=${endDate}`
    );
    return response;
  },
  
  checkAvailability: async (roomInstanceId, checkInDate, checkOutDate) => {
    const response = await apiClient.get(
      `/calendar/availability?roomInstanceId=${roomInstanceId}&checkInDate=${checkInDate}&checkOutDate=${checkOutDate}`
    );
    return response;
  },
  
  createQuickBooking: async (bookingData) => {
    const response = await apiClient.post('/calendar/bookings/quick', bookingData);
    return response;
  },
  
  updateRoomStatus: async (roomInstanceId, status) => {
    const response = await apiClient.put(`/calendar/rooms/${roomInstanceId}/status`, { status });
    return response;
  },
};

// Bookings API
export const bookingsAPI = {
  // Admin endpoints
  getAll: async () => {
    const response = await apiClient.get('/bookings/admin/all');
    return response;
  },
  
  getByHotel: async (hotelId) => {
    const response = await apiClient.get(`/bookings/admin/hotel/${hotelId}`);
    return response;
  },
  
  getByStatus: async (status) => {
    const response = await apiClient.get(`/bookings/admin/status/${status}`);
    return response;
  },
  
  getById: async (id) => {
    const response = await apiClient.get(`/bookings/${id}`);
    return response;
  },
  
  updateStatus: async (id, status) => {
    const response = await apiClient.put(`/bookings/admin/${id}/status?status=${status}`);
    return response;
  },
  
  checkIn: async (id) => {
    const response = await apiClient.post(`/bookings/admin/${id}/check-in`);
    return response;
  },
  
  checkOut: async (id) => {
    const response = await apiClient.post(`/bookings/admin/${id}/check-out`);
    return response;
  },
  
  cancel: async (id) => {
    const response = await apiClient.post(`/bookings/${id}/cancel`);
    return response;
  },
};

// Payments API
export const paymentsAPI = {
  getByBooking: async (bookingId) => {
    const response = await apiClient.get(`/payments/booking/${bookingId}`);
    return response;
  },
  
  refund: async (paymentId, amount) => {
    const response = await apiClient.post(`/payments/${paymentId}/refund`, { amount });
    return response;
  },
};

export default apiClient;
