/* === LOGISTICS OPERATIONS DATABASE - FULL DDL, INDEXES, AND ANALYTICAL QUERIES === */

/* === TABLE DDL === */
 CREATE   TABLE  customers (
    customer_id  TEXT   PRIMARY KEY ,
    customer_name  TEXT ,
    customer_type  TEXT ,
    credit_terms_days  INTEGER ,
    primary_freight_type  TEXT ,
    account_status  TEXT ,
    contract_start_date  TEXT ,
    annual_revenue_potential  REAL 
);

 CREATE   TABLE  drivers (
    driver_id  TEXT   PRIMARY KEY ,
    first_name  TEXT ,
    last_name  TEXT ,
    hire_date  TEXT ,
    termination_date  TEXT ,
    license_number  TEXT ,
    license_state  TEXT ,
    date_of_birth  TEXT ,
    home_terminal  TEXT ,
    employment_status  TEXT ,
    cdl_class  TEXT ,
    years_experience  INTEGER 
);

 CREATE   TABLE  trucks (
    truck_id  TEXT   PRIMARY KEY ,
    unit_number  INTEGER ,
    make  TEXT ,
    model_year  INTEGER ,
    vin  TEXT ,
    acquisition_date  TEXT ,
    acquisition_mileage  INTEGER ,
    fuel_type  TEXT ,
    tank_capacity_gallons  INTEGER ,
    status  TEXT ,
    home_terminal  TEXT 
);

 CREATE   TABLE  trailers (
    trailer_id  TEXT   PRIMARY KEY ,
    trailer_number  INTEGER ,
    trailer_type  TEXT ,
    length_feet  INTEGER ,
    model_year  INTEGER ,
    vin  TEXT ,
    acquisition_date  TEXT ,
    status  TEXT ,
    current_location  TEXT 
);

 CREATE   TABLE  facilities (
    facility_id  TEXT   PRIMARY KEY ,
    facility_name  TEXT ,
    facility_type  TEXT ,
    city  TEXT ,
    state  TEXT ,
    latitude  REAL ,
    longitude  REAL ,
    dock_doors  INTEGER ,
    operating_hours  TEXT 
);

 CREATE   TABLE  routes (
    route_id  TEXT   PRIMARY KEY ,
    origin_city  TEXT ,
    origin_state  TEXT ,
    destination_city  TEXT ,
    destination_state  TEXT ,
    typical_distance_miles  INTEGER ,
    base_rate_per_mile  REAL ,
    fuel_surcharge_rate  REAL ,
    typical_transit_days  INTEGER 
);

 CREATE   TABLE  loads (
    load_id  TEXT   PRIMARY KEY ,
    customer_id  TEXT ,
    route_id  TEXT ,
    load_date  TEXT ,
    load_type  TEXT ,
    weight_lbs  INTEGER ,
    pieces  INTEGER ,
    revenue  REAL ,
    fuel_surcharge  REAL ,
    accessorial_charges  REAL ,
    load_status  TEXT ,
    booking_type  TEXT ,
     FOREIGN KEY  (customer_id)  REFERENCES  customers(customer_id),
     FOREIGN KEY  (route_id)  REFERENCES  routes(route_id)
);

 CREATE   TABLE  trips (
    trip_id  TEXT   PRIMARY KEY ,
    load_id  TEXT ,
    driver_id  TEXT ,
    truck_id  TEXT ,
    trailer_id  TEXT ,
    dispatch_date  TEXT ,
    actual_distance_miles  INTEGER ,
    actual_duration_hours  REAL ,
    fuel_gallons_used  REAL ,
    average_mpg  REAL ,
    idle_time_hours  REAL ,
    trip_status  TEXT ,
     FOREIGN KEY  (load_id)  REFERENCES  loads(load_id),
     FOREIGN KEY  (driver_id)  REFERENCES  drivers(driver_id),
     FOREIGN KEY  (truck_id)  REFERENCES  trucks(truck_id),
     FOREIGN KEY  (trailer_id)  REFERENCES  trailers(trailer_id)
);

 CREATE   TABLE  fuel_purchases (
    fuel_purchase_id  TEXT   PRIMARY KEY ,
    trip_id  TEXT ,
    truck_id  TEXT ,
    driver_id  TEXT ,
    purchase_date  TEXT ,
    location_city  TEXT ,
    location_state  TEXT ,
    gallons  REAL ,
    price_per_gallon  REAL ,
    total_cost  REAL ,
    fuel_card_number  TEXT ,
     FOREIGN KEY  (trip_id)  REFERENCES  trips(trip_id),
     FOREIGN KEY  (truck_id)  REFERENCES  trucks(truck_id),
     FOREIGN KEY  (driver_id)  REFERENCES  drivers(driver_id)
);

 CREATE   TABLE  maintenance_records (
    maintenance_id  TEXT   PRIMARY KEY ,
    truck_id  TEXT ,
    maintenance_date  TEXT ,
    maintenance_type  TEXT ,
    odometer_reading  INTEGER ,
    labor_hours  REAL ,
    labor_cost  REAL ,
    parts_cost  REAL ,
    total_cost  REAL ,
    facility_location  TEXT ,
    downtime_hours  REAL ,
    service_description  TEXT ,
     FOREIGN KEY  (truck_id)  REFERENCES  trucks(truck_id)
);

 CREATE   TABLE  delivery_events (
    event_id  TEXT   PRIMARY KEY ,
    load_id  TEXT ,
    trip_id  TEXT ,
    event_type  TEXT ,
    facility_id  TEXT ,
    scheduled_datetime  TEXT ,
    actual_datetime  TEXT ,
    detention_minutes  INTEGER ,
    on_time_flag  INTEGER ,
    location_city  TEXT ,
    location_state  TEXT ,
     FOREIGN KEY  (load_id)  REFERENCES  loads(load_id),
     FOREIGN KEY  (trip_id)  REFERENCES  trips(trip_id),
     FOREIGN KEY  (facility_id)  REFERENCES  facilities(facility_id)
);

 CREATE   TABLE  safety_incidents (
    incident_id  TEXT   PRIMARY KEY ,
    trip_id  TEXT ,
    truck_id  TEXT ,
    driver_id  TEXT ,
    incident_date  TEXT ,
    incident_type  TEXT ,
    location_city  TEXT ,
    location_state  TEXT ,
    at_fault_flag  INTEGER ,
    injury_flag  INTEGER ,
    vehicle_damage_cost  REAL ,
    cargo_damage_cost  REAL ,
    claim_amount  REAL ,
    preventable_flag  INTEGER ,
    description  TEXT ,
     FOREIGN KEY  (trip_id)  REFERENCES  trips(trip_id),
     FOREIGN KEY  (truck_id)  REFERENCES  trucks(truck_id),
     FOREIGN KEY  (driver_id)  REFERENCES  drivers(driver_id)
);

 CREATE   TABLE  driver_monthly_metrics (
    driver_id  TEXT ,
    month  TEXT ,
    trips_completed  INTEGER ,
    total_miles  INTEGER ,
    total_revenue  REAL ,
    average_mpg  REAL ,
    total_fuel_gallons  REAL ,
    on_time_delivery_rate  REAL ,
    average_idle_hours  REAL ,
     PRIMARY KEY  (driver_id, month)
);

 CREATE   TABLE  truck_utilization_metrics (
    truck_id  TEXT ,
    month  TEXT ,
    trips_completed  INTEGER ,
    total_miles  INTEGER ,
    total_revenue  REAL ,
    average_mpg  REAL ,
    maintenance_events  INTEGER ,
    maintenance_cost  REAL ,
    downtime_hours  REAL ,
    utilization_rate  REAL ,
     PRIMARY KEY  (truck_id, month)
);

/* === INDEXING STRATEGY === */
/* === FK JOIN SUPPORT === */
 CREATE INDEX  idx_loads_customer_id  ON  loads(customer_id);
 CREATE INDEX  idx_loads_route_id  ON  loads(route_id);
 CREATE INDEX  idx_trips_load_id  ON  trips(load_id);
 CREATE INDEX  idx_trips_driver_id  ON  trips(driver_id);
 CREATE INDEX  idx_trips_truck_id  ON  trips(truck_id);
 CREATE INDEX  idx_trips_trailer_id  ON  trips(trailer_id);
 CREATE INDEX  idx_fuel_purchases_trip_id  ON  fuel_purchases(trip_id);
 CREATE INDEX  idx_fuel_purchases_truck_id  ON  fuel_purchases(truck_id);
 CREATE INDEX  idx_fuel_purchases_driver_id  ON  fuel_purchases(driver_id);
 CREATE INDEX  idx_maintenance_records_truck_id  ON  maintenance_records(truck_id);
 CREATE INDEX  idx_delivery_events_load_id  ON  delivery_events(load_id);
 CREATE INDEX  idx_delivery_events_trip_id  ON  delivery_events(trip_id);
 CREATE INDEX  idx_delivery_events_facility_id  ON  delivery_events(facility_id);
 CREATE INDEX  idx_safety_incidents_trip_id  ON  safety_incidents(trip_id);
 CREATE INDEX  idx_safety_incidents_truck_id  ON  safety_incidents(truck_id);
 CREATE INDEX  idx_safety_incidents_driver_id  ON  safety_incidents(driver_id);

/* === TIME-SERIES AND ANALYTICAL ACCESS PATHS === */
 CREATE INDEX  idx_fuel_purchases_purchase_date  ON  fuel_purchases(purchase_date);
 CREATE INDEX  idx_delivery_events_scheduled_datetime  ON  delivery_events(scheduled_datetime);
 CREATE INDEX  idx_delivery_events_actual_datetime  ON  delivery_events(actual_datetime);
 CREATE INDEX  idx_safety_incidents_incident_date  ON  safety_incidents(incident_date);

/* === COMPOSITE INDEXES FOR HIGH-VALUE JOIN + FILTER PATTERNS === */
 CREATE INDEX  idx_safety_incidents_driver_incident_date  ON  safety_incidents(driver_id, incident_date);
 CREATE INDEX  idx_delivery_events_trip_event_time  ON  delivery_events(trip_id, scheduled_datetime);
 CREATE INDEX  idx_fuel_purchases_driver_purchase_date  ON  fuel_purchases(driver_id, purchase_date);
 CREATE INDEX  idx_fuel_purchases_truck_purchase_date  ON  fuel_purchases(truck_id, purchase_date);

/* === QUERY 1 - DRIVER RELIABILITY & RISK === */
WITH incident_counts AS (
     SELECT 
        d.driver_id,
        d.first_name,
        d.last_name,
         COUNT (si.incident_id) AS total_incidents
     FROM  drivers d
     LEFT JOIN  safety_incidents si
         ON  d.driver_id = si.driver_id
     GROUP BY  d.driver_id, d.first_name, d.last_name
), ranked_drivers AS (
     SELECT 
        driver_id,
        first_name,
        last_name,
        total_incidents,
         DENSE_RANK ()  OVER  ( ORDER BY  total_incidents  ASC , driver_id  ASC ) AS reliability_rank_low,
         DENSE_RANK ()  OVER  ( ORDER BY  total_incidents  DESC , driver_id  ASC ) AS risk_rank_high
     FROM  incident_counts
)
 SELECT 
    'Top 3 Most Reliable' AS cohort,
    driver_id,
    first_name,
    last_name,
    total_incidents,
    reliability_rank_low AS rank_position
 FROM  ranked_drivers
 WHERE  reliability_rank_low <= 3
 UNION ALL 
 SELECT 
    'Bottom 3 Least Reliable' AS cohort,
    driver_id,
    first_name,
    last_name,
    total_incidents,
    risk_rank_high AS rank_position
 FROM  ranked_drivers
 WHERE  risk_rank_high <= 3
 ORDER BY  cohort, rank_position, driver_id;

/* === QUERY 2 - OPERATIONAL COST VOLATILITY === */
WITH fuel_daily AS (
     SELECT 
         DATE (purchase_date) AS fuel_date,
         SUM (total_cost) AS daily_fuel_cost
     FROM  fuel_purchases
     GROUP BY   DATE (purchase_date)
), rolling_costs AS (
     SELECT 
        fuel_date,
        daily_fuel_cost,
         AVG (daily_fuel_cost)  OVER  (
             ORDER BY  julianday(fuel_date)
             RANGE BETWEEN  29  PRECEDING AND  CURRENT ROW
        ) AS rolling_30_day_avg_cost
     FROM  fuel_daily
)
 SELECT 
    fuel_date,
    daily_fuel_cost,
    rolling_30_day_avg_cost,
    daily_fuel_cost - rolling_30_day_avg_cost AS cost_spike_vs_rolling_avg
 FROM  rolling_costs
 ORDER BY  fuel_date;

/* === QUERY 3 - ACTIVE SLA BREACH DETECTION === */
WITH delivery_timeline AS (
     SELECT 
        de.event_id,
        de.load_id,
        de.trip_id,
        de.event_type,
        de.facility_id,
        de.scheduled_datetime,
        de.actual_datetime,
        de.location_city,
        de.location_state,
        de.on_time_flag,
         CAST ((julianday(de.actual_datetime) - julianday(de.scheduled_datetime)) * 24 * 60 AS  INTEGER ) AS delay_minutes,
        t.driver_id,
        t.truck_id
     FROM  delivery_events de
     JOIN  trips t
         ON  de.trip_id = t.trip_id
     WHERE  de.scheduled_datetime IS NOT NULL
       AND  de.actual_datetime IS NOT NULL
       AND  (
          de.on_time_flag = 0
           OR  (julianday(de.actual_datetime) - julianday(de.scheduled_datetime)) * 24 * 60 > 0
      )
)
 SELECT 
    dt.trip_id,
    dt.load_id,
    dt.event_type,
    dt.facility_id,
    f.facility_name,
    f.city AS facility_city,
    f.state AS facility_state,
    dt.location_city,
    dt.location_state,
    dt.delay_minutes,
    dt.driver_id,
    dt.truck_id
 FROM  delivery_timeline dt
 LEFT JOIN  facilities f
     ON  dt.facility_id = f.facility_id
 ORDER BY  dt.delay_minutes  DESC , dt.trip_id, dt.event_type;
