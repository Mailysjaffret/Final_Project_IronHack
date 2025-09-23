import os
import pymysql
from pymysql.cursors import DictCursor
from flask import Flask, request, jsonify
from flasgger import Swagger
from dotenv import load_dotenv

# Charger les variables d'environnement (.env)
load_dotenv()

app = Flask(__name__)
swagger = Swagger(app)

# --- Connexion MySQL ---
def get_db_connection():
    return pymysql.connect(
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        user=os.getenv("MYSQL_USER", "root"),
        password=os.getenv("MYSQL_PASSWORD", ""),
        database=os.getenv("MYSQL_DB", "tourism_analytics"),
        port=int(os.getenv("MYSQL_PORT", 3306)),
        cursorclass=DictCursor
    )

# --- Homepage ---
@app.route("/")
def home():
    return """
    <h1>Welcome to my Tourism Analytics API 🌍</h1>
    <p>Available endpoints:</p>
    <ul>
        <li><a href="/airbnb?limit=5">/airbnb</a> → List of Airbnb listings (with pagination)</li>
        <li><a href="/airbnb/262141">/airbnb/{listing_id}</a> → Get a single Airbnb listing by ID</li>
        <li><a href="/eurostat?country=France&year=2018">/eurostat</a> → Eurostat data with filters</li>
        <li><a href="/eurostat/1">/eurostat/{record_id}</a> → Get a single Eurostat record by ID</li>
        <li><a href="/apidocs">/apidocs</a> → Swagger UI documentation</li>
    </ul>
    """

# -----------------------------
# --- Airbnb endpoints ---
# -----------------------------
@app.route("/airbnb/<int:listing_id>", methods=["GET"])
def get_airbnb(listing_id):
    """
    Get details of a single Airbnb listing by ID
    ---
    parameters:
      - name: listing_id
        in: path
        type: integer
        required: true
        description: The ID of the Airbnb listing
    responses:
      200:
        description: A single Airbnb listing
      404:
        description: Listing not found
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM airbnb_listing WHERE listing_id = %s", (listing_id,))
    row = cursor.fetchone()
    conn.close()
    if row:
        return jsonify(row)
    return jsonify({"error": "Listing not found"}), 404

@app.route("/airbnb", methods=["GET"])
def list_airbnb():
    """
    Get a list of Airbnb listings (with pagination)
    ---
    parameters:
      - name: limit
        in: query
        type: integer
        required: false
        default: 10
        description: Number of records to return
    responses:
      200:
        description: A list of Airbnb listings
    """
    limit = int(request.args.get("limit", 10))
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM airbnb_listing LIMIT %s", (limit,))
    rows = cursor.fetchall()
    conn.close()
    return jsonify(rows)

# -----------------------------
# --- Eurostat endpoints ---
# -----------------------------
@app.route("/eurostat/<int:record_id>", methods=["GET"])
def get_eurostat(record_id):
    """
    Get details of a single Eurostat record by ID
    ---
    parameters:
      - name: record_id
        in: path
        type: integer
        required: true
        description: The ID of the Eurostat record
    responses:
      200:
        description: A single Eurostat record
      404:
        description: Record not found
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM eurostat_fact WHERE eurostat_fact_id = %s", (record_id,))
    row = cursor.fetchone()
    conn.close()
    if row:
        return jsonify(row)
    return jsonify({"error": "Record not found"}), 404

@app.route("/eurostat", methods=["GET"])
def list_eurostat():
    """
    Get Eurostat data (with optional filters for country and year)
    ---
    parameters:
      - name: country
        in: query
        type: string
        required: false
        description: Filter by country name
      - name: year
        in: query
        type: integer
        required: false
        description: Filter by year
    responses:
      200:
        description: A list of Eurostat records
    """
    country = request.args.get("country")
    year = request.args.get("year")

    query = "SELECT e.* FROM eurostat_fact e"
    params = []

    if country:
        query += " JOIN country c ON e.country_id = c.country_id WHERE c.country_name = %s"
        params.append(country)
    else:
        query += " WHERE 1=1"

    if year:
        query += " AND e.year = %s"
        params.append(year)

    query += " LIMIT 50"

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query, tuple(params))
    rows = cursor.fetchall()
    conn.close()
    return jsonify(rows)

# --- Lancer le serveur ---
if __name__ == "__main__":
    app.run(debug=True)