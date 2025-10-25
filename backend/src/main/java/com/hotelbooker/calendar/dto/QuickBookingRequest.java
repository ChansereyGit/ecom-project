package com.hotelbooker.calendar.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuickBookingRequest {
    private String roomInstanceId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private Integer numberOfGuests;
    private String specialRequests;
}
