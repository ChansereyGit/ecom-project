# 🏨 HOTEL MODULE - Complete Implementation

## Entities, DTOs, Services, and Controllers

---

## 1. Entity Layer

### Hotel.java

```java
package com.hotelbooker.hotel.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "hotels")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Hotel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Integer starRating;
    
    @Column(nullable = false)
    private String address;
    
    @Column(nullable = false)
    private String city;
    
    @Column(nullable = false)
    private String country;
    
    private Double latitude;
    private Double longitude;
    
    private String mainImage;
    
    @ElementCollection
    @CollectionTable(name = "hotel_images", joinColumns = @JoinColumn(name = "hotel_id"))
    @Column(name = "image_url")
    private List<String> images = new ArrayList<>();
    
    @ElementCollection
    @CollectionTable(name = "hotel_amenities", joinColumns = @JoinColumn(name = "hotel_id"))
    @Column(name = "amenity")
    private List<String> amenities = new ArrayList<>();
    
    private String checkInTime = "15:00";
    private String checkOutTime = "11:00";
    
    private BigDecimal averageRating = BigDecimal.ZERO;
    private Integer reviewCount = 0;
    
    private boolean active = true;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    @OneToMany(mappedBy = "hotel", cascade = CascadeType.ALL)
    private List<Room> rooms = new ArrayList<>();
}
```

### Room.java

```java
package com.hotelbooker.hotel.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "rooms")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Room {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hotel_id", nullable = false)
    private Hotel hotel;
    
    @Column(nullable = false)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private String bedType;
    private Integer maxOccupancy;
    private Integer roomSize; // in square meters
    private String view;
    private String floor;
    
    @Column(nullable = false)
    private BigDecimal pricePerNight;
    
    private BigDecimal originalPrice;
    private Integer discountPercentage;
    
    @ElementCollection
    @CollectionTable(name = "room_images", joinColumns = @JoinColumn(name = "room_id"))
    @Column(name = "image_url")
    private List<String> images = new ArrayList<>();
    
    @ElementCollection
    @CollectionTable(name = "room_amenities", joinColumns = @JoinColumn(name = "room_id"))
    @Column(name = "amenity")
    private List<String> amenities = new ArrayList<>();
    
    private Integer totalRooms;
    private Integer availableRooms;
    
    private boolean breakfastIncluded = false;
    private String cancellationPolicy;
    
    private boolean active = true;
}
```

