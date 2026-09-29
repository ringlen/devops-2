package com.library.billing;

public class BillingService {
    public boolean subscribe(String userId, String plan) {
        if (userId == null || userId.isEmpty()) return false;
        if (plan == null || plan.isEmpty()) return false;
        return true;
    }

    public boolean cancelSubscription(String userId) {
        if (userId == null || userId.isEmpty()) return false;
        return true;
    }

    public boolean processPayment(String userId, double amount) {
        if (userId == null || userId.isEmpty()) return false;
        if (amount <= 0) return false;
        return true;
    }
}
