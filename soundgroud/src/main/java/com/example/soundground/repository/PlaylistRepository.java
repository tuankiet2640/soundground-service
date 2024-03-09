package com.example.soundground.repository;

import com.example.soundground.entity.Playlist;
import com.example.soundground.entity.Track;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Set;

public interface PlaylistRepository extends JpaRepository<Playlist, Long> {

    //find all tracks from a public playlist
    @Query("SELECT p.tracks FROM Playlist p JOIN p.tracks t WHERE p.playlistId = :playlistId AND t.status = 'PUBLIC'")
    Set<Track> findPublicTracksInPlaylist(Long playlistId);

    //find all tracks from a private playlist
    @Query("SELECT p.tracks FROM Playlist p JOIN p.tracks t WHERE p.playlistId = :playlistId AND t.status = 'PRIVATE'")
    Set<Track> findPrivateTracksInPlaylist(Long playlistId);

    //find all playlist of a user
    @Query("SELECT p FROM Playlist p WHERE p.user.userId = :userId")
    Page<Playlist> findUserPlaylists(Long userId, Pageable pageable);

    //find all public playlist
    @Query("SELECT p FROM Playlist p WHERE p.status = 'PUBLIC'")
    Page<Playlist> findPublicPlaylists(Pageable pageable);

    //find all liked playlist of a user
    @Query("SELECT p FROM Playlist p JOIN p.favoritedBy u WHERE u.userId = :userId")
    Page<Playlist> findLikedPlaylists(Long userId, Pageable pageable);
}
