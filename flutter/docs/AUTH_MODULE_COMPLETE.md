# 🔐 AUTH MODULE - Complete Implementation

## For All 3 Approaches (Monolithic, Modular, Hybrid)

---

## 1. Entity Layer

### User.java

```java
package com.hotelbooker.auth.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    
    @Column(nullable = false)
    private String firstName;
    
    @Column(nullable = false)
    private String lastName;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(nullable = false)
    private String password;
    
    private String phone;
    private String profileImage;
    
    @Enumerated(EnumType.STRING)
    private AuthProvider provider = AuthProvider.LOCAL;
    
    private String providerId;
    
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "user_roles", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "role")
    @Enumerated(EnumType.STRING)
    private Set<Role> roles = new HashSet<>();
    
    private boolean emailVerified = false;
    private boolean active = true;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
```

### Role.java (Enum)

```java
package com.hotelbooker.auth.domain.entity;

public enum Role {
    USER,
    ADMIN,
    HOTEL_MANAGER
}
```

### AuthProvider.java (Enum)

```java
package com.hotelbooker.auth.domain.entity;

public enum AuthProvider {
    LOCAL,
    GOOGLE,
    FACEBOOK,
    APPLE
}
```

