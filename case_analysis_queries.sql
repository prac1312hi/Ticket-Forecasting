CREATE DATABASE IF NOT EXISTS case_analysis;
USE case_analysis;
SELECT COUNT(*) FROM closed_cases;   -- should be 19771
SELECT COUNT(*) FROM open_cases;     -- should match the open count from Cell 7 (about 143)

/*Change the password and user*/
CREATE USER 'analyst'@'localhost' IDENTIFIED BY 'Analyst@2026';
GRANT ALL PRIVILEGES ON case_analysis.* TO 'analyst'@'localhost';
FLUSH PRIVILEGES;

/*To bring the data to MySQL from python*/
USE case_analysis;

CREATE TABLE all_cases AS
SELECT case_number, case_owner, source, opened_at, NULL AS closed_at, 'Open' AS state
FROM open_cases
UNION ALL
SELECT case_number, case_owner, source, opened_at, closed_at, 'Closed'
FROM closed_cases;

SELECT state, COUNT(*) FROM all_cases GROUP BY state;

/*Queries:*/

/*1. Monthly volume and resolution time*/
select date_format(closed_at, '%Y-%m') as month,
count(*) as cases_closed,
Round(avg(days_to_close), 1) as avg_days_to_close
from closed_cases
group by month
order by month;

/*2. Which channels take longest to resolve? */
select source,
count(*) as cases,
round(avg(days_to_close), 1) as avg_days,
sum(days_to_close = 0) as same_day_closures
from closed_cases
group by source
order by cases DESC;

/*3. How quickly do cases close? (speed buckets)*/
select case when days_to_close = 0 then '1. Same Day'
WHEN days_to_close <= 3  THEN '2. 1-3 days'
            WHEN days_to_close <= 7  THEN '3. 4-7 days'
            WHEN days_to_close <= 30 THEN '4. 8-30 days'
            else '5. 30+ days' End as speed,
            count(*) as cases,
            round(100.0 * count(*)/ (select count(*) from closed_cases), 1 ) as pct
            from closed_cases
            group by speed
            order by speed;
            
/* 4. Current open backlog: status and overdue followups*/
Select sub_status,
count(*) as open_cases,
sum(follow_up_overdue) as overdue_followups,
round(avg(days_open), 1) as avg_days_open
from open_cases
group by sub_status
order by open_cases DESC;

/*5. Data-quality check: untagged cases by year*/
SELECT YEAR(closed_at) AS year,
       COUNT(*) AS total,
       SUM(source = 'Unknown') AS unknown_source,
       ROUND(100.0 * SUM(source = 'Unknown') / COUNT(*), 1) AS pct_unknown
FROM closed_cases
GROUP BY year;