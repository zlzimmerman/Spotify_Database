-- Group 5: Spotify Daylist Data 
-- Arjun, Annika, Aryana, Zoe, Kayla 

USE spotify;

-- 1. Most common artist among the 5 Members:
SELECT 
    a.ArtistStageName,
    COUNT(*) AS AppearanceCount
FROM 
    Playlists p
JOIN 
    Songs s ON p.SongID = s.SongID
JOIN 
    Artists a ON s.ArtistID = a.ArtistID
GROUP BY 
    a.ArtistID, a.ArtistStageName
ORDER BY 
    AppearanceCount DESC
LIMIT 1;


-- 2. Which  songs have appeared on the top 100
SELECT 
    s.SongName,
    a.ArtistStageName,
    al.AlbumName,
    str.SongStreams
FROM 
    Streams str
JOIN 
    Songs s ON str.SongID = s.SongID
JOIN 
    Artists a ON s.ArtistID = a.ArtistID
JOIN 
    Albums al ON s.AlbumID = al.AlbumID
WHERE 
    str.Top100Song = 1
ORDER BY 
    str.SongStreams DESC;

-- 3. Most Common Genres/Least Common Genres 
-- Most Common: 
SELECT 
    SongGenre,
    COUNT(*) AS GenreCount
FROM 
    Songs
GROUP BY 
    SongGenre
HAVING COUNT(*) = (
    SELECT 
        MAX(GenreCount)
    FROM (
        SELECT 
            COUNT(*) AS GenreCount
        FROM 
            Songs
        GROUP BY 
            SongGenre
    ) AS Sub
);

-- Least Common Genres: 
SELECT 
    SongGenre,
    COUNT(*) AS GenreCount
FROM 
    Songs
GROUP BY 
    SongGenre
HAVING COUNT(*) = (
    SELECT 
        MIN(GenreCount)
    FROM (
        SELECT 
            COUNT(*) AS GenreCount
        FROM 
            Songs
        GROUP BY 
            SongGenre
    ) AS Sub
);

-- 4. Songs with most streams/Songs with least streams
-- Songs with Most Streams: 
SELECT 
    s.SongName,
    a.ArtistStageName,
    str.SongStreams
FROM 
    Songs s
JOIN 
    Artists a ON s.ArtistID = a.ArtistID
JOIN 
    Streams str ON s.SongID = str.SongID
WHERE 
    str.SongStreams = (
        SELECT MAX(SongStreams) FROM Streams
);

-- Songs with Least Streams:
SELECT 
    s.SongName,
    a.ArtistStageName,
    str.SongStreams
FROM 
    Songs s
JOIN 
    Artists a ON s.ArtistID = a.ArtistID
JOIN 
    Streams str ON s.SongID = str.SongID
WHERE 
    str.SongStreams = (
        SELECT MIN(SongStreams) FROM Streams
);

-- 5. Song that appears the most times:
SELECT 
    s.SongName,
    a.ArtistStageName,
    COUNT(*) AS AppearanceCount
FROM 
    Playlists p
JOIN 
    Songs s ON p.SongID = s.SongID
JOIN 
    Artists a ON s.ArtistID = a.ArtistID
GROUP BY 
    p.SongID
ORDER BY 
    AppearanceCount DESC
LIMIT 1;

-- 6. Song released the latest/Song released the earliest (Dates):
-- Latest Song Release Date: 
SELECT 
    s.SongName,
    a.ArtistStageName,
    al.AlbumName,
    al.AlbumReleaseDate
FROM Songs s
JOIN Albums al ON s.AlbumID = al.AlbumID
JOIN Artists a ON s.ArtistID = a.ArtistID
ORDER BY al.AlbumReleaseDate DESC
LIMIT 1;

-- Earliest Song Release Date:
SELECT 
    s.SongName,
    a.ArtistStageName,
    al.AlbumName,
    al.AlbumReleaseDate
FROM Songs s
JOIN Albums al ON s.AlbumID = al.AlbumID
JOIN Artists a ON s.ArtistID = a.ArtistID
ORDER BY al.AlbumReleaseDate ASC
LIMIT 1;
 
-- 7. Which member had the most songs in the top 100
SELECT 
    m.MemberName,
    COUNT(*) AS Top100SongCount
FROM Playlists p
JOIN Streams s ON p.SongID = s.SongID
JOIN Members m ON p.MemberID = m.MemberID
WHERE s.Top100Song = 1
GROUP BY m.MemberName
ORDER BY Top100SongCount DESC
LIMIT 1;

-- 8. Longest Song/Shortest Song (Duration)
-- Longest Song: 
SELECT 
    SongName, 
    SongDuration
FROM Songs
ORDER BY STR_TO_DATE(SongDuration, '%H:%i:%s') DESC
LIMIT 1;

-- Shortest Song: 
SELECT 
    SongName, 
    SongDuration
FROM Songs
ORDER BY STR_TO_DATE(SongDuration, '%H:%i:%s') ASC
LIMIT 1;
