# 🚀 Quick Start Guide - Hotel Booking System

## Get Started in 30 Minutes

---

## Step 1: Choose Your Approach

### ⭐ RECOMMENDED: Modular Monolith

**Why?**
- Perfect balance of simplicity and scalability
- Easy to migrate to microservices later
- Clean architecture
- Single deployment

**When to use:**
- ✅ Team of 1-5 developers
- ✅ Want to ship in 3-4 months
- ✅ Budget: $30-70/month hosting
- ✅ Expecting growth but not massive scale initially

---

## Step 2: Setup Development Environment

### Prerequisites

```bash
# Install Java 17+
java -version

# Install Maven
mvn -version

# Install PostgreSQL
psql --version

# Install Redis
redis-cli --version

# Install Docker (optional but recommended)
docker --version
```

### Create Database

```sql
-- Connect to PostgreSQL
psql -U postgres

-- Create database
CREATE DATABASE hotel_booking;

-- Create user
CREATE USER hotel_user WITH PASSWORD 'your_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE hotel_booking TO hotel_user;
```

---

## Step 3: Create Spring Boot Project

### Option A: Using Spring Initializr (Web)

1. Go to https://start.spring.io/
2. Configure:
   - Project: Maven
   - Language: Java
   - Spring Boot: 3.2.x
   - Group: com.hotelbooker
   - Artifact: hotel-booking-system
   - Packaging: Jar
   - Java: 17

3. Add Dependencies:
   - Spring Web
   - Spring Data JPA
   - Spring Security
   - Validation
   - PostgreSQL Driver
   - Spring Data Redis
   - Lombok

4. Click "Generate" and extract

### Option B: Using Spring CLI

```bash
spring init \
  --dependencies=web,data-jpa,security,validation,postgresql,redis,lombok \
  --group-id=com.hotelbooker \
  --artifact-id=hotel-booking-system \
  --name=HotelBookingSystem \
  --package-name=com.hotelbooker \
  --java-version=17 \
  hotel-booking-system

cd hotel-booking-system
```

---

## Step 4: Configure Application

### application.yml

```yaml
spring:
  application:
    name: hotel-booking-system
  
  datasource:
    url: jdbc:postgresql://localhost:5432/hotel_booking
    username: hotel_user
    password: your_password
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.PostgreSQLDialect
  
  redis:
    host: localhost
    port: 6379
    timeout: 60000

# JWT Configuration
jwt:
  secret: your-256-bit-secret-key-change-this-in-production
  expiration: 86400000 # 24 hours in milliseconds

# Server Configuration
server:
  port: 8080
  error:
    include-message: always
    include-binding-errors: always

# Logging
logging:
  level:
    com.hotelbooker: DEBUG
    org.springframework.security: DEBUG
```

---

## Step 5: Create Project Structure

```bash
# Navigate to src/main/java/com/hotelbooker/
cd src/main/java/com/hotelbooker/

# Create module directories
mkdir -p common/{dto,exception,config,util}
mkdir -p auth/{api/dto,domain/{entity,repository,service}}
mkdir -p user/{api/dto,domain/{entity,repository,service}}
mkdir -p hotel/{api/dto,domain/{entity,repository,service}}
mkdir -p booking/{api/dto,domain/{entity,repository,service}}
mkdir -p payment/{api/dto,domain/{entity,repository,service}}
mkdir -p review/{api/dto,domain/{entity,repository,service}}
```

---

## Step 6: Add Additional Dependencies

### pom.xml

```xml
<dependencies>
    <!-- JWT -->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
        <version>0.11.5</version>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-impl</artifactId>
        <version>0.11.5</version>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-jackson</artifactId>
        <version>0.11.5</version>
        <scope>runtime</scope>
    </dependency>
    
    <!-- MapStruct for DTO mapping -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>1.5.5.Final</version>
    </dependency>
    
    <!-- Swagger/OpenAPI -->
    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        <version>2.2.0</version>
    </dependency>
</dependencies>
```

---

## Step 7: Run the Application

```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run

# Or run the JAR
java -jar target/hotel-booking-system-0.0.1-SNAPSHOT.jar
```

### Verify it's running

```bash
# Check health
curl http://localhost:8080/actuator/health

# Access Swagger UI
open http://localhost:8080/swagger-ui.html
```

---

## Step 8: Next Steps

### Week 1: Implement Auth Module
1. Create User entity
2. Create UserRepository
3. Create AuthService
4. Create AuthController
5. Test with Postman

### Week 2: Implement Hotel Module
1. Create Hotel & Room entities
2. Create repositories
3. Create HotelService
4. Create HotelController
5. Test search functionality

### Week 3: Implement Booking Module
1. Create Booking entity
2. Create BookingService
3. Implement availability check
4. Create BookingController
5. Test booking flow

---

## Useful Commands

```bash
# Run tests
mvn test

# Run with specific profile
mvn spring-boot:run -Dspring-boot.run.profiles=dev

# Build Docker image
docker build -t hotel-booking-system .

# Run with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## Troubleshooting

### Database Connection Issues
```bash
# Check PostgreSQL is running
pg_isready

# Check connection
psql -U hotel_user -d hotel_booking -h localhost
```

### Redis Connection Issues
```bash
# Check Redis is running
redis-cli ping

# Should return: PONG
```

### Port Already in Use
```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>
```

---

## Resources

- 📚 [Full Documentation](./BACKEND_ARCHITECTURE_GUIDE.md)
- 🏗️ [Architecture Comparison](./ARCHITECTURE_COMPARISON.md)
- 🗺️ [Implementation Roadmap](./IMPLEMENTATION_ROADMAP.md)
- 💻 [Code Examples](./MODULAR_MONOLITH_CODE_EXAMPLES.md)
- 🔐 [Auth Module](./AUTH_MODULE_COMPLETE.md)
- 🏨 [Hotel Module](./HOTEL_MODULE_COMPLETE.md)

---

## Need Help?

1. Check the documentation files in `/docs`
2. Review the code examples
3. Follow the implementation roadmap
4. Test each module independently

**You're ready to build! 🚀**

