-- Fact Table: PCH Admissions
DROP TABLE IF EXISTS fact_pch_admissions CASCADE;

CREATE TABLE fact_pch_admissions (
    admission_id SERIAL PRIMARY KEY,
    region_id INTEGER REFERENCES dim_region(region_id),
    care_level_id INTEGER REFERENCES dim_care_level(care_level_id),
    time_id INTEGER REFERENCES dim_time(time_id),
    admission_source VARCHAR(20),
    total_admissions INTEGER,
    percentage_of_region DECIMAL(5,2)
);