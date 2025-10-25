package com.hotelbooker.hotel.controller;

import com.hotelbooker.common.dto.ApiResponse;
import com.hotelbooker.hotel.dto.HotelDto;
import com.hotelbooker.hotel.dto.HotelSearchRequest;
import com.hotelbooker.hotel.dto.RoomDto;
import com.hotelbooker.hotel.service.HotelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/hotels")
@RequiredArgsConstructor
public class HotelController {
    
    private final HotelService hotelService;
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<HotelDto>>> getAllHotels() {
        List<HotelDto> hotels = hotelService.getAllHotels();
        return ResponseEntity.ok(ApiResponse.success(hotels));
    }
    
    @PostMapping("/search")
    public ResponseEntity<ApiResponse<List<HotelDto>>> searchHotels(
            @RequestBody HotelSearchRequest request
    ) {
        List<HotelDto> hotels = hotelService.searchHotels(request);
        return ResponseEntity.ok(ApiResponse.success(hotels));
    }
    
    @GetMapping("/{hotelId}")
    public ResponseEntity<ApiResponse<HotelDto>> getHotelById(
            @PathVariable String hotelId
    ) {
        HotelDto hotel = hotelService.getHotelById(hotelId);
        return ResponseEntity.ok(ApiResponse.success(hotel));
    }
    
    @GetMapping("/{hotelId}/rooms")
    public ResponseEntity<ApiResponse<List<RoomDto>>> getHotelRooms(
            @PathVariable String hotelId
    ) {
        List<RoomDto> rooms = hotelService.getHotelRooms(hotelId);
        return ResponseEntity.ok(ApiResponse.success(rooms));
    }
    
    @GetMapping("/featured")
    public ResponseEntity<ApiResponse<List<HotelDto>>> getFeaturedHotels() {
        List<HotelDto> hotels = hotelService.getFeaturedHotels();
        return ResponseEntity.ok(ApiResponse.success(hotels));
    }
    
    @GetMapping("/destinations")
    public ResponseEntity<ApiResponse<List<String>>> getPopularDestinations() {
        List<String> destinations = hotelService.getPopularDestinations();
        return ResponseEntity.ok(ApiResponse.success(destinations));
    }
    
    // Admin endpoints
    @PostMapping
    public ResponseEntity<ApiResponse<HotelDto>> createHotel(
            @RequestBody HotelDto hotelDto
    ) {
        HotelDto createdHotel = hotelService.createHotel(hotelDto);
        return ResponseEntity.ok(ApiResponse.success(createdHotel));
    }
    
    @PutMapping("/{hotelId}")
    public ResponseEntity<ApiResponse<HotelDto>> updateHotel(
            @PathVariable String hotelId,
            @RequestBody HotelDto hotelDto
    ) {
        HotelDto updatedHotel = hotelService.updateHotel(hotelId, hotelDto);
        return ResponseEntity.ok(ApiResponse.success(updatedHotel));
    }
    
    @DeleteMapping("/{hotelId}")
    public ResponseEntity<ApiResponse<Void>> deleteHotel(
            @PathVariable String hotelId
    ) {
        hotelService.deleteHotel(hotelId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }
    
    // Room management endpoints
    @PostMapping("/{hotelId}/rooms")
    public ResponseEntity<ApiResponse<RoomDto>> createRoom(
            @PathVariable String hotelId,
            @RequestBody RoomDto roomDto
    ) {
        RoomDto createdRoom = hotelService.createRoom(hotelId, roomDto);
        return ResponseEntity.ok(ApiResponse.success(createdRoom));
    }
    
    @PutMapping("/{hotelId}/rooms/{roomId}")
    public ResponseEntity<ApiResponse<RoomDto>> updateRoom(
            @PathVariable String hotelId,
            @PathVariable String roomId,
            @RequestBody RoomDto roomDto
    ) {
        RoomDto updatedRoom = hotelService.updateRoom(hotelId, roomId, roomDto);
        return ResponseEntity.ok(ApiResponse.success(updatedRoom));
    }
    
    @DeleteMapping("/{hotelId}/rooms/{roomId}")
    public ResponseEntity<ApiResponse<Void>> deleteRoom(
            @PathVariable String hotelId,
            @PathVariable String roomId
    ) {
        hotelService.deleteRoom(hotelId, roomId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}
