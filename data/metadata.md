project: Tourism Data Analysis
author: Mailys
created: 2025-09-23
version: 1.0
description: >
  This project gathers multiple data sources related to international tourism
  (trips, accommodation, transport, cities, prices, and Airbnb) to analyze
  travel behaviors and build visualizations.

datasets:

  - name: Eurostat_trips
    description: Eurostat dataset on international trips
    columns:
      - name: Country
        type: object
        description: Country of origin of the travelers
      - name: Time
        type: int64
        description: Reference year of the observation
      - name: Accommodation
        type: object
        description: Categorical value related to type of accommodation
      - name: Purpose
        type: object
        description: Main purpose of the trip
      - name: Duration
        type: object
        description: Length of stay category
      - name: Transport
        type: object
        description: Main mode of transport used
      - name: Destination
        type: object
        description: Country of destination
      - name: Value_accomodation
        type: float64
        description: Number of trips broken down by accommodation type
      - name: Value_transport
        type: float64
        description: Number of trips broken down by transport mode
      - name: Value_destination
        type: float64
        description: Number of trips broken down by destination country

  - name: City_dataset
    description: Descriptive information about touristic cities
    columns:
      - name: Name of the city
        type: object
        description: Name of the city
      - name: Country where the city is located
        type: int64
        description: Country code or identifier where the city is located
      - name: Number of international visitors in 2018
        type: float64
        description: Number of international visitors in 2018
      - name: Short text description of the city
        type: object
        description: Short description of the city
      - name: Date when the data was extracted
        type: datetime64
        description: Date when the data was extracted
      - name: URL of the wikipedia page used
        type: object
        description: Source Wikipedia link

  - name: World_data
    description: Global dataset on international tourist arrivals
    columns:
      - name: Country
        type: object
        description: Name of the country
      - name: Year
        type: int64
        description: Reference year of the observation
      - name: Arrivals (millions)
        type: float64
        description: Number of international tourist arrivals, in millions

  - name: Numbeo
    description: Consumer price dataset by city (Numbeo)
    columns:
      - name: City
        type: object
        description: Name of the city where the item price was collected
      - name: Item_label
        type: object
        description: Name of the good or service
      - name: Price_eur
        type: float64
        description: Price of the item in euros

  - name: Airbnb
    description: Airbnb dataset on listings and reviews
    columns:
      - name: listing_name
        type: object
        description: Name of the listing
      - name: neighbourhood_cleansed
        type: object
        description: Standardized neighborhood name
      - name: latitude
        type: float64
        description: Latitude coordinate
      - name: longitude
        type: float64
        description: Longitude coordinate
      - name: room_type
        type: object
        description: Type of room (entire, private, shared…)
      - name: accommodates
        type: object
        description: Maximum number of guests the listing can host
      - name: bedrooms
        type: float64
        description: Number of bedrooms
      - name: beds
        type: float64
        description: Number of beds
      - name: bathrooms
        type: float64
        description: Number of bathrooms
      - name: bathrooms_text
        type: object
        description: Text description of bathrooms
      - name: price
        type: int64
        description: Price per night
      - name: minimum_nights
        type: int64
        description: Minimum nights allowed per booking
      - name: maximum_nights
        type: int64
        description: Maximum nights allowed per booking
      - name: availability_365
        type: int64
        description: Number of days available for booking within a year
      - name: number_of_reviews
        type: int64
        description: Total number of reviews received
      - name: review_scores_rating
        type: float64
        description: Average review rating (0-5)
      - name: city
        type: object
        description: City where the listing is located