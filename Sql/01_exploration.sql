/* ==========================================================
   01_exploration.sql
   Purpose: sanity checks & data profiling
   Table: public.superstore
   ========================================================== */

/* 1) Total row count */
SELECT COUNT(*) AS total_rows
FROM public.superstore;

/* 2) Peek at first 10 rows */
SELECT *
FROM public.superstore
LIMIT 10;

/* 3) Date range */
SELECT 
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date
FROM public.superstore;

/* 4) Missing values in key fields */
SELECT
  COUNT(*) FILTER (WHERE order_date IS NULL) AS missing_order_date,
  COUNT(*) FILTER (WHERE sales IS NULL)      AS missing_sales,
  COUNT(*) FILTER (WHERE profit IS NULL)     AS missing_profit,
  COUNT(*) FILTER (WHERE customer_id IS NULL)AS missing_customer_id
FROM public.superstore;

/* 5) Unique counts (granularity check) */
SELECT 
  COUNT(DISTINCT order_id)    AS unique_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT product_id)  AS unique_products
FROM public.superstore;

/* 6) Overall sales, profit, avg discount */
SELECT 
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(AVG(discount)*100,2) AS avg_discount_pct
FROM public.superstore;

/* 7) Orders per category (composition) */
SELECT category, COUNT(*) AS order_lines
FROM public.superstore
GROUP BY category
ORDER BY order_lines DESC;

/* 8) Shipping sanity: avg days to ship + oddities */
SELECT
  ship_mode,
  ROUND(AVG(EXTRACT(DAY FROM (ship_date - order_date))),2) AS avg_days_to_ship,
  SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END)  AS illogical_shipments
FROM public.superstore
GROUP BY ship_mode
ORDER BY avg_days_to_ship;
