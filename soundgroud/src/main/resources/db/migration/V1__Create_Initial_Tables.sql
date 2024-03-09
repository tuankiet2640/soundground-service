CREATE SCHEMA IF NOT EXISTS soundground;
-- Create the app_user table
CREATE TABLE soundground.app_user
(
    user_id     BIGSERIAL PRIMARY KEY,
    username    VARCHAR(255) NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    date_joined TIMESTAMP    NOT NULL
);

-- Create the track table
CREATE TABLE soundground.track
(
    track_id    BIGSERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    upload_date TIMESTAMP    NOT NULL,
    artwork     VARCHAR(255),
    genre       VARCHAR(255),
    plays_count BIGINT,
    audio_path  VARCHAR(255),
    status      VARCHAR(50),
    user_id     BIGINT,
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id)
);


-- Create the playlist table
CREATE TABLE soundground.playlist
(
    playlist_id   BIGSERIAL PRIMARY KEY,
    title         VARCHAR(255) NOT NULL,
    creation_date TIMESTAMP    NOT NULL,
    artwork       VARCHAR(255),
    status      VARCHAR(50),
    user_id       BIGINT,
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id)
);

-- Create the comment table
CREATE TABLE soundground.comment
(
    comment_id BIGSERIAL PRIMARY KEY,
    text       TEXT      NOT NULL,
    posted_at  TIMESTAMP NOT NULL,
    user_id    BIGINT,
    track_id   BIGINT,
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (track_id) REFERENCES soundground.track (track_id)
);

-- Many-to-Many: User followed playlists
CREATE TABLE soundground.user_followed_playlists
(
    user_id     BIGINT,
    playlist_id BIGINT,
    PRIMARY KEY (user_id, playlist_id),
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (playlist_id) REFERENCES soundground.playlist (playlist_id)
);

-- Many-to-Many: User followers
CREATE TABLE soundground.user_followers
(
    user_id     BIGINT,
    follower_id BIGINT,
    PRIMARY KEY (user_id, follower_id),
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (follower_id) REFERENCES soundground.app_user (user_id)
);

-- Many-to-Many: Playlist tracks
CREATE TABLE soundground.playlist_tracks
(
    playlist_id BIGINT,
    track_id BIGINT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES soundground.playlist(playlist_id),
    FOREIGN KEY (track_id) REFERENCES soundground.track(track_id)
);

-- Many-to-Many: User liked tracks
CREATE TABLE soundground.user_liked_tracks
(
    user_id BIGINT,
    track_id BIGINT,
    PRIMARY KEY (user_id, track_id),
    FOREIGN KEY (user_id) REFERENCES soundground.app_user(user_id),
    FOREIGN KEY (track_id) REFERENCES soundground.track(track_id)
);