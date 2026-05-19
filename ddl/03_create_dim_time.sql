-- Dimension Table: Time
DROP TABLE IF EXISTS dim_time CASCADE;

CREATE TABLE dim_time (
    time_id SERIAL PRIMARY KEY,
    fiscal_year VARCHAR(20) NOT NULL UNIQUE,
    start_date DATE,
    end_date DATE
);

INSERT INTO dim_time (fiscal_year, start_date, end_date) VALUES
    ('2018-2019', '2018-04-01', '2019-03-31'),
    ('2019-2020', '2019-04-01', '2020-03-31');