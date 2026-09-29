package com.library.auth;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AuthServiceTest {

    AuthService auth = new AuthService();

    @Test
    void testRegisterSuccess() {
        assertTrue(auth.register("user@email.com", "password123"));
    }

    @Test
    void testRegisterEmptyEmail() {
        assertFalse(auth.register("", "password123"));
    }

    @Test
    void testLoginSuccess() {
        assertTrue(auth.login("user@email.com", "password123"));
    }

    @Test
    void testResetPassword() {
        assertTrue(auth.resetPassword("user@email.com"));
    }
}