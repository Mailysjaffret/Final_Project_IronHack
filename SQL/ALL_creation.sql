-- 1. CREATION DE LA BASE

-- DROP DATABASE IF EXISTS tourism_analytics;
CREATE DATABASE tourism_analytics
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE tourism_analytics;

-- 2. TABLES FINALES (celles qui servent pour l’analyse)

-- Pays
CREATE TABLE country (
  country_id   INT AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_country_name (country_name)
) ENGINE=InnoDB;

-- Villes (issues de Wikipedia)
CREATE TABLE city (
  city_id      INT AUTO_INCREMENT PRIMARY KEY,
  city_name    VARCHAR(120) NOT NULL,
  country_id   INT NOT NULL,
  international_visitors_2018 INT NULL,
  description  TEXT NULL,
  extract_date DATE NULL,
  source_url   VARCHAR(255) NULL,
  UNIQUE KEY uq_city_country (city_name, country_id),
  CONSTRAINT fk_city_country
    FOREIGN KEY (country_id) REFERENCES country(country_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Airbnb listings
-- DROP TABLE IF EXISTS airbnb_listing;
CREATE TABLE airbnb_listing (
  listing_id        BIGINT AUTO_INCREMENT PRIMARY KEY,
  city_id           INT NOT NULL,
  listing_name      VARCHAR(255) NOT NULL,
  neighbourhood_cleansed VARCHAR(150) NULL,
  latitude          DECIMAL(9,6) NULL,
  longitude         DECIMAL(9,6) NULL,
  room_type         VARCHAR(120) NULL,
  accommodates      INT NULL,
  bedrooms          DECIMAL(4,1) NULL,
  beds              DECIMAL(4,1) NULL,
  bathrooms         DECIMAL(4,1) NULL,
  bathrooms_text    VARCHAR(120) NULL,
  price             DECIMAL(10,2) NULL,
  minimum_nights    INT NULL,
  maximum_nights    INT NULL,
  availability_365  INT NULL,
  number_of_reviews INT NULL,
  review_scores_rating DECIMAL(4,2) NULL,
  KEY ix_airbnb_city (city_id),
  CONSTRAINT uq_airbnb UNIQUE (city_id, listing_name),  -- éviter doublons
  CONSTRAINT fk_airbnb_city FOREIGN KEY (city_id) 
    REFERENCES city(city_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Numbeo (version pivotée)
CREATE TABLE numbeo_cost (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  city_id INT NOT NULL,
  item_label VARCHAR(150),
  price_eur DECIMAL(10,2),
  CONSTRAINT fk_numbeo_city
    FOREIGN KEY (city_id) REFERENCES city(city_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Eurostat
CREATE TABLE eurostat_fact (
  eurostat_fact_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id   INT NOT NULL,
  year         SMALLINT NOT NULL,
  accommodation VARCHAR(120) NULL,
  purpose       VARCHAR(120) NULL,
  duration      VARCHAR(120) NULL,
  transport     VARCHAR(120) NULL,
  destination   VARCHAR(120) NULL,
  value_accomodation DECIMAL(18,4) NULL,
  value_transport   DECIMAL(18,4) NULL,
  value_destination DECIMAL(18,4) NULL,
  KEY ix_euro_country_year (country_id, year),
  CONSTRAINT fk_euro_country
    FOREIGN KEY (country_id) REFERENCES country(country_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Worlddata
CREATE TABLE worlddata_fact (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id INT NOT NULL,
  year INT NOT NULL,
  arrivals_million DECIMAL(10,2),
  CONSTRAINT fk_world_country
    FOREIGN KEY (country_id) REFERENCES country(country_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


-- 3. TABLES STAGING (pour charger les CSV bruts)

-- Wikipedia
CREATE TABLE stg_wiki (
  city   VARCHAR(120),
  country VARCHAR(100),
  international_visitors_2018 VARCHAR(64),
  description TEXT,
  extract_date VARCHAR(32),
  source_url VARCHAR(255)
);

-- DROP TABLE IF EXISTS stg_airbnb;
-- Airbnb (16 colonnes seulement)
CREATE TABLE stg_airbnb (
  listing_name VARCHAR(255),
  neighbourhood_cleansed VARCHAR(150),
  latitude VARCHAR(64),
  longitude VARCHAR(64),
  room_type VARCHAR(120),
  accommodates VARCHAR(64),
  bedrooms VARCHAR(64),
  beds VARCHAR(64),
  bathrooms VARCHAR(64),
  bathrooms_text VARCHAR(120),
  price VARCHAR(64),
  minimum_nights VARCHAR(64),
  maximum_nights VARCHAR(64),
  availability_365 VARCHAR(64),
  number_of_reviews VARCHAR(64),
  review_scores_rating VARCHAR(64),
  city VARCHAR(120)
);

-- Numbeo pivot
CREATE TABLE stg_numbeo (
  City VARCHAR(120),
  Item_label VARCHAR(150),
  Price_eur VARCHAR(64)
);

-- Eurostat
CREATE TABLE stg_eurostat (
  Country VARCHAR(100),
  Time VARCHAR(10),
  Accommodation VARCHAR(120),
  Purpose VARCHAR(120),
  Duration VARCHAR(120),
  Transport VARCHAR(120),
  Destination VARCHAR(120),
  Value_accomodation VARCHAR(64),
  Value_transport VARCHAR(64),
  Value_destination VARCHAR(64)
);

-- Worlddata
CREATE TABLE stg_worlddata (
  Country VARCHAR(120),
  Year VARCHAR(10),
  Arrivals_millions VARCHAR(64)
);

-- 4. CHARGEMENT DES DONNEES (CSV → staging)

-- Wikipedia
LOAD DATA LOCAL INFILE '/Users/mailysjaffret/Desktop/IRONHACK/Final_Project/data/clean/wiki_city_international_visitors.csv'
INTO TABLE stg_wiki
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(city, country, international_visitors_2018, description, extract_date, source_url);


SHOW COLUMNS FROM stg_airbnb;
SET GLOBAL local_infile = 1;
-- Airbnb
LOAD DATA LOCAL INFILE '/Users/mailysjaffret/Desktop/IRONHACK/Final_Project/data/clean/airbnb_clean.csv'
INTO TABLE stg_airbnb
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(listing_name, neighbourhood_cleansed, latitude, longitude, room_type, accommodates,
 bedrooms, beds, bathrooms, bathrooms_text, price, minimum_nights,
 maximum_nights, availability_365, number_of_reviews, review_scores_rating, city);
 
-- Numbeo
LOAD DATA LOCAL INFILE '/Users/mailysjaffret/Desktop/IRONHACK/Final_Project/data/clean/numbeo_cost_of_living.csv'
INTO TABLE stg_numbeo
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(City, Item_label, Price_eur);

-- Eurostat
LOAD DATA LOCAL INFILE '/Users/mailysjaffret/Desktop/IRONHACK/Final_Project/data/clean/eurostat_trips_all.csv'
INTO TABLE stg_eurostat
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Country, Time, Accommodation, Purpose, Duration, Transport, Destination,
 Value_accomodation, Value_transport, Value_destination);

-- Worlddata
LOAD DATA LOCAL INFILE '/Users/mailysjaffret/Desktop/IRONHACK/Final_Project/data/clean/world_data_number_of_arrivals.csv'
INTO TABLE stg_worlddata
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Country, Year, Arrivals_millions);


-- 5. INSERTION DANS LES TABLES FINALES

-- 5.1 Pays
INSERT IGNORE INTO country (country_name)
SELECT DISTINCT country FROM stg_wiki WHERE country IS NOT NULL AND country <> ''
UNION
SELECT DISTINCT Country FROM stg_eurostat WHERE Country IS NOT NULL AND Country <> ''
UNION
SELECT DISTINCT Country FROM stg_worlddata WHERE Country IS NOT NULL AND Country <> '';

-- 5.2 Villes (depuis Wikipedia)
INSERT INTO city (city_name, country_id, international_visitors_2018, description, extract_date, source_url)
SELECT
  w.city,
  c.country_id,
  CAST(REPLACE(w.international_visitors_2018,'.0','') AS UNSIGNED),
  w.description,
  STR_TO_DATE(w.extract_date, '%Y-%m-%d'),
  w.source_url
FROM stg_wiki w
JOIN country c ON c.country_name = w.country COLLATE utf8mb4_0900_ai_ci;

-- 5.3 Airbnb
-- DELETE FROM airbnb_listing;
INSERT INTO airbnb_listing (
  city_id, listing_name, neighbourhood_cleansed, latitude, longitude, room_type,
  accommodates, bedrooms, beds, bathrooms, bathrooms_text,
  price, minimum_nights, maximum_nights, availability_365,
  number_of_reviews, review_scores_rating
)
SELECT
  ci.city_id,
  s.listing_name,
  s.neighbourhood_cleansed,
  CAST(NULLIF(REPLACE(s.latitude, ',', '.'), '') AS DECIMAL(9,6)),
  CAST(NULLIF(REPLACE(s.longitude, ',', '.'), '') AS DECIMAL(9,6)),
  s.room_type,
  CAST(NULLIF(s.accommodates, '') AS SIGNED),
  CAST(NULLIF(REPLACE(s.bedrooms, ',', '.'), '') AS DECIMAL(4,1)),
  CAST(NULLIF(REPLACE(s.beds, ',', '.'), '') AS DECIMAL(4,1)),
  CAST(NULLIF(REPLACE(s.bathrooms, ',', '.'), '') AS DECIMAL(4,1)),
  s.bathrooms_text,
  CAST(NULLIF(REPLACE(s.price, ',', '.'), '') AS DECIMAL(10,2)),
  CAST(NULLIF(s.minimum_nights, '') AS SIGNED),
  CAST(NULLIF(s.maximum_nights, '') AS SIGNED),
  CAST(NULLIF(s.availability_365, '') AS SIGNED),
  CAST(NULLIF(s.number_of_reviews, '') AS SIGNED),
  CAST(NULLIF(REPLACE(s.review_scores_rating, ',', '.'), '') AS DECIMAL(4,2))
FROM stg_airbnb s
JOIN city ci ON ci.city_name = s.city COLLATE utf8mb4_0900_ai_ci;

-- 5.4 Numbeo
-- DELETE FROM numbeo_cost;
INSERT INTO numbeo_cost (city_id, item_label, price_eur)
SELECT
  ci.city_id,
  n.Item_label,
  CAST(NULLIF(REPLACE(n.Price_eur, ',', '.'), '') AS DECIMAL(10,2))
FROM stg_numbeo n
JOIN city ci ON ci.city_name = n.City COLLATE utf8mb4_0900_ai_ci;

-- 5.5 Worlddata
INSERT INTO worlddata_fact (country_id, year, arrivals_million)
SELECT
  c.country_id,
  CAST(w.Year AS UNSIGNED),
  CAST(NULLIF(REPLACE(w.Arrivals_millions, ',', '.'), '') AS DECIMAL(10,2))
FROM stg_worlddata w
JOIN country c ON c.country_name = w.Country COLLATE utf8mb4_0900_ai_ci;

-- 5.7 Eurostat
INSERT INTO eurostat_fact (
  country_id, year, accommodation, purpose, duration, transport, destination,
  value_accomodation, value_transport, value_destination
)
SELECT
  c.country_id,
  CAST(e.Time AS UNSIGNED),
  NULLIF(e.Accommodation,''), 
  NULLIF(e.Purpose,''), 
  NULLIF(e.Duration,''), 
  NULLIF(e.Transport,''), 
  NULLIF(e.Destination,''),
  
  -- Nettoyage des valeurs numériques
  CASE 
    WHEN e.Value_accomodation REGEXP '^-?[0-9]+(\\.[0-9]+)?$' 
    THEN e.Value_accomodation ELSE NULL END,
    
  CASE 
    WHEN e.Value_transport REGEXP '^-?[0-9]+(\\.[0-9]+)?$' 
    THEN e.Value_transport ELSE NULL END,
    
  CASE 
    WHEN e.Value_destination REGEXP '^-?[0-9]+(\\.[0-9]+)?$' 
    THEN e.Value_destination ELSE NULL END

FROM stg_eurostat e
JOIN country c
  ON c.country_name = e.Country COLLATE utf8mb4_0900_ai_ci;

-- 6. CONTROLES

SELECT
  (SELECT COUNT(*) FROM country)        AS nb_countries,
  (SELECT COUNT(*) FROM city)           AS nb_cities,
  (SELECT COUNT(*) FROM airbnb_listing) AS nb_airbnb,
  (SELECT COUNT(*) FROM numbeo_cost)    AS nb_numbeo,
  (SELECT COUNT(*) FROM eurostat_fact)  AS nb_eurostat,
  (SELECT COUNT(*) FROM worlddata_fact) AS nb_worlddata;
  
  
  