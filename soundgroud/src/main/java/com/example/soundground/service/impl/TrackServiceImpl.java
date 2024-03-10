package com.example.soundground.service.impl;

import com.example.soundground.dto.TrackDTO;
import com.example.soundground.entity.Track;
import com.example.soundground.repository.TrackRepository;
import com.example.soundground.service.TrackService;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.github.benmanes.caffeine.cache.LoadingCache;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service @RequiredArgsConstructor
public class TrackServiceImpl implements TrackService {

    private final TrackRepository trackRepository;
    private final ModelMapper modelMapper;

    private final LoadingCache<Long, Optional<TrackDTO>> trackCache = Caffeine.newBuilder()
            .maximumSize(1000)
            .expireAfterAccess(10, TimeUnit.MINUTES)
            .build(key -> trackRepository.findById(key).map(track -> modelMapper.map(track, TrackDTO.class)));

    @Override
    @Cacheable(cacheNames = "tracks", key = "#pageable.pageNumber")
    public Page<TrackDTO> findTracks(Pageable pageable) {
        return trackRepository.findAll(pageable).map(track -> modelMapper.map(track, TrackDTO.class));
    }

    @Override
    @Cacheable(cacheNames = "track", key = "#id")
    public Optional<TrackDTO> findById(Long id) {
        return trackCache.get(id);
    }

    @Override
    @CachePut(cacheNames = "track", key = "#result.trackId")
    public TrackDTO save(Track track) {
        Track savedTrack = trackRepository.save(track);
        return modelMapper.map(savedTrack, TrackDTO.class);
    }

    @Override
    @CacheEvict(cacheNames = "track", key = "#id")
    public void deleteById(Long id) {
        trackRepository.deleteById(id);
    }
}
