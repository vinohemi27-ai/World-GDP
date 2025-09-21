-- Top 10 GDP countries in 2025
SELECT Country, year, gdp
FROM world_gdp_long
WHERE year = '2025'
ORDER BY gdp DESC
LIMIT 10;

-- Average GDP (2020–2025) per country
SELECT Country, AVG(gdp) AS avg_gdp
FROM world_gdp_long
WHERE year BETWEEN '2020' AND '2025'
GROUP BY Country
ORDER BY avg_gdp DESC
LIMIT 10;

-- Volatility of top 10 GDP countries
WITH yr_wise_top AS (
  SELECT Country, year, gdp,
         RANK() OVER (PARTITION BY year ORDER BY gdp DESC) AS rnk
  FROM world_gdp_long
)
SELECT Country, AVG(gdp) AS avg_gdp,
       COUNT(Country) AS times_in_top10,
       STDDEV_POP(gdp) AS volatility
FROM yr_wise_top
WHERE rnk <= 10
GROUP BY Country
ORDER BY times_in_top10 DESC, avg_gdp DESC, volatility ASC;

-- YoY GDP Growth (2024 → 2025) for top 10
WITH yr_wise_top AS (
  SELECT Country, year, gdp,
         RANK() OVER (PARTITION BY year ORDER BY gdp DESC) AS rnk
  FROM world_gdp_long
)
SELECT t2024.Country, t2024.gdp AS gdp_2024,
       t2025.gdp AS gdp_2025,
       ((t2025.gdp - t2024.gdp) / t2024.gdp) * 100 AS gdp_growth
FROM yr_wise_top t2024
JOIN yr_wise_top t2025 ON t2024.Country = t2025.Country
WHERE t2024.year = '2024' AND t2025.year = '2025'
  AND t2024.rnk <= 10 AND t2025.rnk <= 10
ORDER BY gdp_growth DESC;
