CREATE SCHEMA IF NOT EXISTS analytics;
SET search_path TO analytics, public;

-- Purpose: key performance indicators (KPIs) summary
-- Table: public.superstore
   ========================================================== */
CREATE OR REPLACE VIEW analytics.kpi AS
SELECT
  COUNT(DISTINCT order_id)      AS orders,
  COUNT(DISTINCT customer_name) AS customers,
  ROUND(SUM(sales)::numeric,2)  AS total_sales,
  ROUND(SUM(profit)::numeric,2) AS total_profit,
  ROUND(100.0 * SUM(profit)/NULLIF(SUM(sales),0),2) AS profit_margin_pct,
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date
FROM public.superstore; 
--========================================================= */
-- Saniyty check
-- Purpose: verify view creation
--========================================================= */
SELECT COUNT(*) AS rows_in_table
FROM public.superstore;

SELECT * FROM analytics.kpi;
--========================================================= */
-- Monthly trend view
-- Purpose: monthly sales with running totals + % of annual total
-- Table: public.superstore
--========================================================= */
CREATE OR REPLACE VIEW analytics.monthly_perf AS
SELECT
  DATE_TRUNC('month', order_date)::date AS month,
  ROUND(SUM(sales)::numeric,2)         AS sales,
  ROUND(SUM(profit)::numeric,2)        AS profit,
  ROUND(100.0 * SUM(profit)/NULLIF(SUM(sales),0),2) AS margin_pct
FROM public.superstore
GROUP BY 1
ORDER BY 1;
--========================================================= */
-- Category/sub-category performance view
-- Purpose: sales and profit by product category
-- Table: public.superstore
CREATE OR REPLACE VIEW analytics.cat_subcat AS
SELECT
  category,
  "sub_category" AS subcategory,
  ROUND(SUM(sales)::numeric,2)  AS sales,
  ROUND(SUM(profit)::numeric,2) AS profit,
  ROUND(100.0 * SUM(profit)/NULLIF(SUM(sales),0),2) AS margin_pct
FROM public.superstore
GROUP BY 1,2;
--========================================================= */
-- Top customers view
-- Purpose: top customers by sales and profit
-- Table: public.superstore
--========================================================= */
DROP VIEW IF EXISTS analytics.top_customers;
CREATE VIEW analytics.top_customers AS
SELECT
  customer_name,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SUM(sales)::numeric,2)  AS sales,
  ROUND(SUM(profit)::numeric,2) AS profit
FROM public.superstore
GROUP BY customer_name;
--========================================================= */
-- Discount imoact view
-- Purpose: sales and profit by discount level
-- Table: public.superstore
--========================================================= */
CREATE OR REPLACE VIEW analytics.discount_buckets AS
WITH b AS (
  SELECT
    CASE
      WHEN discount < 0.05 THEN '0–4%'
      WHEN discount < 0.15 THEN '5–14%'
      WHEN discount < 0.30 THEN '15–29%'
      ELSE '30%+'
    END AS discount_bucket,
    sales, profit
  FROM public.superstore
)
SELECT
  discount_bucket,
  ROUND(SUM(sales)::numeric,2)  AS sales,
  ROUND(SUM(profit)::numeric,2) AS profit,
  ROUND(100.0 * SUM(profit)/NULLIF(SUM(sales),0),2) AS margin_pct
FROM b
GROUP BY 1
ORDER BY
  CASE discount_bucket
    WHEN '0–4%' THEN 1 WHEN '5–14%' THEN 2 WHEN '15–29%' THEN 3 ELSE 4
  END;
--========================================================= */
-- Region/Segment performance view
-- Purpose: sales and profit by region and customer segment
-- Table: public.superstore
--========================================================= */
CREATE OR REPLACE VIEW analytics.region_segment AS
SELECT
  region,
  segment,
  ROUND(SUM(sales)::numeric,2)  AS sales,
  ROUND(SUM(profit)::numeric,2) AS profit,
  ROUND(AVG(discount)::numeric,4) AS avg_discount,
  ROUND(100.0 * SUM(profit)/NULLIF(SUM(sales),0),2) AS margin_pct
FROM public.superstore
GROUP BY 1,2;


