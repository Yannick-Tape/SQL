--#######DEBUT DU SCRIPT A COLLER DANS PgAdmin#########



-- Création de la table Anime avec modification de la précision
CREATE TABLE Anime (
    Anime_ID SERIAL PRIMARY KEY,
    English_name VARCHAR(255),
    Score DECIMAL(5,2),  -- Changement de DECIMAL(4,2) à DECIMAL(5,2)
    Type VARCHAR(50),
    Episodes INT,
    Aired DATE,
    Premiered VARCHAR(50),
    Source VARCHAR(50),
    Duration VARCHAR(50),
    Rating VARCHAR(100),
    Ranked DECIMAL(5,2),  -- Changement de DECIMAL(4,2) à DECIMAL(5,2)
    Popularity INT
);

-- Création de la table Genre
CREATE TABLE Genre (
    Genre_ID SERIAL PRIMARY KEY,
    Genre_Name VARCHAR(100) UNIQUE
);

-- Création de la table associative Anime_Genre
CREATE TABLE Anime_Genre (
    Anime_ID INT,
    Genre_ID INT,
    PRIMARY KEY (Anime_ID, Genre_ID),
    FOREIGN KEY (Anime_ID) REFERENCES Anime(Anime_ID) ON DELETE CASCADE,
    FOREIGN KEY (Genre_ID) REFERENCES Genre(Genre_ID) ON DELETE CASCADE
);

-- Création de la table Studio
CREATE TABLE Studio (
    Studio_ID SERIAL PRIMARY KEY,
    Studio_Name VARCHAR(255) UNIQUE
);

-- Création de la table associative Anime_Studio
CREATE TABLE Anime_Studio (
    Anime_ID INT,
    Studio_ID INT,
    PRIMARY KEY (Anime_ID, Studio_ID),
    FOREIGN KEY (Anime_ID) REFERENCES Anime(Anime_ID) ON DELETE CASCADE,
    FOREIGN KEY (Studio_ID) REFERENCES Studio(Studio_ID) ON DELETE CASCADE
);

-- Création de la table Producer
CREATE TABLE Producer (
    Producer_ID SERIAL PRIMARY KEY,
    Producer_Name VARCHAR(255) UNIQUE
);

-- Création de la table associative Anime_Producer
CREATE TABLE Anime_Producer (
    Anime_ID INT,
    Producer_ID INT,
    PRIMARY KEY (Anime_ID, Producer_ID),
    FOREIGN KEY (Anime_ID) REFERENCES Anime(Anime_ID) ON DELETE CASCADE,
    FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE
);

################


-- Insertion des données dans la table Anime
INSERT INTO Anime (English_name, Score, Type, Episodes, Aired, Premiered, Source, Duration, Rating, Ranked, Popularity) VALUES
('Cowboy Bebop', 8.78, 'TV', 26, '1998-04-03', 'Spring 1998', 'Original', '24 min. per ep', 'R - 17+ (violence & profanity)', 28.0, 39),
('Cowboy Bebop: The Movie', 8.39, 'Movie', 1, '2001-09-01', '', 'Original', '1 hr. 55 min.', 'R - 17+ (violence & profanity)', 159.0, 518),
('Naruto', 7.91, 'TV', 220, '2002-10-03', 'Fall 2002', 'Manga', '23 min. per ep.', 'PG-13 - Teens 13 or older', 660.0, 8);

-- Insertion des données dans la table Genre
INSERT INTO Genre (Genre_Name) VALUES
('Action'), ('Adventure'), ('Drama'), ('Sci-Fi'), ('Space'), ('Shounen'), ('Military');

-- Insertion des relations Anime-Genre
INSERT INTO Anime_Genre (Anime_ID, Genre_ID) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 1), (2, 3), (2, 4), (2, 5),
(3, 1), (3, 2), (3, 6);

-- Insertion des données dans la table Studio
INSERT INTO Studio (Studio_Name) VALUES 
('Sunrise'), ('Bones'), ('Studio Pierrot'), ('Toei Animation');

-- Insertion des relations Anime-Studio
INSERT INTO Anime_Studio (Anime_ID, Studio_ID) VALUES
(1, 1), (2, 2), (3, 3);

-- Insertion des données dans la table Producer
INSERT INTO Producer (Producer_Name) VALUES 
('Bandai Visual'), ('TV Tokyo'), ('Shueisha'), ('Fuji TV');

-- Insertion des relations Anime-Producer
INSERT INTO Anime_Producer (Anime_ID, Producer_ID) VALUES
(1, 1), (3, 2), (3, 3);


--######FIN DU SCRIPT A COLLER#####
