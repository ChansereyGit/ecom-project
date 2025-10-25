# 💻 Modular Monolith - Complete Code Examples

## Ready-to-Use Implementation

---

## 1. Project Structure

```
hotel-booking-system/
├── src/main/java/com/hotelbooker/
│   ├── HotelBookingApplication.java
│   │
│   ├── common/
│   │   ├── dto/
│   │   │   ├── ApiResponse.java
│   │   │   ├── PageResponse.java
│   │   │   └── ErrorDetails.java
│   │   ├── exception/
│   │   │   ├── GlobalExceptionHandler.java
│   │   │   ├── ResourceNotFoundException.java
│   │   │   └── BusinessException.java
│   │   ├── config/
│   │   │   ├── SecurityConfig.java
│   │   │   ├── JwtConfig.java
│   │   │   └── CorsConfig.java
│   │   └── util/
│   │       └── JwtUtil.java
│   │
│   ├── auth/
│   │   ├── api/
│   │   │   ├── AuthController.java
│   │   │   └── dto/
│   │   │       ├── LoginRequest.java
│   │   │       ├── RegisterRequest.java
│   │   │       └── AuthResponse.java
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   ├── User.java
│   │   │   │   ├── Role.java
│   │   │   │   └── AuthProvider.java
│   │   │   ├── repository/
│   │   │   │   └── UserRepository.java
│   │   │   └── service/
│   │   │       ├── AuthService.java
│   │   │       └── AuthServiceImpl.java
│   │   └── AuthModuleConfig.java
│   │
│   ├── hotel/
│   │   ├── api/
│   │   │   ├── HotelController.java
│   │   │   └── dto/
│   │   │       ├── HotelSearchRequest.java
│   │   │       ├── HotelResponse.java
│   │   │       └── RoomResponse.java
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   ├── Hotel.java
│   │   │   │   └── Room.java
│   │   │   ├── repository/
│   │   │   │   ├── HotelRepository.java
│   │   │   │   └── RoomRepository.java
│   │   │   └── service/
│   │   │       ├── HotelService.java
│   │   │       └── HotelServiceImpl.java
│   │   └── HotelModuleConfig.java
│   │
│   └── booking/
│       ├── api/
│       ├── domain/
│       └── BookingModuleConfig.java
│
└── src/main/resources/
    ├── application.yml
    ├── application-dev.yml
    └── application-prod.yml
```

---

## 2. Main Application

### HotelBookingApplication.java

```java
package com.hotelbooker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableJpaAuditing
@EnableCaching
@EnableAsync
public class HotelBookingApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(HotelBookingApplication.class, args);
    }
}
```

---

## 3. Common Layer

### ApiResponse.java

```java
package com.hotelbooker.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    
    private boolean success;
    private T data;
    private ErrorDetails error;
    
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();
    
    public static <T> ApiResponse<T> success(T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .data(data)
                .timestamp(LocalDateTime.now())
                .build();
    }
    
    public static <T> ApiResponse<T> error(String code, String message) {
        return ApiResponse.<T>builder()
                .success(false)
                .error(ErrorDetails.builder()
                        .code(code)
                        .message(message)
                        .build())
                .timestamp(LocalDateTime.now())
                .build();
    }
    
    public static <T> ApiResponse<T> error(ErrorDetails error) {
        return ApiResponse.<T>builder()
                .success(false)
                .error(error)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
```

### ErrorDetails.java

```java
package com.hotelbooker.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ErrorDetails {
    private String code;
    private String message;
    private Object details;
}
```

