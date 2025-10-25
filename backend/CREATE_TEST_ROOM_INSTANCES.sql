-- Quick Setup: Create Test Room Instances
-- This script creates room instances for your existing hotels

-- First, let's see what we have
SELECT 'Current Hotels:' as info;
SELECT id, name FROM hotels LIMIT 5;

SELECT 'Current Room Types:' as info;
SELECT r.id, r.room_type, r.price_per_night, h.name as hotel_name 
FROM rooms r 
JOIN hotels h ON r.hotel_id = h.id 
LIMIT 10;

-- Create room instances for each room type
-- This will create 5 room instances per room type (rooms 101-105)

DO $$
DECLARE
    room_type_record RECORD;
    room_num INTEGER;
BEGIN
    -- Loop through all room types
    FOR room_type_record IN 
        SELECT r.id as room_type_id, r.room_type, h.name as hotel_name
        FROM rooms r
        JOIN hotels h ON r.hotel_id = h.id
    LOOP
        RAISE NOTICE 'Creating room instances for % in %', room_type_record.room_type, room_type_record.hotel_name;
        
        -- Create 5 room instances (101-105) for this room type
        FOR room_num IN 101..105 LOOP
            -- Check if room number already exists
            IF NOT EXISTS (SELECT 1 FROM room_instances WHERE room_number = room_num::text) THEN
                INSERT INTO room_instances (id, room_type_id, room_number, floor, status, created_at, updated_at)
                VALUES (
                    gen_random_uuid()::text,
                    room_type_record.room_type_id,
                    room_num::text,
                    1, -- Floor 1
                    'AVAILABLE',
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP
                );
            END IF;
        END LOOP;
        
        -- Create 5 more on floor 2 (201-205)
        FOR room_num IN 201..205 LOOP
            IF NOT EXISTS (SELECT 1 FROM room_instances WHERE room_number = room_num::text) THEN
                INSERT INTO room_instances (id, room_type_id, room_number, floor, status, created_at, updated_at)
                VALUES (
                    gen_random_uuid()::text,
                    room_type_record.room_type_id,
                    room_num::text,
                    2, -- Floor 2
                    'AVAILABLE',
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP
                );
            END IF;
        END LOOP;
    END LOOP;
END $$;

-- Verify room instances were created
SELECT 'Room Instances Created:' as info;
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
ORDER BY h.name, ri.floor, ri.room_number;

-- Count by hotel
SELECT 'Room Instances by Hotel:' as info;
SELECT 
    h.name as hotel_name,
    COUNT(ri.id) as room_count
FROM hotels h
LEFT JOIN rooms r ON r.hotel_id = h.id
LEFT JOIN room_instances ri ON ri.room_type_id = r.id
GROUP BY h.id, h.name
ORDER BY h.name;
