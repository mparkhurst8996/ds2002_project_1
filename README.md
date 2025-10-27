# DS-2002 – Data Project 1: Shuttle Data Warehouse

## Overview

This project demonstrates an end-to-end **ETL pipeline** and a **dimensional data mart** for a shuttle transportation business. The goal is to show competence in creating and implementing data systems, including:

- Relational and NoSQL databases
- ETL pipelines
- Data transformations
- APIs and cloud services
- SQL analytics

The shuttle data warehouse (`shuttle_dw`) allows analysis of trips, passengers, vehicles, drivers, and external factors such as weather.

---

## Database Schema (`shuttle_dw`)

### Dimension Tables

1. **dim_date**  
   - Fully populated date dimension with calendar and fiscal info  
   - Used for time-based analysis

2. **dim_driver**  
   - Driver info: `first_name`, `last_name`, `cdl_flag`, `hire_month`, `hire_year`

3. **dim_vehicle**  
   - Vehicle info: `vehicle_number`, `vehicle_type`, `electric_flag`, `capacity`

4. **dim_route**  
   - Route info: `route_name`, `primary_stops`, `route_duration_min`

5. **dim_customers**  
   - Customer info, ride history generated from Northwind customers

### Fact Table

- **fact_passenger_counts**
  - Trip-based metrics: `passengers`, `trip_duration_min`, `route_distance_miles`
  - Links `dim_driver`, `dim_vehicle`, `dim_route`, `dim_date`, and optionally `dim_customers`

### Staging Table

- **vehicle_status_stg**  
  - Loaded from MongoDB JSON
  - Includes `vehicle_number`, `status_timestamp`, `battery_level`, `current_location`, `in_service`

### Weather Table

- **weather**  
  - Populated via OpenWeatherMap API
  - Includes `city`, `temperature` (°F), `weather_condition`, `weather_date`, `timestamp`

---

## ETL Pipeline

The ETL process integrates **structured, semi-structured, and API data** into the `shuttle_dw` warehouse.

### 1. Structured CSV Data → MySQL
Notebook: `etl_pipeline.ipynb`

- Loads `drivers.csv`, `routes.csv`, `vehicles.csv`, and `trips.csv` into corresponding MySQL tables.
- Uses SQLAlchemy and Pandas.
- Verifies row counts and previews table content.

### 2. Customers from Northwind → dim_customers
Notebook: `customers_northwind_relational.ipynb`

- Connects to Northwind MySQL database to fetch `customers`.
- Generates 2–5 rides per customer, assigning random shuttle routes.
- Loads into `dim_customers` table in `shuttle_dw`.

### 3. Vehicle Status JSON → MongoDB → MySQL
Notebook: `vehicle_status_mongo.ipynb`

- Loads `vehicle_status.json` into MongoDB (`shuttle_ops.vehicle_status` collection).
- Extracts data into Pandas DataFrame.
- Loads into MySQL staging table `vehicle_status_stg`.

### 4. Weather API → MySQL
Notebook: `weather_api.ipynb`

- Fetches historical daily weather for Charlottesville via OpenWeatherMap API for October 2025.
- Aggregates hourly temperature and conditions to daily averages.
- Loads into `weather` table in MySQL.
- Converts temperatures from Kelvin → Fahrenheit.
- Can join with trips to analyze weather impact on passengers.

---

## Implementation Steps (All SQL and Notebooks)

Follow these steps to fully implement the project:

### Step 1: Create Database and Tables
1. Run `sql/schema.sql` to create `shuttle_dw` and core fact/dimension tables (`dim_driver`, `dim_vehicle`, `dim_route`, `fact_passenger_counts`, `vehicle_status_stg`).

### Step 2: Create and Populate Date Dimension
1. Run `sql/dim_date.sql` to create `dim_date`.
2. Execute the stored procedure in MySQL to populate the date dimension:
   ```sql
   CALL PopulateDateDimension('2025-10-01', '2025-10-31');
   
### Step 3: Load Shuttle Data from CSV
1. Ensure the following CSV files are in the jupyter notebook and callable:
   - `drivers.csv`
   - `routes.csv`
   - `vehicles.csv`
   - `trips.csv`
2. Open and run the notebook `python/etl_pipeline.ipynb` to:
   - Load CSV data into corresponding MySQL tables:
     - `dim_driver`
     - `dim_route`
     - `dim_vehicle`
     - `fact_passenger_counts`
   - Verify row counts and preview table contents.

---

### Step 4: Load Customers from Northwind
1. Make sure the Northwind database is running locally.
2. Open and run the notebook `python/customers_northwind_relational.ipynb` to:
   - Fetch all customers from Northwind.
   - Generate 2–5 random rides per customer with shuttle routes.
   - Load this data into the `dim_customers` table in `shuttle_dw`.
   - Preview the resulting table to confirm data.

---

### Step 5: Load Vehicle Status via MongoDB
1. Ensure MongoDB (Atlas or local) is running.
2. Open and run the notebook `python/vehicle_status_mongo.ipynb` to:
   - Load `vehicle_status.json` into MongoDB (`shuttle_ops.vehicle_status` collection).
   - Extract data back into a Pandas DataFrame.
   - Load data into MySQL staging table `vehicle_status_stg`.
   - Preview the data in MySQL to verify successful loading.

---

### Step 6: Load Historical Weather Data via API
1. Replace `API_KEY` in `python/weather_api.ipynb` with a valid OpenWeatherMap key.
2. Run the notebook to:
   - Fetch historical weather data for Charlottesville for October 2025.
   - Aggregate hourly temperature and conditions to daily averages.
   - Load data into the `weather` table in MySQL.
   - Convert temperatures from Kelvin to Fahrenheit.
   - Preview the data to confirm successful insertion.

---

### Step 7: Verify and Query Data
1. Run `sql/queries.sql` or custom SQL queries to validate and analyze data:
   - Total passengers per driver per route.
   - Electric vs non-electric vehicle trips and passengers.
   - Passengers by day of week per route.
   - Join `fact_passenger_counts` with `dim_customers` and `weather` for combined insights.
2. Use MySQL Workbench or a Python notebook to execute these queries and review results.
