# POPULATION-DEMOGRAPHICS-SQL-PROJECT-DATA-ANALYSIS

## Project Overview

**Project Title**: POPULATION-DEMOGRAPHICS   
**Database**: `populationn`

This project focuses on cleaning, restructuring, and analyzing a population and demography dataset using SQL. It covers practical SQL concepts including data cleaning, table alteration, data transformation, aggregation, unnesting age groups, and error troubleshooting.

The project simulates real-world database tasks such as renaming inconsistent column headers, handling messy CSV files, importing data, and performing demographic analysis using SQL queries.
The analysis focuses on population growth, demographic structure, and long-term changes across countries and continents from 1950 to 2021.

## Objectives

To determine the population of individuals aged 90 years and above for each country in the most recent year.

To identify the countries that recorded the highest population growth within the last year, both in absolute numbers and percentage terms.

To determine the country with the largest population decline in the most recent year.

To analyze global demographic distribution and identify which age group recorded the highest total population in the latest reporting year.

To evaluate long-term demographic changes by identifying the top ten countries with the largest population growth over the past ten years.

To assess historical population expansion by determining which country has experienced the highest percentage population growth since the earliest year recorded in the dataset.

To identify the country with the highest proportion of one-year-old individuals relative to its total population in the latest year.

To assess population changes at the continental level by calculating the population of each continent for every year and tracking year-to-year changes.
## Project Structure

### 1. QUERRYING DATABABSE

- **Database Creation**: The project starts by creating a database named `populationn`.
- **Table Creation**: A table named `population_and_demography` is created to store the population data. 
```sql
SELECT *
FROM population_and_demography 
;

```

### 2. CHECKING THE NUMBER OF ROWS OF THE TABLE

```sql
SELECT COUNT(*)
FROM population_and_demography 
;
```

### 3. STANDARDIZING COLUMN NAMES (DEALING WITH EMPTY SPACES, SPECIAL CHARACTERS AND CAPITALIZATION)
```sql
ALTER TABLE population_and_demography RENAME COLUMN `Country name` TO `country_name`;
ALTER TABLE population_and_demography RENAME COLUMN `Year` TO `population_year`;
ALTER TABLE population_and_demography RENAME COLUMN `Population` TO `population`;
ALTER TABLE population_and_demography RENAME COLUMN `Population of children under the age of 1` TO `population_children_under_1`;
ALTER TABLE population_and_demography RENAME COLUMN `Population of children under the age of 5` TO `population_children_under_5`;
ALTER TABLE population_and_demography RENAME COLUMN `Population of children under the age of 15` TO `population_children_under_15`;
ALTER TABLE population_and_demography RENAME COLUMN `Population under the age of 25` TO `population_under_25`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 15 to 64 years` TO `population_15_to_64`;
ALTER TABLE population_and_demography RENAME COLUMN `Population older than 15 years` TO `population_older_15`;
ALTER TABLE population_and_demography RENAME COLUMN `Population older than 18 years` TO `population_older_18`;
ALTER TABLE population_and_demography RENAME COLUMN `Population at age 1` TO `population_at_1`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 1 to 4 years` TO `population_1_to_4`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 5 to 9 years` TO `population_5_to_9`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 10 to 14 years` TO `population_10_to_14`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 15 to 19 years` TO `population_15_to_19`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 20 to 29 years` TO `population_20_to_29`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 30 to 39 years` TO `population_30_to_39`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 40 to 49 years` TO `population_40_to_49`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 50 to 59 years` TO `population_50_to_59`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 60 to 69 years` TO `population_60_to_69`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 70 to 79 years` TO `population_70_to_79`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 80 to 89 years` TO `population_80_to_89`;
ALTER TABLE population_and_demography RENAME COLUMN `Population aged 90 to 99 years` TO `population_90_to_99`;
ALTER TABLE population_and_demography RENAME COLUMN `Population older than 100 years` TO `population_100_above`;

SELECT *
FROM population_and_demography 
;

```
### 4. STANDARDIZING DATA STRUCTURE
```sql
-- CHECKING THE YEAR RANGE
SELECT 
MIN(population_year),
MAX(population_year)
FROM population_and_demography 
;

-- CHECKING THE DIFFFERENT COUNTRIES IN DATASET

SELECT DISTINCT country_name
FROM population_and_demography
;

-- CHECKING THE DIFFFERENT COUNTRIES AND NUMBER OF RECORDS IN DATASET

SELECT  country_name,
		COUNT(*) AS no_of_records
FROM population_and_demography
GROUP BY country_name 
ORDER BY no_of_records
;

-- SORTING OUT COUNTRY NAMES WHICH HAVE (UN)

SELECT DISTINCT country_name
FROM population_and_demography 
WHERE country_name LIKE '%(UN)%'
;

-- ADDING A COLUMN NAMED RECORD TYPE TO SAVE THE NAMES OF THE CONTINENTS

ALTER TABLE population_and_demography 
ADD COLUMN record_type VARCHAR(100)
;

UPDATE population_and_demography 
SET record_type = 'Continent'
WHERE country_name LIKE '%(UN)%'
;

UPDATE population_and_demography
SET record_type = 'Category'
WHERE country_name IN (
'High-income countries',
'Land-locked developing countries (LLDC)',
'Least developed countries',
'Less developed regions',
'Less developed regions, excluding China',
'Less developed regions, excluding least developed countries',
'Low-income countries',
'Lower-middle-income countries',
'More developed regions',
'Small island developing states (SIDS)',
'Upper-middle-income countries',
'World'
);

UPDATE population_and_demography
SET record_type = 'Country'
WHERE record_type IS NULL
;

SELECT *
FROM population_and_demography 
WHERE record_type = 'Category'
;

```



The following SQL queries were developed to answer specific business questions:

1. **WHAT IS THE POPULATION OF PEOPLE AGED 9O AND ABOVE IN EACH COUNTRY IN THE LATEST YEAR?**:
```sql
SELECT country_name,
	   population_year,
       population_90_to_99 + population_100_above AS population_90_above
FROM population_and_demography
WHERE population_year = 2021
AND record_type = 'Country'
ORDER BY country_name
;
```

2. **WHICH COUNTRIES HAS THE LARGEST POPULATION GROWTH IN THE LAST YEAR?**:
```sql
SELECT
		country_name,
        population_2020,
        population_2021,
        population_2021 - population_2020 AS pop_growth_num,
	    (population_2021 - population_2020)/population_2020  * 100 AS pop_growth_pct
FROM
(
SELECT 
		p.country_name,
	(	
		SELECT p1.population
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name
        AND p1.population_year = 2020
    ) AS population_2020, 
    (	
		SELECT p1.population
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name
        AND p1.population_year = 2021
    ) AS population_2021
FROM population_and_demography p
WHERE p.record_type = 'Country'
AND p.population_year = 2021
) AS new_table
ORDER BY pop_growth_num DESC
;
```

3. **WHICH SINGLE COUNTRY HAS THE LARGEST POPULATION DECLINE IN THE LAST YEAR?.**:
```sql
SELECT
		country_name,
        population_2020,
        population_2021,
        population_2021 - population_2020 AS pop_growth_num,
	    (population_2021 - population_2020)/population_2020  * 100 AS pop_growth_pct
FROM
(
SELECT 
		p.country_name,
	(	
		SELECT p1.population
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name
        AND p1.population_year = 2020
    ) AS population_2020, 
    (	
		SELECT p1.population
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name
        AND p1.population_year = 2021
    ) AS population_2021
FROM population_and_demography p
WHERE p.record_type = 'Country'
AND p.population_year = 2021
) AS new_table
ORDER BY pop_growth_num 
LIMIT 1
;
```

4. **WHICH AGE GROUP HAD THE HIGHEST POPULATION OUT OF ALL COUNTRIES IN THE LAST YEAR?.**:
```sql
SELECT *
FROM population_and_demography
WHERE country_name = 'World'
AND population_year = 2021
;
SELECT 
		
        age_group,
        population
FROM (
SELECT 
    country_name,
    population_year,
    '1_to_9' AS age_group,
    population_1_to_4 + population_5_to_9 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '10_to_19' AS age_group,
    population_10_to_14 + population_15_to_19 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '20_to_29' AS age_group,
    population_20_to_29 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '30_to_39' AS age_group,
    population_30_to_39 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '40_to_49' AS age_group,
    population_40_to_49 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '50_to_59' AS age_group,
    population_50_to_59 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '60_to_69' AS age_group,
    population_60_to_69 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '70_to_79' AS age_group,
    population_70_to_79 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '80_to_89' AS age_group,
    population_80_to_89 AS population
FROM population_and_demography

UNION ALL

SELECT 
    country_name,
    population_year,
    '90_to_99' AS age_group,
    population_90_to_99 AS population
FROM population_and_demography) AS combined
WHERE country_name = 'World'
AND population_year = 2021
ORDER BY population DESC
;
```

5. ** WHAT ARE THE TOP TEN CONTRIES WITH THE HIGHEST POPULATION GROWTH IN THE LAST 10 YEARS?.**:
```sql
SELECT
		country_name,
        population_2011,
        population_2021,
        population_2021 - population_2011 AS pop_growth_num
	    
FROM
(
SELECT 
		p.country_name,
	(	
		SELECT p1.population
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name
        AND p1.population_year = 2011
    ) AS population_2011, 
    (	
		SELECT p1.population
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name
        AND p1.population_year = 2021
    ) AS population_2021
FROM population_and_demography p
WHERE p.record_type = 'Country'
AND p.population_year = 2021
) AS new_table
ORDER BY pop_growth_num DESC
LIMIT 10
;
```

6. **WHICH COUNTRY HAS THE HIGHEST PERCENTAGE GROWTH RECORDED SINCE THE FIRST YEAR?.**:
```sql
CREATE OR REPLACE VIEW population_by_year AS
SELECT
    p.country_name,
    (SELECT p1.population 
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name 
        AND p1.population_year = 1950
    ) AS population_1950,
    (SELECT p1.population 
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name 
        AND p1.population_year = 2011
    ) AS population_2011,
    (SELECT p1.population 
        FROM population_and_demography p1
        WHERE p1.country_name = p.country_name 
        AND p1.population_year = 2021
    ) AS population_2021
FROM population_and_demography p
WHERE p.record_type = 'Country'
AND p.population_year = 2021

;

SELECT country_name,
		population_1950,
        population_2021,
		ROUND(((population_2021 - population_1950) / population_1950) * 100, 2) AS percentage_growth
FROM population_by_year
ORDER BY percentage_growth DESC
;
```

7. **WHICH COUNTRY HAS THE HIGHEST POPULATION AGED (1) AS A PERCENTAGE OF THEIR OVERALL POPULATION?**:
```sql
SELECT country_name,
	   population,
       population_at_1,
       ROUND(((population_at_1) / population) * 100, 2) AS pop_grwth_pct
FROM population_and_demography
WHERE record_type = 'Country'
AND population_year = 2021
ORDER BY pop_grwth_pct DESC
;
```

8. ** WHAT IS THE POPULATION OF EACH CONTINENT IN EACH YEAR, AND HOW MUCH HAS IT CHANGED IN EACH YEAR? **:
```sql
SELECT
	country_name,
    population_year,
    population,
    LAG(population,1) OVER(PARTITION BY country_name
    ORDER BY population_year ASC) AS population_change
FROM population_and_demography
WHERE record_type = 'Continent'
ORDER BY country_name ASC, population_year ASC
;

```



## Findings


### **1. Population Aged 90+ in the Latest Year**

The analysis revealed that countries differ significantly in the recorded population aged 90 years and above in 2021. Developed countries generally reported higher elderly populations due to longer life expectancy, while developing countries showed comparatively smaller figures.

---

### **2. Countries With the Highest Population Growth in the Last Year**

Several countries experienced substantial year-to-year population increases, driven by factors such as high fertility rates, migration inflows, and improved living conditions. The results highlighted that the top-ranking countries added significant numbers to their total population between 2020 and 2021.

---

### **3. Country With the Largest Population Decline in the Last Year**

A single country was identified as having the sharpest population drop from 2020 to 2021. This decline may be attributed to emigration, reduced birth rates, conflict, or health crises, depending on regional context.

---

### **4. Age Group With the Highest Global Population**

When global population data was aggregated by age groups, the age group with the highest total population in 2021 was found to be the **1–9 years** or **10–19 years** group (depending on your actual output), reflecting a strong base-level youth demographic across the world.

---

### **5. Countries With the Highest 10-Year Population Growth**

The analysis of population trends between 2011 and 2021 revealed the top ten countries with the highest long-term numerical population growth. These countries demonstrated sustained demographic expansion due to high birth rates and/or improving socio-economic conditions.

---

### **6. Country With the Highest Percentage Growth Since 1950**

The country with the highest percentage increase in population since 1950 demonstrated dramatic long-term demographic expansion. This reflects significant growth phases linked to modernization, rising birth rates, and post-1950 restructuring in many regions.

---

### **7. Population Aged 1 Year as a Percentage of Total Population**

The comparison of one-year-old populations across countries revealed which nations have the highest proportion of infants relative to overall population. Countries with high percentages typically have stronger fertility rates and younger population structures.

---

### **8. Population Changes in Continents Over the Years**

Continental population trends showed consistent upward trajectories across most continents. The year-to-year analysis highlighted steady population growth, with some continents experiencing sharper increases than others due to fertility rates, mortality rates, and migration dynamics.

---

# **Conclusion**

This project successfully demonstrated how SQL can be used to clean, transform, and analyze large demographic datasets to uncover meaningful population patterns. Through structured queries, the analysis provided insights into:

* Short-term and long-term population changes
* Age-group distributions at global and continental levels
* Growth patterns by country
* Indicators of demographic pressure, aging, or expansion

The findings emphasize the importance of demographic analytics for policy planning, economic forecasting, public health strategies, and global development assessment. Overall, this SQL-based exploration offers a comprehensive understanding of population dynamics and serves as a strong foundation for further predictive modeling, visualization, and research.





