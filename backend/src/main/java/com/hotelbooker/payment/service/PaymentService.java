package com.hotelbooker.payment.service;

import com.hotelbooker.payment.config.StripeConfig;
import com.hotelbooker.payment.dto.PaymentIntentRequest;
import com.hotelbooker.payment.dto.PaymentIntentResponse;
import com.hotelbooker.payment.model.Payment;
import com.hotelbooker.payment.repository.PaymentRepository;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentService {
    
    private final PaymentRepository paymentRepository;
    private final StripeConfig stripeConfig;
    
    @Transactional
    public PaymentIntentResponse createPaymentIntent(PaymentIntentRequest request, String userId) {
        try {
            log.info("Creating payment intent for amount: {} {}", request.getAmount(), request.getCurrency());
            
            // Convert amount to cents (Stripe uses smallest currency unit)
            Long amountInCents = (long) (request.getAmount() * 100);
            
            // Build metadata
            Map<String, String> metadata = new HashMap<>();
            if (request.getMetadata() != null) {
                metadata.putAll(request.getMetadata());
            }
            metadata.put("userId", userId);
            if (request.getBookingId() != null) {
                metadata.put("bookingId", request.getBookingId());
            }
            
            // Create Stripe PaymentIntent
            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                    .setAmount(amountInCents)
                    .setCurrency(request.getCurrency().toLowerCase())
                    .setDescription(request.getDescription() != null ? 
                            request.getDescription() : "Hotel Booking Payment")
                    .putAllMetadata(metadata)
                    .setAutomaticPaymentMethods(
                            PaymentIntentCreateParams.AutomaticPaymentMethods.builder()
                                    .setEnabled(true)
                                    .build()
                    )
                    .build();
            
            PaymentIntent paymentIntent = PaymentIntent.create(params);
            
            // Save payment record
            Payment payment = Payment.builder()
                    .bookingId(request.getBookingId())
                    .userId(userId)
                    .stripePaymentIntentId(paymentIntent.getId())
                    .amount(request.getAmount())
                    .currency(request.getCurrency())
                    .status(Payment.PaymentStatus.PENDING)
                    .build();
            
            paymentRepository.save(payment);
            
            log.info("Payment intent created successfully: {}", paymentIntent.getId());
            
            return PaymentIntentResponse.builder()
                    .paymentIntentId(paymentIntent.getId())
                    .clientSecret(paymentIntent.getClientSecret())
                    .publishableKey(stripeConfig.getPublishableKey())
                    .amount(request.getAmount())
                    .currency(request.getCurrency())
                    .status(paymentIntent.getStatus())
                    .build();
                    
        } catch (StripeException e) {
            log.error("Error creating payment intent: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to create payment intent: " + e.getMessage());
        }
    }
    
    @Transactional
    public Payment updatePaymentStatus(String paymentIntentId, Payment.PaymentStatus status, String failureReason) {
        Optional<Payment> paymentOpt = paymentRepository.findByStripePaymentIntentId(paymentIntentId);
        
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            payment.setStatus(status);
            if (failureReason != null) {
                payment.setFailureReason(failureReason);
            }
            return paymentRepository.save(payment);
        }
        
        log.warn("Payment not found for payment intent: {}", paymentIntentId);
        return null;
    }
    
    public Optional<Payment> getPaymentByIntentId(String paymentIntentId) {
        return paymentRepository.findByStripePaymentIntentId(paymentIntentId);
    }
    
    public Optional<Payment> getPaymentByBookingId(String bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }
    
    public List<Payment> getUserPayments(String userId) {
        return paymentRepository.findByUserId(userId);
    }
    
    public PaymentIntent retrievePaymentIntent(String paymentIntentId) {
        try {
            return PaymentIntent.retrieve(paymentIntentId);
        } catch (StripeException e) {
            log.error("Error retrieving payment intent: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve payment intent: " + e.getMessage());
        }
    }
    
    @Transactional
    public Payment confirmPayment(String paymentIntentId) {
        try {
            PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentIntentId);
            
            Payment.PaymentStatus status;
            switch (paymentIntent.getStatus()) {
                case "succeeded":
                    status = Payment.PaymentStatus.SUCCEEDED;
                    break;
                case "processing":
                    status = Payment.PaymentStatus.PROCESSING;
                    break;
                case "requires_payment_method":
                case "requires_confirmation":
                case "requires_action":
                    status = Payment.PaymentStatus.PENDING;
                    break;
                case "canceled":
                    status = Payment.PaymentStatus.CANCELLED;
                    break;
                default:
                    status = Payment.PaymentStatus.FAILED;
            }
            
            return updatePaymentStatus(paymentIntentId, status, null);
            
        } catch (StripeException e) {
            log.error("Error confirming payment: {}", e.getMessage(), e);
            updatePaymentStatus(paymentIntentId, Payment.PaymentStatus.FAILED, e.getMessage());
            throw new RuntimeException("Failed to confirm payment: " + e.getMessage());
        }
    }
}
