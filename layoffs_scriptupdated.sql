SELECT *
FROM layoffs
ORDER BY company
;

SELECT CONCAT(company,location),
industry,
ROW_NUMBER() OVER(PARTITION BY CONCAT(company,location) ORDER BY industry) AS dup_num
FROM layoffs
;

SELECT row_id
FROM (
	SELECT CONCAT(company,location) AS row_id,
	industry,
	ROW_NUMBER() OVER(PARTITION BY CONCAT(company,location) ORDER BY industry) AS dup_num
	FROM layoffs
) AS duplicates
WHERE dup_num > 1
;

DELETE FROM layoffs
WHERE 
	CONCAT(company,location) IN ( 
		SELECT row_id
FROM (
	SELECT CONCAT(company,location) AS row_id,
	industry,
	ROW_NUMBER() OVER(PARTITION BY CONCAT(company,location) ORDER BY industry) AS dup_num
	FROM layoffs
) AS duplicates
WHERE dup_num > 1
)
;

SELECT *
FROM layoffs
WHERE industry IS NULL ;

UPDATE layoffs
SET industry = 'Gaming'
WHERE industry IS NULL;

SELECT *
FROM layoffs 
WHERE percentage_laid_off IS NULL;

SELECT company,
location,
total_laid_off
FROM layoffs
WHERE total_laid_off > 100;
SELECT *
FROM layoffs
WHERE country = 'United States' AND total_laid_off >= 300;

SELECT *
FROM layoffs 
WHERE country LIKE 'A%';
SELECT *
FROM layoffs
WHERE country IN ('Canada','United States','France','Germany')
ORDER BY funds_raised_millions DESC
LIMIT 10;
SELECT date,
CONVERT(date,DATETIME)
FROM layoffs;

SELECT MIN(total_laid_off),MAX(total_laid_off),AVG(total_laid_off)
FROM layoffs;

SELECT company, total_laid_off,
CASE
	WHEN total_laid_off >= 8000 THEN 'high_layers'
    WHEN total_laid_off BETWEEN 100 AND 7999 THEN 'mid_layers'
    ELSE 'low_layers'
END AS 'layoff_range'
FROM layoffs;

SELECT *
FROM (
SELECT company, total_laid_off,
CASE
	WHEN total_laid_off >= 8000 THEN 'high_layers'
    WHEN total_laid_off BETWEEN 100 AND 7999 THEN 'mid_layers'
    ELSE 'low_layers'
END AS 'layoff_range'
FROM layoffs
) AS layoffs_table
WHERE layoff_range = 'high_layers'
;

SELECT *
FROM layoffs;
SELECT MIN(funds_raised_millions),MAX(funds_raised_millions),AVG(funds_raised_millions)
FROM layoffs;

SELECT company, funds_raised_millions,
CASE
	WHEN funds_raised_millions >= 20000 THEN 'big_fish'
    WHEN funds_raised_millions BETWEEN 300 AND 19999 THEN 'mid_fish'
    ELSE 'small_fish'
END AS 'company_Size_range'
FROM layoffs;

SELECT *
FROM (
SELECT company, funds_raised_millions,
CASE
	WHEN funds_raised_millions >= 20000 THEN 'big_fish'
    WHEN funds_raised_millions BETWEEN 300 AND 19999 THEN 'mid_fish'
    ELSE 'small_fish'
END AS 'company_Size_range'
FROM layoffs
) AS companysize_table
WHERE company_Size_range = 'big_fish'
;

ALTER TABLE layoffs
ADD COLUMN Layoff_range VARCHAR(50) AFTER total_laid_off
;

UPDATE layoffs
SET Layoff_range = CASE
	WHEN total_laid_off >= 8000 THEN 'high_layers'
    WHEN total_laid_off BETWEEN 100 AND 7999 THEN 'mid_layers'
    ELSE 'low_layers'
END;
SELECT *
FROM layoffs;

SELECT AVG(total_laid_off) AS layoff_average,
industry
FROM layoffs
GROUP BY industry
ORDER BY 1 DESC;


SELECT *
FROM layoffs
WHERE total_laid_off > (
SELECT AVG(total_laid_off) AS loa
FROM layoffs
);

SELECT *
FROM layoffs
WHERE country = 'United States' AND funds_raised_millions >= 500;

WITH B_United_States AS
( SELECT *
	FROM layoffs
	WHERE country = 'United States' AND funds_raised_millions >= 1000
),
Bpercent_layoff AS
(	SELECT *
	FROM layoffs 
	WHERE percentage_laid_off >= 0.7
) 
SELECT *
FROM B_United_States bus
JOIN Bpercent_layoff bpl
	ON bus.country = bpl.country
;


DELIMITER $$
CREATE PROCEDURE first_procedures()
BEGIN 
	SELECT *
	FROM layoffs 
	WHERE percentage_laid_off >= 0.7
    ;
END $$
DELIMITER ;

