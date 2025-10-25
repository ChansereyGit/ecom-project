package com.hotelbooker.payment.repository;

import com.hotelbooker.payment.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, String> {
    
    Optional<Payment> findByStripePaymentIntentId(String stripePaymentIntentId);
    
    Optional<Payment> findByBookingId(String bookingId);
    
    List<Payment> findByUserId(String userId);
    
    List<Payment> findByStatus(Payment.PaymentStatus status);
}
