-- Complete Calendar Setup Script
-- This script sets up everything needed for the calendar to work

-- Step 1: Check current state
\echo '=== Current Database State ==='
SELECT 'Hotels:' as info, COUNT(*) as count FROM hotels;
SELECT 'Room Types:' as info, COUNT(*) as count FROM rooms;
SELECT 'Room Instances:' as info, COUNT(*) as count FROM room_instances;
SELECT 'Bookings:' as info, COUNT(*) as count FROM bookings;

-- Step 2: Create room_instances table if it doesn't exist
\echo ''
\echo '=== Creating room_instances table ==='

CREATE TABLE IF NOT EXISTS room_instances (
    id VARCHAR(255) PRIMARY KEY,
    room_type_id VARCHAR(255) NOT NULL,
    room_number VARCHAR(50) NOT NULL,
    floor INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_room_type FOREIGN KEY (room_type_id) REFERENCES rooms(id) ON DELETE CASCADE,
    CONSTRAINT unique_room_number UNIQUE (room_number),
    CONSTRAINT check_room_status CHECK (status IN ('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'BLOCKED'))
);

-- Step 3: Add room_instance_id to bookings if not exists
\echo '=== Updating bookings table ==='

ALTER TABLE bookings 
ADD COLUMN IF NOT EXISTS room_instance_id VARCHAR(255);

-- Add foreign key constraint only if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_room_instance'
    ) THEN
        ALTER TABLE bookings 
        ADD CONSTRAINT fk_room_instance 
        FOREIGN KEY (room_instance_id) REFERENCES room_instances(id);
    END IF;
END $$;

-- Step 4: Create indexes
\echo '=== Creating indexes ==='

CREATE INDEX IF NOT EXISTS idx_room_instances_type ON room_instances(room_type_id);
CREATE INDEX IF NOT EXISTS idx_room_instances_status ON room_instances(status);
CREATE INDEX IF NOT EXISTS idx_room_instances_floor ON room_instances(floor);
CREATE INDEX IF NOT EXISTS idx_bookings_room_instance ON bookings(room_instance_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates ON bookings(check_in_date, check_out_date);

-- Step 5: Clear existing room instances (optional - comment out if you want to keep existing data)
-- TRUNCATE room_instances CASCADE;

-- Step 6: Create room instances for all room types
\echo ''
\echo '=== Creating room instances ==='

DO $$
DECLARE
    room_type_record RECORD;
    room_num INTEGER;
    instances_created INTEGER := 0;
BEGIN
    -- Loop through all room types
    FOR room_type_record IN 
        SELECT r.id as room_type_id, r.room_type, h.name as hotel_name, h.id as hotel_id
        FROM rooms r
        JOIN hotels h ON r.hotel_id = h.id
        ORDER BY h.name, r.room_type
    LOOP
        RAISE NOTICE 'Creating room instances for % (%) in %', 
            room_type_record.room_type, 
            room_type_record.room_type_id,
            room_type_record.hotel_name;
        
        -- Create 5 room instances on floor 1 (101-105)
        FOR room_num IN 101..105 LOOP
            -- Just use room number (101, 102, etc.)
            IF NOT EXISTS (SELECT 1 FROM room_instances WHERE room_number = room_num::text AND room_type_id = room_type_record.room_type_id) THEN
                INSERT INTO room_instances (id, room_type_id, room_number, floor, status, created_at, updated_at)
                VALUES (
                    gen_random_uuid()::text,
                    room_type_record.room_type_id,
                    room_num::text,
                    1,
                    'AVAILABLE',
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP
                );
                instances_created := instances_created + 1;
            END IF;
        END LOOP;
        
        -- Create 5 more on floor 2 (201-205)
        FOR room_num IN 201..205 LOOP
            IF NOT EXISTS (SELECT 1 FROM room_instances WHERE room_number = room_num::text AND room_type_id = room_type_record.room_type_id) THEN
                INSERT INTO room_instances (id, room_type_id, room_number, floor, status, created_at, updated_at)
                VALUES (
                    gen_random_uuid()::text,
                    room_type_record.room_type_id,
                    room_num::text,
                    2,
                    'AVAILABLE',
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP
                );
                instances_created := instances_created + 1;
            END IF;
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'Total room instances created: %', instances_created;
END $$;

-- Step 7: Verify setup
\echo ''
\echo '=== Verification ==='

SELECT 'Room Instances Created:' as info, COUNT(*) as count FROM room_instances;

\echo ''
\echo '=== Room Instances by Hotel ==='
SELECT 
    h.name as hotel_name,
    COUNT(ri.id) as room_count,
    COUNT(CASE WHEN ri.status = 'AVAILABLE' THEN 1 END) as available,
    COUNT(CASE WHEN ri.status = 'OCCUPIED' THEN 1 END) as occupied
FROM hotels h
LEFT JOIN rooms r ON r.hotel_id = h.id
LEFT JOIN room_instances ri ON ri.room_type_id = r.id
GROUP BY h.id, h.name
ORDER BY h.name;

\echo ''
\echo '=== Sample Room Instances ==='
SELECT 
    ri.room_number,
    ri.floor,
    ri.status,
    r.room_type,
    r.price_per_night,
    h.name as hotel_name
FROM room_instances ri
JOIN rooms r ON ri.room_type_id = r.id
JOIN hotels h ON r.hotel_id = h.id
ORDER BY h.name, ri.floor, ri.room_number
LIMIT 20;

\echo ''
\echo '=== Setup Complete! ==='
\echo 'You can now:'
\echo '1. Restart your backend: cd backend && ./mvnw spring-boot:run'
\echo '2. Refresh the admin portal'
\echo '3. Navigate to Calendar page'
\echo '4. Select a hotel from the dropdown'
\echo '5. You should see the room instances in the calendar!'
