CREATE DATABASE shuttle_dw;
USE shuttle_dw;

-- Dimensions
CREATE TABLE IF NOT EXISTS dim_driver (
    driver_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    cdl_flag CHAR(1),
    hire_month TINYINT,
    hire_year SMALLINT
);

CREATE TABLE IF NOT EXISTS dim_route (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(50),
    primary_stops VARCHAR(100),
    route_duration_min INT
);

CREATE TABLE IF NOT EXISTS dim_vehicle (
    vehicle_id INT PRIMARY KEY,
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(20),
    electric_flag CHAR(1),
    capacity INT
);

-- Vehicle status staging (loaded from JSON / MongoDB)
CREATE TABLE IF NOT EXISTS vehicle_status_stg (
    vehicle_number VARCHAR(20),
    status_timestamp DATETIME,
    battery_level INT,
    current_location VARCHAR(100),
    in_service TINYINT
);

-- Fact table
CREATE TABLE IF NOT EXISTS fact_passenger_counts (
    trip_id INT PRIMARY KEY,
    date_key INT,
    route_id INT,
    driver_id INT,
    vehicle_id INT,
    passengers INT,
    trip_duration_min INT,
    route_distance_miles DECIMAL(6,2)
);
