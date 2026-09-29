package com.library.auth;

public class AuthService {
    public boolean register(String email, String password) {
        if (email == null || email.isEmpty()) return false;
        if (password == null || password.length() < 6) return false;
        return true;
    }

    public boolean login(String email, String password) {
        if (email == null || password == null) return false;
        return !email.isEmpty() && !password.isEmpty();
    }

    public boolean resetPassword(String email) {
        if (email == null || email.isEmpty()) return false;
        return true;
    }
}
