# 🏗️ APPROACH 1: MONOLITHIC ARCHITECTURE

## Complete Implementation Guide

### Step 1: Main Application Class

```java
package com.hotelbooker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableCaching
@EnableAsync
public class HotelBookingApplication {
    public static void main(String[] args) {
        SpringApplication.run(HotelBookingApplication.class, args);
    }
}
```

---

## Step 2: Common Layer

### ApiResponse.java (Standard Response Wrapper)

```java
package com.hotelbooker.common.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private T data;
    private ErrorDetails error;
    private LocalDateTime timestamp;

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, data, null, LocalDateTime.now());
    }

    public static <T> ApiResponse<T> error(String code, String message) {
        ErrorDetails error = new ErrorDetails(code, message, null);
        return new ApiResponse<>(false, null, error, LocalDateTime.now());
    }
}
```

### ErrorDetails.java

```java
package com.hotelbooker.common.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ErrorDetails {
    private String code;
    private String message;
    private Object details;
}
```

