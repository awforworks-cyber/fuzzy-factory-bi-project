/*
=========================================================
Fuzzy Factory E-Commerce BI Project
Azure SQL Database Schema
=========================================================

Purpose:
- Drops existing tables in dependency-safe order.
- Recreates all six Fuzzy Factory source tables.
- Defines primary keys and foreign-key relationships.
- Uses analysis-ready data types for Azure SQL.
- Includes website_pageviews for landing-page and funnel analysis.

Important:
- Load tables in this order:
  1. products
  2. website_sessions
  3. website_pageviews
  4. orders
  5. order_items
  6. order_item_refunds
=========================================================
*/

---------------------------------------------------------
-- Drop existing tables in child-to-parent dependency order
---------------------------------------------------------

DROP TABLE IF EXISTS dbo.order_item_refunds;
DROP TABLE IF EXISTS dbo.order_items;
DROP TABLE IF EXISTS dbo.orders;
DROP TABLE IF EXISTS dbo.website_pageviews;
DROP TABLE IF EXISTS dbo.products;
DROP TABLE IF EXISTS dbo.website_sessions;

---------------------------------------------------------
-- 1. Product dimension
---------------------------------------------------------

CREATE TABLE dbo.products (
    product_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL,
    product_name NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_products
        PRIMARY KEY (product_id)
);

---------------------------------------------------------
-- 2. Website sessions
---------------------------------------------------------

CREATE TABLE dbo.website_sessions (
    website_session_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL,
    user_id INT NOT NULL,
    is_repeat_session INT NOT NULL,  
    utm_source NVARCHAR(100) NULL,
    utm_campaign NVARCHAR(100) NULL,
    utm_content NVARCHAR(255) NULL,
    device_type NVARCHAR(25) NOT NULL,
    http_referer NVARCHAR(1000) NULL,

    CONSTRAINT PK_website_sessions
        PRIMARY KEY (website_session_id)
);
---------------------------------------------------------
-- 3. Website pageviews
---------------------------------------------------------

CREATE TABLE dbo.website_pageviews (
    website_pageview_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL,
    website_session_id INT NOT NULL,
    pageview_url NVARCHAR(500) NOT NULL,

    CONSTRAINT PK_website_pageviews
        PRIMARY KEY (website_pageview_id),

    CONSTRAINT FK_website_pageviews_website_sessions
        FOREIGN KEY (website_session_id)
        REFERENCES dbo.website_sessions (website_session_id)
);

---------------------------------------------------------
-- 4. Orders
---------------------------------------------------------

CREATE TABLE dbo.orders (
    order_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL,
    website_session_id INT NOT NULL,
    user_id INT NOT NULL,
    primary_product_id INT NOT NULL,
    items_purchased INT NOT NULL,
    price_usd DECIMAL(10, 2) NOT NULL,
    cogs_usd DECIMAL(10, 2) NOT NULL,

    CONSTRAINT PK_orders
        PRIMARY KEY (order_id),

    CONSTRAINT FK_orders_website_sessions
        FOREIGN KEY (website_session_id)
        REFERENCES dbo.website_sessions (website_session_id),

    CONSTRAINT FK_orders_products
        FOREIGN KEY (primary_product_id)
        REFERENCES dbo.products (product_id),

    CONSTRAINT CK_orders_items_purchased_positive
        CHECK (items_purchased > 0),

    CONSTRAINT CK_orders_price_usd_positive
        CHECK (price_usd > 0),

    CONSTRAINT CK_orders_cogs_usd_positive
        CHECK (cogs_usd > 0),

    CONSTRAINT CK_orders_cogs_not_greater_than_price
        CHECK (cogs_usd <= price_usd)
);

---------------------------------------------------------
-- 5. Order items
---------------------------------------------------------

CREATE TABLE dbo.order_items (
    order_item_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    is_primary_item INT NOT NULL,
    price_usd DECIMAL(10, 2) NOT NULL,
    cogs_usd DECIMAL(10, 2) NOT NULL,

    CONSTRAINT PK_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders (order_id),

    CONSTRAINT FK_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products (product_id),

    CONSTRAINT CK_order_items_price_usd_positive
        CHECK (price_usd > 0),

    CONSTRAINT CK_order_items_cogs_usd_positive
        CHECK (cogs_usd > 0),

    CONSTRAINT CK_order_items_cogs_not_greater_than_price
        CHECK (cogs_usd <= price_usd)
);
---------------------------------------------------------
-- 6. Order item refunds
---------------------------------------------------------

CREATE TABLE dbo.order_item_refunds (
    order_item_refund_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL,
    order_item_id INT NOT NULL,
    order_id INT NOT NULL,
    refund_amount_usd DECIMAL(10, 2) NOT NULL,

    CONSTRAINT PK_order_item_refunds
        PRIMARY KEY (order_item_refund_id),

    CONSTRAINT FK_order_item_refunds_order_items
        FOREIGN KEY (order_item_id)
        REFERENCES dbo.order_items (order_item_id),

    CONSTRAINT FK_order_item_refunds_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders (order_id),

    CONSTRAINT CK_order_item_refunds_amount_positive
        CHECK (refund_amount_usd > 0)
);

---------------------------------------------------------
-- Performance indexes for common joins and analysis
---------------------------------------------------------

CREATE INDEX IX_website_sessions_created_at
    ON dbo.website_sessions (created_at);

CREATE INDEX IX_website_sessions_user_id
    ON dbo.website_sessions (user_id);

CREATE INDEX IX_website_pageviews_session_id
    ON dbo.website_pageviews (website_session_id);

CREATE INDEX IX_website_pageviews_created_at
    ON dbo.website_pageviews (created_at);

CREATE INDEX IX_website_pageviews_pageview_url
    ON dbo.website_pageviews (pageview_url);

CREATE INDEX IX_orders_session_id
    ON dbo.orders (website_session_id);

CREATE INDEX IX_orders_user_id
    ON dbo.orders (user_id);

CREATE INDEX IX_orders_primary_product_id
    ON dbo.orders (primary_product_id);

CREATE INDEX IX_orders_created_at
    ON dbo.orders (created_at);

CREATE INDEX IX_order_items_order_id
    ON dbo.order_items (order_id);

CREATE INDEX IX_order_items_product_id
    ON dbo.order_items (product_id);

CREATE INDEX IX_order_items_created_at
    ON dbo.order_items (created_at);

CREATE INDEX IX_order_item_refunds_order_item_id
    ON dbo.order_item_refunds (order_item_id);

CREATE INDEX IX_order_item_refunds_order_id
    ON dbo.order_item_refunds (order_id);

CREATE INDEX IX_order_item_refunds_created_at
    ON dbo.order_item_refunds (created_at);

---------------------------------------------------------
-- Validate the schema after creation
---------------------------------------------------------

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;

