package com.example.soundground.controller;

import com.example.soundground.entity.Episode;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class EpisodeController {

    @GetMapping("/episodes")
    public List<Episode> getEpisodes() {
        return null;
    }
}
