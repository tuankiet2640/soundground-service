package com.example.soundground.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "playlist", schema = "soundground")
public class Playlist {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long playlistId;

    private String title;
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationDate;
    private Boolean isPublic;

    @ManyToOne(fetch = FetchType.LAZY)
    private AppUser user;

    @ManyToMany
    @JoinTable(
            name = "playlist_tracks",
            joinColumns = @JoinColumn(name = "playlistId"),
            inverseJoinColumns = @JoinColumn(name = "trackId")
    )
    private Set<Track> tracks = new HashSet<>();

    @ManyToMany(mappedBy = "followedPlaylists")
    private Set<AppUser> followers = new HashSet<>();


}
