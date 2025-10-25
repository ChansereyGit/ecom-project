package com.hotelbooker.calendar.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomInstanceDto {
    private String id;
    private String roomTypeId;
    private String roomNumber;
    private Integer floor;
    private String status;
    private String notes;
    
    // Room type details
    private String roomTypeName;
    private Double pricePerNight;
    private Integer maxGuests;
    private String bedType;
}
