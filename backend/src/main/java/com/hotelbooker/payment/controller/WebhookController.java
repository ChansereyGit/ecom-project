package com.hotelbooker.payment.controller;

import com.hotelbooker.payment.config.StripeConfig;
import com.hotelbooker.payment.model.Payment;
import com.hotelbooker.payment.service.PaymentService;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.model.Event;
import com.stripe.model.PaymentIntent;
import com.stripe.net.Webhook;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/webhooks")
@RequiredArgsConstructor
@Slf4j
public class WebhookController {
    
    private final PaymentService paymentService;
    private final StripeConfig stripeConfig;
    
    @PostMapping("/stripe")
    public ResponseEntity<String> handleStripeWebhook(
            @RequestBody String payload,
            @RequestHeader("Stripe-Signature") String sigHeader) {
        
        log.info("Received Stripe webhook");
        
        Event event;
        
        // Verify webhook signature if webhook secret is configured
        if (stripeConfig.getWebhookSecret() != null && !stripeConfig.getWebhookSecret().isEmpty()) {
            try {
                event = Webhook.constructEvent(
                        payload,
                        sigHeader,
                        stripeConfig.getWebhookSecret()
                );
            } catch (SignatureVerificationException e) {
                log.error("Invalid webhook signature", e);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid signature");
            }
        } else {
            // For development without webhook secret
            try {
                event = Event.GSON.fromJson(payload, Event.class);
            } catch (Exception e) {
                log.error("Error parsing webhook payload", e);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid payload");
            }
        }
        
        // Handle the event
        switch (event.getType()) {
            case "payment_intent.succeeded":
                handlePaymentIntentSucceeded(event);
                break;
                
            case "payment_intent.payment_failed":
                handlePaymentIntentFailed(event);
                break;
                
            case "payment_intent.canceled":
                handlePaymentIntentCanceled(event);
                break;
                
            case "payment_intent.processing":
                handlePaymentIntentProcessing(event);
                break;
                
            default:
                log.info("Unhandled event type: {}", event.getType());
        }
        
        return ResponseEntity.ok("Webhook received");
    }
    
    private void handlePaymentIntentSucceeded(Event event) {
        PaymentIntent paymentIntent = (PaymentIntent) event.getDataObjectDeserializer()
                .getObject()
                .orElse(null);
        
        if (paymentIntent != null) {
            log.info("Payment succeeded: {}", paymentIntent.getId());
            paymentService.updatePaymentStatus(
                    paymentIntent.getId(),
                    Payment.PaymentStatus.SUCCEEDED,
                    null
            );
        }
    }
    
    private void handlePaymentIntentFailed(Event event) {
        PaymentIntent paymentIntent = (PaymentIntent) event.getDataObjectDeserializer()
                .getObject()
                .orElse(null);
        
        if (paymentIntent != null) {
            log.warn("Payment failed: {}", paymentIntent.getId());
            String failureMessage = paymentIntent.getLastPaymentError() != null ?
                    paymentIntent.getLastPaymentError().getMessage() : "Payment failed";
            
            paymentService.updatePaymentStatus(
                    paymentIntent.getId(),
                    Payment.PaymentStatus.FAILED,
                    failureMessage
            );
        }
    }
    
    private void handlePaymentIntentCanceled(Event event) {
        PaymentIntent paymentIntent = (PaymentIntent) event.getDataObjectDeserializer()
                .getObject()
                .orElse(null);
        
        if (paymentIntent != null) {
            log.info("Payment canceled: {}", paymentIntent.getId());
            paymentService.updatePaymentStatus(
                    paymentIntent.getId(),
                    Payment.PaymentStatus.CANCELLED,
                    "Payment was canceled"
            );
        }
    }
    
    private void handlePaymentIntentProcessing(Event event) {
        PaymentIntent paymentIntent = (PaymentIntent) event.getDataObjectDeserializer()
                .getObject()
                .orElse(null);
        
        if (paymentIntent != null) {
            log.info("Payment processing: {}", paymentIntent.getId());
            paymentService.updatePaymentStatus(
                    paymentIntent.getId(),
                    Payment.PaymentStatus.PROCESSING,
                    null
            );
        }
    }
}
