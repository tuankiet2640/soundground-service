package com.example.soundground.controller;

import com.example.soundground.dto.TrackDTO;
import com.example.soundground.entity.Track;
import com.example.soundground.service.TrackService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController @RequiredArgsConstructor
@RequestMapping("/api/v1/tracks")
public class TrackController {
    private final TrackService trackService;

    @GetMapping
    public ResponseEntity<Page<TrackDTO>> getTracks(@PageableDefault(size = 10, page = 0) Pageable pageable) {
        return ResponseEntity.ok(trackService.findTracks(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TrackDTO> getTrackById(@PathVariable Long id) {
        Optional<TrackDTO> track = trackService.findById(id);
        return track.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<TrackDTO> createTrack(@RequestBody TrackDTO trackDTO) {
        TrackDTO savedTrack = trackService.save(trackDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedTrack);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TrackDTO> updateTrack(@PathVariable Long id, @RequestBody TrackDTO trackDTO) {
        Optional<TrackDTO> existingTrack = trackService.findById(id);
        if (existingTrack.isPresent()) {
            TrackDTO updatedTrack = trackService.update(id, trackDTO);
            return ResponseEntity.ok(updatedTrack);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTrack(@PathVariable Long id) {
        trackService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
