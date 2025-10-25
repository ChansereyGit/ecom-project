package com.hotelbooker.payment.controller;

import com.hotelbooker.common.dto.ApiResponse;
import com.hotelbooker.payment.dto.PaymentIntentRequest;
import com.hotelbooker.payment.dto.PaymentIntentResponse;
import com.hotelbooker.payment.model.Payment;
import com.hotelbooker.payment.service.PaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/payments")
@RequiredArgsConstructor
@Slf4j
public class PaymentController {
    
    private final PaymentService paymentService;
    
    @PostMapping("/create-intent")
    public ResponseEntity<ApiResponse<PaymentIntentResponse>> createPaymentIntent(
            @Valid @RequestBody PaymentIntentRequest request,
            Authentication authentication) {
        
        log.info("Creating payment intent for user: {}", authentication.getName());
        
        try {
            PaymentIntentResponse response = paymentService.createPaymentIntent(
                    request, 
                    authentication.getName()
            );
            
            return ResponseEntity.ok(ApiResponse.success(
                    "Payment intent created successfully",
                    response
            ));
            
        } catch (Exception e) {
            log.error("Error creating payment intent", e);
            return ResponseEntity.badRequest().body(ApiResponse.error(
                    "Failed to create payment intent: " + e.getMessage()
            ));
        }
    }
    
    @PostMapping("/confirm/{paymentIntentId}")
    public ResponseEntity<ApiResponse<Payment>> confirmPayment(
            @PathVariable String paymentIntentId,
            Authentication authentication) {
        
        log.info("Confirming payment: {} for user: {}", paymentIntentId, authentication.getName());
        
        try {
            Payment payment = paymentService.confirmPayment(paymentIntentId);
            
            if (payment == null) {
                return ResponseEntity.notFound().build();
            }
            
            return ResponseEntity.ok(ApiResponse.success(
                    "Payment confirmed successfully",
                    payment
            ));
            
        } catch (Exception e) {
            log.error("Error confirming payment", e);
            return ResponseEntity.badRequest().body(ApiResponse.error(
                    "Failed to confirm payment: " + e.getMessage()
            ));
        }
    }
    
    @GetMapping("/intent/{paymentIntentId}")
    public ResponseEntity<ApiResponse<Payment>> getPaymentByIntentId(
            @PathVariable String paymentIntentId,
            Authentication authentication) {
        
        return paymentService.getPaymentByIntentId(paymentIntentId)
                .map(payment -> ResponseEntity.ok(ApiResponse.success("Payment retrieved", payment)))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<ApiResponse<Payment>> getPaymentByBookingId(
            @PathVariable String bookingId,
            Authentication authentication) {
        
        return paymentService.getPaymentByBookingId(bookingId)
                .map(payment -> ResponseEntity.ok(ApiResponse.success("Payment retrieved", payment)))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/my-payments")
    public ResponseEntity<ApiResponse<List<Payment>>> getUserPayments(
            Authentication authentication) {
        
        List<Payment> payments = paymentService.getUserPayments(authentication.getName());
        
        return ResponseEntity.ok(ApiResponse.success(
                "Payments retrieved successfully",
                payments
        ));
    }
}
