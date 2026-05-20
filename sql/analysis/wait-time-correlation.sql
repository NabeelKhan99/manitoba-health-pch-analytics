-- Wait Time Correlation: Analyze relationship between wait times and care level acuity
-- Source: Manitoba Health Annual Statistics 2018-2020, Figures 90 and 91
-- Purpose: Determine if regions with longer wait times admit higher-acuity patients

WITH weighted_acuity AS (
    SELECT 
        r.region_name,
        a.median_wait_weeks,
        SUM(
            CASE 
                WHEN c.level_code = 'Level 2N' THEN 2 * (f.percentage_of_region / 100)
                WHEN c.level_code = 'Level 2Y' THEN 3 * (f.percentage_of_region / 100)
                WHEN c.level_code = 'Level 3N' THEN 4 * (f.percentage_of_region / 100)
                WHEN c.level_code = 'Level 3Y' THEN 5 * (f.percentage_of_region / 100)
                WHEN c.level_code = 'Level 4' THEN 6 * (f.percentage_of_region / 100)
                ELSE 0
            END
        ) AS weighted_acuity_score
    FROM dim_region r
    JOIN agg_wait_times a ON r.region_id = a.region_id
    JOIN fact_pch_admissions f ON r.region_id = f.region_id
    JOIN dim_care_level c ON f.care_level_id = c.care_level_id
    WHERE r.region_name != 'Manitoba'
    GROUP BY r.region_name, a.median_wait_weeks
)
SELECT 
    region_name,
    median_wait_weeks,
    ROUND(weighted_acuity_score, 2) AS weighted_acuity_score,
    CASE 
        WHEN median_wait_weeks < 5 THEN 'Low wait time'
        WHEN median_wait_weeks BETWEEN 5 AND 15 THEN 'Medium wait time'
        ELSE 'High wait time'
    END AS wait_time_category
FROM weighted_acuity
ORDER BY median_wait_weeks DESC;