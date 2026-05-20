-- Disparity Analysis: Variance from Manitoba Benchmark
-- Source: Manitoba Health Annual Statistics 2018-2020, Figure 91
-- Purpose: Calculate how far each region deviates from provincial benchmark (4.0 weeks)

WITH benchmark AS (
    SELECT 4.0 AS manitoba_benchmark
)
SELECT 
    r.region_name,
    a.median_wait_weeks,
    b.manitoba_benchmark,
    ROUND((a.median_wait_weeks - b.manitoba_benchmark), 1) AS weeks_above_benchmark,
    ROUND(((a.median_wait_weeks - b.manitoba_benchmark) / b.manitoba_benchmark) * 100, 1) AS percent_above_benchmark,
    CASE 
        WHEN a.median_wait_weeks <= b.manitoba_benchmark THEN 'At or below benchmark'
        WHEN a.median_wait_weeks <= b.manitoba_benchmark * 2 THEN 'Moderately above benchmark'
        ELSE 'Severely above benchmark'
    END AS disparity_severity
FROM agg_wait_times a
CROSS JOIN benchmark b
JOIN dim_region r ON a.region_id = r.region_id
WHERE r.region_name != 'Manitoba'
ORDER BY weeks_above_benchmark DESC;