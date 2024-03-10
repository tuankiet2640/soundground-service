package com.example.soundground.service;

import com.example.soundground.dto.TrackDTO;
import com.example.soundground.entity.Track;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface TrackService {
    Page<TrackDTO> findTracks(Pageable pageable);
    Optional<TrackDTO> findById(Long id);
    TrackDTO save(Track track);
    void deleteById(Long id);

}
