--select all
select * from evening_class.international_debt_with_missing_values idwmv 

-- Total amount of debt owned by all countries
select sum(debt) as total_sum from evening_class.international_debt_with_missing_values; 
-- distinct types of indicators and what they mean
select distinct indicator_name from evening_class.international_debt_with_missing_values;
--How many distinct countries are recorded in the dataset?
select count(distinct country_name) from evening_class.international_debt_with_missing_values idwmv 
--Which country has the highest total debt, and how much does it owe?

select country_name,sum(debt) as total_debt from evening_class.international_debt_with_missing_values
group by country_name
order by sum(debt) desc
limit 1;

SELECT COALESCE(NULLIF(country_name, '')) AS country_name,SUM(debt ) as total_debt
FROM evening_class.international_debt_with_missing_values
where country_name <> ''
GROUP BY country_name
ORDER BY total_debt desc;

SELECT country_name, SUM(debt) AS total_debt
FROM evening_class.international_debt_with_missing_values
WHERE country_name IS NOT NULL AND TRIM(country_name) <> ''
GROUP BY country_name
ORDER BY total_debt desc;

select country_name, sum(debt) from evening_class.international_debt_with_missing_values 
group by country_name
having length(country_name)>0
order by sum(debt) desc;

--What is the average debt across different debt indicators?
SELECT indicator_name, AVG(debt) AS avg_debt
FROM evening_class.international_debt_with_missing_values idwmv
GROUP BY indicator_name
ORDER BY avg_debt desc;

--Which country has made the highest amount of principal repayments?
SELECT country_name, SUM(debt) AS total_principal_repayments
FROM evening_class.international_debt_with_missing_values idwmv
WHERE 
  (
    indicator_name = 'Principal repayments on external debt, long-term (AMT, current US$)' 
    OR indicator_name = 'Principal repayments on external debt, private nonguaranteed (PNG) (AMT, current US$)'
  )
  AND country_name IS NOT NULL
  AND TRIM(country_name) <> ''
GROUP BY country_name 
ORDER BY total_principal_repayments asc
LIMIT 1;

--What is the most common debt indicator across all countries - Using rank
WITH indicator_counts AS (
    SELECT 
        country_name,
        indicator_name,
        COUNT(*) AS frequency,
        RANK() OVER (PARTITION BY country_name ORDER BY COUNT(*) DESC) AS rank_within_country
    FROM 
        evening_class.international_debt_with_missing_values idwmv 
    WHERE 
        indicator_name IS NOT NULL 
        AND TRIM(indicator_name) <> ''
        AND country_name IS NOT NULL
        AND TRIM(country_name) <> ''
    GROUP BY 
        country_name, indicator_name
)

SELECT 
    country_name,
    indicator_name,
    frequency
FROM 
    indicator_counts
WHERE 
    rank_within_country = 1
ORDER BY 
    country_name;

WITH indicator_counts AS (  --using row)
    SELECT 
        country_name,
        indicator_name,
        COUNT(*) AS frequency
    FROM 
        evening_class.international_debt_with_missing_values idwmv 
    WHERE 
        indicator_name IS NOT NULL 
        AND TRIM(indicator_name) <> ''
        AND country_name IS NOT NULL
        AND TRIM(country_name) <> ''
    GROUP BY 
        country_name, indicator_name
),
ranked_indicators AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY country_name ORDER BY frequency DESC) AS rn
    FROM indicator_counts
)
SELECT 
    country_name,
    indicator_name,
    frequency
FROM 
    ranked_indicators
WHERE rn = 1
ORDER BY country_name;

















--Identify any other key debt trends and summarize your findings.

