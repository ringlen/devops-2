package com.library.libraryfav;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class LibraryFavServiceTest {

    LibraryFavService library = new LibraryFavService();

    @Test
    void testAddToFavorites() {
        assertTrue(library.addToFavorites("user-1", "book-123"));
    }

    @Test
    void testAddToFavoritesEmptyUser() {
        assertFalse(library.addToFavorites("", "book-123"));
    }

    @Test
    void testGetHistory() {
        assertTrue(library.getHistory("user-1"));
    }

    @Test
    void testGetHistoryEmptyUser() {
        assertFalse(library.getHistory(""));
    }
}