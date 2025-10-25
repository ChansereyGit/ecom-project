package com.hotelbooker.hotel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomDto {
    private String id;
    private String hotelId;
    private String roomType;
    private String description;
    private Double pricePerNight;
    private Integer maxGuests;
    private Integer totalRooms;
    private Integer availableRooms;
    private Double size;
    private List<String> images;
    private List<String> amenities;
    private String bedType;
    private boolean hasBreakfast;
    private boolean freeCancellation;
}
