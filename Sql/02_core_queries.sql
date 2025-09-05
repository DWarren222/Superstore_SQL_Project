/* ==========================================================
   02_core_queries.sql
   Purpose: business analysis queries (recruiter-facing)
   Table: public.superstore
   ========================================================== */

/* sanity: row count each run */
SELECT COUNT(*) AS total_rows
FROM public.superstore;

/* 1) Sales, profit, orders by year (with margin) */
SELECT
  EXTRACT(YEAR FROM order_date)::int AS order_year,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SUM(sales),2)      AS total_sales,
  ROUND(SUM(profit),2)     AS total_profit,
  ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM public.superstore
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

/* 2) Monthly sales & profit trend */
SELECT
  DATE_TRUNC('month', order_date)::date AS order_month,
  ROUND(SUM(sales),2)  AS monthly_sales,
  ROUND(SUM(profit),2) AS monthly_profit
FROM public.superstore
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

/* 3) Top 10 products by revenue */
SELECT
  product_name,
  ROUND(SUM(sales),2)  AS revenue,
  ROUND(SUM(profit),2) AS profit
FROM public.superstore
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

/* 4) Top customers by sales & profit (+margin & orders) */
SELECT
  customer_id,
  customer_name,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM public.superstore
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC, total_profit DESC
LIMIT 10;

/* 4a) % of total revenue contributed by top 10 customers (one-shot) */
WITH overall AS (
  SELECT SUM(sales) AS total_sales FROM public.superstore
),
top10 AS (
  SELECT customer_id, customer_name, SUM(sales) AS customer_sales
  FROM public.superstore
  GROUP BY customer_id, customer_name
  ORDER BY customer_sales DESC
  LIMIT 10
)
SELECT
  ROUND(SUM(customer_sales),2) AS top10_sales,
  ROUND(SUM(customer_sales)/o.total_sales*100,2) AS pct_of_total_sales
FROM top10
CROSS JOIN overall o;

/* 5) Profit margin by region & category */
SELECT
  region,
  category,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM public.superstore
GROUP BY region, category
ORDER BY region, category;

/* 6) Average discount by category (for README “Discounts”) */
SELECT
  category,
  ROUND(AVG(discount)*100,2) AS avg_discount_pct
FROM public.superstore
GROUP BY category
ORDER BY avg_discount_pct DESC;

/* 7) Sub-category margins — best 10 */
SELECT
  sub_category,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM public.superstore
GROUP BY sub_category
HAVING SUM(sales) > 0
ORDER BY profit_margin_pct DESC
LIMIT 10;

/* 7a) Sub-category margins — worst 10 (risk) */
SELECT
  sub_category,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM public.superstore
GROUP BY sub_category
HAVING SUM(sales) > 0
ORDER BY profit_margin_pct ASC
LIMIT 10;

/* 8) Regional totals (revenue/profit/margin) for README bullets */
SELECT
  region,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100,2) AS profit_margin_pct
FROM public.superstore
GROUP BY region
ORDER BY total_sales DESC;
