/* ==========================================================
   03_advanced_queries.sql
   Purpose: limited “bonus learning” queries you ran
   Focus: running totals; YoY by category
   Table: public.superstore
   ========================================================== */

/* A) Monthly sales with running totals + % of annual total */
WITH monthly AS (
  SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    EXTRACT(YEAR FROM order_date)::int     AS order_year,
    SUM(sales) AS monthly_sales,
    SUM(profit) AS monthly_profit
  FROM public.superstore
  WHERE order_date IS NOT NULL
  GROUP BY 1, 2
),
running AS (
  SELECT
    order_year,
    order_month,
    monthly_sales,
    monthly_profit,
    SUM(monthly_sales)  OVER (PARTITION BY order_year ORDER BY order_month) AS running_sales,
    SUM(monthly_profit) OVER (PARTITION BY order_year ORDER BY order_month) AS running_profit
  FROM monthly
),
yearly AS (
  SELECT order_year, SUM(monthly_sales) AS annual_sales
  FROM monthly
  GROUP BY order_year
)
SELECT
  r.order_year,
  r.order_month,
  ROUND(r.monthly_sales,2)  AS monthly_sales,
  ROUND(r.running_sales,2)  AS running_sales,
  y.annual_sales,
  ROUND(r.running_sales/NULLIF(y.annual_sales,0)*100,2) AS pct_of_year
FROM running r
JOIN yearly y USING (order_year)
ORDER BY r.order_year, r.order_month;

/* (Optional helper) First month each year crossing 50% of annual sales */
WITH base AS (
  SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    EXTRACT(YEAR FROM order_date)::int     AS order_year,
    SUM(sales) AS monthly_sales
  FROM public.superstore
  WHERE order_date IS NOT NULL
  GROUP BY 1, 2
),
rt AS (
  SELECT
    order_year,
    order_month,
    SUM(monthly_sales) OVER (PARTITION BY order_year ORDER BY order_month) AS running_sales
  FROM base
),
yr AS (
  SELECT order_year, SUM(monthly_sales) AS annual_sales
  FROM base
  GROUP BY order_year
),
pct AS (
  SELECT
    rt.order_year,
    rt.order_month,
    rt.running_sales,
    yr.annual_sales,
    rt.running_sales/NULLIF(yr.annual_sales,0) AS pct
  FROM rt
  JOIN yr ON yr.order_year = rt.order_year
)
SELECT order_year, order_month, ROUND(pct*100,2) AS pct_of_year
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY order_year ORDER BY order_month) AS rn50
  FROM pct
  WHERE pct >= 0.50
) x
WHERE rn50 = 1
ORDER BY order_year;

/* B) YoY sales growth by category */
WITH yearly AS (
  SELECT
    EXTRACT(YEAR FROM order_date)::int AS order_year,
    category,
    SUM(sales) AS total_sales
  FROM public.superstore
  WHERE order_date IS NOT NULL
  GROUP BY 1, 2
),
yoy AS (
  SELECT
    order_year,
    category,
    total_sales,
    LAG(total_sales) OVER (PARTITION BY category ORDER BY order_year) AS prior_year_sales
  FROM yearly
)
SELECT
  order_year,
  category,
  total_sales,
  prior_year_sales,
  ROUND((total_sales - prior_year_sales)/NULLIF(prior_year_sales,0)*100,2) AS yoy_growth_pct
FROM yoy
ORDER BY category, order_year;
