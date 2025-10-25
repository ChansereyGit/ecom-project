-- Fix Payment table to allow null booking_id
-- This is needed because we create the payment BEFORE the booking exists

ALTER TABLE payments ALTER COLUMN booking_id DROP NOT NULL;

-- Verify the change
\d payments;
