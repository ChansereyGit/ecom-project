-- Add Contact Information and Operational Settings to Hotels Table
-- These fields are optional and won't break existing data or Flutter app

-- Add Contact Information columns
ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS phone_number VARCHAR(50),
ADD COLUMN IF NOT EXISTS email VARCHAR(255),
ADD COLUMN IF NOT EXISTS website VARCHAR(500);

-- Add Operational Settings columns
ALTER TABLE hotels
ADD COLUMN IF NOT EXISTS check_in_time VARCHAR(10),
ADD COLUMN IF NOT EXISTS check_out_time VARCHAR(10);

-- Verify the columns were added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'hotels' 
AND column_name IN ('phone_number', 'email', 'website', 'check_in_time', 'check_out_time');

-- Optional: Update existing hotels with default values
UPDATE hotels 
SET check_in_time = '15:00', 
    check_out_time = '11:00'
WHERE check_in_time IS NULL;
