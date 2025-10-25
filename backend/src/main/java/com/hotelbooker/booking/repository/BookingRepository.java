package com.hotelbooker.booking.repository;

import com.hotelbooker.booking.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, String> {
    
    List<Booking> findByUserIdOrderByCreatedAtDesc(String userId);
    
    List<Booking> findByUserIdAndStatusOrderByCheckInDateDesc(String userId, Booking.BookingStatus status);
    
    List<Booking> findByUserIdAndCheckInDateAfterOrderByCheckInDate(String userId, LocalDate date);
    
    List<Booking> findByUserIdAndCheckOutDateBeforeOrderByCheckOutDateDesc(String userId, LocalDate date);
    
    // Calendar-specific queries
    @org.springframework.data.jpa.repository.Query(
        "SELECT b FROM Booking b WHERE b.hotel.id = :hotelId " +
        "AND ((b.checkInDate <= :endDate AND b.checkOutDate >= :startDate)) " +
        "ORDER BY b.checkInDate"
    )
    List<Booking> findByHotelIdAndDateRange(
        @org.springframework.data.repository.query.Param("hotelId") String hotelId,
        @org.springframework.data.repository.query.Param("startDate") LocalDate startDate,
        @org.springframework.data.repository.query.Param("endDate") LocalDate endDate
    );
    
    @org.springframework.data.jpa.repository.Query(
        "SELECT b FROM Booking b WHERE b.roomInstance.id = :roomInstanceId " +
        "AND b.status != 'CANCELLED' " +
        "AND ((b.checkInDate < :checkOutDate AND b.checkOutDate > :checkInDate))"
    )
    List<Booking> findByRoomInstanceIdAndDateRange(
        @org.springframework.data.repository.query.Param("roomInstanceId") String roomInstanceId,
        @org.springframework.data.repository.query.Param("checkInDate") LocalDate checkInDate,
        @org.springframework.data.repository.query.Param("checkOutDate") LocalDate checkOutDate
    );
    
    // Admin queries
    List<Booking> findByHotelIdOrderByCreatedAtDesc(String hotelId);
    
    List<Booking> findByStatusOrderByCreatedAtDesc(Booking.BookingStatus status);
    
    @org.springframework.data.jpa.repository.Query(
        "SELECT b FROM Booking b WHERE b.checkInDate = :date ORDER BY b.createdAt DESC"
    )
    List<Booking> findByCheckInDate(@org.springframework.data.repository.query.Param("date") LocalDate date);
    
    @org.springframework.data.jpa.repository.Query(
        "SELECT b FROM Booking b WHERE b.checkOutDate = :date ORDER BY b.createdAt DESC"
    )
    List<Booking> findByCheckOutDate(@org.springframework.data.repository.query.Param("date") LocalDate date);
}
