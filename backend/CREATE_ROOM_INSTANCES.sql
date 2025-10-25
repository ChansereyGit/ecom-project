-- Create Room Instances Table for Individual Physical Rooms
-- This allows tracking of specific rooms (101, 102, etc.) vs room types (Deluxe, Suite)

-- Create room_instances table
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

-- Add room_instance_id to bookings table
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

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_room_instances_type ON room_instances(room_type_id);
CREATE INDEX IF NOT EXISTS idx_room_instances_status ON room_instances(status);
CREATE INDEX IF NOT EXISTS idx_room_instances_floor ON room_instances(floor);
CREATE INDEX IF NOT EXISTS idx_bookings_room_instance ON bookings(room_instance_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates ON bookings(check_in_date, check_out_date);

-- Sample data: Create room instances for existing room types
-- This assumes you have room types already created

-- Example: If you have a "Deluxe King" room type, create physical instances
-- INSERT INTO room_instances (id, room_type_id, room_number, floor, status) VALUES
-- (gen_random_uuid()::text, 'your-room-type-id', '101', 1, 'AVAILABLE'),
-- (gen_random_uuid()::text, 'your-room-type-id', '102', 1, 'AVAILABLE'),
-- (gen_random_uuid()::text, 'your-room-type-id', '103', 1, 'AVAILABLE');

-- Function to check room availability for date range
CREATE OR REPLACE FUNCTION is_room_available(
    p_room_instance_id VARCHAR(255),
    p_check_in_date DATE,
    p_check_out_date DATE
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN NOT EXISTS (
        SELECT 1 FROM bookings
        WHERE room_instance_id = p_room_instance_id
        AND status NOT IN ('CANCELLED')
        AND (
            (check_in_date <= p_check_in_date AND check_out_date > p_check_in_date)
            OR (check_in_date < p_check_out_date AND check_out_date >= p_check_out_date)
            OR (check_in_date >= p_check_in_date AND check_out_date <= p_check_out_date)
        )
    );
END;
$$ LANGUAGE plpgsql;

-- View to see room availability summary
CREATE OR REPLACE VIEW room_availability_summary AS
SELECT 
    ri.id as room_instance_id,
    ri.room_number,
    ri.floor,
    ri.status as room_status,
    r.room_type,
    r.price_per_night,
    r.max_guests,
    COUNT(b.id) as total_bookings,
    COUNT(CASE WHEN b.status = 'CONFIRMED' THEN 1 END) as confirmed_bookings,
    COUNT(CASE WHEN b.check_in_date <= CURRENT_DATE AND b.check_out_date > CURRENT_DATE THEN 1 END) as current_bookings
FROM room_instances ri
LEFT JOIN rooms r ON ri.room_type_id = r.id
LEFT JOIN bookings b ON ri.id = b.room_instance_id
GROUP BY ri.id, ri.room_number, ri.floor, ri.status, r.room_type, r.price_per_night, r.max_guests;

COMMENT ON TABLE room_instances IS 'Physical room instances (Room 101, 102, etc.) linked to room types';
COMMENT ON COLUMN room_instances.room_type_id IS 'Reference to the room type (Deluxe, Suite, etc.)';
COMMENT ON COLUMN room_instances.room_number IS 'Physical room number (101, 102, 201A, etc.)';
COMMENT ON COLUMN room_instances.status IS 'Current status: AVAILABLE, OCCUPIED, MAINTENANCE, BLOCKED';
