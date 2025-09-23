-- Table à l'échelle de la ville : airbnb + wikipedia + numbeo
CREATE TABLE airbnb_wiki_numbeo AS
SELECT 
    a.listing_id,
    a.listing_name,
    ci.city_name,
    co.country_name,
    a.room_type,
    a.price,
    a.accommodates,
    a.bedrooms,
    a.beds,
    a.bathrooms,
    a.availability_365,
    a.number_of_reviews,
    a.review_scores_rating,

    -- Numbeo pivot complet
    MAX(CASE WHEN n.item_label = 'Meal_inexpensive_restaurant' THEN n.price_eur END) AS meal_inexpensive,
    MAX(CASE WHEN n.item_label = 'Mcdonalds' THEN n.price_eur END) AS mcdonalds,
    MAX(CASE WHEN n.item_label = 'Cappuccino' THEN n.price_eur END) AS cappuccino,
    MAX(CASE WHEN n.item_label = 'Gasoline_1l' THEN n.price_eur END) AS gasoline_1l,
    MAX(CASE WHEN n.item_label = 'One_way_ticket' THEN n.price_eur END) AS one_way_ticket,
    MAX(CASE WHEN n.item_label = 'Monthly_pass' THEN n.price_eur END) AS monthly_pass,
    MAX(CASE WHEN n.item_label = 'Taxi_1km' THEN n.price_eur END) AS taxi_1km,
    MAX(CASE WHEN n.item_label = 'Cinema' THEN n.price_eur END) AS cinema,
    MAX(CASE WHEN n.item_label = 'Fitness_monthly' THEN n.price_eur END) AS fitness_monthly,

    -- Wikipedia
    ci.international_visitors_2018,
    ci.description AS wiki_description

FROM airbnb_listing a
JOIN city ci 
    ON a.city_id = ci.city_id
JOIN country co 
    ON ci.country_id = co.country_id
LEFT JOIN numbeo_cost n 
    ON ci.city_id = n.city_id
GROUP BY 
    a.listing_id, a.listing_name, 
    ci.city_name, co.country_name,
    a.room_type, a.price, a.accommodates, 
    a.bedrooms, a.beds, a.bathrooms, 
    a.availability_365, a.number_of_reviews, 
    a.review_scores_rating, 
    ci.international_visitors_2018, ci.description;
    
-- Table à l'échelle du pays : eurostat + worlddata
CREATE TABLE eurostat_world_data AS
SELECT 
    c.country_id,
    c.country_name,
    e.year,
    e.accommodation,
    e.purpose,
    e.duration,
    e.transport,
    e.destination,
    e.value_accomodation,
    e.value_transport,
    e.value_destination,
    w.arrivals_million
FROM country c
LEFT JOIN eurostat_fact e ON c.country_id = e.country_id
LEFT JOIN worlddata_fact w ON c.country_id = w.country_id AND e.year = w.year;

SELECT COUNT(*) FROM airbnb_wiki_numbeo;
SELECT COUNT(*) FROM eurostat_world_data;

SELECT * FROM airbnb_wiki_numbeo;
SELECT * FROM eurostat_world_data;