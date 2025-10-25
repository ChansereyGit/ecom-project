package com.hotelbooker.hotel.repository;

import com.hotelbooker.hotel.entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, String> {
    
    List<Hotel> findByCityContainingIgnoreCaseAndAvailableTrue(String city);
    
    @Query("SELECT h FROM Hotel h WHERE " +
           "LOWER(h.city) LIKE LOWER(CONCAT('%', :location, '%')) OR " +
           "LOWER(h.name) LIKE LOWER(CONCAT('%', :location, '%')) OR " +
           "LOWER(h.country) LIKE LOWER(CONCAT('%', :location, '%'))")
    List<Hotel> searchByLocation(@Param("location") String location);
    
    @Query("SELECT h FROM Hotel h WHERE h.pricePerNight BETWEEN :minPrice AND :maxPrice " +
           "AND h.available = true")
    List<Hotel> findByPriceRange(@Param("minPrice") Double minPrice, @Param("maxPrice") Double maxPrice);
    
    List<Hotel> findByFeaturedTrueAndAvailableTrue();
    
    @Query("SELECT DISTINCT h.city FROM Hotel h WHERE h.available = true ORDER BY h.city")
    List<String> findAllCities();
}
