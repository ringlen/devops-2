package com.library.billing;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class BillingServiceTest {

    BillingService billing = new BillingService();

    @Test
    void testSubscribe() {
        assertTrue(billing.subscribe("user-1", "premium"));
    }

    @Test
    void testSubscribeEmptyPlan() {
        assertFalse(billing.subscribe("user-1", ""));
    }

    @Test
    void testCancelSubscription() {
        assertTrue(billing.cancelSubscription("user-1"));
    }

    @Test
    void testProcessPayment() {
        assertTrue(billing.processPayment("user-1", 9.99));
    }

    @Test
    void testProcessPaymentNegativeAmount() {
        assertFalse(billing.processPayment("user-1", -5.0));
    }
}