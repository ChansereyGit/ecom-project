# 🏗️ Hotel Booking System - Backend Architecture Guide

## Table of Contents
1. [Monolithic Architecture](#1-monolithic-architecture)
2. [Modular Monolith (Migration-Ready)](#2-modular-monolith-migration-ready)
3. [Hybrid Approach](#3-hybrid-approach-monolith-with-microservices-ready-architecture)

---

## Overview

This guide provides 3 architectural approaches for your hotel booking system:
- **Monolithic**: Fast development, simple deployment
- **Modular Monolith**: Clean boundaries, easy to split later
- **Hybrid**: Best of both worlds

**Recommendation**: Start with Modular Monolith (#2)

---

## 1. MONOLITHIC ARCHITECTURE

### 📁 Project Structure

```
hotel-booking-monolith/
├── src/main/java/com/hotelbooker/
│   ├── HotelBookingApplication.java
│   ├── config/
│   │   ├── SecurityConfig.java
│   │   ├── JwtConfig.java
│   │   └── CorsConfig.java
│   ├── auth/
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   └── model/
│   ├── user/
│   ├── hotel/
│   ├── booking/
│   ├── payment/
│   ├── review/
│   ├── notification/
│   └── common/
│       ├── exception/
│       ├── dto/
│       └── util/
├── src/main/resources/
│   ├── application.yml
│   └── application-prod.yml
└── pom.xml
```

### 📦 Dependencies (pom.xml)


```xml
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    
    <!-- Database -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
    </dependency>
    
    <!-- JWT -->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
        <version>0.11.5</version>
    </dependency>
    
    <!-- Redis for caching -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
</dependencies>
```

### 🔧 Configuration (application.yml)

```yaml
spring:
  application:
    name: hotel-booking-monolith
  datasource:
    url: jdbc:postgresql://localhost:5432/hotel_booking
    username: postgres
    password: password
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
  redis:
    host: localhost
    port: 6379

jwt:
  secret: your-secret-key-here
  expiration: 86400000 # 24 hours

server:
  port: 8080
```

