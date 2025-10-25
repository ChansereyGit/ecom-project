package com.hotelbooker.hotel.entity;

import com.hotelbooker.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "rooms")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Room extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hotel_id", nullable = false)
    private Hotel hotel;
    
    @Column(nullable = false)
    private String roomType;
    
    @Column(length = 1000)
    private String description;
    
    @Column(nullable = false)
    private Double pricePerNight;
    
    @Column(nullable = false)
    private Integer maxGuests;
    
    @Column(nullable = false)
    private Integer totalRooms;
    
    @Column(nullable = false)
    private Integer availableRooms;
    
    private Double size; // in square meters
    
    @ElementCollection
    @CollectionTable(name = "room_images", joinColumns = @JoinColumn(name = "room_id"))
    @Column(name = "image_url")
    private List<String> images = new ArrayList<>();
    
    @ElementCollection
    @CollectionTable(name = "room_amenities", joinColumns = @JoinColumn(name = "room_id"))
    @Column(name = "amenity")
    private List<String> amenities = new ArrayList<>();
    
    private String bedType;
    private boolean hasBreakfast = false;
    private boolean freeCancellation = false;
}
