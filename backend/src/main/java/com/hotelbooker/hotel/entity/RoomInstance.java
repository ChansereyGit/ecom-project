package com.hotelbooker.hotel.entity;

import com.hotelbooker.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "room_instances")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomInstance extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_type_id", nullable = false)
    private Room roomType;
    
    @Column(name = "room_number", unique = true, nullable = false, length = 50)
    private String roomNumber;
    
    @Column(name = "floor")
    private Integer floor;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private RoomStatus status = RoomStatus.AVAILABLE;
    
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    public enum RoomStatus {
        AVAILABLE,
        OCCUPIED,
        MAINTENANCE,
        BLOCKED
    }
    
    // Helper method to get hotel from room type
    public Hotel getHotel() {
        return roomType != null ? roomType.getHotel() : null;
    }
}
