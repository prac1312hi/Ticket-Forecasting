-- monthly_cases.sql
-- Monthly count of cases CREATED, Dec 2024 – Sep 2026 (full months only).
-- Replace `cases` and `created_date` with your actual table and column names.

SELECT
    DATE_FORMAT(created_date, '%Y-%m') AS month,
    COUNT(*)                           AS tickets
FROM cases
WHERE created_date >= '2024-12-01'
  AND created_date <  '2026-10-01'      -- excludes the incomplete current month
GROUP BY DATE_FORMAT(created_date, '%Y-%m')
ORDER BY month;

-- Optional: same counts split by case record type
-- SELECT DATE_FORMAT(created_date, '%Y-%m') AS month,
--        record_type,
--        COUNT(*) AS tickets
-- FROM cases
-- WHERE created_date >= '2024-12-01' AND created_date < '2026-10-01'
-- GROUP BY month, record_type
-- ORDER BY month, record_type;

-- Optional: year-over-year check used to rule out seasonality
-- SELECT MONTH(created_date) AS month_num,
--        SUM(YEAR(created_date) = 2025) AS tickets_2025,
--        SUM(YEAR(created_date) = 2026) AS tickets_2026
-- FROM cases
-- WHERE created_date >= '2025-01-01' AND created_date < '2026-10-01'
-- GROUP BY MONTH(created_date)
-- ORDER BY month_num;
