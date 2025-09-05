# 📊 Superstore SQL Analytics Project

## 📌 Overview
This project analyzes the **Superstore dataset** using PostgreSQL to uncover key insights into sales, profitability, discounts, shipping, and customer behavior.  

The goal is to showcase SQL skills in:  
- Writing clean, well-structured queries  
- Using aggregations, grouping, and basic window functions  
- Extracting actionable business insights from raw data  

**Stack:** PostgreSQL + VS Code  
**Dataset:** Sample Superstore orders dataset (~10k+ rows, 4 years of transactions)  

---

## 🎯 Business Questions Answered
1. How do sales, profit, and order volume trend over time?  
2. Which products and customers drive the most revenue?  
3. Which regions and categories are most profitable?  
4. Are discounts helping or hurting profit margins?  
5. Which customer segments and categories deliver the most value?  
6. How has sales growth performed year-over-year by category?  

---

## 📂 Project Structure

01_exploration.sql -- sanity checks, profiling the dataset
02_core_queries.sql -- main business analysis queries
03_advanced_queries.sql-- optional learning: ranking, running totals, YoY
README.md -- project write-up


---

## 🔑 Key Insights

### 📈 Sales Trends
- Sales grew from ~$162K in 2014 to ~$272(**108% growth overall**).  
- Monthly analysis showed spikes in **November–December**.  
- Profit margins dipped in **July 2021 and January 2022** due to heavier discounting.  

### 🏆 Top Customers
- The top 10 customers contributed ~ $158K of ~ $2.3M total revenue.  
- Example top customers: **Sean Miller,Tamara Chand,Hunter Lopez**.  
- Some top customers had strong margins, while others were heavily discount-driven.  

### 📦 Category & Sub-Category Insights
- **[Furnishings]** had the highest revenue (~[10.8]% of sales).  
- **[Labels]** achieved the strongest profit margin (~ 43%).  
- Sub-categories like **[Appliences]** delivered strong profit, while **[Fasteners]** underperformed despite high sales.  

### 💰 Discounts
- Average discounts varied by category:  
  - **Furniture** ~17.3%  
  - **Office Supplies** ~15.6%  
  - **Technology** ~13.2%  
 

### 🌍 Regional Insights
- **West** generated the most revenue.  
- **West** also delivered stronger relative margins.  
- Regional differences highlight opportunities for tailored strategies.  

### 📊 YoY Growth by Category
- **Office Supplies** grew consistently YoY  
- **Furniture and Technology** slowed or declined in **2024**.  

---

Advance queries were included as part of my learning journey — not daily skills yet, but a way to demonstrate curiosity and growth beyond the fundamentals.  

---

## 🧰 Skills Demonstrated
- SQL queries with `GROUP BY`, `HAVING`, and conditional logic  
- Use of window functions for ranking and growth calculations  
- Data profiling and quality checks before analysis  
- Translating SQL results into **business-focused insights**  

---

## 🚀 Next Steps
- Expand analysis with customer segmentation (RFM or repeat behavior).  
- Build a visualization dashboard (Looker Studio or Tableau) for interactive exploration.  
- Apply the same workflow to other datasets (e-commerce, HR, finance).  

---

✨ **Takeaway for recruiters:** This project demonstrates that I can structure a SQL analysis workflow end-to-end — from data profiling → business queries → insights — while also showing initiative to grow beyond entry-level fundamentals.
