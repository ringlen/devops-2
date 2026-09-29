package com.library.ebook;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class EbookServiceTest {

    EbookService ebook = new EbookService();

    @Test
    void testOpenBook() {
        assertTrue(ebook.openBook("book-123"));
    }

    @Test
    void testOpenBookEmptyId() {
        assertFalse(ebook.openBook(""));
    }

    @Test
    void testSaveBookmark() {
        assertTrue(ebook.saveBookmark("book-123", 42));
    }

    @Test
    void testSaveBookmarkNegativePage() {
        assertFalse(ebook.saveBookmark("book-123", -1));
    }

    @Test
    void testSetFontSize() {
        assertTrue(ebook.setFontSize(14));
    }

    @Test
    void testSetFontSizeOutOfRange() {
        assertFalse(ebook.setFontSize(100));
    }
}