SELECT 'website_sessions'    AS table_name, COUNT(*) AS row_count FROM dbo.website_sessions
UNION ALL
SELECT 'website_pageviews'   AS table_name, COUNT(*) AS row_count FROM dbo.website_pageviews
UNION ALL
SELECT 'orders'              AS table_name, COUNT(*) AS row_count FROM dbo.orders
UNION ALL
SELECT 'order_items'         AS table_name, COUNT(*) AS row_count FROM dbo.order_items
UNION ALL
SELECT 'order_item_refunds'  AS table_name, COUNT(*) AS row_count FROM dbo.order_item_refunds
UNION ALL
SELECT 'products'            AS table_name, COUNT(*) AS row_count FROM dbo.products;

-- website_sessions
SELECT COUNT(*) AS total,
       COUNT(DISTINCT website_session_id) AS distinct_ids
FROM dbo.website_sessions;

-- website_pageviews
SELECT COUNT(*) AS total,
       COUNT(DISTINCT website_pageview_id) AS distinct_ids
FROM dbo.website_pageviews;

-- orders
SELECT COUNT(*) AS total,
       COUNT(DISTINCT order_id) AS distinct_ids
FROM dbo.orders;

-- order_items
SELECT COUNT(*) AS total,
       COUNT(DISTINCT order_item_id) AS distinct_ids
FROM dbo.order_items;

-- order_item_refunds
SELECT COUNT(*) AS total,
       COUNT(DISTINCT order_item_refund_id) AS distinct_ids
FROM dbo.order_item_refunds;

-- products
SELECT COUNT(*) AS total,
       COUNT(DISTINCT product_id) AS distinct_ids
FROM dbo.products;

-- Orders critical fields
SELECT
    SUM(CASE WHEN order_id IS NULL            THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN website_session_id IS NULL  THEN 1 ELSE 0 END) AS null_session_id,
    SUM(CASE WHEN user_id IS NULL             THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN primary_product_id IS NULL  THEN 1 ELSE 0 END) AS null_primary_product_id,
    SUM(CASE WHEN items_purchased IS NULL     THEN 1 ELSE 0 END) AS null_items_purchased,
    SUM(CASE WHEN price_usd IS NULL           THEN 1 ELSE 0 END) AS null_price_usd,
    SUM(CASE WHEN cogs_usd IS NULL            THEN 1 ELSE 0 END) AS null_cogs_usd
FROM dbo.orders;

-- Order item refunds critical fields
SELECT
    SUM(CASE WHEN order_item_refund_id IS NULL THEN 1 ELSE 0 END) AS null_refund_id,
    SUM(CASE WHEN order_item_id IS NULL        THEN 1 ELSE 0 END) AS null_order_item_id,
    SUM(CASE WHEN order_id IS NULL             THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN refund_amount_usd IS NULL    THEN 1 ELSE 0 END) AS null_refund_amount
FROM dbo.order_item_refunds;

-- Basic plausibility checks for orders
SELECT
    MIN(items_purchased) AS min_items_purchased,
    MAX(items_purchased) AS max_items_purchased,
    MIN(price_usd)       AS min_price_usd,
    MAX(price_usd)       AS max_price_usd,
    MIN(cogs_usd)        AS min_cogs_usd,
    MAX(cogs_usd)        AS max_cogs_usd
FROM dbo.orders;

-- Rows where cost exceeds price (should be 0)
SELECT COUNT(*) AS cogs_gt_price
FROM dbo.orders
WHERE cogs_usd > price_usd;

-- Refund amounts plausibility
SELECT
    MIN(refund_amount_usd) AS min_refund,
    MAX(refund_amount_usd) AS max_refund
FROM dbo.order_item_refunds;