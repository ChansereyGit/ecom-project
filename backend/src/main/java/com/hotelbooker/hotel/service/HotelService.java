package com.hotelbooker.hotel.service;

import com.hotelbooker.common.exception.ResourceNotFoundException;
import com.hotelbooker.hotel.dto.HotelDto;
import com.hotelbooker.hotel.dto.HotelSearchRequest;
import com.hotelbooker.hotel.dto.RoomDto;
import com.hotelbooker.hotel.entity.Hotel;
import com.hotelbooker.hotel.entity.Room;
import com.hotelbooker.hotel.repository.HotelRepository;
import com.hotelbooker.hotel.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HotelService {
    
    private final HotelRepository hotelRepository;
    private final RoomRepository roomRepository;
    
    public List<HotelDto> getAllHotels() {
        return hotelRepository.findAll()
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }
    
    public List<HotelDto> searchHotels(HotelSearchRequest request) {
        List<Hotel> hotels;
        
        if (request.getLocation() != null && !request.getLocation().isEmpty()) {
            hotels = hotelRepository.searchByLocation(request.getLocation());
        } else {
            hotels = hotelRepository.findAll();
        }
        
        // Get search parameters for dynamic pricing
        int numberOfRooms = request.getRooms() != null ? request.getRooms() : 1;
        int numberOfGuests = request.getGuests() != null ? request.getGuests() : 2;
        
        // Apply filters and calculate dynamic pricing
        return hotels.stream()
                .filter(h -> request.getMinPrice() == null || h.getPricePerNight() >= request.getMinPrice())
                .filter(h -> request.getMaxPrice() == null || h.getPricePerNight() <= request.getMaxPrice())
                .filter(h -> request.getMinStarRating() == null || h.getStarRating() >= request.getMinStarRating())
                .filter(h -> request.getMinGuestRating() == null || h.getGuestRating() >= request.getMinGuestRating())
                .map(h -> mapToDtoWithDynamicPricing(h, numberOfRooms, numberOfGuests))
                .collect(Collectors.toList());
    }
    
    public HotelDto getHotelById(String hotelId) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found with id: " + hotelId));
        return mapToDto(hotel);
    }
    
    public List<RoomDto> getHotelRooms(String hotelId) {
        if (!hotelRepository.existsById(hotelId)) {
            throw new ResourceNotFoundException("Hotel not found with id: " + hotelId);
        }
        
        List<Room> rooms = roomRepository.findByHotelIdAndAvailableRoomsGreaterThan(hotelId, 0);
        return rooms.stream()
                .map(this::mapToRoomDto)
                .collect(Collectors.toList());
    }
    
    public List<HotelDto> getFeaturedHotels() {
        return hotelRepository.findByFeaturedTrueAndAvailableTrue()
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }
    
    public List<String> getPopularDestinations() {
        return hotelRepository.findAllCities();
    }
    
    public HotelDto createHotel(HotelDto hotelDto) {
        Hotel hotel = Hotel.builder()
                .name(hotelDto.getName())
                .description(hotelDto.getDescription())
                .address(hotelDto.getAddress())
                .city(hotelDto.getCity())
                .country(hotelDto.getCountry())
                .latitude(hotelDto.getLatitude() != null ? hotelDto.getLatitude() : 0.0)
                .longitude(hotelDto.getLongitude() != null ? hotelDto.getLongitude() : 0.0)
                .pricePerNight(hotelDto.getPricePerNight())
                .guestRating(hotelDto.getGuestRating() != null ? hotelDto.getGuestRating() : 0.0)
                .totalReviews(hotelDto.getTotalReviews() != null ? hotelDto.getTotalReviews() : 0)
                .starRating(hotelDto.getStarRating())
                .images(hotelDto.getImages() != null ? hotelDto.getImages() : List.of())
                .amenities(hotelDto.getAmenities() != null ? hotelDto.getAmenities() : List.of())
                .featured(hotelDto.isFeatured())
                .available(hotelDto.isAvailable())
                .status(hotelDto.getStatus() != null ? Hotel.HotelStatus.valueOf(hotelDto.getStatus()) : Hotel.HotelStatus.ACTIVE)
                .phoneNumber(hotelDto.getPhoneNumber())
                .email(hotelDto.getEmail())
                .website(hotelDto.getWebsite())
                .checkInTime(hotelDto.getCheckInTime())
                .checkOutTime(hotelDto.getCheckOutTime())
                .build();
        
        Hotel savedHotel = hotelRepository.save(hotel);
        return mapToDto(savedHotel);
    }
    
    public HotelDto updateHotel(String hotelId, HotelDto hotelDto) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found with id: " + hotelId));
        
        hotel.setName(hotelDto.getName());
        hotel.setDescription(hotelDto.getDescription());
        hotel.setAddress(hotelDto.getAddress());
        hotel.setCity(hotelDto.getCity());
        hotel.setCountry(hotelDto.getCountry());
        hotel.setLatitude(hotelDto.getLatitude() != null ? hotelDto.getLatitude() : hotel.getLatitude());
        hotel.setLongitude(hotelDto.getLongitude() != null ? hotelDto.getLongitude() : hotel.getLongitude());
        hotel.setPricePerNight(hotelDto.getPricePerNight());
        hotel.setGuestRating(hotelDto.getGuestRating() != null ? hotelDto.getGuestRating() : hotel.getGuestRating());
        hotel.setTotalReviews(hotelDto.getTotalReviews() != null ? hotelDto.getTotalReviews() : hotel.getTotalReviews());
        hotel.setStarRating(hotelDto.getStarRating());
        hotel.setImages(hotelDto.getImages() != null ? hotelDto.getImages() : hotel.getImages());
        hotel.setAmenities(hotelDto.getAmenities() != null ? hotelDto.getAmenities() : hotel.getAmenities());
        hotel.setFeatured(hotelDto.isFeatured());
        hotel.setAvailable(hotelDto.isAvailable());
        if (hotelDto.getStatus() != null) {
            hotel.setStatus(Hotel.HotelStatus.valueOf(hotelDto.getStatus()));
        }
        hotel.setPhoneNumber(hotelDto.getPhoneNumber());
        hotel.setEmail(hotelDto.getEmail());
        hotel.setWebsite(hotelDto.getWebsite());
        hotel.setCheckInTime(hotelDto.getCheckInTime());
        hotel.setCheckOutTime(hotelDto.getCheckOutTime());
        
        Hotel updatedHotel = hotelRepository.save(hotel);
        return mapToDto(updatedHotel);
    }
    
    public void deleteHotel(String hotelId) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found with id: " + hotelId));
        hotelRepository.delete(hotel);
    }
    
    // Room management methods
    public RoomDto createRoom(String hotelId, RoomDto roomDto) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found with id: " + hotelId));
        
        Room room = Room.builder()
                .hotel(hotel)
                .roomType(roomDto.getRoomType())
                .description(roomDto.getDescription())
                .pricePerNight(roomDto.getPricePerNight())
                .maxGuests(roomDto.getMaxGuests())
                .totalRooms(roomDto.getTotalRooms())
                .availableRooms(roomDto.getAvailableRooms() != null ? roomDto.getAvailableRooms() : roomDto.getTotalRooms())
                .size(roomDto.getSize())
                .images(roomDto.getImages() != null ? roomDto.getImages() : List.of())
                .amenities(roomDto.getAmenities() != null ? roomDto.getAmenities() : List.of())
                .bedType(roomDto.getBedType())
                .hasBreakfast(roomDto.isHasBreakfast())
                .freeCancellation(roomDto.isFreeCancellation())
                .build();
        
        Room savedRoom = roomRepository.save(room);
        return mapToRoomDto(savedRoom);
    }
    
    public RoomDto updateRoom(String hotelId, String roomId, RoomDto roomDto) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found with id: " + hotelId));
        
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new ResourceNotFoundException("Room not found with id: " + roomId));
        
        if (!room.getHotel().getId().equals(hotelId)) {
            throw new IllegalArgumentException("Room does not belong to this hotel");
        }
        
        room.setRoomType(roomDto.getRoomType());
        room.setDescription(roomDto.getDescription());
        room.setPricePerNight(roomDto.getPricePerNight());
        room.setMaxGuests(roomDto.getMaxGuests());
        room.setTotalRooms(roomDto.getTotalRooms());
        room.setAvailableRooms(roomDto.getAvailableRooms() != null ? roomDto.getAvailableRooms() : room.getAvailableRooms());
        room.setSize(roomDto.getSize());
        room.setImages(roomDto.getImages() != null ? roomDto.getImages() : room.getImages());
        room.setAmenities(roomDto.getAmenities() != null ? roomDto.getAmenities() : room.getAmenities());
        room.setBedType(roomDto.getBedType());
        room.setHasBreakfast(roomDto.isHasBreakfast());
        room.setFreeCancellation(roomDto.isFreeCancellation());
        
        Room updatedRoom = roomRepository.save(room);
        return mapToRoomDto(updatedRoom);
    }
    
    public void deleteRoom(String hotelId, String roomId) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found with id: " + hotelId));
        
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new ResourceNotFoundException("Room not found with id: " + roomId));
        
        if (!room.getHotel().getId().equals(hotelId)) {
            throw new IllegalArgumentException("Room does not belong to this hotel");
        }
        
        roomRepository.delete(room);
    }
    
    private HotelDto mapToDto(Hotel hotel) {
        return HotelDto.builder()
                .id(hotel.getId())
                .name(hotel.getName())
                .description(hotel.getDescription())
                .address(hotel.getAddress())
                .city(hotel.getCity())
                .country(hotel.getCountry())
                .latitude(hotel.getLatitude())
                .longitude(hotel.getLongitude())
                .pricePerNight(hotel.getPricePerNight())
                .guestRating(hotel.getGuestRating())
                .totalReviews(hotel.getTotalReviews())
                .starRating(hotel.getStarRating())
                .images(hotel.getImages())
                .amenities(hotel.getAmenities())
                .featured(hotel.isFeatured())
                .available(hotel.isAvailable())
                .status(hotel.getStatus() != null ? hotel.getStatus().name() : "ACTIVE")
                .phoneNumber(hotel.getPhoneNumber())
                .email(hotel.getEmail())
                .website(hotel.getWebsite())
                .checkInTime(hotel.getCheckInTime())
                .checkOutTime(hotel.getCheckOutTime())
                .build();
    }
    
    private HotelDto mapToDtoWithDynamicPricing(Hotel hotel, int numberOfRooms, int numberOfGuests) {
        // Calculate dynamic price based on rooms and guests
        // Base price is per room per night
        double basePrice = hotel.getPricePerNight();
        
        // Apply room multiplier (more rooms = slight discount)
        double roomMultiplier = numberOfRooms > 1 ? 0.95 : 1.0; // 5% discount for multiple rooms
        
        // Apply guest multiplier (more guests may need larger rooms)
        double guestMultiplier = 1.0;
        if (numberOfGuests > 2) {
            guestMultiplier = 1.1; // 10% increase for more than 2 guests
        }
        
        // Calculate final price per night (for all rooms)
        double dynamicPrice = basePrice * numberOfRooms * roomMultiplier * guestMultiplier;
        
        return HotelDto.builder()
                .id(hotel.getId())
                .name(hotel.getName())
                .description(hotel.getDescription())
                .address(hotel.getAddress())
                .city(hotel.getCity())
                .country(hotel.getCountry())
                .latitude(hotel.getLatitude())
                .longitude(hotel.getLongitude())
                .pricePerNight(Math.round(dynamicPrice * 100.0) / 100.0) // Round to 2 decimals
                .guestRating(hotel.getGuestRating())
                .totalReviews(hotel.getTotalReviews())
                .starRating(hotel.getStarRating())
                .images(hotel.getImages())
                .amenities(hotel.getAmenities())
                .featured(hotel.isFeatured())
                .available(hotel.isAvailable())
                .build();
    }
    
    private RoomDto mapToRoomDto(Room room) {
        return RoomDto.builder()
                .id(room.getId())
                .hotelId(room.getHotel().getId())
                .roomType(room.getRoomType())
                .description(room.getDescription())
                .pricePerNight(room.getPricePerNight())
                .maxGuests(room.getMaxGuests())
                .totalRooms(room.getTotalRooms())
                .availableRooms(room.getAvailableRooms())
                .size(room.getSize())
                .images(room.getImages())
                .amenities(room.getAmenities())
                .bedType(room.getBedType())
                .hasBreakfast(room.isHasBreakfast())
                .freeCancellation(room.isFreeCancellation())
                .build();
    }
}
