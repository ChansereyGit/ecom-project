package com.hotelbooker.calendar.service;

import com.hotelbooker.booking.dto.BookingDto;
import com.hotelbooker.booking.entity.Booking;
import com.hotelbooker.booking.repository.BookingRepository;
import com.hotelbooker.calendar.dto.QuickBookingRequest;
import com.hotelbooker.calendar.dto.RoomInstanceDto;
import com.hotelbooker.common.exception.ResourceNotFoundException;
import com.hotelbooker.hotel.entity.Room;
import com.hotelbooker.hotel.entity.RoomInstance;
import com.hotelbooker.hotel.repository.RoomInstanceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CalendarService {
    
    private final RoomInstanceRepository roomInstanceRepository;
    private final BookingRepository bookingRepository;
    
    /**
     * Get all room instances for a hotel
     */
    public List<RoomInstanceDto> getRoomInstances(String hotelId) {
        return roomInstanceRepository.findByHotelIdOrderByFloorAndRoomNumber(hotelId)
                .stream()
                .map(this::mapToRoomInstanceDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Get bookings for a hotel within date range
     */
    public List<BookingDto> getBookingsForDateRange(
            String hotelId,
            LocalDate startDate,
            LocalDate endDate
    ) {
        List<Booking> bookings = bookingRepository.findByHotelIdAndDateRange(
                hotelId, startDate, endDate
        );
        
        return bookings.stream()
                .map(this::mapToBookingDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Check if a specific room instance is available for date range
     */
    public boolean isRoomAvailable(
            String roomInstanceId,
            LocalDate checkInDate,
            LocalDate checkOutDate
    ) {
        // Check for overlapping bookings
        List<Booking> overlappingBookings = bookingRepository
                .findByRoomInstanceIdAndDateRange(roomInstanceId, checkInDate, checkOutDate);
        
        // Filter out cancelled bookings
        return overlappingBookings.stream()
                .noneMatch(b -> b.getStatus() != Booking.BookingStatus.CANCELLED);
    }
    
    /**
     * Create a quick booking from calendar
     */
    @Transactional
    public BookingDto createQuickBooking(QuickBookingRequest request) {
        // Validate room instance exists
        RoomInstance roomInstance = roomInstanceRepository.findById(request.getRoomInstanceId())
                .orElseThrow(() -> new ResourceNotFoundException("Room not found"));
        
        // Validate dates
        if (request.getCheckOutDate().isBefore(request.getCheckInDate()) ||
            request.getCheckOutDate().isEqual(request.getCheckInDate())) {
            throw new IllegalArgumentException("Check-out date must be after check-in date");
        }
        
        // Check availability
        if (!isRoomAvailable(
                request.getRoomInstanceId(),
                request.getCheckInDate(),
                request.getCheckOutDate()
        )) {
            throw new IllegalArgumentException("Room is not available for selected dates");
        }
        
        // Calculate nights and total price
        long nights = ChronoUnit.DAYS.between(request.getCheckInDate(), request.getCheckOutDate());
        Room roomType = roomInstance.getRoomType();
        double totalPrice = roomType.getPricePerNight() * nights;
        
        // Create booking
        Booking booking = Booking.builder()
                .roomInstance(roomInstance)
                .room(roomType)
                .hotel(roomInstance.getHotel())
                .checkInDate(request.getCheckInDate())
                .checkOutDate(request.getCheckOutDate())
                .numberOfGuests(request.getNumberOfGuests() != null ? request.getNumberOfGuests() : 1)
                .numberOfRooms(1)  // Always 1 for specific room instance
                .numberOfNights((int) nights)
                .totalPrice(totalPrice)
                .status(Booking.BookingStatus.CONFIRMED)
                .guestName(request.getGuestName())
                .guestEmail(request.getGuestEmail())
                .guestPhone(request.getGuestPhone())
                .specialRequests(request.getSpecialRequests())
                .build();
        
        booking = bookingRepository.save(booking);
        
        // Update room instance status to OCCUPIED
        roomInstance.setStatus(RoomInstance.RoomStatus.OCCUPIED);
        roomInstanceRepository.save(roomInstance);
        
        return mapToBookingDto(booking);
    }
    
    /**
     * Update room instance status
     */
    @Transactional
    public RoomInstanceDto updateRoomStatus(String roomInstanceId, String status) {
        RoomInstance roomInstance = roomInstanceRepository.findById(roomInstanceId)
                .orElseThrow(() -> new ResourceNotFoundException("Room not found"));
        
        roomInstance.setStatus(RoomInstance.RoomStatus.valueOf(status));
        roomInstance = roomInstanceRepository.save(roomInstance);
        
        return mapToRoomInstanceDto(roomInstance);
    }
    
    /**
     * Create a new room instance
     */
    @Transactional
    public RoomInstanceDto createRoomInstance(String roomTypeId, String roomNumber, Integer floor) {
        // Check if room number already exists
        if (roomInstanceRepository.existsByRoomNumber(roomNumber)) {
            throw new IllegalArgumentException("Room number already exists");
        }
        
        // This would need a RoomRepository to fetch the room type
        // For now, assuming it's passed correctly
        RoomInstance roomInstance = RoomInstance.builder()
                .roomNumber(roomNumber)
                .floor(floor)
                .status(RoomInstance.RoomStatus.AVAILABLE)
                .build();
        
        roomInstance = roomInstanceRepository.save(roomInstance);
        return mapToRoomInstanceDto(roomInstance);
    }
    
    // Mapping methods
    private RoomInstanceDto mapToRoomInstanceDto(RoomInstance roomInstance) {
        Room roomType = roomInstance.getRoomType();
        
        return RoomInstanceDto.builder()
                .id(roomInstance.getId())
                .roomTypeId(roomType.getId())
                .roomNumber(roomInstance.getRoomNumber())
                .floor(roomInstance.getFloor())
                .status(roomInstance.getStatus().name())
                .notes(roomInstance.getNotes())
                .roomTypeName(roomType.getRoomType())
                .pricePerNight(roomType.getPricePerNight())
                .maxGuests(roomType.getMaxGuests())
                .bedType(roomType.getBedType())
                .build();
    }
    
    private BookingDto mapToBookingDto(Booking booking) {
        return BookingDto.builder()
                .id(booking.getId())
                .userId(booking.getUser() != null ? booking.getUser().getId() : null)
                .hotelId(booking.getHotel().getId())
                .hotelName(booking.getHotel().getName())
                .roomId(booking.getRoom().getId())
                .roomType(booking.getRoom().getRoomType())
                .roomNumber(booking.getRoomInstance() != null ? booking.getRoomInstance().getRoomNumber() : null)
                .roomInstanceId(booking.getRoomInstance() != null ? booking.getRoomInstance().getId() : null)
                .checkInDate(booking.getCheckInDate())
                .checkOutDate(booking.getCheckOutDate())
                .numberOfGuests(booking.getNumberOfGuests())
                .numberOfRooms(booking.getNumberOfRooms())
                .numberOfNights(booking.getNumberOfNights())
                .totalPrice(booking.getTotalPrice())
                .status(booking.getStatus().name())
                .guestName(booking.getGuestName())
                .guestEmail(booking.getGuestEmail())
                .guestPhone(booking.getGuestPhone())
                .specialRequests(booking.getSpecialRequests())
                .build();
    }
}
