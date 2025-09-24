# 🏨 Tourism in Europe’s Capitals
Beds & Budgets: Mapping Airbnb Supply and Urban Travel Demand


## 📌 Introduction
This project combines **tourism demand** (Eurostat, WorldData, Wikipedia, Numbeo) and **tourism supply** (Airbnb) to analyze patterns in European travel and short-term rental markets.  

The focus is on **four countries** (France, Germany, Italy, Spain) and their capitals (Paris, Berlin, Rome, Madrid).  
The main objectives were:
- Identify the main drivers of Airbnb prices  
- Compare travel behaviors across Europe  
- Generate actionable insights for hosts, cities, and tourism boards  

---

## 🗂️ Data Sources
- **Eurostat (API/JSON)**: trips by purpose, transport, destination  
- **Airbnb (CSV)**: listings, availability, prices, reviews  
- **Numbeo (scraping)**: cost of living indicators  
- **WorldData & Wikipedia (scraping)**: tourist arrivals and city descriptions  

---

## 🗄️ Database Design
I built a **MySQL database** with a 3-level structure:  
- **Country** (Eurostat, WorldData)  
- **City** (Wikipedia, Numbeo, Airbnb link)  
- **Airbnb listings**  

This schema ensured **referential integrity** and enabled queries across all datasets.  
Staging tables were used to load raw CSVs safely before transforming them into the final schema.

---

## ☁️ BigQuery
Airbnb dataset was **denormalized and optimized** in Google BigQuery:  
- Partitioned by price ranges  
- Clustered by city  
- Derived variable `price_range` for analysis  

This setup enabled **scalable queries** and direct connection to Python notebooks for exporting clean datasets into Tableau.

---

## 📊 Exploratory Data Analysis
Key findings on Airbnb prices:
- **Main drivers**: city, room type, availability  
  - Paris is the most expensive (avg 285€), Madrid the cheapest (145€)  
  - Entire homes/hotel rooms are 2–3x more expensive than private/shared rooms  
  - Year-round listings are more expensive → often professional hosts  
- **Minor factors**: reviews and capacity have almost no effect  

---

## 🌐 Flask API
I built a **Flask API** (with Swagger docs) to expose MySQL data:  
- `/airbnb` (list or single listing)  
- `/eurostat` (filter by country/year)  

This API makes the project **scalable and reusable** for dashboards, ML models, or external apps.  

---

## 🤖 Machine Learning
- **Clustering** (Paris): K-means revealed 5 clusters of listings, with avg prices ranging from ~200€ to ~370€.  
- **Supervised models**: Linear Regression, Random Forest, XGBoost → best was **XGBoost (R² = 0.14)**. Limited predictive power, but confirmed that **availability** and **reviews** are key features.  
- **Classification** (cheap / mid-range / luxury): Random Forest reached ~56% accuracy.  

---

## ✅ Conclusion
- **Tourism demand and supply are aligned**: France, Italy, Spain, Germany concentrate both the bulk of tourism flows (Eurostat) and Airbnb supply.  
- **Airbnb price drivers**: city, room type, and availability (not reviews or capacity).  
- **Policy & business insights**:  
  - Hosts can adapt strategies (budget vs premium travelers)  
  - Cities can regulate professional year-round listings  
  - Tourism boards can highlight affordability of Madrid/Rome compared to Paris

---

## 📂 Deliverables
- MySQL database (ERD, scripts, queries)  
- Python notebooks (scraping, cleaning, EDA, ML)  
- BigQuery optimized dataset  
- Flask API (with Swagger docs)  
- Tableau dashboards  
- Final report & presentation  

---