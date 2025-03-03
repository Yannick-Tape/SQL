import psycopg2

conn = psycopg2.connect(
    database="chenil_v4",            
    host="18.203.253.18",              
    user="daniel",                 
    password="datascientest",      
    port=5432                      
)
cur = conn.cursor()
cur.execute("SELECT * FROM Chiens LIMIT 10;")

rows = cur.fetchall()
for row in rows:
    print(row)


cur.close()
conn.close()

