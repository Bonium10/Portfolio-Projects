-- Exploratory Data Analysis

select *
from layoffs_staging2;


-- Looking at Percentage to see how big these layoffs were

select max(percentage_laid_off),  min(percentage_laid_off)
from layoffs_staging2
where  percentage_laid_off is not null;


-- Which companies had 1 which is basically 100 percent of the company laid off

select *
from layoffs_staging2
where percentage_laid_off =1;
-- these are mostly startups it looks like who all went out of business during this time


-- If we order by funds_raised_millions we can see how big some of these companies were

select *
from layoffs_staging2
where percentage_laid_off =1
order by funds_raised_millions desc;


-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoffs_staging
ORDER BY 2 DESC;

-- Companies with the most Total Layoffs

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- By location

select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by 2 desc;

select *
from layoffs_staging2;

-- Total laid off in past years on the dataset

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;



-- Rolling Total of Layoffs Per Month

select substring(`date`, 1,7) as `Month`, sum(total_laid_off) as Total_laid_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc;


-- now use it in a CTE so we can query off of it

with Rolling_total as
(
select substring(`date`, 1,7) as `Month`, sum(total_laid_off) as Total_laid_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`, Total_laid_off,
sum(Total_laid_off) over(order by `Month`) as rolling_total
from Rolling_total;

-- Companies that laid off the most per year

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(select *, 
dense_rank() over (partition by years order by total_laid_off desc) as  Ranking
from company_year
where years is not null
)
select *
from company_year_rank
where Ranking <= 5;






