# Project Plan

## Project Title

Fuzzy Factory E-Commerce Business Intelligence Project

## Project Overview

This project builds an end-to-end business intelligence solution using six related e-commerce tables. The goal is to transform raw website session, pageview, order, product, and refund data into decision-ready reporting that helps business leaders evaluate marketing effectiveness, website funnel performance, product performance, profitability, and refund risk.

## Primary Stakeholder

Director of E-Commerce / Growth & Operations Manager

## Stakeholder Context

This stakeholder is responsible for understanding how marketing activity translates into website sessions, page engagement, orders, revenue, and profit while also monitoring product-level performance and refund behavior. The dataset includes acquisition fields, campaign fields, device type, pageview URLs, order-level revenue and cost, product-level item detail, and refund data.

This combination supports realistic questions about whether marketing brings in valuable traffic, whether visitors progress through key web pages, which products generate profit, and where refunds create risk.

## Stakeholder Needs

The stakeholder needs reporting that can help answer:

- Which acquisition channels and campaigns bring in the most valuable traffic?
- Which landing pages and website pages support stronger conversion?
- Which devices perform better in terms of conversion and average order value?
- Which products drive revenue, gross profit, and refund exposure?
- How do new and repeat sessions differ in quality and behavior?
- Which trends require action from marketing, merchandising, product, or operations teams?

## Business Objective

Build a reporting solution that connects marketing, website behavior, product, and order data into a single view of performance so the stakeholder can identify where growth is strong, where website funnels underperform, where profitability is weak, and where refunds create risk.

## Business Questions

### Marketing and Traffic

- Which `utm_source`, `utm_campaign`, and `utm_content` combinations drive the most sessions, orders, and revenue?
- Which `device_type` performs best for conversion and average order value?
- Which traffic sources bring higher-value or lower-value users?
- How do untagged or direct sessions compare with tagged campaign traffic?

### Website and Funnel Performance

- Which `pageview_url` values receive the most traffic?
- Which pages are the most common landing pages?
- How do conversion rates vary by landing page?
- Which page sequences or key funnel pages appear most associated with completed orders?
- Are there meaningful differences in page-level behavior by campaign, device type, or repeat-session status?

### Sales and Product Performance

- Which products generate the highest revenue and gross profit?
- How does `primary_product_id` compare with line-item product behavior from `order_items`?
- Which products are most frequently associated with bundled purchases or additional items?
- Which products contribute the most to total orders and items purchased?

### Refund and Risk Analysis

- Which products have the highest refund amount and refund frequency?
- Are refunds concentrated in certain products, periods, or order patterns?
- How much revenue is offset by refunds at the product or order level?
- How do refunds affect realized revenue and profitability?

### Customer and Session Behavior

- How do repeat sessions compare with first-time sessions in conversion, revenue, and order value?
- Are certain channels or devices associated with stronger repeat behavior?
- Do pageviews per session differ between converting and non-converting sessions?

### Trend Analysis

- How do sessions, pageviews, orders, revenue, gross profit, and refunds change over time?
- Which periods show major performance shifts that deserve business attention?
- Do page-level funnel metrics change over time?

## Data Sources

This project uses the following source tables:

- `website_sessions`
- `website_pageviews`
- `orders`
- `order_items`
- `order_item_refunds`
- `products`

## Expected Relationships

The analysis will rely on these relationships:

- `website_sessions.website_session_id` to `website_pageviews.website_session_id`
- `website_sessions.website_session_id` to `orders.website_session_id`
- `orders.order_id` to `order_items.order_id`
- `order_items.product_id` to `products.product_id`
- `order_items.order_item_id` to `order_item_refunds.order_item_id`
- `orders.order_id` to `order_item_refunds.order_id`
- `website_sessions.user_id` to `orders.user_id` for behavior comparisons where useful

## Project Scope

The first version of the project will focus on:

- Marketing channel and campaign performance
- Landing-page and high-level funnel performance
- Device-level behavior
- Product sales and gross profit
- Refund analysis
- Session, pageview, and order trends over time
- Repeat versus new session behavior
- KPI development in SQL and Power BI

The first version will not focus on:

- Predictive modeling
- Advanced customer lifetime value modeling
- Full clickstream reconstruction
- Complex sequence modeling across every possible page path

## EDA Plan

The exploratory data analysis phase will answer:

- How many rows and columns are in each table?
- What date range does each table cover?
- Are there missing values in important fields?
- Are there duplicated rows?
- Are primary key fields complete and unique?
- Are there orphaned foreign keys across expected joins?
- Do prices, COGS, and refund amounts look reasonable?
- How complete are joins between sessions, pageviews, orders, items, products, and refunds?
- Which pages are most frequently viewed?
- How many pageviews occur per session?

## Data Cleaning and Preparation Plan

The cleaning phase will include:

1. Review all field names and confirm data types.
2. Convert all `created_at` fields to datetime format.
3. Check primary key uniqueness in each table.
4. Validate foreign key relationships across all tables.
5. Investigate nulls and determine whether to remove, keep, categorize, or flag them.
6. Check for duplicate rows or duplicate transactional records.
7. Standardize null marketing fields:
   - Categorize missing UTM fields as `untagged`, `direct`, `organic`, or `unknown`, according to documented business rules.
   - Preserve null `http_referer` values where source information is unavailable.
8. Create derived fields such as:
   - Gross profit = revenue minus COGS
   - Net revenue = revenue minus refund amount
   - Average order value
   - Refund rate
   - Conversion rate
   - Items per order
   - Pageviews per session
   - Landing page
9. Create cleaned analytical tables or views for downstream reporting.

## SQL Plan

SQL is the main technical proof area of the project.

### SQL Goals

- Load raw CSV files into a relational database.
- Build staging tables for all six source files.
- Profile and validate each table.
- Join multiple tables for unified reporting.
- Build KPI summary queries.
- Create reusable views or summary tables.
- Use window functions to show analytical depth.
- Create page-level funnel and landing-page analysis queries.

### SQL Skills to Demonstrate

- `INNER JOIN` and `LEFT JOIN`
- `GROUP BY` aggregations
- `CASE` expressions
- Common Table Expressions (CTEs)
- Window functions, including:
  - `RANK()`
  - `ROW_NUMBER()`
  - `SUM() OVER()`
  - `LAG()`
- Date functions for weekly and monthly trend analysis
- Conditional aggregation for funnel metrics

### Example SQL Use Cases

- Rank products by revenue, gross profit, refund amount, or refund rate.
- Compute running monthly revenue and gross profit.
- Compare month-over-month performance.
- Sequence orders by user to identify repeat behavior.
- Compare campaign and device performance.
- Identify top landing pages.
- Compare conversion rates by landing page.
- Measure pageviews per session and compare converting versus non-converting sessions.
- Create a basic page funnel using selected key URLs.

## Azure Data Factory Plan

Azure Data Factory will provide the ingestion and orchestration layer.

### Pipeline Goal

Create a reusable pipeline that copies the six raw CSV files into Azure SQL staging tables:

- `website_sessions`
- `website_pageviews`
- `orders`
- `order_items`
- `order_item_refunds`
- `products`

### Pipeline Design

- Source: raw CSV files in the repository or Azure Blob Storage.
- Activity: Copy Data activity.
- Destination: Azure SQL staging tables.
- Control: Validate row counts after ingestion.
- Version control: Store ADF artifacts in the GitHub repository under the `adf/` folder.

### Portfolio Value

The pipeline demonstrates a practical ELT pattern:

1. Ingest raw source data with Azure Data Factory.
2. Store structured staging data in Azure SQL.
3. Transform and model data using SQL.
4. Build dashboards in Power BI.

## Excel Plan

Excel will be used to show business-user reporting skills after SQL cleaning is complete.

### Excel Skills to Demonstrate

- XLOOKUP or VLOOKUP
- Pivot tables
- Filters and slicers
- Conditional formatting
- Basic validation and summary views

### Example Excel Outputs

- Revenue by month and channel pivot table
- Product summary pivot table
- Refund summary by product
- Landing-page performance summary
- Lookup-based enrichment of reporting tables
- A stakeholder-facing summary tab

## Python Plan

Python will be used as a supporting validation and exploration tool, not the center of the project.

### Python Skills to Demonstrate

- Pandas for data review and validation
- NumPy for numerical checks
- Matplotlib and Seaborn for exploratory charts
- Jupyter notebook documentation of validation steps

### Python Use Cases

- Validate raw files before SQL ingestion.
- Validate SQL outputs against raw or intermediate datasets.
- Profile missing values, duplicate rows, primary keys, and foreign keys.
- Explore value distributions before KPI design.
- Review pageview volume and page-level patterns.
- Check for unusual patterns or outliers.

## Data Modeling Plan

The Power BI model will use a star-schema-style structure where possible.

### Candidate Fact Tables

- `fact_sessions`
- `fact_pageviews`
- `fact_orders`
- `fact_order_items`
- `fact_refunds`

### Candidate Dimension Tables

- `dim_products`
- `dim_date`
- `dim_traffic_source`
- `dim_device`
- `dim_pages`

### Modeling Questions to Be Ready For

- Why was a certain fact grain chosen?
- Why are session-level, pageview-level, order-level, and item-level facts separated?
- How were refunds handled in the model?
- How are pageviews connected to sessions without duplicating order revenue?
- Why is this structure better than one flattened table?

## KPI Framework

The project will define, calculate, and document the following KPIs:

- Sessions
- Pageviews
- Pageviews per session
- Orders
- Conversion rate
- Revenue
- Net revenue
- Gross profit
- Average order value
- Items per order
- Refund amount
- Refund rate
- Repeat session share
- Landing-page conversion rate

Each KPI should include:

- A formula
- A grain
- A business purpose
- Assumptions used
- Source tables or fields

## Dashboard Plan

The final Power BI dashboard should include four pages.

### 1. Executive Overview

- Sessions
- Pageviews
- Orders
- Conversion rate
- Revenue
- Net revenue
- Gross profit
- Average order value
- Monthly trends
- Core filters

### 2. Channel and Session Performance

- Traffic-source performance
- Campaign performance
- Device comparison
- New versus repeat session behavior
- Conversion rate by channel and device
- Revenue by channel

### 3. Website Funnel Performance

- Top landing pages
- Most-viewed pages
- Pageviews per session
- Conversion rate by landing page
- Key page funnel metrics
- Page performance by device or campaign

### 4. Product and Refund Analysis

- Product revenue
- Product gross profit
- Refund amount and refund rate
- Top and bottom product performers
- Product performance trends

## Documentation Plan

The repository should include:

- `README.md`
- `docs/project_plan.md`
- `docs/data_dictionary.md`
- `docs/cleaning_log.md`
- `docs/kpi_definitions.md`
- `sql/` scripts
- `adf/` pipeline artifacts
- `notebooks/` Jupyter notebooks
- `data/raw/` source CSV files, where appropriate for repository size and licensing
- Excel workbook
- Power BI file
- Dashboard screenshots

## Deliverables

The final portfolio deliverables should be:

- A public GitHub repository with organized folders.
- Clean SQL scripts for table creation, loading, validation, transformations, and KPI analysis.
- Azure Data Factory pipeline artifacts stored in GitHub.
- A documented Jupyter notebook showing EDA and data-quality validation.
- An Excel file showing lookups and pivot tables.
- A Power BI dashboard with executive, channel, funnel, product, and refund views.
- A README that leads with the business problem, technical architecture, results, and recommendations.
- Supporting documentation that explains project decisions, data-quality findings, KPI formulas, and limitations.

## Risks and Assumptions

- UTM and referer fields contain missing values, so some traffic attribution is incomplete.
- Refund analysis requires careful matching at both order and order-item level.
- Session, pageview, order, and refund timestamps require standardization before time-based analysis.
- Pageview data supports high-level funnel analysis but does not necessarily provide a complete customer journey across every possible path.
- Some conclusions may be directional rather than definitive because the dataset is historical and limited to available fields.

## Interview Preparation Goals

By the end of the project, be ready to explain:

- Why this stakeholder was chosen.
- Why the business questions matter.
- How the six tables relate to each other.
- Why pageviews are analyzed separately from sessions and orders.
- What data-quality issues were found.
- How SQL joins supported analysis.
- How Azure Data Factory, Azure SQL, SQL, and Power BI work together.
- How window functions added business insight.
- Why Excel was used after SQL.
- How the Power BI model was structured.
- What recommendations were identified.
- What limitations remained in the analysis.

## Build Order

1. Finalize stakeholder and business questions.
2. Review the data dictionary and inspect raw files.
3. Complete EDA and document data-quality findings.
4. Load all six source tables into Azure SQL staging tables.
5. Build and test the Azure Data Factory ingestion pipeline.
6. Clean and prepare SQL analytical tables or views.
7. Build KPI queries and summary views.
8. Perform page-level and funnel analysis.
9. Export reporting extracts for Excel.
10. Validate outputs in Jupyter notebooks.
11. Build the Power BI model and dashboard.
12. Write final documentation, business insights, and recommendations.
13. Update resume bullets using completed project outcomes.