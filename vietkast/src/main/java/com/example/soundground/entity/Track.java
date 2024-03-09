package com.example.soundground.entity;

import com.example.soundground.entity.AppUser;
import com.example.soundground.entity.Comment;
import com.example.soundground.entity.Playlist;
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
@Table(name = "track", schema = "soundground")
public class Track {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long trackId;

    private String title;
    @Temporal(TemporalType.TIMESTAMP)
    private Date uploadDate;
    private String artwork;
    private String genre;
    private Long playsCount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id") // Explicitly specify the column name
    private AppUser user;

    @ManyToMany(mappedBy = "tracks")
    private Set<Playlist> playlists = new HashSet<>();

    @OneToMany(mappedBy = "track", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Comment> comments = new HashSet<>();
}
