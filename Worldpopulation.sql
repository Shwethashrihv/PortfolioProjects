/*
World Population Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Select Data that we are going to be starting with
SELECT * FROM world_population

-- Select all countries and their capitals
SELECT Country, Capital 
FROM world_population
  
  -- Top 10 most populated countries in 2022
SELECT Country, `2022 Population`
FROM world_population
ORDER BY `2022 Population` DESC
LIMIT 10;

 -- Total world population in 2022
 SELECT SUM(`2022 Population`) AS Total_World_Population_2022
FROM world_population;

-- Average growth rate by continent
SELECT Continent, AVG(`Growth Rate`) AS Avg_Growth_Rate
FROM world_population
GROUP BY Continent;

-- Population growth over decades: Population growth between 1970 and 2022 for each country.
SELECT Country, 
`2022 Population` - `1970 Population` AS Population_Growth
FROM world_population;

-- Countries with the highest growth rate
SELECT Country, `Growth Rate`
FROM world_population
ORDER BY `Growth Rate` DESC
LIMIT 10;

-- Top 10 countries with the highest population density
SELECT Country, Density
FROM world_population
ORDER BY Density DESC
LIMIT 10;

-- Countries in Asia with a population over 100 million
SELECT Country, `2022 Population`
FROM world_population
WHERE Continent = 'Asia' AND `2022 Population` > 100000000;

-- Correlation between area and population density
SELECT `Area (km²)`, `Density`
FROM world_population;

-- Countries where the population in 2022 is less than in 2000
SELECT Country, `2022 Population`, `2000 Population`
FROM world_population
WHERE `2022 Population` < `2000 Population`;

-- Continent with the highest average growth rate
SELECT Continent, AVG(`Growth Rate`) AS Avg_Growth_Rate
FROM world_population
GROUP BY Continent
ORDER BY Avg_Growth_Rate DESC
LIMIT 1;

-- Top 5 Countries by Population Growth Rate
SELECT Country, `Growth Rate`
FROM world_population
ORDER BY `Growth Rate` DESC
LIMIT 5;

--  Countries with Population Close to World Average
WITH WorldAvgPopulation AS (
  SELECT AVG(`2022 Population`) AS AvgPopulation
  FROM world_population
)
SELECT Country, `2022 Population`
FROM world_population, WorldAvgPopulation
WHERE ABS(`2022 Population` - AvgPopulation) <= 0.10 * AvgPopulation;

-- Historical Population Comparison
SELECT Country, 
       (`2022 Population` - `2000 Population`) / (`2022 Population`) * 100 AS Population_Growth_Rate
FROM world_population
WHERE `2000 Population` > 0;

-- Correlation Between Population and Area
SELECT 
    (COUNT(*) * SUM(`2022 Population` * `Area (km²)`) - SUM(`2022 Population`) * SUM(`Area (km²)`)) /
    SQRT(
        (COUNT(*) * SUM(POW(`2022 Population`, 2)) - POW(SUM(`2022 Population`), 2)) *
        (COUNT(*) * SUM(POW(`Area (km²)`, 2)) - POW(SUM(`Area (km²)`), 2))
    ) AS Population_Area_Correlation
FROM world_population;


-- Top Continent by Population Growth Rate

SELECT Continent,
       AVG((`2022 Population` - `2000 Population`) / `2000 Population` * 100) AS Avg_Growth_Rate
FROM world_population
GROUP BY Continent
ORDER BY Avg_Growth_Rate DESC
LIMIT 1;

--  Population Density Increase from 1970 to 2022
WITH DensityChange AS (
    SELECT Country,
           (`2022 Population` / `Area (km²)`) AS Density_2022,
           (`1970 Population` / `Area (km²)`) AS Density_1970,
           (`2022 Population` / `Area (km²)`) - (`1970 Population` / `Area (km²)`) AS Density_Change
    FROM world_population
)
SELECT Country,
       Density_2022,
       Density_1970,
       Density_Change
FROM DensityChange;

-- Countries with Growth Rate Above the Continent Average

WITH ContinentAverageGrowthRate AS (
    SELECT Continent,
           AVG(`Growth Rate`) AS Average_Growth_Rate
    FROM world_population
    GROUP BY Continent
),
CountryGrowthRate AS (
    SELECT Country,
           Continent,
           `Growth Rate`
    FROM world_population
)
SELECT c.Country,
       c.`Growth Rate`,
       a.Average_Growth_Rate
FROM CountryGrowthRate c
JOIN ContinentAverageGrowthRate a ON c.Continent = a.Continent
WHERE c.`Growth Rate` > a.Average_Growth_Rate;

-- Top 3 Countries by Population in Each Continent

WITH RankedCountries AS (
    SELECT Country,
           Continent,
           `2022 Population`,
           RANK() OVER (PARTITION BY Continent ORDER BY `2022 Population` DESC) AS Population_Rank
    FROM world_population
)
SELECT Country,
       Continent,
       `2022 Population`,
       Population_Rank
FROM RankedCountries
WHERE Population_Rank <= 3;

-- View for Population Density Change
CREATE VIEW PopulationDensityChange AS
SELECT Country,
       (`2022 Population` / `Area (km²)`) AS Density_2022,
       (`1970 Population` / `Area (km²)`) AS Density_1970,
       (`2022 Population` / `Area (km²)`) - (`1970 Population` / `Area (km²)`) AS Density_Change
FROM world_population;

-- Convert Density to Numeric Format

SELECT Country, 
       CAST(Density AS DECIMAL(10, 2)) AS Densityy
FROM world_population;

-- Temporary table to Analyzing Population Density by Continent

CREATE TEMPORARY TABLE TempPopulationDensity AS
SELECT Country,
       Continent,
       (`2022 Population` / `Area (km²)`) AS Population_Density
FROM world_population;









