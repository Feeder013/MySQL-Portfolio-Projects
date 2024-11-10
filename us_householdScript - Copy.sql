SELECT *
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income;

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

DELETE FROM us_household_income
WHERE row_id IN 
	( SELECT *
    FROM ( SELECT row_id, id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id ) AS row_num
    FROM us_household_income ) AS duplicates
    WHERE row_num > 1
    ) ;
    
SELECT *
FROM us_household_income
WHERE City = '';

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';
UPDATE us_household_income
SET Type = 'Borough'
WHERE State_Name = 'boroughs';

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

SELECT *
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id;
    
SELECT u.State_Name,County,Type,'Primary',Mean,Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0;

SELECT u.State_Name, ROUND(AVG(Mean),1) AS avg_mean,
ROUND(AVG(Median),1) AS avg_median
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0 
GROUP BY u.State_Name
LIMIT 5;

SELECT State_Name,County, Type, COUNT(Type)
FROM us_household_income;

SELECT *
FROM us_household_income
WHERE Type = 'Community' OR 'Urban'
HAVING COUNT(Type) > 100;

SELECT u.State_Name, City, ROUND(AVG(Mean),1)
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY City DESC;


