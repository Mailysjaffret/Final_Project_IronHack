-- 1) Average Airbnb Price per City
SELECT ci.city_name,
       ROUND(AVG(a.price), 2) AS avg_airbnb_price
FROM airbnb_listing a
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY avg_airbnb_price DESC;

-- 2) Airbnb Price vs Airbnb Capacity
-- Do larger accommodations cost proportionally more ?
SELECT ci.city_name,
       ROUND(AVG(a.accommodates), 1) AS avg_capacity,
       ROUND(AVG(a.price), 2) AS avg_price,
       ROUND(AVG(a.price) / NULLIF(AVG(a.accommodates),0), 2) AS price_per_person
FROM city ci
JOIN airbnb_listing a ON ci.city_id = a.city_id
GROUP BY ci.city_name;

-- 3) TOP 3 Travel Purposes and Destinations by country (2023)
SELECT t.country_name,
       t.purpose,
       t.destination,
       t.total_trips_million,
       t.rn AS rank_in_country
FROM (
    SELECT c.country_name,
           e.purpose,
           e.destination,
           ROUND(SUM(e.value_destination) / 1000000, 1) AS total_trips_million,
           ROW_NUMBER() OVER (
               PARTITION BY c.country_name
               ORDER BY SUM(e.value_destination) DESC
           ) AS rn
    FROM eurostat_fact e
    JOIN country c ON e.country_id = c.country_id
    WHERE e.purpose IS NOT NULL
      AND e.purpose <> 'Total'
      AND e.destination IS NOT NULL
      AND e.year = 2023
    GROUP BY c.country_name, e.purpose, e.destination
) t
WHERE t.rn <= 3
ORDER BY t.country_name, t.rn;

-- 4) Domestic vs International Trips by Country (2023)
SELECT c.country_name,
       SUM(CASE WHEN e.destination = c.country_name 
                THEN e.value_destination ELSE 0 END) / 1000000 AS domestic_trips_million,
       SUM(CASE WHEN e.destination <> c.country_name 
                THEN e.value_destination ELSE 0 END) / 1000000 AS international_trips_million,
       ROUND(
         SUM(CASE WHEN e.destination = c.country_name 
                  THEN e.value_destination ELSE 0 END) 
         / SUM(e.value_destination) * 100, 1
       ) AS pct_domestic,
       ROUND(
         SUM(CASE WHEN e.destination <> c.country_name 
                  THEN e.value_destination ELSE 0 END) 
         / SUM(e.value_destination) * 100, 1
       ) AS pct_international
FROM eurostat_fact e
JOIN country c ON e.country_id = c.country_id
WHERE e.purpose IS NOT NULL
  AND e.purpose <> 'Total'
  AND e.destination IS NOT NULL
  AND e.year = 2020
GROUP BY c.country_name
ORDER BY pct_domestic DESC;


-- 5) Main Transport Modes by Country (2023)
SELECT t.country_name,
       t.transport,
       t.total_trips_million,
       t.rn AS rank_in_country
FROM (
    SELECT c.country_name,
           e.transport,
           ROUND(SUM(e.value_transport) / 1000000, 1) AS total_trips_million,
           ROW_NUMBER() OVER (
               PARTITION BY c.country_name
               ORDER BY SUM(e.value_transport) DESC
           ) AS rn
    FROM eurostat_fact e
    JOIN country c ON e.country_id = c.country_id
    WHERE e.transport IS NOT NULL
      AND e.year = 2023
    GROUP BY c.country_name, e.transport
) t
WHERE t.rn <= 3
ORDER BY t.country_name, t.rn;