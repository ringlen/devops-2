package com.library.ebook;

public class EbookService {
    public boolean openBook(String bookId) {
        if (bookId == null || bookId.isEmpty()) return false;
        return true;
    }

    public boolean saveBookmark(String bookId, int page) {
        if (bookId == null || bookId.isEmpty()) return false;
        if (page < 0) return false;
        return true;
    }

    public boolean setFontSize(int size) {
        if (size < 8 || size > 32) return false;
        return true;
    }
}
