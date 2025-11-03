SELECT *
FROM population_and_demography 
;


-- CHECKING THE NUMBER OF ROWS OF THE TABLE

SELECT COUNT(*)
FROM population_and_demography 
;

-- STANDARDIZING COLUMN NAMES (DEALING WITH EMPTY SPACES, SPECIAL CHARACTERS AND CAPITALIZATION)

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
-- EDA
-- 1. WHAT IS THE POPULATION OF PEOPLE AGED 9O AND ABOVE IN EACH COUNTRY IN THE LATEST YEAR?

SELECT country_name,
	   population_year,
       population_90_to_99 + population_100_above AS population_90_above
FROM population_and_demography
WHERE population_year = 2021
AND record_type = 'Country'
ORDER BY country_name
;

-- 2. WHICH COUNTRIES HAS THE LARGEST POPULATION GROWTH IN THE LAST YEAR?

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

-- 3. WHICH SINGLE COUNTRY HAS THE LARGEST POPULATION DECLINE IN THE LAST YEAR?

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

-- 4. WHICH AGE GROUP HAD THE HIGHEST POPULATION OUT OF ALL COUNTRIES IN THE LAST YEAR?

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

-- 5. WHAT ARE THE TOP TEN CONTRIES WITH THE HIGHEST POPULATION GROWTH IN THE LAST 10 YEARS?

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


-- 6. WHICH COUNTRY HAS THE HIGHEST PERCENTAGE GROWTH RECORDED SINCE THE FIRST YEAR?

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


-- 7. WHICH COUNTRY HAS THE HIGHEST POPULATION AGED (1) AS A PERCENTAGE OF THEIR OVERALL POPULATION?

SELECT country_name,
	   population,
       population_at_1,
       ROUND(((population_at_1) / population) * 100, 2) AS pop_grwth_pct
FROM population_and_demography
WHERE record_type = 'Country'
AND population_year = 2021
ORDER BY pop_grwth_pct DESC
;

-- 8. WHAT IS THE POPULATION OF EACH CONTINENT IN EACH YEAR, AND HOW MUCH HAS IT CHANGED IN EACH YEAR?

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




































