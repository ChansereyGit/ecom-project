# 🏗️ APPROACH 3: HYBRID APPROACH

## Monolith with Microservices-Ready Architecture

This approach uses a monolithic deployment but implements microservices patterns internally.

### Key Features:
- ✅ Single deployment (monolith benefits)
- ✅ Microservices patterns (API Gateway, Service Discovery)
- ✅ Event-driven communication
- ✅ Can extract services without code changes

---

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│         API Gateway (Spring Cloud Gateway)       │
│              Port: 8080                          │
└─────────────────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
┌───────▼──────┐ ┌───▼──────┐ ┌───▼──────┐
│ Auth Module  │ │  Hotel   │ │ Booking  │
│              │ │  Module  │ │  Module  │
└──────────────┘ └──────────┘ └──────────┘
        │             │             │
        └─────────────┼─────────────┘
                      │
        ┌─────────────▼─────────────┐
        │    Event Bus (Spring)     │
        │    Message Queue          │
        └───────────────────────────┘
                      │
        ┌─────────────▼─────────────┐
        │    PostgreSQL Database    │
        │    (Separate Schemas)     │
        └───────────────────────────┘
```

---

## Project Structure

```
hotel-booking-hybrid/
├── gateway/                       # API Gateway
│   └── GatewayApplication.java
│
├── modules/
│   ├── auth-module/
│   ├── hotel-module/
│   ├── booking-module/
│   ├── payment-module/
│   └── review-module/
│
├── common/
│   ├── events/                    # Domain events
│   ├── messaging/                 # Event bus
│   └── dto/
│
└── infrastructure/
    ├── database/
    └── cache/
```

---

## Implementation

### 1. API Gateway Configuration

```java
package com.hotelbooker.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class GatewayApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(GatewayApplication.class, args);
    }
    
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
            .route("auth", r -> r.path("/api/v1/auth/**")
                .uri("forward:/auth"))
            .route("hotels", r -> r.path("/api/v1/hotels/**")
                .uri("forward:/hotels"))
            .route("bookings", r -> r.path("/api/v1/bookings/**")
                .uri("forward:/bookings"))
            .route("payments", r -> r.path("/api/v1/payments/**")
                .uri("forward:/payments"))
            .route("reviews", r -> r.path("/api/v1/reviews/**")
                .uri("forward:/reviews"))
            .build();
    }
}
```

