package com.hotelbooker.booking.controller;

import com.hotelbooker.booking.dto.BookingDto;
import com.hotelbooker.booking.dto.CreateBookingRequest;

import com.hotelbooker.booking.service.BookingService;
import com.hotelbooker.common.dto.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/bookings")
@RequiredArgsConstructor
public class BookingController {
    
    private final BookingService bookingService;
    
    @PostMapping
    public ResponseEntity<ApiResponse<BookingDto>> createBooking(
            @Valid @RequestBody CreateBookingRequest request
    ) {
        BookingDto booking = bookingService.createBooking(request);
        return ResponseEntity.ok(ApiResponse.success("Booking created successfully", booking));
    }
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<BookingDto>>> getUserBookings() {
        List<BookingDto> bookings = bookingService.getUserBookings();
        return ResponseEntity.ok(ApiResponse.success(bookings));
    }
    
    @GetMapping("/{bookingId}")
    public ResponseEntity<ApiResponse<BookingDto>> getBookingById(
            @PathVariable String bookingId
    ) {
        BookingDto booking = bookingService.getBookingById(bookingId);
        return ResponseEntity.ok(ApiResponse.success(booking));
    }
    
    @GetMapping("/upcoming")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getUpcomingBookings() {
        List<BookingDto> bookings = bookingService.getUpcomingBookings();
        return ResponseEntity.ok(ApiResponse.success(bookings));
    }
    
    @PostMapping("/{bookingId}/cancel")
    public ResponseEntity<ApiResponse<BookingDto>> cancelBooking(
            @PathVariable String bookingId
    ) {
        BookingDto booking = bookingService.cancelBooking(bookingId);
        return ResponseEntity.ok(ApiResponse.success("Booking cancelled successfully", booking));
    }
    
    // Admin endpoints
    @GetMapping("/admin/all")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getAllBookings() {
        List<BookingDto> bookings = bookingService.getAllBookings();
        return ResponseEntity.ok(ApiResponse.success(bookings));
    }
    
    @GetMapping("/admin/hotel/{hotelId}")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getBookingsByHotel(
            @PathVariable String hotelId
    ) {
        List<BookingDto> bookings = bookingService.getBookingsByHotel(hotelId);
        return ResponseEntity.ok(ApiResponse.success(bookings));
    }
    
    @GetMapping("/admin/status/{status}")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getBookingsByStatus(
            @PathVariable String status
    ) {
        com.hotelbooker.booking.entity.Booking.BookingStatus bookingStatus = 
            com.hotelbooker.booking.entity.Booking.BookingStatus.valueOf(status.toUpperCase());
        List<BookingDto> bookings = bookingService.getBookingsByStatus(bookingStatus);
        return ResponseEntity.ok(ApiResponse.success(bookings));
    }
    
    @PutMapping("/admin/{bookingId}/status")
    public ResponseEntity<ApiResponse<BookingDto>> updateBookingStatus(
            @PathVariable String bookingId,
            @RequestParam String status
    ) {
        com.hotelbooker.booking.entity.Booking.BookingStatus newStatus = 
            com.hotelbooker.booking.entity.Booking.BookingStatus.valueOf(status.toUpperCase());
        BookingDto booking = bookingService.updateBookingStatus(bookingId, newStatus);
        return ResponseEntity.ok(ApiResponse.success("Booking status updated successfully", booking));
    }
    
    @PostMapping("/admin/{bookingId}/check-in")
    public ResponseEntity<ApiResponse<BookingDto>> checkInBooking(
            @PathVariable String bookingId
    ) {
        BookingDto booking = bookingService.checkInBooking(bookingId);
        return ResponseEntity.ok(ApiResponse.success("Guest checked in successfully", booking));
    }
    
    @PostMapping("/admin/{bookingId}/check-out")
    public ResponseEntity<ApiResponse<BookingDto>> checkOutBooking(
            @PathVariable String bookingId
    ) {
        BookingDto booking = bookingService.checkOutBooking(bookingId);
        return ResponseEntity.ok(ApiResponse.success("Guest checked out successfully", booking));
    }
}
