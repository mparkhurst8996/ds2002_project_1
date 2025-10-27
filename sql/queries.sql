-- Total Passengers per Driver per Route
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
    r.route_name,
    SUM(f.passengers) AS total_passengers
FROM fact_passenger_counts f
JOIN dim_driver d ON f.driver_id = d.driver_id
JOIN dim_route r ON f.route_id = r.route_id
GROUP BY driver_name, r.route_name
ORDER BY total_passengers DESC;

-- Electric vs Non-Electric Vehicle Trips and Passengers by Route
SELECT 
    v.electric_flag AS is_electric,
    r.route_name,
    COUNT(f.trip_id) AS total_trips,
    SUM(f.passengers) AS total_passengers
FROM fact_passenger_counts f
JOIN dim_vehicle v ON f.vehicle_id = v.vehicle_id
JOIN dim_route r ON f.route_id = r.route_id
GROUP BY v.electric_flag, r.route_name
ORDER BY is_electric, total_passengers DESC;

#passengers by day of week per route
SELECT 
    r.route_name,
    d.day_name_of_week,
    SUM(f.passengers) AS total_passengers
FROM fact_passenger_counts f
JOIN dim_route r ON f.route_id = r.route_id
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY r.route_name, d.day_name_of_week
ORDER BY r.route_name,
         FIELD(d.day_name_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');        
         
         SELECT
    c.customer_id,
    c.first_name AS customer_first,
    c.last_name AS customer_last,
    d.driver_id,
    d.first_name AS driver_first,
    d.last_name AS driver_last,
    f.trip_id,
    f.route_id,
    f.passengers,
    f.trip_duration_min,
    f.route_distance_miles,
    c.ride_date,
    c.route_ridden,
    w.temperature,
    w.weather_condition
FROM fact_passenger_counts f
JOIN dim_customers c
    ON f.date_key = DATE_FORMAT(c.ride_date, '%Y%m%d')  -- adjust if date_key format differs
JOIN dim_driver d
    ON f.driver_id = d.driver_id
LEFT JOIN weather w
    ON c.ride_date = w.weather_date
ORDER BY c.ride_date DESC
LIMIT 100;
