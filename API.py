import psycopg2

# Συνδεση στη βαση δεδομενων
conn = psycopg2.connect(
    host="your_host",
    database="your_database",
    user="your_username",
    password="your_password"
)

# Δημιουργια cursor
cursor = conn.cursor()

# Εκτελεση query
query = "SELECT * FROM your_table"
cursor.execute(query)


cursor.execute("SELECT * FROM "ΠΑΙΚΤΕΣ"")
players = cursor.fetchall()
cursor.execute("SELECT * FROM "ΟΜΑΔΕΣ"")
teams = cursor.fetchall()
cursor.execute("SELECT * FROM "ΑΓΩΝΕΣ"")
matches = cursor.fetchall()


# Ληψη αποτελεσματων
results = cursor.fetchall()

# Εμφανιση αποτελεσματων
for row in results:
    print(row)


print("Παίκτες:")
for player in players:
    print(player)

print("Ομάδες:")
for team in teams:
    print(team)

print("Αγώνες:")
for match in matches:
    print(match)
    

# Κλεισιμο cursor και συνδεσης
cursor.close()
conn.close()
