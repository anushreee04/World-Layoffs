##EXPLORATORY DATA ANAYSIS
#YEAR-WISE TOTAL LAYOFFS
Select year(`date`), sum(total_laid_off)
from layoff_staging2
group by year(`date`) 
order by 1 desc;

#LAYOFFS OVER TIME
SELECT 
  YEAR(`date`) AS `year`,
  MONTH(`date`) AS `month`,
  SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
WHERE YEAR(`date`) IS NOT NULL
  AND MONTH(`date`) IS NOT NULL
GROUP BY YEAR(`date`), MONTH(`date`)
ORDER BY YEAR(`date`), MONTH(`date`);

#OR

with rolling_total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from  layoff_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1
)
select `month`, total_off,
sum(total_off) over(order by `month`) as Rolling_Total
from rolling_total;

#TOP 10 COUNTRIES BY LAYOFF
SELECT 
  country, 
  SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY country
ORDER BY total_layoffs DESC
LIMIT 10;

#TOP COMPANIES BY LAYOFF
SELECT 
  company, 
  SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;

#COMPANY-WISE YEARLY LAYOFFS
Select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company, year(`date`)
order by 3 desc;

#INDUSTRY BY LAYOFF
SELECT 
  industry, 
  COUNT(DISTINCT company) AS companies_affected,
  SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY industry
ORDER BY total_layoffs DESC;

##ADVANCED ANALYSIS
#TOTAL LAYOFF V/S FUNDING
SELECT 
  company, 
  funds_raised_millions, 
  AVG(total_laid_off) AS avg_total_laid_off
FROM layoff_staging2
WHERE funds_raised_millions IS NOT NULL
GROUP BY company, funds_raised_millions
ORDER BY avg_total_laid_off DESC;

#IDENTIFY MASS LAYOFF EVENTS
SELECT *
FROM layoff_staging2
WHERE total_laid_off >= 50
ORDER BY total_laid_off DESC;

#WHICH STAGE COMPANIES ARE AFFECTED THE MOST>
SELECT 
  stage, 
  COUNT(*) AS num_events, 
  SUM(total_laid_off) AS total_layoffs
FROM layoff_staging
GROUP BY stage
ORDER BY total_layoffs DESC;

#TOP 5 COMPANIES WITH HIGHEST LAYOFFS PER YEARS
with com_year (company, `year`, total_laid_off) as 
(
Select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company, year(`date`)
),
com_year_rank as
(
select *, dense_rank() over(partition by `year` order by total_laid_off desc) as ranking
from com_year
where `year` is not null
)
select *
from com_year_rank
where ranking<=5;
