USE health_insurance;

SELECT *
FROM health_insurance;

SELECT *
FROM health_insurance
WHERE bmi <= 18.5;

SELECT bmi,
CASE
	WHEN bmi <= 18.5 THEN 'Underweight'
    WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'Normal'
    WHEN bmi BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    WHEN bmi >= 30 THEN 'Obese'
END AS 'bmi_indicator'
FROM health_insurance
;

ALTER TABLE health_insurance
ADD COLUMN bmi_indicator VARCHAR(50) AFTER bmi
;


UPDATE health_insurance
SET bmi_indicator = CASE 
	WHEN bmi <= 18.5 THEN 'Underweight'
    WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'Normal'
    WHEN bmi BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    WHEN bmi >= 30 THEN 'Obese'
END
;
    
SELECT children,
ROUND(AVG(charges),1) AS Approx_charges
FROM (
SELECT *
FROM health_insurance
WHERE bmi_indicator = 'Obese'
ORDER BY bmi
) AS obese_table
GROUP BY children with ROLLUP
;

SELECT smoker, region,
ROUND(AVG(charges),2) AS mean_charges
FROM
	(
	SELECT *
	FROM health_insurance
	WHERE bmi_indicator = 'Obese'
	) AS Obese_table
WHERE smoker = 'yes'
GROUP BY region 
ORDER BY region 
;

