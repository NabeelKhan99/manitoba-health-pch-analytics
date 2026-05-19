-- Dimension Table: Care Level (Acuity)
DROP TABLE IF EXISTS dim_care_level CASCADE;

CREATE TABLE dim_care_level (
    care_level_id SERIAL PRIMARY KEY,
    level_code VARCHAR(10) NOT NULL UNIQUE,
    level_description VARCHAR(50),
    requires_supervision BOOLEAN,
    acuity_score INTEGER
);

INSERT INTO dim_care_level (level_code, level_description, requires_supervision, acuity_score) VALUES
    ('Level 2N', 'Low need, no supervision', FALSE, 2),
    ('Level 2Y', 'Low need, requires supervision', TRUE, 3),
    ('Level 3N', 'Moderate need, no supervision', FALSE, 4),
    ('Level 3Y', 'Moderate need, requires supervision', TRUE, 5),
    ('Level 4', 'High need', FALSE, 6);