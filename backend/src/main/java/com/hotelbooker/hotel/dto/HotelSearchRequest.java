package com.hotelbooker.hotel.dto;

import lombok.Data;

@Data
public class HotelSearchRequest {
    private String location;
    private String checkInDate;
    private String checkOutDate;
    private Integer guests;
    private Integer rooms;
    private Double minPrice;
    private Double maxPrice;
    private Integer minStarRating;
    private Double minGuestRating;
}
