package com.hotelbooker.booking.dto;

import com.hotelbooker.booking.entity.Booking;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateBookingStatusRequest {
    private Booking.BookingStatus status;
    private String notes;
    private String cancelReason;
}
