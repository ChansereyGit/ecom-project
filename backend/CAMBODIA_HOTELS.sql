-- Cambodia Hotels Mock Data
-- Add popular hotels in Cambodia's top tourist destinations

-- Delete existing Cambodia hotels if any (to avoid conflicts)
DELETE FROM room_amenities WHERE room_id IN (SELECT id FROM rooms WHERE hotel_id IN (SELECT id FROM hotels WHERE country = 'Cambodia'));
DELETE FROM rooms WHERE hotel_id IN (SELECT id FROM hotels WHERE country = 'Cambodia');
DELETE FROM hotel_amenities WHERE hotel_id IN (SELECT id FROM hotels WHERE country = 'Cambodia');
DELETE FROM hotel_images WHERE hotel_id IN (SELECT id FROM hotels WHERE country = 'Cambodia');
DELETE FROM hotels WHERE country = 'Cambodia';

-- Insert Cambodia Hotels
INSERT INTO hotels (id, name, description, address, city, country, latitude, longitude, 
                    price_per_night, star_rating, guest_rating, total_reviews, featured, available, 
                    created_at, updated_at)
VALUES 
-- Siem Reap Hotels (Angkor Wat area)
('550e8400-e29b-41d4-a716-446655440010', 
 'Angkor Palace Resort & Spa', 
 'Luxury resort near Angkor Wat temples with traditional Khmer architecture', 
 'National Road 6, Khum Svay Dankum', 'Siem Reap', 'Cambodia', 13.3671, 103.8448,
 85.00, 5, 4.7, 2340, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440011', 
 'Sokha Angkor Resort', 
 'Modern resort with pool and spa, 10 minutes from Angkor temples', 
 'Street 60, Mondol 1 Village', 'Siem Reap', 'Cambodia', 13.3633, 103.8564,
 65.00, 4, 4.5, 1890, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440012', 
 'Riverside Boutique Hotel', 
 'Charming boutique hotel along Siem Reap River with rooftop bar', 
 'Riverside Road, Old Market Area', 'Siem Reap', 'Cambodia', 13.3622, 103.8597,
 45.00, 3, 4.3, 1120, false, true, NOW(), NOW()),

-- Phnom Penh Hotels (Capital city)
('550e8400-e29b-41d4-a716-446655440013', 
 'Raffles Hotel Le Royal', 
 'Historic luxury hotel in the heart of Phnom Penh since 1929', 
 '92 Rukhak Vithei Daun Penh', 'Phnom Penh', 'Cambodia', 11.5564, 104.9282,
 120.00, 5, 4.8, 3200, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440014', 
 'Rosewood Phnom Penh', 
 'Ultra-luxury hotel with Mekong River views and rooftop infinity pool', 
 'Vattanac Capital Tower, Preah Monivong Blvd', 'Phnom Penh', 'Cambodia', 11.5449, 104.9282,
 150.00, 5, 4.9, 1560, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440015', 
 'Palace Gate Hotel & Resort', 
 'Elegant hotel near Royal Palace with traditional Khmer design', 
 'Street 178, Sangkat Chey Chumneah', 'Phnom Penh', 'Cambodia', 11.5625, 104.9280,
 70.00, 4, 4.4, 980, false, true, NOW(), NOW()),

-- Preah Sihanouk (Sihanoukville - Beach destination)
('550e8400-e29b-41d4-a716-446655440016', 
 'Sokha Beach Resort', 
 'Premier beach resort with private white sand beach and multiple pools', 
 'Street 2 Thnou, Sangkat 4', 'Preah Sihanouk', 'Cambodia', 10.6094, 103.5294,
 95.00, 5, 4.6, 2100, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440017', 
 'Independence Hotel', 
 'Historic beachfront hotel with stunning ocean views', 
 'Independence Beach', 'Preah Sihanouk', 'Cambodia', 10.6167, 103.5167,
 75.00, 4, 4.4, 1450, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440018', 
 'Otres Beach Resort', 
 'Relaxed beachfront resort on peaceful Otres Beach', 
 'Otres Beach Road', 'Preah Sihanouk', 'Cambodia', 10.5833, 103.5333,
 55.00, 3, 4.2, 890, false, true, NOW(), NOW()),

-- Kampot Hotels (Riverside town)
('550e8400-e29b-41d4-a716-446655440019', 
 'Knai Bang Chatt Resort', 
 'Boutique seaside resort with modernist architecture and infinity pool', 
 'Phum Thmey, Sangkat Kampong Bay', 'Kampot', 'Cambodia', 10.6167, 104.1833,
 110.00, 5, 4.8, 780, true, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440020', 
 'Rikitikitavi Boutique Hotel', 
 'Stylish riverside hotel with colonial charm and sunset views', 
 'Riverside Road', 'Kampot', 'Cambodia', 10.6167, 104.1833,
 60.00, 4, 4.5, 650, false, true, NOW(), NOW()),

('550e8400-e29b-41d4-a716-446655440021', 
 'Kampot Cabana', 
 'Peaceful riverside bungalows surrounded by nature', 
 'Tuk Chhou Road', 'Kampot', 'Cambodia', 10.6000, 104.1667,
 35.00, 3, 4.3, 520, false, true, NOW(), NOW());

-- Insert Hotel Images for Cambodia Hotels
INSERT INTO hotel_images (hotel_id, image_url)
VALUES 
-- Siem Reap
('550e8400-e29b-41d4-a716-446655440010', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb'),
('550e8400-e29b-41d4-a716-446655440010', 'https://images.unsplash.com/photo-1566073771259-6a8506099945'),
('550e8400-e29b-41d4-a716-446655440011', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4'),
('550e8400-e29b-41d4-a716-446655440012', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d'),
-- Phnom Penh
('550e8400-e29b-41d4-a716-446655440013', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b'),
('550e8400-e29b-41d4-a716-446655440014', 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9'),
('550e8400-e29b-41d4-a716-446655440015', 'https://images.unsplash.com/photo-1566073771259-6a8506099945'),
-- Preah Sihanouk
('550e8400-e29b-41d4-a716-446655440016', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4'),
('550e8400-e29b-41d4-a716-446655440017', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d'),
('550e8400-e29b-41d4-a716-446655440018', 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9'),
-- Kampot
('550e8400-e29b-41d4-a716-446655440019', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb'),
('550e8400-e29b-41d4-a716-446655440020', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b'),
('550e8400-e29b-41d4-a716-446655440021', 'https://images.unsplash.com/photo-1566073771259-6a8506099945');

-- Insert Hotel Amenities for Cambodia Hotels
INSERT INTO hotel_amenities (hotel_id, amenity)
VALUES 
-- Angkor Palace Resort
('550e8400-e29b-41d4-a716-446655440010', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440010', 'Swimming Pool'),
('550e8400-e29b-41d4-a716-446655440010', 'Spa'),
('550e8400-e29b-41d4-a716-446655440010', 'Restaurant'),
('550e8400-e29b-41d4-a716-446655440010', 'Free Parking'),
('550e8400-e29b-41d4-a716-446655440010', 'Airport Shuttle'),
-- Sokha Angkor Resort
('550e8400-e29b-41d4-a716-446655440011', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440011', 'Pool'),
('550e8400-e29b-41d4-a716-446655440011', 'Gym'),
('550e8400-e29b-41d4-a716-446655440011', 'Restaurant'),
-- Riverside Boutique
('550e8400-e29b-41d4-a716-446655440012', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440012', 'Rooftop Bar'),
('550e8400-e29b-41d4-a716-446655440012', 'Bicycle Rental'),
-- Raffles Le Royal
('550e8400-e29b-41d4-a716-446655440013', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440013', 'Swimming Pool'),
('550e8400-e29b-41d4-a716-446655440013', 'Spa'),
('550e8400-e29b-41d4-a716-446655440013', 'Multiple Restaurants'),
('550e8400-e29b-41d4-a716-446655440013', 'Concierge'),
-- Rosewood Phnom Penh
('550e8400-e29b-41d4-a716-446655440014', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440014', 'Infinity Pool'),
('550e8400-e29b-41d4-a716-446655440014', 'Spa'),
('550e8400-e29b-41d4-a716-446655440014', 'Fine Dining'),
('550e8400-e29b-41d4-a716-446655440014', 'Rooftop Bar'),
-- Palace Gate
('550e8400-e29b-41d4-a716-446655440015', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440015', 'Pool'),
('550e8400-e29b-41d4-a716-446655440015', 'Restaurant'),
-- Sokha Beach Resort
('550e8400-e29b-41d4-a716-446655440016', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440016', 'Private Beach'),
('550e8400-e29b-41d4-a716-446655440016', 'Multiple Pools'),
('550e8400-e29b-41d4-a716-446655440016', 'Spa'),
('550e8400-e29b-41d4-a716-446655440016', 'Water Sports'),
-- Independence Hotel
('550e8400-e29b-41d4-a716-446655440017', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440017', 'Beach Access'),
('550e8400-e29b-41d4-a716-446655440017', 'Pool'),
('550e8400-e29b-41d4-a716-446655440017', 'Restaurant'),
-- Otres Beach Resort
('550e8400-e29b-41d4-a716-446655440018', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440018', 'Beach Access'),
('550e8400-e29b-41d4-a716-446655440018', 'Restaurant'),
-- Knai Bang Chatt
('550e8400-e29b-41d4-a716-446655440019', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440019', 'Infinity Pool'),
('550e8400-e29b-41d4-a716-446655440019', 'Spa'),
('550e8400-e29b-41d4-a716-446655440019', 'Restaurant'),
-- Rikitikitavi
('550e8400-e29b-41d4-a716-446655440020', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440020', 'Riverside View'),
('550e8400-e29b-41d4-a716-446655440020', 'Restaurant'),
-- Kampot Cabana
('550e8400-e29b-41d4-a716-446655440021', 'Free WiFi'),
('550e8400-e29b-41d4-a716-446655440021', 'Riverside'),
('550e8400-e29b-41d4-a716-446655440021', 'Bicycle Rental');

-- Insert Rooms for Cambodia Hotels
INSERT INTO rooms (id, hotel_id, room_type, description, price_per_night, max_guests, 
                   total_rooms, available_rooms, size, bed_type, has_breakfast, 
                   free_cancellation, created_at, updated_at)
VALUES 
-- Angkor Palace Resort Rooms
('660e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440010',
 'Deluxe Garden View', 'Spacious room with traditional Khmer decor and garden view', 
 85.00, 2, 20, 20, 38.0, 'King', true, true, NOW(), NOW()),

('660e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440010',
 'Pool Villa Suite', 'Private villa with plunge pool and outdoor shower', 
 180.00, 4, 8, 8, 75.0, 'King', true, true, NOW(), NOW()),

-- Sokha Angkor Resort Rooms
('660e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440011',
 'Superior Room', 'Modern room with pool view', 
 65.00, 2, 25, 25, 32.0, 'Queen', true, true, NOW(), NOW()),

('660e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440011',
 'Family Suite', 'Spacious suite perfect for families', 
 120.00, 4, 10, 10, 55.0, 'King + Twin', true, true, NOW(), NOW()),

-- Riverside Boutique Rooms
('660e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440012',
 'Standard Double', 'Cozy room with city view', 
 45.00, 2, 15, 15, 25.0, 'Double', true, false, NOW(), NOW()),

-- Raffles Le Royal Rooms
('660e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440013',
 'Landmark Room', 'Elegant room with colonial charm', 
 120.00, 2, 30, 30, 42.0, 'King', true, true, NOW(), NOW()),

('660e8400-e29b-41d4-a716-446655440016', '550e8400-e29b-41d4-a716-446655440013',
 'Personality Suite', 'Luxurious suite with separate living area', 
 250.00, 4, 12, 12, 80.0, 'King', true, true, NOW(), NOW()),

-- Rosewood Phnom Penh Rooms
('660e8400-e29b-41d4-a716-446655440017', '550e8400-e29b-41d4-a716-446655440014',
 'Deluxe River View', 'Modern luxury with Mekong River views', 
 150.00, 2, 25, 25, 45.0, 'King', true, true, NOW(), NOW()),

('660e8400-e29b-41d4-a716-446655440018', '550e8400-e29b-41d4-a716-446655440014',
 'Rosewood Suite', 'Ultra-luxury suite with panoramic city views', 
 300.00, 4, 8, 8, 90.0, 'King', true, true, NOW(), NOW()),

-- Palace Gate Rooms
('660e8400-e29b-41d4-a716-446655440019', '550e8400-e29b-41d4-a716-446655440015',
 'Superior Room', 'Comfortable room with Khmer design', 
 70.00, 2, 20, 20, 35.0, 'Queen', true, true, NOW(), NOW()),

-- Sokha Beach Resort Rooms
('660e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440016',
 'Deluxe Beach View', 'Beachfront room with private balcony', 
 95.00, 2, 30, 30, 40.0, 'King', true, true, NOW(), NOW()),

('660e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440016',
 'Beach Villa', 'Private villa with direct beach access', 
 220.00, 6, 10, 10, 85.0, 'King + Twin', true, true, NOW(), NOW()),

-- Independence Hotel Rooms
('660e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440017',
 'Ocean View Room', 'Classic room with ocean views', 
 75.00, 2, 18, 18, 35.0, 'Queen', true, true, NOW(), NOW()),

-- Otres Beach Resort Rooms
('660e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440018',
 'Beach Bungalow', 'Rustic bungalow steps from the beach', 
 55.00, 2, 12, 12, 28.0, 'Double', true, true, NOW(), NOW()),

-- Knai Bang Chatt Rooms
('660e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440019',
 'Seaview Suite', 'Modernist suite with infinity pool access', 
 110.00, 2, 15, 15, 50.0, 'King', true, true, NOW(), NOW()),

-- Rikitikitavi Rooms
('660e8400-e29b-41d4-a716-446655440025', '550e8400-e29b-41d4-a716-446655440020',
 'Riverside Room', 'Charming room with river views', 
 60.00, 2, 12, 12, 30.0, 'Queen', true, true, NOW(), NOW()),

-- Kampot Cabana Rooms
('660e8400-e29b-41d4-a716-446655440026', '550e8400-e29b-41d4-a716-446655440021',
 'Garden Bungalow', 'Peaceful bungalow in tropical garden', 
 35.00, 2, 10, 10, 22.0, 'Double', true, true, NOW(), NOW());

-- Insert Room Amenities for Cambodia Hotels
INSERT INTO room_amenities (room_id, amenity)
VALUES 
('660e8400-e29b-41d4-a716-446655440010', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440010', 'TV'),
('660e8400-e29b-41d4-a716-446655440010', 'Mini Bar'),
('660e8400-e29b-41d4-a716-446655440010', 'Safe'),
('660e8400-e29b-41d4-a716-446655440010', 'Balcony'),
('660e8400-e29b-41d4-a716-446655440011', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440011', 'TV'),
('660e8400-e29b-41d4-a716-446655440011', 'Private Pool'),
('660e8400-e29b-41d4-a716-446655440011', 'Outdoor Shower'),
('660e8400-e29b-41d4-a716-446655440012', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440012', 'TV'),
('660e8400-e29b-41d4-a716-446655440012', 'Mini Bar'),
('660e8400-e29b-41d4-a716-446655440015', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440015', 'TV'),
('660e8400-e29b-41d4-a716-446655440015', 'Mini Bar'),
('660e8400-e29b-41d4-a716-446655440015', 'Safe'),
('660e8400-e29b-41d4-a716-446655440015', 'Bathtub'),
('660e8400-e29b-41d4-a716-446655440020', 'WiFi'),
('660e8400-e29b-41d4-a716-446655440020', 'TV'),
('660e8400-e29b-41d4-a716-446655440020', 'Mini Bar'),
('660e8400-e29b-41d4-a716-446655440020', 'Balcony'),
('660e8400-e29b-41d4-a716-446655440020', 'Beach Access');
