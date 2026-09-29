package com.library.catalog;

public class CatalogService {
    public boolean search(String query) {
        if (query == null || query.isEmpty()) return false;
        return true;
    }

    public boolean filterByGenre(String genre) {
        if (genre == null || genre.isEmpty()) return false;
        return true;
    }

    public boolean getBookDetails(String bookId) {
        if (bookId == null || bookId.isEmpty()) return false;
        return true;
    }
}
