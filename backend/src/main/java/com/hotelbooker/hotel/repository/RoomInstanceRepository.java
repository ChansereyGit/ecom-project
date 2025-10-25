package com.hotelbooker.hotel.repository;

import com.hotelbooker.hotel.entity.RoomInstance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoomInstanceRepository extends JpaRepository<RoomInstance, String> {
    
    List<RoomInstance> findByRoomTypeId(String roomTypeId);
    
    @Query("SELECT ri FROM RoomInstance ri WHERE ri.roomType.hotel.id = :hotelId ORDER BY ri.floor, ri.roomNumber")
    List<RoomInstance> findByHotelIdOrderByFloorAndRoomNumber(@Param("hotelId") String hotelId);
    
    @Query("SELECT ri FROM RoomInstance ri WHERE ri.roomType.hotel.id = :hotelId AND ri.status = :status")
    List<RoomInstance> findByHotelIdAndStatus(@Param("hotelId") String hotelId, @Param("status") RoomInstance.RoomStatus status);
    
    Optional<RoomInstance> findByRoomNumber(String roomNumber);
    
    boolean existsByRoomNumber(String roomNumber);
    
    @Query("SELECT COUNT(ri) FROM RoomInstance ri WHERE ri.roomType.hotel.id = :hotelId AND ri.status = 'AVAILABLE'")
    long countAvailableRoomsByHotelId(@Param("hotelId") String hotelId);
    
    @Query("SELECT ri FROM RoomInstance ri WHERE ri.floor = :floor ORDER BY ri.roomNumber")
    List<RoomInstance> findByFloor(@Param("floor") Integer floor);
}
