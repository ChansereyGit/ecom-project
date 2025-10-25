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
public class HotelDto {
    private String id;
    private String name;
    private String description;
    private String address;
    private String city;
    private String country;
    private Double latitude;
    private Double longitude;
    private Double pricePerNight;
    private Double guestRating;
    private Integer totalReviews;
    private Integer starRating;
    private List<String> images;
    private List<String> amenities;
    private boolean featured;
    private boolean available;
    private String status; // ACTIVE, MAINTENANCE, INACTIVE
    
    // Contact Information (Optional)
    private String phoneNumber;
    private String email;
    private String website;
    
    // Operational Settings (Optional)
    private String checkInTime;
    private String checkOutTime;
}
