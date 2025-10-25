package com.hotelbooker.payment.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Payment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    
    @Column(name = "booking_id", nullable = true)
    private String bookingId;
    
    @Column(name = "user_id", nullable = false)
    private String userId;
    
    @Column(name = "stripe_payment_intent_id", unique = true)
    private String stripePaymentIntentId;
    
    @Column(name = "amount", nullable = false)
    private Double amount;
    
    @Column(name = "currency", nullable = false)
    private String currency;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PaymentStatus status;
    
    @Column(name = "payment_method")
    private String paymentMethod;
    
    @Column(name = "failure_reason")
    private String failureReason;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public enum PaymentStatus {
        PENDING,
        PROCESSING,
        SUCCEEDED,
        FAILED,
        CANCELLED,
        REFUNDED
    }
}
