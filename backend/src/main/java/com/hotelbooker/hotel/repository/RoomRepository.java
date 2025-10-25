package com.hotelbooker.hotel.repository;

import com.hotelbooker.hotel.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, String> {
    List<Room> findByHotelIdAndAvailableRoomsGreaterThan(String hotelId, Integer minAvailable);
}
