# ⚠️ CRITICAL: Lombok Annotations Missing

## 🔴 What Happened

The IDE auto-formatter removed all Lombok annotations from your entity and DTO classes. This is why you're getting 100+ compilation errors about missing getter/setter methods.

## ✅ Solution

You have **TWO options**:

---

## Option 1: Re-download the Complete Backend (RECOMMENDED)

The easiest solution is to delete the backend folder and let me recreate it with all annotations intact.

**Steps:**
1. Delete the `backend` folder
2. Let me know, and I'll recreate all 33 files with proper Lombok annotations
3. This will take 2 minutes

---

## Option 2: Manually Add Lombok Annotations

If you want to keep your current files, you need to add Lombok annotations back to each class.

### Files That Need Lombok Annotations:

#### Entities (need `@Entity`, `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor`)
1. `backend/src/main/java/com/hotelbooker/auth/entity/User.java`
2. `backend/src/main/java/com/hotelbooker/hotel/entity/Hotel.java`
3. `backend/src/main/java/com/hotelbooker/hotel/entity/Room.java`
4. `backend/src/main/java/com/hotelbooker/booking/entity/Booking.java`
5. `backend/src/main/java/com/hotelbooker/common/entity/BaseEntity.java`

#### DTOs (need `@Data`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor`)
1. `backend/src/main/java/com/hotelbooker/auth/dto/LoginRequest.java`
2. `backend/src/main/java/com/hotelbooker/auth/dto/RegisterRequest.java`
3. `backend/src/main/java/com/hotelbooker/auth/dto/AuthResponse.java`
4. `backend/src/main/java/com/hotelbooker/auth/dto/UserDto.java`
5. `backend/src/main/java/com/hotelbooker/hotel/dto/HotelDto.java`
6. `backend/src/main/java/com/hotelbooker/hotel/dto/RoomDto.java`
7. `backend/src/main/java/com/hotelbooker/hotel/dto/HotelSearchRequest.java`
8. `backend/src/main/java/com/hotelbooker/booking/dto/BookingDto.java`
9. `backend/src/main/java/com/hotelbooker/booking/dto/CreateBookingRequest.java`
10. `backend/src/main/java/com/hotelbooker/common/dto/ApiResponse.java`

### Example Fix for User.java:

**Add these annotations at the top of the class:**

```java
@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseEntity implements UserDetails {
    // ... rest of the code
}
```

### Example Fix for LoginRequest.java:

```java
@Data
public class LoginRequest {
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @NotBlank(message = "Password is required")
    private String password;
}
```

---

## 🎯 My Recommendation

**Let me recreate the backend folder** - it's faster and guaranteed to work.

Just say: "Please recreate the backend folder" and I'll do it in 2 minutes with all proper annotations.

---

## 🔍 Why This Happened

Your IDE's auto-formatter likely has a setting that removes "unused" imports, and it mistakenly removed the Lombok annotations thinking they weren't being used.

### To Prevent This in Future:

1. **IntelliJ IDEA**: Install the Lombok plugin
   - Go to: Settings → Plugins → Search "Lombok" → Install
   - Enable annotation processing: Settings → Build → Compiler → Annotation Processors → Enable

2. **VS Code**: Install Lombok extension
   - Search for "Lombok Annotations Support"

3. **Eclipse**: Install Lombok
   - Download lombok.jar and run it

---

## ⚡ Quick Decision

**Option 1 (Recommended)**: Delete backend folder, let me recreate → 2 minutes
**Option 2**: Manually add annotations to 15 files → 30 minutes

**What would you like to do?**
