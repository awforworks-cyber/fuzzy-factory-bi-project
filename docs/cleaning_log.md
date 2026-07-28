# Cleaning Log

## Purpose

This document tracks data quality checks, issues identified during exploratory data analysis (EDA), and planned cleaning actions for the Fuzzy Factory BI project. The goal is to document how the raw data was reviewed before SQL transformation, KPI development, and dashboard creation.

## Initial Data Review

| Check Area | Table | What Was Tested | Finding | Impact | Planned Action / Status |
|---|---|---|---|---|---|
| File loading | All core tables | Verified that the raw CSV files could be loaded from the repository path | All required CSV files loaded successfully: `website_sessions`, `orders`, `order_items`, `order_item_refunds`, and `products` | Confirms the repository structure and file access are working correctly for analysis | No action needed |
| Table structure | `website_sessions` | Reviewed row and column count | Table contains 472,871 rows and 9 columns | Volume is plausible for top-of-funnel website traffic | No action needed |
| Table structure | `orders` | Reviewed row and column count | Table contains 32,313 rows and 8 columns | Volume is plausible for completed orders and is much smaller than session volume, which is expected | No action needed |
| Table structure | `order_items` | Reviewed row and column count | Table contains 40,025 rows and 7 columns | Row count is higher than orders, which suggests some orders contain multiple items | No action needed |
| Table structure | `order_item_refunds` | Reviewed row and column count | Table contains 1,731 rows and 5 columns | Refund activity appears to be a relatively small subset of sold items | No action needed |
| Table structure | `products` | Reviewed row and column count | Table contains 4 rows and 3 columns | Small product dimension is consistent with the case study setup | No action needed |
| Column validation | `website_sessions` | Compared column names to the data dictionary | All expected fields are present, including session ID, timestamp, user ID, repeat flag, UTM fields, device type, and referring URL | Confirms the table contains the expected traffic and acquisition dimensions | No action needed |
| Column validation | `orders` | Compared column names to the data dictionary | All expected fields are present, including order ID, timestamp, session ID, user ID, product ID, item count, revenue, and COGS | Confirms the table supports order-level KPI analysis | No action needed |
| Column validation | `order_items` | Compared column names to the data dictionary | All expected fields are present, including item ID, order ID, product ID, primary item flag, revenue, and COGS | Confirms the table supports product-level and item-level analysis | No action needed |
| Column validation | `order_item_refunds` | Compared column names to the data dictionary | All expected fields are present, including refund ID, item ID, order ID, timestamp, and refund amount | Confirms the table supports refund analysis | No action needed |
| Column validation | `products` | Compared column names to the data dictionary | All expected fields are present: product ID, launch timestamp, and product name | Confirms the product dimension is complete at a structural level | No action needed |
| Data types | `website_sessions` | Reviewed data types for keys, flags, categorical fields, and timestamp | `website_session_id` and `user_id` are integers; `is_repeat_session` is integer; campaign and device fields are strings; `created_at` is stored as string | Most fields are usable, but the timestamp is not yet analysis-ready for time-series work | Convert `created_at` to datetime during cleaning |
| Data types | `orders` | Reviewed data types for keys, measures, and timestamp | IDs and counts are integers; `price_usd` and `cogs_usd` are numeric; `created_at` is stored as string | Revenue and cost fields are ready for aggregation, but time-based analysis will require datetime conversion | Convert `created_at` to datetime during cleaning |
| Data types | `order_items` | Reviewed data types for keys, flags, measures, and timestamp | IDs and flag fields are integers; `price_usd` and `cogs_usd` are numeric; `created_at` is stored as string | Item-level revenue and cost are ready for aggregation, but time analysis will require datetime conversion | Convert `created_at` to datetime during cleaning |
| Data types | `order_item_refunds` | Reviewed data types for keys, measures, and timestamp | IDs are integers; `refund_amount_usd` is numeric; `created_at` is stored as string | Refund amount is ready for aggregation, but refund trend analysis will require datetime conversion | Convert `created_at` to datetime during cleaning |
| Data types | `products` | Reviewed data types for keys, descriptive fields, and timestamp | `product_id` is integer; `product_name` is string; `created_at` is stored as string | Product reference data is mostly clean, but launch date should be converted for time-based product analysis | Convert `created_at` to datetime during cleaning |

## Missing Value Checks

| Check Area | Table | What Was Tested | Finding | Impact | Planned Action / Status |
|---|---|---|---|---|---|
| Missing values | `website_sessions` | Checked missing values in core campaign fields (`utm_source`, `utm_campaign`, `utm_content`) | 83,328 sessions have null values for UTM fields | A significant portion of traffic does not carry explicit campaign tags, which limits attribution analysis for those sessions | Treat null UTM fields as `untagged / direct or organic` in analysis and document this assumption |
| Missing values | `website_sessions` | Checked missing values in `http_referer` | 39,917 sessions have null `http_referer` | Many sessions do not expose a referring URL, which is typical for direct visits or privacy constraints | Accept as expected behavior; do not impute, but document that some traffic has unknown referer context |
| Missing values | All other tables | Checked missing values in keys, foreign keys, date fields, and money fields | No missing values found in `orders`, `order_items`, `order_item_refunds`, or `products` | Core transaction, item, refund, and product data is structurally complete | No cleaning required for missing values in these tables at this stage |

## Duplicate Row Checks

| Check Area | Table | What Was Tested | Finding | Impact | Planned Action / Status |
|---|---|---|---|---|---|
| Duplicate rows | All core tables | Checked for completely duplicated rows using `DataFrame.duplicated()` | No tables have fully duplicated rows; duplicate count is 0 for `website_sessions`, `orders`, `order_items`, `order_item_refunds`, and `products` | No evidence of exact row-level duplication in the raw data | No action needed for full-row duplicates at this stage |

## Primary Key Checks

| Check Area | Table | What Was Tested | Finding | Impact | Planned Action / Status |
|---|---|---|---|---|---|
| Primary key uniqueness | All core tables | Reviewed key fields (`website_session_id`, `order_id`, `order_item_id`, `order_item_refund_id`, `product_id`) alongside missing-value and duplicate-row checks | Key fields are complete and behave as unique record identifiers across all core tables | Strong table-level integrity; records are reliable for joins and aggregations | No action needed for primary keys |

## Join Validation

| Check Area | Table | What Was Tested | Finding | Impact | Planned Action / Status |
|---|---|---|---|---|---|
| Join validation | `orders` vs `website_sessions` | Checked that every `orders.website_session_id` exists in `website_sessions.website_session_id` | 0 orphan rows found | Joins from orders to sessions are reliable for funnel and attribution analysis | No action needed |
| Join validation | `order_items` vs `orders` | Checked that every `order_items.order_id` exists in `orders.order_id` | 0 orphan rows found | Item-level analysis can safely roll up to order-level KPIs | No action needed |
| Join validation | `order_items` vs `products` | Checked that every `order_items.product_id` exists in `products.product_id` | 0 orphan rows found | Product-level analysis is structurally complete | No action needed |
| Join validation | `order_item_refunds` vs `order_items` | Checked that every `order_item_refunds.order_item_id` exists in `order_items.order_item_id` | 0 orphan rows found | Refunds can be tied back to the correct sold items | No action needed |
| Join validation | `order_item_refunds` vs `orders` | Checked that every `order_item_refunds.order_id` exists in `orders.order_id` | 0 orphan rows found | Refund analysis can be connected to order-level KPIs | No action needed |

## Value Plausibility Checks

| Check Area | Table | What Was Tested | Finding | Impact | Planned Action / Status |
|---|---|---|---|---|---|
| Value plausibility | `orders` | Reviewed `items_purchased`, `price_usd`, and `cogs_usd` for nulls, negatives, zeros, and extreme values | `items_purchased` ranges from 1 to 2; `price_usd` ranges from 29.99 to 109.98; `cogs_usd` ranges from 9.49 to 41.98; no nulls, negatives, or zeros were found | Order-level quantities, prices, and costs appear plausible and suitable for KPI analysis | No cleaning required at this stage |
| Value plausibility | `orders` | Checked whether any `cogs_usd` values exceed `price_usd` | 0 rows where `cogs_usd > price_usd` | Confirms order-level profitability fields are internally consistent | No action needed |
| Value plausibility | `order_item_refunds` | Reviewed `refund_amount_usd` for nulls, negatives, zeros, and extreme values | `refund_amount_usd` ranges from 29.99 to 59.99 with no nulls, negatives, or zeros | Refund values appear plausible and consistent with item-level pricing | No cleaning required at this stage |
| Value plausibility | `order_item_refunds` and `order_items` | Checked whether any refund amount exceeds the corresponding item price | 0 refund rows exceed the original item price | Confirms refund values are logically consistent with sold item values | No action needed |

## Early Observations

Overall, the Fuzzy Factory data appears structurally healthy based on initial EDA. Core transaction and product tables have complete keys, dates, and monetary fields, with no missing values, duplicate rows, or join integrity issues. Website session data shows expected missingness in marketing attribution fields, reflecting untagged or direct traffic rather than broken records. The main cleaning requirement identified so far is conversion of `created_at` fields from string to proper datetime format.

## Open Cleaning Issues

- Convert all `created_at` fields from string to proper datetime types in each table to support reliable time-based filtering, grouping, and trend analysis.
- Decide how null UTM fields (`utm_source`, `utm_campaign`, `utm_content`) and `http_referer` should be categorized in downstream marketing analysis, such as labeling them as `untagged`, `direct`, or `unknown`.
- Document assumptions about missing marketing metadata and how those values will be treated in SQL models and dashboards.