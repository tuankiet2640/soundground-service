package com.example.soundground.repository;

import com.example.soundground.entity.Track;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface TrackRepository extends JpaRepository<Track, Long> {
    //find all public tracks
    @Query("SELECT t FROM Track t WHERE t.status = 'PUBLIC'")
    Page<Track> findPublicTracks(Pageable pageable);

    //find all tracks of a user
    @Query("SELECT t FROM Track t WHERE t.user.userId = :userId")
    Page<Track> findUserTracks(Long userId, Pageable pageable);

    //find all liked tracks of a user
    @Query("SELECT t FROM Track t JOIN t.favoritedBy u WHERE u.userId = :userId")
    Page<Track> findLikedTracks(Long userId, Pageable pageable);

}
