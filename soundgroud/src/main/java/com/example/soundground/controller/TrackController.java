package com.example.soundground.controller;

import com.example.soundground.entity.Track;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TrackController {

    @GetMapping("/tracks")
    public List<Track> getTracks() {
        return null;
    }
}
