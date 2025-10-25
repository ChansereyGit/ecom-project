package com.hotelbooker.calendar.controller;

import com.hotelbooker.booking.dto.BookingDto;
import com.hotelbooker.calendar.dto.QuickBookingRequest;
import com.hotelbooker.calendar.dto.RoomInstanceDto;
import com.hotelbooker.calendar.service.CalendarService;
import com.hotelbooker.common.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/calendar")
@RequiredArgsConstructor
public class CalendarController {
    
    private final CalendarService calendarService;
    
    /**
     * Get all room instances for a hotel
     */
    @GetMapping("/rooms")
    public ResponseEntity<ApiResponse<List<RoomInstanceDto>>> getRoomInstances(
            @RequestParam String hotelId
    ) {
        List<RoomInstanceDto> rooms = calendarService.getRoomInstances(hotelId);
        return ResponseEntity.ok(ApiResponse.success(rooms));
    }
    
    /**
     * Get bookings for date range
     */
    @GetMapping("/bookings")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getBookings(
            @RequestParam String hotelId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate
    ) {
        List<BookingDto> bookings = calendarService.getBookingsForDateRange(
                hotelId, startDate, endDate
        );
        return ResponseEntity.ok(ApiResponse.success(bookings));
    }
    
    /**
     * Check room availability
     */
    @GetMapping("/availability")
    public ResponseEntity<ApiResponse<Map<String, Boolean>>> checkAvailability(
            @RequestParam String roomInstanceId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkInDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkOutDate
    ) {
        boolean available = calendarService.isRoomAvailable(
                roomInstanceId, checkInDate, checkOutDate
        );
        return ResponseEntity.ok(ApiResponse.success(Map.of("available", available)));
    }
    
    /**
     * Create quick booking from calendar
     */
    @PostMapping("/bookings/quick")
    public ResponseEntity<ApiResponse<BookingDto>> createQuickBooking(
            @RequestBody QuickBookingRequest request
    ) {
        BookingDto booking = calendarService.createQuickBooking(request);
        return ResponseEntity.ok(ApiResponse.success(booking));
    }
    
    /**
     * Update room status
     */
    @PutMapping("/rooms/{roomInstanceId}/status")
    public ResponseEntity<ApiResponse<RoomInstanceDto>> updateRoomStatus(
            @PathVariable String roomInstanceId,
            @RequestBody Map<String, String> request
    ) {
        String status = request.get("status");
        RoomInstanceDto room = calendarService.updateRoomStatus(roomInstanceId, status);
        return ResponseEntity.ok(ApiResponse.success(room));
    }
}
