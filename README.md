# 🏨 Tourism in Europe’s Capitals  
**Beds & Budgets: Mapping Airbnb Supply and Urban Travel Demand**

---

## 📌 Introduction  

This project combines **tourism demand** (Eurostat, WorldData, Wikipedia, Numbeo) and **tourism supply** (Airbnb) to analyze patterns in European travel and short-term rental markets.  

The focus is on four countries — **France, Germany, Italy, Spain** — as they were the **top destinations in 2023 (Eurostat)**, and specifically their capitals: **Paris, Berlin, Rome, Madrid**.  

### Objectives
- Identify the main drivers of Airbnb prices  
- Compare travel behaviors across Europe  
- Use Machine Learning to **predict Airbnb prices** and **classify luxury listings**  
- Apply clustering to detect **geographic price zones in Paris**  
- Generate actionable insights for **hosts, cities, and tourism boards**  

---

## 🛠️ Tools & Technologies  

### 🔹 Data Engineering  
- **MySQL** → database creation (ERD, staging/final tables, SQL scripts)  
- **Google BigQuery** → partitioning & clustering Airbnb data for scalability  
- **Python** → scraping, preprocessing, ML, clustering, API integration  

### 🔹 Data Visualization  
- **Tableau** → interactive dashboards ([link here](#))  
- **Matplotlib & Seaborn** → charts for EDA and ML evaluation  
- **Folium** → interactive maps of Airbnb clusters in Paris  

### 🔹 Project Management  
- **Trello** → task tracking & workflow management  
- **GitHub** → version control & collaboration  

---

## 📂 Data Sources  
- **Eurostat API** → trips by purpose, transport, destination  
- **Inside Airbnb (CSV)** → listings, availability, prices, reviews  
- **Numbeo (scraping)** → cost of living indicators  
- **WorldData & Wikipedia (scraping)** → tourist arrivals, city descriptions  

---

## 📊 Exploratory Data Analysis (EDA)  

### Key insights on Airbnb prices:
- **City effect**: Paris is the most expensive (~285€), Madrid the cheapest (~145€)  
- **Room type**: Entire homes/hotel rooms cost **2–3x more** than private/shared rooms  
- **Availability**: Year-round listings are significantly more expensive → often professional hosts  
- **Reviews & capacity**: Minimal impact on price  

📌 **Statistical tests (ANOVA)** confirmed the significance of **city, room type, and availability** on prices.  

---

## 🤖 Machine Learning  

### 1️⃣ Classification → Luxury vs Non-Luxury listings  
- **Target**: Luxury = `price_per_person > 150€`  
- **Challenge**: imbalanced data (7% luxury) → solved with **SMOTE oversampling**  
- **Models tested**: Logistic Regression, Random Forest, Gradient Boosting, XGBoost  
- **Best performer**: **XGBoost** with balanced recall & precision  
- **Metrics**: Accuracy, Precision, Recall, F1, ROC-AUC  

---

### 2️⃣ Regression → Price Prediction per Person  
- **Features**: accommodates, bedrooms, beds, availability, reviews, room type, neighborhood, latitude/longitude, distance to city center  
- **Preprocessing**: OneHotEncoding for categorical vars + scaling/imputation for numeric  
- **Models tested**: Linear Regression, Random Forest, Gradient Boosting, XGBoost  
- **Best model**: **XGBoost**  
  - RMSE ≈ 44  
  - R² = 0.34  
- **Key feature**: distance to city center improved results significantly  

---

### 3️⃣ Clustering → Paris Airbnb Price Zones  
- **Method**: K-Means on latitude & longitude  
- **Optimal clusters**: `k=5` (chosen with silhouette score)  
- **Insights**:  
  - Central clusters → higher prices (~370€)  
  - Peripheral clusters → more affordable (~200€)  
- **Visualization**: Folium map → clear segmentation of Paris by price  

---

## ✅ Main Results & Insights  

### Airbnb price drivers  
- **Strongest**: city, room type, availability, distance to city center  
- **Weak**: reviews, number of beds  

### Machine Learning performance  
- **Classification**: XGBoost best for predicting luxury listings  
- **Regression**: XGBoost best for predicting price/person (improved with distance to center)  
- **Clustering**: 5 clear price zones in Paris  

### Business & policy insights  
- **Hosts** → adjust pricing based on location & room type  
- **Cities** → regulate professional year-round hosts  
- **Tourism boards** → highlight affordability in Rome & Madrid vs Paris  

---

## 📦 Deliverables  
- **MySQL database** (ERD, SQL scripts, staging/final tables)  
- **Python notebooks** (scraping, cleaning, EDA, ML, clustering, visualization)  
- **BigQuery dataset** (partitioned & clustered)  
- **Flask API** (with Swagger docs)  
- **Tableau dashboard** → https://public.tableau.com/app/profile/ma.lys.jaffret/viz/tourism-in-europe1/Tableaudebord1
- **Final Report & Presentation** 

---