\#  **World GDP Analysis (2020–2025) using SQL**



\## **Project Overview**

This project analyzes GDP data for countries between \*\*2020 and 2025\*\*.  

Using \*\*MySQL\*\*, I cleaned, transformed, and reshaped the data to enable advanced queries such as:

\- Top 10 GDP countries in 2025

\- Country-wise average GDP across 2020–2025

\- Volatility of top countries’ GDP

\- Year-over-year (YoY) growth trends



This project demonstrates \*\*SQL data cleaning, joins, unpivoting, window functions, and analytics\*\*.



---



\##  **Dataset**

\- `gdp\_20\_22` → GDP values for 2020–2022  

\- `gdp\_23\_25` → GDP values for 2023–2025  



Both tables were cleaned, merged, and reshaped into a \*\*long format\*\* table for analysis.



---



\## 🔧 Steps Performed



\### **1. Database Setup**

```sql

CREATE DATABASE world\_gdp;

USE world\_gdp;



**2. Data Cleaning**



Renamed year columns (2023 → gdp\_2023, etc.)



Allowed NULL values



Replaced missing GDP values with 0



ALTER TABLE gdp\_23\_25

RENAME COLUMN `2023` TO gdp\_2023,

RENAME COLUMN `2024` TO gdp\_2024,

RENAME COLUMN `2025` TO gdp\_2025;



UPDATE gdp\_23\_25 

SET gdp\_2025 = COALESCE(gdp\_2025,0);



**3.Data Integration**



Joined both tables to form a combined dataset:



CREATE TABLE world\_gdp AS

SELECT g1.Country, g1.gdp\_2020, g1.gdp\_2021, g1.gdp\_2022,

&nbsp;      g2.gdp\_2023, g2.gdp\_2024, g2.gdp\_2025

FROM gdp\_20\_22 g1

JOIN gdp\_23\_25 g2 ON g1.Country = g2.Country;



**4.Reshaping (Unpivot)**



Converted wide table into long format (Country | year | gdp):



CREATE TABLE world\_gdp\_long AS

SELECT Country, '2020' AS year, gdp\_2020 AS gdp FROM world\_gdp

UNION ALL

SELECT Country, '2021', gdp\_2021 FROM world\_gdp

UNION ALL

SELECT Country, '2022', gdp\_2022 FROM world\_gdp

UNION ALL

SELECT Country, '2023', gdp\_2023 FROM world\_gdp

UNION ALL

SELECT Country, '2024', gdp\_2024 FROM world\_gdp

UNION ALL

SELECT Country, '2025', gdp\_2025 FROM world\_gdp;



**5.Analysis Queries**



Top 10 Countries by GDP in 2025



SELECT Country, year, gdp

FROM world\_gdp\_long

WHERE year = '2025'

ORDER BY gdp DESC

LIMIT 10;



Average GDP (2020–2025) per Country



SELECT Country, AVG(gdp) AS avg\_gdp

FROM world\_gdp\_long

WHERE year BETWEEN '2020' AND '2025'

GROUP BY Country

ORDER BY avg\_gdp DESC

LIMIT 10;





***Volatility of Top 10 GDP Countries***



WITH yr\_wise\_top AS (

&nbsp; SELECT Country, year, gdp,

&nbsp;        RANK() OVER (PARTITION BY year ORDER BY gdp DESC) AS rnk

&nbsp; FROM world\_gdp\_long

)

SELECT Country, AVG(gdp) AS avg\_gdp,

&nbsp;      COUNT(Country) AS times\_in\_top10,

&nbsp;      STDDEV\_POP(gdp) AS volatility

FROM yr\_wise\_top

WHERE rnk <= 10

GROUP BY Country

ORDER BY times\_in\_top10 DESC, avg\_gdp DESC, volatility ASC;



***YoY Growth (2024 → 2025) for Top 10***



WITH yr\_wise\_top AS (

&nbsp; SELECT Country, year, gdp,

&nbsp;        RANK() OVER (PARTITION BY year ORDER BY gdp DESC) AS rnk

&nbsp; FROM world\_gdp\_long

)

SELECT t2024.Country, t2024.gdp AS gdp\_2024,

&nbsp;      t2025.gdp AS gdp\_2025,

&nbsp;      ((t2025.gdp - t2024.gdp) / t2024.gdp) \* 100 AS gdp\_growth

FROM yr\_wise\_top t2024

JOIN yr\_wise\_top t2025

&nbsp;    ON t2024.Country = t2025.Country

WHERE t2024.year = '2024' AND t2025.year = '2025'

&nbsp; AND t2024.rnk <= 10 AND t2025.rnk <= 10

ORDER BY gdp\_growth DESC;

***Key Learnings***

Handling NULL values with COALESCE

Using ALTER TABLE for schema cleaning

Unpivoting with UNION ALL

Ranking with window functions

Calculating volatility (standard deviation) and YoY growth


***Tools Used***

MySQL for data cleaning and analysis

Power BI for visualization
























































































