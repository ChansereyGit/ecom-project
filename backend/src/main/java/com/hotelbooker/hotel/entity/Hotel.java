package com.hotelbooker.hotel.entity;

import com.hotelbooker.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "hotels")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Hotel extends BaseEntity {
    
    @Column(nullable = false)
    private String name;
    
    @Column(length = 2000)
    private String description;
    
    @Column(nullable = false)
    private String address;
    
    @Column(nullable = false)
    private String city;
    
    @Column(nullable = false)
    private String country;
    
    private Double latitude;
    private Double longitude;
    
    @Column(nullable = false)
    private Double pricePerNight;
    
    @Column(nullable = false)
    private Double guestRating = 0.0;
    
    @Column(nullable = false)
    private Integer totalReviews = 0;
    
    @Column(nullable = false)
    private Integer starRating;
    
    @ElementCollection
    @CollectionTable(name = "hotel_images", joinColumns = @JoinColumn(name = "hotel_id"))
    @Column(name = "image_url")
    private List<String> images = new ArrayList<>();
    
    @ElementCollection
    @CollectionTable(name = "hotel_amenities", joinColumns = @JoinColumn(name = "hotel_id"))
    @Column(name = "amenity")
    private List<String> amenities = new ArrayList<>();
    
    @OneToMany(mappedBy = "hotel", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Room> rooms = new ArrayList<>();
    
    private boolean featured = false;
    private boolean available = true;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private HotelStatus status = HotelStatus.ACTIVE;
    
    // Contact Information (Optional)
    private String phoneNumber;
    private String email;
    private String website;
    
    // Operational Settings (Optional)
    private String checkInTime;  // e.g., "15:00"
    private String checkOutTime; // e.g., "11:00"
    
    public enum HotelStatus {
        ACTIVE,
        MAINTENANCE,
        INACTIVE
    }
}
