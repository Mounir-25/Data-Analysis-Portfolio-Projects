-- 1. remove duplicates
-- 2. standardise data
-- 3. remove null and blank values
-- 4. remove any columns

 CREATE TABLE layoffs3 LIKE layoffs2;

 INSERT layoffs3

 SELECT *
 FROM layoffs2;


-- CREATE ROW_NUMBER
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER()  OVER(
PARTITION BY company,industry, total_laid_off, percentage_laid_off,
 `date`, stage, country, funds_raised_millions ) AS row_num
FROM layoffs2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


INSERT INTO layoffs3
SELECT *,
ROW_NUMBER()  OVER(
PARTITION BY company,industry, total_laid_off, percentage_laid_off,
 `date`, stage, country, funds_raised_millions ) AS row_num
FROM layoffs2;

CREATE TABLE `layoffs3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



-- this is the last edited table
DELETE
FROM layoffs3
WHERE row_num > 1;

-- standardizing data

SELECT *
FROM layoffs2;

UPDATE layoffs3
SET country = 'United States'
WHERE industry LIKE 'United States.';

SELECT DISTINCT `date`
FROM layoffs3;
-- ORDER BY 1;

INSERT INTO layoffs3
SELECT  location
FROM layoffs2
ORDER BY 1;

UPDATE layoffs3
SET country = TRIM(TRAILING '.' FROM country);

-- working on the date column
UPDATE layoffs3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs3
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs3
WHERE company = 'Airbnb';

UPDATE layoffs3
SET industry = NULL
WHERE industry = '';

UPDATE layoffs3 t1
JOIN layoffs3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE  t1.industry IS NULL
AND   t2.industry IS NOT NULL;


SELECT *
FROM layoffs3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE 
FROM layoffs3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;






































