package com.hotelbooker.booking.entity;

import com.hotelbooker.auth.entity.User;
import com.hotelbooker.common.entity.BaseEntity;
import com.hotelbooker.hotel.entity.Hotel;
import com.hotelbooker.hotel.entity.Room;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "bookings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = true)  // Nullable for walk-in/admin bookings
    private User user;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hotel_id", nullable = false)
    private Hotel hotel;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_instance_id")
    private com.hotelbooker.hotel.entity.RoomInstance roomInstance;
    
    @Column(nullable = false)
    private LocalDate checkInDate;
    
    @Column(nullable = false)
    private LocalDate checkOutDate;
    
    @Column(nullable = false)
    private Integer numberOfGuests;
    
    @Column(nullable = false)
    private Integer numberOfRooms;
    
    @Column(nullable = false)
    private Integer numberOfNights;
    
    @Column(nullable = false)
    private Double totalPrice;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BookingStatus status = BookingStatus.PENDING;
    
    private String specialRequests;
    
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    
    public enum BookingStatus {
        PENDING,
        CONFIRMED,
        CHECKED_IN,
        CANCELLED,
        COMPLETED
    }
}
