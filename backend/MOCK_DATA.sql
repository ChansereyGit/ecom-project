-- Mock Data for Hotel Booking System
-- Run this SQL in your PostgreSQL database after the backend creates the tables

-- Insert Hotels
INSERT INTO hotels (id, name, description, address, city, country, latitude, longitude, 
                    price_per_night, star_rating, guest_rating, total_reviews, featured, available, 
                    created_at, updated_at)
VALUES 
-- New York Hotels
('550e8400-e29b-41d4-a716-446655440001', 
 'Grand Plaza Hotel New York', 
 'Luxury 5-star hotel in the heart of Manhattan with stunning city views', 
 '123 Fifth Avenue', 'New York', 'USA', 40.7589, -73.9851,
 250.00, 5, 4.8, 1250, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440002', 
 'Times Square Boutique Hotel', 
 'Modern boutique hotel steps from Times Square', 
 '456 West 42nd Street', 'New York', 'USA', 40.7580, -73.9855,
 180.00, 4, 4.5, 890, true, true, NOW(), NOW()),

-- Los Angeles Hotels  
('550e8400-e29b-41d4-a716-446655440003', 
 'Sunset Boulevard Resort', 
 'Iconic hotel on the famous Sunset Strip', 
 '789 Sunset Boulevard', 'Los Angeles', 'USA', 34.0522, -118.2437,
 200.00, 4, 4.6, 750, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440004', 
 'Santa Monica Beach Hotel', 
 'Beachfront hotel with ocean views', 
 '321 Ocean Avenue', 'Los Angeles', 'USA', 34.0195, -118.4912,
 220.00, 4, 4.7, 650, true, true, NOW(), NOW()),

-- Miami Hotels
('550e8400-e29b-41d4-a716-446655440005', 
 'Miami Beach Oceanfront Resort', 
 'Luxury beachfront resort with private beach access', 
 '555 Collins Avenue', 'Miami', 'USA', 25.7907, -80.1300,
 280.00, 5, 4.9, 1100, true, true, NOW(), NOW());

-- Insert Hotel Images
INSERT INTO hotel_images (hotel_id, image_url)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1566073771259-6a8506099945'),
('550e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b'),
('550e8400-e29b-41d4-a716-446655440002', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4'),
('550e8400-e29b-41d4-a716-446655440003', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb'),
('550e8400-e29b-41d4-a716-446655440004', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d'),
('550e8400-e29b-41d4-a716-446655440005', 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9');

-- Insert Hotel Amenities
INSERT INTO hotel_amenities (hotel_id, amenity)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440001', 'Swimming Pool'),
('550e8400-e29b-41d4-a716-446655440001', 'Gym'),
('550e8400-e29b-41d4-a716-446655440001', 'Restaurant'),
('550e8400-e29b-41d4-a716-446655440001', 'Spa'),
('550e8400-e29b-41d4-a716-446655440001', 'Room Service'),
('550e8400-e29b-41d4-a716-446655440002', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440002', 'Rooftop Bar'),
('550e8400-e29b-41d4-a716-446655440002', 'Gym'),
('550e8400-e29b-41d4-a716-446655440003', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440003', 'Pool'),
('550e8400-e29b-41d4-a716-446655440003', 'Parking'),
('550e8400-e29b-41d4-a716-446655440004', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440004', 'Beach Access'),
('550e8400-e29b-41d4-a716-446655440004', 'Pool'),
('550e8400-e29b-41d4-a716-446655440005', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440005', 'Private Beach'),
('550e8400-e29b-41d4-a716-446655440005', 'Spa'),
('550e8400-e29b-41d4-a716-446655440005', 'Multiple Restaurants');

-- Insert Rooms
INSERT INTO rooms (id, hotel_id, room_type, description, price_per_night, max_guests, 
                   total_rooms, available_rooms, size, bed_type, has_breakfast, 
                   free_cancellation, created_at, updated_at)
VALUES 
-- Grand Plaza Hotel Rooms
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001',
 'Deluxe King Room', 'Spacious room with king bed and city view', 
 250.00, 2, 10, 10, 35.0, 'King', true, true, NOW(), NOW()),

('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001',
 'Executive Suite', 'Luxury suite with separate living area', 
 400.00, 4, 5, 5, 60.0, 'King', true, true, NOW(), NOW()),

-- Times Square Hotel Rooms
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002',
 'Standard Queen Room', 'Comfortable room with queen bed', 
 180.00, 2, 15, 15, 28.0, 'Queen', true, false, NOW(), NOW()),

-- Sunset Boulevard Rooms
('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003',
 'Deluxe Double Room', 'Modern room with two double beds', 
 200.00, 4, 12, 12, 32.0, 'Double', true, true, NOW(), NOW()),

-- Santa Monica Rooms
('660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004',
 'Ocean View Suite', 'Stunning ocean view suite', 
 220.00, 2, 8, 8, 40.0, 'King', true, true, NOW(), NOW()),

-- Miami Beach Rooms
('660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440005',
 'Beachfront Villa', 'Luxury villa with private beach access', 
 280.00, 6, 6, 6, 80.0, 'King', true, true, NOW(), NOW());

-- Insert Room Amenities
INSERT INTO room_amenities (room_id, amenity)
VALUES 
('660e8400-e29b-41d4-a716-446655440001', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440001', 'TV'),
('660e8400-e29b-41d4-a716-446655440001', 'Mini Bar'),
('660e8400-e29b-41d4-a716-446655440001', 'Safe'),
('660e8400-e29b-41d4-a716-446655440002', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440002', 'TV'),
('660e8400-e29b-41d4-a716-446655440002', 'Jacuzzi'),
('660e8400-e29b-41d4-a716-446655440003', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440003', 'TV');
