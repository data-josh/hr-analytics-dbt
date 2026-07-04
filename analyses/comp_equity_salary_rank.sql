-- Salary Rank by Department and Country
-- Pattern: ROW_NUMBER dedup → RANK within partition
-- Why: comp table has one row per salary change (fan-out trap)
-- Dedup to latest record before ranking

WITH latest_comp AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY employee_id
      ORDER BY effective_date DESC
    ) AS rn
  FROM `hr-analytics-portfolio-495323.dbt_datajosh.mart_comp_equity`
)

SELECT
  employee_id,
  department,
  job_level,
  country,
  annual_salary_usd,
  compa_ratio,
  RANK() OVER (
    PARTITION BY department, country
    ORDER BY annual_salary_usd DESC
  ) AS salary_rank
FROM latest_comp
WHERE rn = 1
ORDER BY department, country, salary_rank;
