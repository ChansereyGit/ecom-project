package com.hotelbooker.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentIntentResponse {
    
    private String paymentIntentId;
    
    private String clientSecret;
    
    private String publishableKey;
    
    private Double amount;
    
    private String currency;
    
    private String status;
}
