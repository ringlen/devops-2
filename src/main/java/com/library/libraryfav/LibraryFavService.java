package com.library.libraryfav;

public class LibraryFavService {
    public boolean addToFavorites(String userId, String bookId) {
        if (userId == null || userId.isEmpty()) return false;
        if (bookId == null || bookId.isEmpty()) return false;
        return true;
    }

    public boolean getHistory(String userId) {
        if (userId == null || userId.isEmpty()) return false;
        return true;
    }
}
