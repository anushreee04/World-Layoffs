##DATA CLEANING

# REMOVE DUPLICATE
# STANDARDIZE DATA
# DEAL WITH NULL VALUES
# REMOVE UNWANTED ROW/COLUMNS


select* 
from layoffs;

#NEVER WORK WITH ORIGINAL DATA

create table layoff_staging
like layoffs;

insert layoff_staging
select* 
from layoffs;

select*
from layoff_staging;

#REMOVE DUPLICATES (easier when there is unique id)
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`
) as row_num
from layoff_staging;

with duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoff_staging
)
select *
from duplicate_cte
where row_num>1;

select *
from layoff_staging
where company= 'Cazoo';

# NEW TABLE WITH ROW NUMBER COLOUMN TO REMOVE DUPLICATES
CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoff_staging2; 

insert into layoff_staging2
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`
) as row_num
from layoff_staging;

select *
from layoff_staging2
where row_num>1; 

delete
from layoff_staging2
where row_num>1; 

select *
from layoff_staging2;

#STANDARDIZE THE DATA
select company, trim(company)
from layoff_staging2;

update layoff_staging2
set company= trim(company);

select distinct industry
from layoff_staging2
order by 1;

select *
from layoff_staging2
where industry like "Crypto%";

update layoff_staging2
set industry ="Crypto"
where industry like "Crypto%";

select distinct country
from layoff_staging2
order by 1;

update layoff_staging2
set country ="United States"
where country like "United States%";

#OR
select distinct country, trim( trailing '.' from country)
from layoff_staging2
order by 1;

select `date`,
str_to_date(`date`, '%m/%d/%Y' )
from layoff_staging2; 

update layoff_staging2
set `date`= str_to_date(`date`, '%m/%d/%Y' );

alter table layoff_staging2
modify column `date` date;

#NULL/BLANK VALUES
select *
from layoff_staging2
where total_laid_off is NULL
and percentage_laid_off is NUll;

select *
from layoff_staging2
where industry is null
or industry="";

select *
from layoff_staging2
where company="Airbnb";

update layoff_staging2
set industry=null
where industry="";

select t1.industry, t2.industry
from layoff_staging2 t1
join layoff_staging2 t2
	on t1.company=t2.company
    and t1.location=t2.location
where (t1.industry is null )
and t2.industry is not null ;

update layoff_staging2 t1
join layoff_staging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null ;

select *
from layoff_staging2
where industry is null
or industry="";

select *
from layoff_staging2
where company like "Bally%";

#REMOVE UNWANTED ROW COLOUMNS
#we have no use of rows where noth percentage and total laid off are missing
select *
from layoff_staging2
where total_laid_off is NULL
and percentage_laid_off is NUll;

delete
from layoff_staging2
where total_laid_off is NULL
and percentage_laid_off is NUll;

--
select *
from layoff_staging2;

#we don't need row_num anymore

alter table layoff_staging2
drop column row_num;

