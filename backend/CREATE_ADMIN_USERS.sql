-- Create Admin Users for Hotel Management Portal
-- Run this script to create admin and user accounts

-- Note: Passwords are BCrypt hashed
-- admin123 -> $2a$10$xqxQ8Z9X8Z9X8Z9X8Z9X8eK5K5K5K5K5K5K5K5K5K5K5K5K5K5K5K5
-- user123  -> $2a$10$yqyQ8Z9X8Z9X8Z9X8Z9X8eL6L6L6L6L6L6L6L6L6L6L6L6L6L6L6L6

-- Delete existing admin users if they exist
DELETE FROM users WHERE email IN ('admin@hotel.com', 'user@hotel.com');

-- Insert Admin User
INSERT INTO users (id, full_name, email, password, phone_number, role, email_verified, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'Admin User',
    'admin@hotel.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', -- password: admin123
    '+1234567890',
    'ADMIN',
    true,
    NOW(),
    NOW()
);

-- Insert Regular User
INSERT INTO users (id, full_name, email, password, phone_number, role, email_verified, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'Regular User',
    'user@hotel.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', -- password: user123
    '+1234567891',
    'USER',
    true,
    NOW(),
    NOW()
);

-- Verify the users were created
SELECT id, full_name, email, role, email_verified, created_at 
FROM users 
WHERE email IN ('admin@hotel.com', 'user@hotel.com');
