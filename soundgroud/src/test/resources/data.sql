-- Ensure the schema exists
CREATE SCHEMA IF NOT EXISTS soundground;

-- Create the app_user table
CREATE TABLE IF NOT EXISTS soundground.app_user (
                                                    user_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                                    username    VARCHAR(255) NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    date_joined TIMESTAMP    NOT NULL
    );

-- Create the track table
CREATE TABLE IF NOT EXISTS soundground.track (
                                                 track_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
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
CREATE TABLE IF NOT EXISTS soundground.playlist (
                                                    playlist_id   BIGINT AUTO_INCREMENT PRIMARY KEY,
                                                    title         VARCHAR(255) NOT NULL,
    creation_date TIMESTAMP    NOT NULL,
    artwork       VARCHAR(255),
    status        VARCHAR(50),
    user_id       BIGINT,
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id)
    );

-- Create the comment table
CREATE TABLE IF NOT EXISTS soundground.comment (
                                                   comment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                                   text       TEXT      NOT NULL,
                                                   posted_at  TIMESTAMP NOT NULL,
                                                   user_id    BIGINT,
                                                   track_id   BIGINT,
                                                   FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (track_id) REFERENCES soundground.track (track_id)
    );

-- Many-to-Many: User followed playlists
CREATE TABLE IF NOT EXISTS soundground.user_followed_playlists (
                                                                   user_id     BIGINT,
                                                                   playlist_id BIGINT,
                                                                   PRIMARY KEY (user_id, playlist_id),
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (playlist_id) REFERENCES soundground.playlist (playlist_id)
    );

-- Many-to-Many: User followers
CREATE TABLE IF NOT EXISTS soundground.user_followers (
                                                          user_id     BIGINT,
                                                          follower_id BIGINT,
                                                          PRIMARY KEY (user_id, follower_id),
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (follower_id) REFERENCES soundground.app_user (user_id)
    );

-- Many-to-Many: Playlist tracks
CREATE TABLE IF NOT EXISTS soundground.playlist_tracks (
                                                           playlist_id BIGINT,
                                                           track_id    BIGINT,
                                                           PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES soundground.playlist (playlist_id),
    FOREIGN KEY (track_id) REFERENCES soundground.track (track_id)
    );

-- Many-to-Many: User liked tracks
CREATE TABLE IF NOT EXISTS soundground.user_liked_tracks (
                                                             user_id  BIGINT,
                                                             track_id BIGINT,
                                                             PRIMARY KEY (user_id, track_id),
    FOREIGN KEY (user_id) REFERENCES soundground.app_user (user_id),
    FOREIGN KEY (track_id) REFERENCES soundground.track (track_id)
    );

-- Insert Kanye West as a user into app_user if the username doesn't already exist
INSERT INTO soundground.app_user (username, email, password, date_joined)
SELECT 'KanyeWest', 'kanye@west.com', 'password', CURRENT_TIMESTAMP()
    WHERE NOT EXISTS (SELECT 1 FROM soundground.app_user WHERE username = 'KanyeWest');

-- Insert tracks by Kanye West into the track table
INSERT INTO soundground.track (title, upload_date, artwork, genre, plays_count, user_id, audio_path, status)
SELECT 'Gold Digger', CURRENT_TIMESTAMP(), 'gold_digger_art.jpg', 'Hip Hop', 1000000, u.user_id, 'kanye_west_gold_digger.mp3', 'PUBLIC'
FROM soundground.app_user u
WHERE u.username = 'KanyeWest';

-- Insert playlists created by Kanye
INSERT INTO soundground.playlist (title, creation_date, artwork, status, user_id)
SELECT 'Kanye Hits', CURRENT_TIMESTAMP(), 'kanye_hits_art.jpg', 'PUBLIC', u.user_id
FROM soundground.app_user u
WHERE u.username = 'KanyeWest';

-- Associate tracks with playlists
INSERT INTO soundground.playlist_tracks (playlist_id, track_id)
SELECT p.playlist_id, t.track_id
FROM soundground.playlist p
         JOIN soundground.track t ON t.title IN ('Gold Digger', 'Stronger')
         JOIN soundground.app_user u ON u.username = 'KanyeWest'
WHERE p.title = 'Kanye Hits'
  AND NOT EXISTS (
    SELECT 1
    FROM soundground.playlist_tracks pt
    WHERE pt.playlist_id = p.playlist_id
      AND pt.track_id = t.track_id
)
UNION ALL
SELECT p.playlist_id, t.track_id
FROM soundground.playlist p
         JOIN soundground.track t ON t.title IN ('Heartless', 'All of the Lights')
         JOIN soundground.app_user u ON u.username = 'KanyeWest'
WHERE p.title = 'Workout Vibes'
  AND NOT EXISTS (
    SELECT 1
    FROM soundground.playlist_tracks pt
    WHERE pt.playlist_id = p.playlist_id
      AND pt.track_id = t.track_id
);

-- Kanye follows FanUser and vice versa
INSERT INTO soundground.user_followers (user_id, follower_id)
SELECT u1.user_id, u2.user_id
FROM soundground.app_user u1
         JOIN soundground.app_user u2 ON u2.username = 'FanUser'
WHERE u1.username = 'KanyeWest'
  AND NOT EXISTS (
    SELECT 1
    FROM soundground.user_followers uf
    WHERE uf.user_id = u1.user_id
      AND uf.follower_id = u2.user_id
)
UNION ALL
SELECT u1.user_id, u2.user_id
FROM soundground.app_user u1
         JOIN soundground.app_user u2 ON u2.username = 'KanyeWest'
WHERE u1.username = 'FanUser'
  AND NOT EXISTS (
    SELECT 1
    FROM soundground.user_followers uf
    WHERE uf.user_id = u2.user_id
      AND uf.follower_id = u1.user_id
);

-- FanUser liked Kanye's tracks
INSERT INTO soundground.user_liked_tracks (user_id, track_id)
SELECT u.user_id, t.track_id
FROM soundground.track t
         JOIN soundground.app_user u ON u.username = 'FanUser'
WHERE t.title IN ('Gold Digger', 'Stronger', 'Heartless', 'All of the Lights')
  AND NOT EXISTS (
    SELECT 1
    FROM soundground.user_liked_tracks ult
    WHERE ult.user_id = u.user_id
      AND ult.track_id = t.track_id
);
