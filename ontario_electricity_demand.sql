/*
How does Ontario electricity demand vary over time, and what patterns emerge across hours, months and years?
*/

--EXPLORE THE DATA
--FIRST 10 ROWS OF 2025
SELECT *
FROM "PUB_Demand_2025_v396"
LIMIT 10;


--FIRST 10 ROWS OF 2026
SELECT * 
FROM "PUB_Demand_2026_v289"
LIMIT 10;

--CHECK COLUMN TYPES
PRAGMA table_info("PUB_Demand_2025_v396");

PRAGMA table_info("PUB_Demand_2026_v289");

--CHECK FOR MISSING VALUES IN 2025
SELECT 
  SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Missing_Dates_2025,
  SUM(CASE WHEN Hour IS NULL THEN 1 ELSE 0 END) AS Missing_Hours,
  SUM(CASE WHEN "Ontario Demand" IS NULL THEN 1 ELSE 0 END) AS Missing_Demand
FROM "PUB_Demand_2025_v396";

--CHECK FOR MISSING VALUES IN 2026
SELECT 
  SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Missing_Dates_2026,
  SUM(CASE WHEN Hour IS NULL THEN 1 ELSE 0 END) AS Missing_Hours,
  SUM(CASE WHEN "Ontario Demand" IS NULL THEN 1 ELSE 0 END) AS Missing_Demand
FROM "PUB_Demand_2026_v289";

/*
Observation: 
There are no missing values in the Date, Hour and Ontario Demand columns in either year.
*/
--FIND MAXIMUM AND MAXIMUM ONTARIO DEMAND IN 2025
SELECT 
  'Maximum' AS Demand_Type,
  Date,
  Hour,
  "Ontario Demand" AS Demand_Mw
FROM "PUB_Demand_2025_v396"
WHERE "Ontario Demand" = (
  SELECT MAX("Ontario Demand")
  FROM "PUB_Demand_2025_v396"
)
UNION all
SELECT 
  'Minimum' AS Demand_Type,
   Date, 
   Hour,
   "Ontario Demand" AS Demand_mw
FROM "PUB_Demand_2025_v396"
WHERE "Ontario Demand" = (
  SELECT MIN("Ontario Demand")
  FROM "PUB_Demand_2025_v396"
);

--FIND MAXIMUM AND MINIMUM ONTARIO DEMAND IN 2026
SELECT
    'Maximum' AS Demand_Type,
    Date,
    Hour,
    "Ontario Demand" AS Demand_MW
FROM "PUB_Demand_2026_v289"
WHERE "Ontario Demand" = (
    SELECT MAX("Ontario Demand")
    FROM "PUB_Demand_2026_v289"
)

UNION ALL

SELECT
    'Minimum' AS Demand_Type,
    Date,
    Hour,
    "Ontario Demand" AS Demand_MW
FROM "PUB_Demand_2026_v289"
WHERE "Ontario Demand" = (
    SELECT MIN("Ontario Demand")
    FROM "PUB_Demand_2026_v289"
);

/*
Observation:
In 2025, the maximum Ontario Demand was recorded on 24 June at 1900 hours, while the minimum was recorded on 01 June at 0300 hours.
In 2026, the maximum was recorded on 14 July at 1700 hours, while the minimum was recorded on 31 May at 0600 hours. 
*/


--AVERAGE ONTARIO DEMAND BY HOUR IN 2025
select
  Hour, 
  ROUND(AVG("Ontario Demand"), 2) AS Average_Demand_2025
FROM "PUB_Demand_2025_v396"
GROUP BY hour
ORDER BY CAST(Hour as INTEGER);

--AVERAGE ONTARIO DEMAND BY HOUR IN 2026
SELECT 
  Hour,
  ROUND(AVG("Ontario Demand"), 2) AS Average_Demand_2026
FROM "PUB_Demand_2026_v289"
GROUP BY hour
ORDER BY CAST(Hour AS INTEGER);

/*
Observation:
Electicity demand is lower during early morning hours and increases throughout the day, reaching its peak in the evening before decreasing at night.
Both 2025 and 2026 show a similar pattern, with 2026 generally having higher demand.
*/



--AVERAGE ONTARIO DEMAND BY MONTH IN 2025
SELECT 
  SUBSTR(DATE, 6, 2) AS Month,
  ROUND(AVG("Ontario Demand"), 2) AS Average_Demand_2025
FROM "PUB_Demand_2025_v396"
GROUP BY SUBSTR(DATE, 6, 2)
ORDER BY Month;

--AVERAGE ONTARIO DEMAND BY MONTH IN 2026
SELECT 
  SUBSTR(DATE, 6, 2) AS Month,
  ROUND(AVG("Ontario Demand"), 2) AS Average_Demand_2026
FROM "PUB_Demand_2026_v289"
GROUP BY SUBSTR(DATE, 6, 2)
ORDER BY Month;
/*
Observation:
Monthly average electricity demand varies throughout the year. The montly results help identify periods of higher and lower demand and assess whether demand is higher during winter or summer.
*/

--HOW MUCH HIGHER WAS PEAK DEMAND THAN ITS MONTHLY AVERAGE?
WITH Monthly_Averages AS (
    SELECT
        SUBSTR(Date, 1, 7) AS Year_Month,
        AVG("Ontario Demand") AS Monthly_Avg
    FROM "PUB_Demand_2025_v396"
    GROUP BY SUBSTR(Date, 1, 7)
),
Peak_Demand AS (
    SELECT
        Date,
        Hour,
        "Ontario Demand" AS Peak_MW
    FROM "PUB_Demand_2025_v396"
    ORDER BY "Ontario Demand" DESC
    LIMIT 1
)
SELECT
    p.Date,
    p.Hour,
    p.Peak_MW,
    ROUND(m.Monthly_Avg, 2) AS Monthly_Avg_MW,
    ROUND(p.Peak_MW - m.Monthly_Avg, 2) AS Difference_MW,
    ROUND(
        (p.Peak_MW - m.Monthly_Avg) * 100.0 / m.Monthly_Avg,
        2
    ) AS Percent_Above_Avg
FROM Peak_Demand p
JOIN Monthly_Averages m
    ON SUBSTR(p.Date, 1, 7) = m.Year_Month;
/*
Observation:
The highest recorded Ontario electricity demand on June 24, 2025 was 24,862 MW at hour 19(7 PM). This as 8,478.3 MW or 51.75%, above the average demand for that month. This shows that peak demand can be substantially higher than the monthly average.
*/