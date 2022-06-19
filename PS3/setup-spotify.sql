-- [Problem 1]
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS artist, album, playlist;

-- Table artist: spotify artist information
CREATE TABLE artist (
    -- Spotify artist uniform resource indicator
    artist_uri      VARCHAR(250) NOT NULL,
    -- Name of artist
    artist_name     VARCHAR(250) NOT NULL,
    PRIMARY KEY (artist_uri)
);

-- Table album: spotify album information
CREATE TABLE album (
    -- Spotify album uniform resource indicator
    album_uri       VARCHAR(250) NOT NULL,
    -- Name of album
    album_name      VARCHAR(250) NOT NULL,
    -- Date of album release
    release_date    DATE NOT NULL,
    PRIMARY KEY (album_uri)
);

-- Table playlist: spotify playlist information
CREATE TABLE playlist (
    -- Spotify playlist uniform resource indicator
    playlist_uri    VARCHAR(250) NOT NULL,
    -- Name of spotify playlist
    playlist_name   VARCHAR(250) NOT NULL,
    -- Names of users who have added playlist
    added_by        VARCHAR(250),
    PRIMARY KEY (playlist_uri)
);

-- Table track: spotify track information
CREATE TABLE track (
    -- Spotify track uniform resource indicator (Primary Key)
    track_uri       VARCHAR(250) NOT NULL,
    -- Spotify track name
    track_name      VARCHAR(250) NOT NULL,
    -- Spotify artist uniform resource indicator
    artist_uri      VARCHAR(250) NOT NULL,
    -- Spotify album uniform resource indicator
    album_uri       VARCHAR(250) NOT NULL,
    -- Spotify playlist uniform resource indicator
    playlist_uri    VARCHAR(250) NOT NULL,
    -- Duration of track in ms
    duration_ms     DECIMAL(10, 2) NOT NULL,
    -- URL for spotify preview
    preview_url     VARCHAR(250),
    -- Datetime when track was added
    added_at DATETIME NOT NULL,
    PRIMARY KEY (track_uri),
    FOREIGN KEY (artist_uri)
        REFERENCES artist(artist_uri)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (album_uri)
        REFERENCES album(album_uri)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (playlist_uri)
        REFERENCES playlist(playlist_uri)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);