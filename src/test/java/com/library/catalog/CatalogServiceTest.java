package com.library.catalog;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CatalogServiceTest {

    CatalogService catalog = new CatalogService();

    @Test
    void testSearchSuccess() {
        assertTrue(catalog.search("Harry Potter"));
    }

    @Test
    void testSearchEmptyQuery() {
        assertFalse(catalog.search(""));
    }

    @Test
    void testFilterByGenre() {
        assertTrue(catalog.filterByGenre("Fiction"));
    }

    @Test
    void testGetBookDetails() {
        assertTrue(catalog.getBookDetails("book-123"));
    }
}