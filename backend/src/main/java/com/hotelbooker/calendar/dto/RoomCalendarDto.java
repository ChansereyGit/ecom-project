package com.hotelbooker.calendar.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomCalendarDto {
    private RoomInstanceDto room;
    private Map<LocalDate, BookingCellDto> bookingsByDate;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
class BookingCellDto {
    private String bookingId;
    private String guestName;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private String status;
    private boolean isCheckInDay;
    private boolean isCheckOutDay;
}
