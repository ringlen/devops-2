package com.library.audio;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AudioServiceTest {

    AudioService audio = new AudioService();

    @Test
    void testPlay() {
        assertTrue(audio.play("audio-123"));
    }

    @Test
    void testPlayEmptyId() {
        assertFalse(audio.play(""));
    }

    @Test
    void testSetPlaybackSpeed() {
        assertTrue(audio.setPlaybackSpeed(1.5));
    }

    @Test
    void testSetPlaybackSpeedOutOfRange() {
        assertFalse(audio.setPlaybackSpeed(5.0));
    }

    @Test
    void testCacheAudio() {
        assertTrue(audio.cacheAudio("audio-123"));
    }
}