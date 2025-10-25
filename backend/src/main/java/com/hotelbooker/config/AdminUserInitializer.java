package com.hotelbooker.config;

import com.hotelbooker.auth.entity.User;
import com.hotelbooker.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class AdminUserInitializer implements CommandLineRunner {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    
    @Override
    public void run(String... args) {
        createAdminUserIfNotExists();
        createRegularUserIfNotExists();
    }
    
    private void createAdminUserIfNotExists() {
        String adminEmail = "admin@hotel.com";
        
        if (userRepository.findByEmail(adminEmail).isEmpty()) {
            User admin = User.builder()
                    .fullName("Admin User")
                    .email(adminEmail)
                    .password(passwordEncoder.encode("admin123"))
                    .phoneNumber("+1234567890")
                    .role(User.Role.ADMIN)
                    .emailVerified(true)
                    .build();
            
            userRepository.save(admin);
            log.info("✅ Created admin user: {}", adminEmail);
            log.info("   Password: admin123");
        } else {
            log.info("ℹ️  Admin user already exists: {}", adminEmail);
        }
    }
    
    private void createRegularUserIfNotExists() {
        String userEmail = "user@hotel.com";
        
        if (userRepository.findByEmail(userEmail).isEmpty()) {
            User user = User.builder()
                    .fullName("Regular User")
                    .email(userEmail)
                    .password(passwordEncoder.encode("user123"))
                    .phoneNumber("+1234567891")
                    .role(User.Role.USER)
                    .emailVerified(true)
                    .build();
            
            userRepository.save(user);
            log.info("✅ Created regular user: {}", userEmail);
            log.info("   Password: user123");
        } else {
            log.info("ℹ️  Regular user already exists: {}", userEmail);
        }
    }
}
