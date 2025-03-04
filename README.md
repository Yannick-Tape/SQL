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
host name/adress : adresse ip  de ma VM
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

# Téléchagez les données à la racine (ubuntu/home) :
cd && wget https://dst-de.s3.eu-west-3.amazonaws.com/bdd_postgres_fr/database/examen.sql

########### debut commande qui ne marche pas ################
# Mettez en place la base de données:
docker exec -i pg_container psql -U daniel -d exam_Yannick_TAPE < ./examen.sql
########### fin commande qui ne marche pas ################ on trouve une autre solution :

D'après notre docker-compose (fichier docker-compose.yml), la seule base de données créée automatiquement au démarrage est animedb.
C'est pourquoi On va donc la créer manuellement exam_Yannick_TAPE sinon PostgreSQL ne trouve pas:

1. Vérifier que les conteneurs tournent :
docker ps       # pour vérifier que pg_container tourne (sinon faire docker-compose up -d)

2. Se connecter à PostgreSQL et créer la base de données :
Comme seule la base animedb existe, on doit se connecter à elle et créer exam_Yannick_TAPE
docker exec -it pg_container psql -U daniel -d animedb
CREATE DATABASE "exam_Yannick_TAPE";
\q
3. Importer examen.sql dans la base exam_Yannick_TAPE
docker exec -it pg_container psql -U daniel -d "exam_Yannick_TAPE" -f /home/examen.sql

4. Vérifier que les tables ont bien été importées
docker exec -it pg_container psql -U daniel -d "exam_Yannick_TAPE"
\dt          # Si les tables apparaissent, tout est bon !

# on ouvre pgAdmin pour lancer les requetes:
Ouvre ton navigateur et va à http://localhost:5050 (ou l'adresse IP de ton serveur si tu ne travailles pas en local).
Connecte-toi avec les identifiants suivants :
Email : daniel@datascientest.com
Mot de passe : data_engineer
Une fois connecté à pgAdmin, ajoute un nouveau serveur.
Name : Pokemon SERVER
# clique sur le bouton Connection puis :
host name/adress : adresse ip  de ma VM
maintenance database:exam_Yannick_TAPE (voir ci-dessus CREATE DATABASE "exam_Yannick_TAPE";
)
Nom d'utilisateur : daniel
Mot de passe : datascientest




-- 	COMMANDE SQL A COPIER-COLLER DANS PGADMIN EXAM-PART2


-- Requête 1: Compter le nombre de Pokémon par type dans l'ordre décroissant.
SELECT name_type, COUNT(*) 
FROM PokemonType 
JOIN Types ON PokemonType.type_id = Types.type_id 
GROUP BY name_type 
ORDER BY COUNT(*) DESC;

-- Requête 2: Lister les Pokémon avec un nombre de base de points supérieur à 600, triés de manière décroissante.
SELECT name, base_total 
FROM Pokemon 
WHERE base_total > 600 
ORDER BY base_total DESC;

-- Requête 3: Afficher les types de Pokémon avec la base de points moyenne dans l'ordre croissant
SELECT Types.name_type, AVG(Pokemon.base_total) AS moyenne_points 
FROM Pokemon
JOIN PokemonType ON Pokemon.pokedex_number = PokemonType.pokedex_number
JOIN Types ON PokemonType.type_id = Types.type_id
GROUP BY Types.name_type
ORDER BY moyenne_points ASC;

-- Requête 4: Trouver les Pokémon qui ont la capacité spéciale 'Overgrow' et trier par la base de points dans un ordre décroissant.
SELECT Pokemon.name, Pokemon.base_total 
FROM Pokemon
JOIN PokemonAbility ON Pokemon.pokedex_number = PokemonAbility.pokedex_number
JOIN Abilities ON PokemonAbility.ability_id = Abilities.ability_id
WHERE Abilities.name_ability = 'Overgrow'
ORDER BY Pokemon.base_total DESC;

-- Requête 5: Lister les noms des Pokémon, leur type principal et leur type secondaire (s'ils en ont un). Trier par le nom.
SELECT p.name, 
       MIN(t.name_type) AS type_principal, 
       CASE 
           WHEN COUNT(t.name_type) > 1 THEN MAX(t.name_type) 
           ELSE 'Aucun' 
       END AS type_secondaire
FROM Pokemon p
JOIN PokemonType pt ON p.pokedex_number = pt.pokedex_number
JOIN Types t ON pt.type_id = t.type_id
GROUP BY p.name
ORDER BY p.name;

-- Requête 6: Afficher les Pokémon avec un total de stats supérieur à la moyenne par génération.
SELECT p.name, p.generation, p.base_total
FROM Pokemon p
WHERE p.base_total > (
    SELECT AVG(p2.base_total) 
    FROM Pokemon p2 
    WHERE p2.generation = p.generation
)
ORDER BY p.generation, p.base_total DESC;

-- Requête 7: Trouver les Pokémon de type "fire" avec une attaque supérieure à 100
SELECT p.name, s.attack 
FROM Pokemon p
JOIN Stats s ON p.pokedex_number = s.pokedex_number
JOIN PokemonType pt ON p.pokedex_number = pt.pokedex_number
JOIN Types t ON pt.type_id = t.type_id
WHERE LOWER(t.name_type) = 'fire' AND s.attack > 100
ORDER BY s.attack DESC;

-- Requête 8: Indiquer si le total des stats d'un Pokémon est supérieur ou inférieur à la moyenne par génération
SELECT p.name, p.generation, p.base_total,
       CASE 
           WHEN p.base_total > (SELECT AVG(p2.base_total) FROM Pokemon p2 WHERE p2.generation = p.generation) 
           THEN 'Supérieur à la moyenne' 
           ELSE 'Inférieur ou égal à la moyenne' 
       END AS comparaison
FROM Pokemon p
ORDER BY p.generation, p.base_total DESC;



---    EXAM-PART2 PSYCOPG2 script_pokemon.py      ---	

- le script script_pokemon.py permet de lancer les requêtes faites dans la partie 2 :
python3 script_pokemon.py
- La sauvegarde de la base de données :

  	1. Exécute cette commande dans ta VM Ubuntu pour exporter ta base de données exam_Yannick_TAPE en fichier SQL sur ta VM:
docker exec -t pg_container pg_dump -U daniel -d exam_Yannick_TAPE > exam_Yannick_TAPE.sql
	puis Vérifie que le fichier est bien créé avec :
ls -lh exam_Yannick_TAPE.sql

# on s'assure que ces 3 files sont également présents :
vim requete_SQL_Part1.sql
vim requete_SQL_Part2.sql
vim script_pokemon.py

	2.  Création de l’archive exam_TAPE.tar
mkdir exam_TAPE

# on copie-colle les files à compresser :
cp exam_Yannick_TAPE.sql requete_SQL_Part1.sql requete_SQL_Part2.sql script_pokemon.py docker-compose.yaml exam_TAPE/

ls -l ./exam_TAPE/  # tout est ok

# Puis, on crée l’archive .tar :
tar -cvf exam_TAPE.tar exam_TAPE
ls -l

	3.  Transfert du fichier exam_TAPE.tar sur ta machine locale avec scp
#######
COMMANDE A EXECUTER DANS MON TERMINAL WINDOWS LOCAL CMD pour voir si mon ordinateur peut acceder à la VM :
ssh -i "C:\Users\33669\Downloads\data_enginering_machine.pem" ubuntu@34.244.134.220
exit # c'était juste une vérification. on viens de se deconnecter de la VM 

Enfin la commande (toujours sur mon cmd) pour ensuite faire le transfer du .tar :
scp -i "C:\Users\33669\Downloads\data_enginering_machine.pem" ubuntu@34.244.134.220:~/SQL_langage_partie/SQL/exam_TAPE.tar .

Le fichier .tar se trouve désormais sur mon ordinateur local. je peux le soumettre à la correction de DS ( C:\Users\33669\exam_TAPE.tar)

git status
git add *
git status
git commit -m "mon examen de SQL complet"
git status
git push

