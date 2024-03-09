-- Ensure the schema exists
CREATE SCHEMA IF NOT EXISTS soundground;

-- Insert Kanye West as a user into app_user
INSERT INTO soundground.app_user (username, email, password, date_joined)
VALUES ('KanyeWest', 'kanye@west.com', 'password', NOW());

-- Insert tracks by Kanye West into track table
INSERT INTO soundground.track (title, upload_date, artwork, genre, plays_count, user_id)
VALUES
    ('Gold Digger', NOW(), 'gold_digger_art.jpg', 'Hip Hop', 1000000, (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest')),
    ('Stronger', NOW(), 'stronger_art.jpg', 'Electronic', 1500000, (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest')),
    ('Heartless', NOW(), 'heartless_art.jpg', 'Pop', 1200000, (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest')),
    ('All of the Lights', NOW(), 'all_of_the_lights_art.jpg', 'Hip Hop', 1100000, (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest'));

-- Insert playlists created by Kanye
INSERT INTO soundground.playlist (title, creation_date, artwork, is_public, user_id)
VALUES
    ('Kanye Hits', NOW(), 'kanye_hits_art.jpg', TRUE, (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest')),
    ('Workout Vibes', NOW(), 'workout_vibes_art.jpg', TRUE, (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest'));

-- Associate tracks with playlists
-- Assuming you know the IDs or using subqueries to find them based on the title
INSERT INTO soundground.playlist_tracks (playlist_id, track_id)
SELECT p.playlist_id, t.track_id
FROM soundground.playlist p, soundground.track t
WHERE p.title = 'Kanye Hits' AND t.title IN ('Gold Digger', 'Stronger')
UNION ALL
SELECT p.playlist_id, t.track_id
FROM soundground.playlist p, soundground.track t
WHERE p.title = 'Workout Vibes' AND t.title IN ('Heartless', 'All of the Lights');

-- Insert comments on tracks
INSERT INTO soundground.comment (text, posted_at, user_id, track_id)
VALUES
    ('This track is fire!', NOW(), (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest'), (SELECT track_id FROM soundground.track WHERE title = 'Gold Digger')),
    ('Never gets old!', NOW(), (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest'), (SELECT track_id FROM soundground.track WHERE title = 'Stronger'));

-- Create a follower for Kanye (optional, demonstrating Many-to-Many user_followers)
INSERT INTO soundground.app_user (username, email, password, date_joined)
VALUES ('FanUser', 'fan@example.com', 'password', NOW());

-- Kanye follows FanUser and vice versa
INSERT INTO soundground.user_followers (user_id, follower_id)
VALUES
    ((SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest'), (SELECT user_id FROM soundground.app_user WHERE username = 'FanUser')),
    ((SELECT user_id FROM soundground.app_user WHERE username = 'FanUser'), (SELECT user_id FROM soundground.app_user WHERE username = 'KanyeWest'));
