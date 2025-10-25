package com.hotelbooker.booking.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingDto {
    private String id;
    private String userId;
    private String hotelId;
    private String hotelName;
    private String roomId;
    private String roomType;
    private String roomNumber;  // Physical room number (101, 102, etc.)
    private String roomInstanceId;  // Room instance ID for calendar matching
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private Integer numberOfGuests;
    private Integer numberOfRooms;
    private Integer numberOfNights;
    private Double totalPrice;
    private String status;
    private String specialRequests;
    private String guestName;
    private String guestEmail;
    private String guestPhone;
}
