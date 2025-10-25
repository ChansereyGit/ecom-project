-- Add status column to hotels table
-- This migration adds the hotel status field (ACTIVE, MAINTENANCE, INACTIVE)

-- Add status column with default value ACTIVE
ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE';

-- Add check constraint to ensure valid status values
ALTER TABLE hotels 
ADD CONSTRAINT check_hotel_status 
CHECK (status IN ('ACTIVE', 'MAINTENANCE', 'INACTIVE'));

-- Update existing hotels to have ACTIVE status
UPDATE hotels 
SET status = 'ACTIVE' 
WHERE status IS NULL;

-- Create index on status for faster filtering
CREATE INDEX IF NOT EXISTS idx_hotels_status ON hotels(status);

-- Verify the changes
SELECT id, name, status FROM hotels LIMIT 10;
