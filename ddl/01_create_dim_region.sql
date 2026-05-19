-- Dimension Table: Region
-- Source: Manitoba Health Annual Statistics Report 2018-2020
-- Contains 5 health regions + Manitoba reference

DROP TABLE IF EXISTS dim_region CASCADE;

CREATE TABLE dim_region (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL UNIQUE,
    rha_code VARCHAR(2),
    population_75_plus INTEGER,
    total_population INTEGER,
    is_significant_wait_time BOOLEAN,
    wait_time_benchmark VARCHAR(10)
);

-- Insert data from Figure 89, 91, and population table
INSERT INTO dim_region (region_name, rha_code, population_75_plus, total_population, is_significant_wait_time, wait_time_benchmark) VALUES
    ('Winnipeg', '01', 65737, 858873, TRUE, 'lower'),
    ('Prairie Mountain', '02', 16303, 178759, FALSE, 'similar'),
    ('Interlake-Eastern', '03', 11656, 138865, TRUE, 'higher'),
    ('Northern', '04', 2294, 77189, TRUE, 'higher'),
    ('Southern', '05', 14191, 232303, TRUE, 'higher');

-- Insert Manitoba summary (for benchmarking)
INSERT INTO dim_region (region_name, rha_code, population_75_plus, total_population, is_significant_wait_time, wait_time_benchmark) VALUES
    ('Manitoba', '00', 110181, 1485989, NULL, 'reference');