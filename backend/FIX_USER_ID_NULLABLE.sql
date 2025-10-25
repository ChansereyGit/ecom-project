-- Make user_id nullable in bookings table for walk-in/admin bookings
ALTER TABLE bookings ALTER COLUMN user_id DROP NOT NULL;
