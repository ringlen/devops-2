package com.library.audio;

public class AudioService {
    public boolean play(String audioId) {
        if (audioId == null || audioId.isEmpty()) return false;
        return true;
    }

    public boolean setPlaybackSpeed(double speed) {
        if (speed < 0.5 || speed > 3.0) return false;
        return true;
    }

    public boolean cacheAudio(String audioId) {
        if (audioId == null || audioId.isEmpty()) return false;
        return true;
    }
}
