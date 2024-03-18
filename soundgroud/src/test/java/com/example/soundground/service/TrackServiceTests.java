package com.example.soundground.service;

import com.example.soundground.dto.TrackDTO;
import com.example.soundground.entity.Track;
import com.example.soundground.repository.TrackRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.jdbc.Sql;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;

@org.springframework.boot.test.context.SpringBootTest
@Sql(scripts = "/data.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
public class TrackServiceTests {
    @Autowired
    private TrackService trackService;

    @Autowired
    private TrackRepository trackRepository;

    @BeforeEach
    public void setUp() {
        trackRepository.deleteAll();
    }

    //test find all tracks
     @Test
    public void testFindAllTracks() {
        Page<com.example.soundground.dto.TrackDTO> tracks = trackService.findTracks(PageRequest.of(0, 10));
        assertEquals(10, tracks.getTotalElements());
    }

    //test find track by id
    @Test
    public void testFindTrackById() {
        com.example.soundground.dto.TrackDTO track = trackService.findById(1L).get();
        assertEquals(1L, track.getTrackId());
    }

    //test save track
    @Test
    public void testSaveTrack() {
        TrackDTO trackDTO = new TrackDTO();
        trackDTO.setTitle("Test Track");
        trackDTO.setAudioPath("https://test.com");
        trackDTO.setUploadDate(new java.util.Date());
        com.example.soundground.dto.TrackDTO savedTrack = trackService.save(trackDTO);
        org.junit.jupiter.api.Assertions.assertNotNull(savedTrack.getTrackId());
    }

    //test delete track
//    @Test
//    public void testDeleteTrack() {
//        trackService.deleteById(1L);
//        org.junit.jupiter.api.Assertions.assertTrue(trackService.findById(1L).isEmpty());
//    }
}
