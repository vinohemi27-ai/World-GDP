-- Combine both tables
CREATE TABLE world_gdp AS
SELECT g1.Country, g1.gdp_2020, g1.gdp_2021, g1.gdp_2022,
       g2.gdp_2023, g2.gdp_2024, g2.gdp_2025
FROM gdp_20_22 g1
JOIN gdp_23_25 g2 ON g1.Country = g2.Country;

-- Reshape (Unpivot) wide to long format
CREATE TABLE world_gdp_long AS
SELECT Country, '2020' AS year, gdp_2020 AS gdp FROM world_gdp
UNION ALL
SELECT Country, '2021', gdp_2021 FROM world_gdp
UNION ALL
SELECT Country, '2022', gdp_2022 FROM world_gdp
UNION ALL
SELECT Country, '2023', gdp_2023 FROM world_gdp
UNION ALL
SELECT Country, '2024', gdp_2024 FROM world_gdp
UNION ALL
SELECT Country, '2025', gdp_2025 FROM world_gdp;
