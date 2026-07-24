# Project Plan

## Project Title
Fuzzy Factory E-Commerce Business Intelligence Project

## Project Overview
This project will build an end-to-end business intelligence solution using multi-table e-commerce data. The goal is to transform raw website session, order, product, and refund data into decision-ready reporting that helps business leaders evaluate marketing effectiveness, product performance, profitability, and refund risk.

## Primary Stakeholder
Director of E-Commerce / Growth & Operations Manager

## Stakeholder Context
This stakeholder is responsible for understanding how marketing activity translates into sessions, orders, revenue, and profit while also monitoring product-level performance and refund behavior. Because the dataset includes traffic source fields, campaign fields, device type, order-level revenue and cost, product-level item detail, and refund data, it supports the type of questions this stakeholder would realistically ask.

## Stakeholder Needs
The stakeholder needs reporting that can help answer:
- Which acquisition channels and campaigns bring in the most valuable traffic?
- Which devices perform better in terms of conversion and average order value?
- Which products drive revenue, gross profit, and refund exposure?
- How do new and repeat sessions differ in quality and behavior?
- Which trends require action from marketing, merchandising, or operations teams?

## Business Objective
Build a reporting solution that connects marketing, product, and order data into a single view of performance so the stakeholder can identify where growth is strong, where profitability is weak, and where refunds are creating risk.

## Business Questions
### Marketing and Traffic
- Which `utm_source`, `utm_campaign`, and `utm_content` combinations drive the most sessions, orders, and revenue?
- Which `device_type` performs best for conversion and average order value?
- Which traffic sources appear to bring higher-value or lower-value users?

### Sales and Product Performance
- Which products generate the highest revenue and gross profit?
- How does `primary_product_id` compare with line-item product behavior from `order_items`?
- Which products are most frequently associated with bundled purchases or additional items?

### Refund and Risk Analysis
- Which products have the highest refund amount and refund frequency?
- Are refunds concentrated in certain products, periods, or order patterns?
- How much revenue is being offset by refunds at the product or order level?

### Customer and Session Behavior
- How do repeat sessions compare with first-time sessions in conversion, revenue, and order value?
- Are there signs that certain channels or devices drive stronger repeat behavior?

### Trend Analysis
- How do sessions, orders, revenue, gross profit, and refunds change over time?
- Which periods show major performance shifts that deserve business attention?

## Data Sources
This project uses the following source tables:
- `website_sessions`
- `orders`
- `order_items`
- `order_item_refunds`
- `products`

## Expected Relationships
The analysis will likely rely on these relationships:
- `website_sessions.website_session_id` to `orders.website_session_id`
- `orders.order_id` to `order_items.order_id`
- `order_items.product_id` to `products.product_id`
- `order_items.order_item_id` to `order_item_refunds.order_item_id`
- `orders.order_id` to `order_item_refunds.order_id`
- `website_sessions.user_id` to `orders.user_id` for behavior comparisons where useful

## Project Scope
The first version of the project will focus on:
- Marketing channel performance
- Device-level behavior
- Product sales and gross profit
- Refund analysis
- Session and order trends over time
- Repeat versus new session behavior

The first version will not focus on:
- Predictive modeling
- Advanced customer lifetime value modeling
- Detailed web page path analysis unless pageview data is added later

## EDA Plan
The exploratory data analysis phase will answer:
- How many rows are in each table?
- What date range does each table cover?
- Are there missing values in important fields?
- Are there duplicate primary keys?
- Are there orphaned foreign keys?
- Do prices, COGS, and refund amounts look reasonable?
- How complete are the joins between sessions, orders, items, and refunds?

## Data Cleaning and Preparation Plan
The cleaning phase will include:
1. Review all field names and confirm data types.
2. Standardize timestamps for time-based analysis.
3. Check primary key uniqueness in each table.
4. Validate foreign key relationships across tables.
5. Investigate nulls and determine whether to remove, keep, or flag them.
6. Check for duplicate rows or duplicate transactional records.
7. Create derived fields such as:
   - Gross profit = revenue minus COGS
   - Average order value
   - Refund rate
   - Conversion rate
   - Items per order
8. Create cleaned analytical tables or views for downstream reporting.

## SQL Plan
SQL will be the main technical proof area of the project.

### SQL goals
- Load raw CSV files into a relational database
- Explore and profile each table
- Join multiple tables for unified reporting
- Build KPI summary queries
- Create reusable views or summary tables
- Use window functions to show analytical depth

### SQL skills to demonstrate
- INNER JOIN and LEFT JOIN
- GROUP BY aggregations
- CASE expressions
- Common Table Expressions (CTEs)
- Window functions such as:
  - `RANK()`
  - `ROW_NUMBER()`
  - `SUM() OVER()`
  - `LAG()`

### Example SQL use cases
- Rank products by revenue or refund amount
- Compute running monthly revenue
- Compare month-over-month changes
- Sequence orders by user to identify repeat behavior
- Compare performance by campaign and device

## Excel Plan
Excel will be used to show business-user reporting skills after SQL cleaning is complete.

### Excel skills to demonstrate
- XLOOKUP or VLOOKUP
- Pivot tables
- Filters and slicers
- Conditional formatting
- Basic validation and summary views

### Example Excel outputs
- Revenue by month and channel pivot table
- Product summary pivot table
- Refund summary by product
- Lookup-based enrichment of reporting tables
- A small stakeholder-facing summary tab

## Python Plan
Python will be used as a supporting validation and exploration tool, not the center of the project.

### Python skills to demonstrate
- Pandas for data review and validation
- NumPy for numerical checks
- Matplotlib and Seaborn for exploratory charts
- Jupyter notebook documentation of validation steps

### Python use cases
- Validate SQL outputs against raw or intermediate files
- Explore distributions before final KPI design
- Check for unusual patterns or outliers

## Data Modeling Plan
The Power BI model will likely use a star-schema-style structure.

### Candidate fact tables
- `fact_orders`
- `fact_order_items`
- `fact_refunds`

### Candidate dimension tables
- `dim_products`
- `dim_sessions`
- `dim_date`

### Modeling questions to be ready for
- Why was a certain fact grain chosen?
- Why separate order-level and item-level analysis?
- How were refunds handled in the model?
- Why was this structure better than one flattened table?

## KPI Framework
The project should define, calculate, and document the following KPIs:
- Sessions
- Orders
- Conversion rate
- Revenue
- Gross profit
- Average order value
- Items per order
- Refund amount
- Refund rate
- Repeat session share

Each KPI should have:
- a formula,
- a grain,
- a business purpose,
- and any assumptions used.

## Dashboard Plan
The final dashboard should likely include three pages:

### 1. Executive Overview
- Sessions
- Orders
- Conversion rate
- Revenue
- Gross profit
- Average order value
- Time trends
- Core filters

### 2. Channel and Session Performance
- Traffic source performance
- Campaign performance
- Device comparison
- New versus repeat session behavior

### 3. Product and Refund Analysis
- Product revenue
- Product gross profit
- Refund amount and refund rate
- Top and bottom product performers

## Documentation Plan
The repository should include:
- `README.md`
- `docs/project_plan.md`
- `docs/cleaning_log.md`
- `docs/kpi_definitions.md`
- SQL scripts
- Excel workbook
- Jupyter notebook(s)
- Power BI file
- Dashboard screenshots

## Deliverables
The final deliverables for the portfolio project should be:
- A public GitHub repository with organized folders
- Clean SQL scripts
- A documented Jupyter notebook
- An Excel file showing lookups and pivot tables
- A Power BI dashboard
- A README with business framing
- Supporting docs that explain the reasoning behind the analysis

## Risks and Assumptions
- Some fields may contain nulls or incomplete mappings.
- Refund analysis may require careful matching at both order and order-item level.
- Session and order timing may need standardization before trend analysis.
- Some business conclusions may be directional rather than definitive because the dataset is historical and limited to the available tables.

## Interview Preparation Goals
By the end of the project, be ready to explain:
- Why this stakeholder was chosen
- Why these business questions matter
- How the tables relate to each other
- What data quality issues were found
- How SQL joins supported the analysis
- How window functions added business insight
- Why Excel was used after SQL
- How the Power BI model was structured
- What the key recommendations were
- What limitations remained in the final analysis

## Build Order
1. Finalize stakeholder and business questions
2. Review data dictionary and inspect raw files
3. Load files into SQL
4. Perform EDA and document quality issues
5. Clean and prepare analysis tables
6. Build KPI queries and summary views
7. Export reporting extracts for Excel
8. Perform Python validation in Jupyter notebooks
9. Build the Power BI model and dashboard
10. Write final documentation and project insights
11. Update resume bullets using completed project work