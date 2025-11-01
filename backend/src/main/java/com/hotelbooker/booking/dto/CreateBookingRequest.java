package com.hotelbooker.booking.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

import java.time.LocalDate;

@Data
public class CreateBookingRequest {
    
    @NotBlank(message = "Hotel ID is required")
    private String hotelId;
    
    @NotBlank(message = "Room ID is required")
    private String roomId;
    
    @NotNull(message = "Check-in date is required")
    @FutureOrPresent(message = "Check-in date cannot be in the past")
    private LocalDate checkInDate;
    
    @NotNull(message = "Check-out date is required")
    @FutureOrPresent(message = "Check-out date cannot be in the past")
    private LocalDate checkOutDate;
    
    @NotNull(message = "Number of guests is required")
    @Min(value = 1, message = "At least 1 guest is required")
    private Integer numberOfGuests;
    
    @NotNull(message = "Number of rooms is required")
    @Min(value = 1, message = "At least 1 room is required")
    private Integer numberOfRooms;
    
    private String specialRequests;
    
    @NotBlank(message = "Guest name is required")
    private String guestName;
    
    @NotBlank(message = "Guest email is required")
    @Email(message = "Invalid email format")
    private String guestEmail;
    
    @NotBlank(message = "Guest phone is required")
    private String guestPhone;
    
    private String paymentIntentId; // Optional: Link payment to booking
}
