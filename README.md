# SQL
Implémentation d'une base de données relationnelle


########################################## PARTIE I ##################################
Créer un repo sur GitHub denommé SQL
cd~ puis mkdir SQL_langage_partie
cd mkdir SQL_langage_partie
git clone … (on clone le repo SQL dans le dossier SQL_langage_partie qui est à la racine) 

docker ps -a # on vérifie que tous les conteneur sont supprimés si non
docker stop <c1> <c2>
docker rm <c1> <c2>

vim docker-compose.yam

version: '3.8'
services:
  db:
    container_name: pg_container
    image: postgres:16-alpine
    restart: always
    environment:
      POSTGRES_USER: daniel
      POSTGRES_PASSWORD: datascientest
      POSTGRES_DB: animedb
    ports:
      - "5432:5432"
  pgadmin:
    container_name: pgadmin4_container
    image: dpage/pgadmin4
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: daniel@datascientest.com
      PGADMIN_DEFAULT_PASSWORD: data_engineer
    ports:
      - "5050:80"

docker-compose up -d
docker ps -a   # on verifie bien que pg et pgadmin tournent

docker exec -it pg_container bash   # on ouvrir le serveur
psql -h localhost -U daniel animedb   # on se connecte au serveur
\l    # on verifie que notre base de données animedb est existe déjà



Ouvre ton navigateur et va à http://localhost:5050 (ou l'adresse IP de ton serveur si tu ne travailles pas en local).
Connecte-toi avec les identifiants suivants :
Email : daniel@datascientest.com
Mot de passe : data_engineer
Une fois connecté à pgAdmin, ajoute un nouveau serveur.
Name : PostgreSQL SERVER
# clique sur le bouton Connection puis :
maintenance database : animedb (voir variable d'env du docker-compose POSTGRES_DB: animedb)
Nom d'utilisateur : daniel
Mot de passe : datascientest

# Aborescence (à gauche et en haut) de la fenetre 
PostgreSQL SERVER ----> Databases  ----> animesb ----> Schémas ----> Tables

#Exécuter ton script SQL :
Ouvre le Query Tool dans pgAdmin.
Colle ton script SQL (celui que tu veux utiliser pour créer les tables et insérer des données).
Exécute-le. voici le Script:

--#######DEBUT DU SCRIPT A COLLER#########
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

# Clic droit sur Tables (dans l'aborescence) puis rafraichir; elles apparaissent toutes.

# run chacune de ces commandes l'une apres l'autre:
SELECT * FROM Anime;
SELECT * FROM Genre;
SELECT * FROM Anime_Genre;
SELECT * FROM Studio;
SELECT * FROM Anime_Studio;
SELECT * FROM Producer;
SELECT * FROM Anime_Producer;

########################################## PARTIE II ##################################



Nous sommes dans le repertoire : Ubuntu/home/SQL_langage_partie/SQL

# Téléchagez les données à l'aide de la commande suivante
cd && wget https://dst-de.s3.eu-west-3.amazonaws.com/bdd_postgres_fr/database/examen.sql

# Mettez en place la base de données:
docker exec -i pg_container psql -U daniel -d exam_Yannick_TAPE < ./examen.sql

















