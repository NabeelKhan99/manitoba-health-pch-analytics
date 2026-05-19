-- Aggregate Table: Wait Times by Region
DROP TABLE IF EXISTS agg_wait_times CASCADE;

CREATE TABLE agg_wait_times (
    wait_time_id SERIAL PRIMARY KEY,
    region_id INTEGER REFERENCES dim_region(region_id),
    median_wait_weeks DECIMAL(5,1),
    is_significant BOOLEAN,
    manitoba_benchmark DECIMAL(5,1)
);

INSERT INTO agg_wait_times (region_id, median_wait_weeks, is_significant, manitoba_benchmark)
SELECT 
    region_id,
    CASE region_name
        WHEN 'Winnipeg' THEN 0.9
        WHEN 'Prairie Mountain' THEN 5.4
        WHEN 'Interlake-Eastern' THEN 22.0
        WHEN 'Northern' THEN 14.1
        WHEN 'Southern' THEN 26.6
    END,
    CASE region_name
        WHEN 'Prairie Mountain' THEN FALSE
        ELSE TRUE
    END,
    4.0
FROM dim_region
WHERE region_name != 'Manitoba';