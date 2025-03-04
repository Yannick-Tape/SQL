import psycopg2

# Connexion à la base PostgreSQL
conn = psycopg2.connect(
    dbname="exam_Yannick_TAPE",
    user="daniel",
    password="datascientest",
    host="localhost",
    port="5432"
)

# Fonction pour exécuter une requête et afficher les résultats
def execute_query(query, description):
    with conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()
        print(f"\n{description} :\n" + "=" * 50)
        for row in rows:
            print(row)

# Liste des requêtes SQL et descriptions
queries = [
    ("Compter le nombre de Pokémon par type dans l'ordre décroissant",
     "SELECT name_type, COUNT(*) FROM PokemonType JOIN Types ON PokemonType.type_id = Types.type_id GROUP BY name_type ORDER BY COUNT(*) DESC;"),
    
    ("Lister les Pokémon avec un nombre de base de points supérieur à 600",
     "SELECT name, base_total FROM Pokemon WHERE base_total > 600 ORDER BY base_total DESC;"),
    
    ("Afficher les types de Pokémon avec la base de points moyenne dans l'ordre croissant",
     "SELECT Types.name_type, AVG(Pokemon.base_total) AS moyenne_points FROM Pokemon JOIN PokemonType ON Pokemon.pokedex_number = PokemonType.pokedex_number JOIN Types ON PokemonType.type_id = Types.type_id GROUP BY Types.name_type ORDER BY moyenne_points ASC;"),
    
    ("Trouver les Pokémon qui ont la capacité spéciale 'Overgrow'",
     "SELECT Pokemon.name, Pokemon.base_total FROM Pokemon JOIN PokemonAbility ON Pokemon.pokedex_number = PokemonAbility.pokedex_number JOIN Abilities ON PokemonAbility.ability_id = Abilities.ability_id WHERE Abilities.name_ability = 'Overgrow' ORDER BY Pokemon.base_total DESC;"),
    
    ("Lister les noms des Pokémon, leur type principal et leur type secondaire",
     """SELECT p.name, MIN(t.name_type) AS type_principal, 
               CASE WHEN COUNT(t.name_type) > 1 THEN MAX(t.name_type) ELSE 'Aucun' END AS type_secondaire
        FROM Pokemon p
        JOIN PokemonType pt ON p.pokedex_number = pt.pokedex_number
        JOIN Types t ON pt.type_id = t.type_id
        GROUP BY p.name
        ORDER BY p.name;"""),
    
    ("Afficher les Pokémon avec un total de stats supérieur à la moyenne par génération",
     """SELECT p.name, p.generation, p.base_total
        FROM Pokemon p
        WHERE p.base_total > (SELECT AVG(p2.base_total) FROM Pokemon p2 WHERE p2.generation = p.generation)
        ORDER BY p.generation, p.base_total DESC;"""),
    
    ("Trouver les Pokémon de type 'Fire' avec une attaque supérieure à 100",
     """SELECT p.name, s.attack 
        FROM Pokemon p
        JOIN Stats s ON p.pokedex_number = s.pokedex_number
        JOIN PokemonType pt ON p.pokedex_number = pt.pokedex_number
        JOIN Types t ON pt.type_id = t.type_id
        WHERE LOWER(t.name_type) = 'fire' AND s.attack > 100
        ORDER BY s.attack DESC;"""),
    
    ("Indiquer si le total des stats d'un Pokémon est supérieur ou inférieur à la moyenne par génération",
     """SELECT p.name, p.generation, p.base_total,
               CASE 
                   WHEN p.base_total > (SELECT AVG(p2.base_total) FROM Pokemon p2 WHERE p2.generation = p.generation) 
                   THEN 'Supérieur à la moyenne' 
                   ELSE 'Inférieur ou égal à la moyenne' 
               END AS comparaison
        FROM Pokemon p
        ORDER BY p.generation, p.base_total DESC;""")
]

# Exécution des requêtes
for desc, query in queries:
    execute_query(query, desc)

# Fermer la connexion
conn.close()

