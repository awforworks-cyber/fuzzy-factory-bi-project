# Fuzzy Factory BI Project

End-to-end business intelligence project analyzing multi-table e-commerce data with SQL, Excel, Python, and Power BI to evaluate marketing performance, product sales, profitability, and refund behavior.

## Project Objective
Build a business intelligence solution that turns raw e-commerce data into decision-ready reporting for sales, marketing, and operations leaders by cleaning the data, joining multiple tables, defining KPIs, and presenting insights in a dashboard.

## Stakeholder
Director of E-Commerce / Growth & Operations Manager

## Business Questions
- Which traffic sources, campaigns, and devices drive the most sessions, orders, and revenue?
- Which products generate the most sales, gross profit, and refund exposure?
- How do orders, conversion, revenue, and refund behavior change over time?
- How do repeat sessions compare with new sessions in terms of order behavior and value?
- Where are the biggest opportunities to improve performance or reduce refund risk?

## Dataset
This project uses multi-table e-commerce data including:
- `website_sessions` for traffic source, campaign, device type, and repeat session behavior.
- `orders` for order-level revenue, cost, item count, primary product, and session linkage.
- `order_items` for line-item product detail and bundle analysis.
- `order_item_refunds` for refund behavior and refund amount tracking.
- `products` for product reference information.

## Tools Used
- SQL for data loading, cleaning, joins, KPI creation, and window functions
- Excel for lookups, pivot tables, and business-friendly reporting
- Python (Pandas, NumPy, Matplotlib, Seaborn) for validation and exploratory analysis
- Power BI for data modeling and dashboard development

## Planned Workflow
1. Define stakeholder needs, project objectives, and business questions.
2. Review the source data and perform exploratory data analysis.
3. Load raw files into SQL and validate keys, relationships, and data quality issues.
4. Clean and prepare analysis-ready tables.
5. Build SQL queries for KPIs, joins, and time-based analysis.
6. Export clean extracts for Excel analysis and reporting.
7. Use Python to validate results and explore trends.
8. Create a Power BI dashboard for executive reporting.
9. Document findings, recommendations, and limitations.

## Repository Structure
- `data/raw/` – original source files
- `data/clean/` – cleaned extracts and reporting tables
- `sql/` – SQL scripts for loading, cleaning, joins, and analysis
- `excel/` – Excel files with lookups and pivot tables
- `notebooks/` – Jupyter notebooks for Python validation and EDA
- `powerbi/` – Power BI files
- `images/` – dashboard screenshots
- `docs/` – project plan, KPI definitions, cleaning log, and other documentation