# Data Dictionary

## Overview
This project uses a multi-table e-commerce dataset to analyze website traffic, orders, product performance, and refund activity. The dataset supports business intelligence reporting across marketing, sales, profitability, and customer behavior.

## Table Summary

| Table | Business Purpose | Row Grain | Primary Key |
|---|---|---|---|
| `website_sessions` | Tracks visits to the website and the marketing context behind each visit | One row per website session | `website_session_id` |
| `orders` | Captures completed customer orders and order-level financial outcomes | One row per order | `order_id` |
| `order_items` | Breaks orders into individual purchased items for product-level analysis | One row per item within an order | `order_item_id` |
| `order_item_refunds` | Records refund events tied to purchased items and orders | One row per refunded order item event | `order_item_refund_id` |
| `products` | Stores product reference details used to label and analyze sales | One row per product | `product_id` |

## `website_sessions`

### Business Purpose
This table captures website traffic and the acquisition context behind each visit. It helps measure where traffic came from, which campaigns drove visits, whether the visitor used a mobile or desktop device, and whether the session came from a new or repeat visitor.

### Row Grain
One row represents one website session.

### Primary Key
- `website_session_id`

### Important Fields
- `website_session_id` – unique identifier for each session
- `created_at` – session start timestamp used for trend analysis
- `user_id` – connects sessions to users and helps compare behavior over time
- `is_repeat_session` – indicates whether the visitor has visited previously
- `utm_source` – traffic origin
- `utm_campaign` – marketing campaign name
- `utm_content` – ad or content variation
- `device_type` – mobile or desktop
- `http_referer` – referring source URL

### Likely Joins
- `website_sessions.website_session_id` to `orders.website_session_id`
- `website_sessions.user_id` to `orders.user_id` when analyzing user behavior across sessions and purchases

### Why It Matters
This table is the foundation for traffic, conversion, marketing, and new-versus-repeat session analysis. It allows the project to connect top-of-funnel website activity to downstream order outcomes.

## `orders`

### Business Purpose
This table captures completed orders and serves as the main order-level fact table for revenue, cost, and profitability analysis.

### Row Grain
One row represents one completed order.

### Primary Key
- `order_id`

### Important Fields
- `order_id` – unique identifier for each order
- `created_at` – order timestamp used for trend analysis
- `website_session_id` – connects each order back to the originating session
- `user_id` – identifies the purchasing user
- `primary_product_id` – identifies the main product in the order
- `items_purchased` – count of items included in the order
- `price_usd` – total order revenue
- `cogs_usd` – total cost of goods sold for the order

### Likely Joins
- `orders.website_session_id` to `website_sessions.website_session_id`
- `orders.order_id` to `order_items.order_id`
- `orders.order_id` to `order_item_refunds.order_id`
- `orders.primary_product_id` to `products.product_id`

### Why It Matters
This table is central for measuring orders, revenue, average order value, gross profit, and conversion from sessions to purchases. It is also a bridge between traffic behavior and item-level product analysis.

## `order_items`

### Business Purpose
This table breaks each order into individual purchased items, making it possible to analyze sales at the product level rather than only at the order level.

### Row Grain
One row represents one purchased item within an order.

### Primary Key
- `order_item_id`

### Important Fields
- `order_item_id` – unique identifier for each order item
- `created_at` – timestamp for when the item was ordered
- `order_id` – links the item back to the order
- `product_id` – identifies the purchased product
- `is_primary_item` – indicates whether the item was the primary item in the order
- `price_usd` – item-level revenue
- `cogs_usd` – item-level cost of goods sold

### Likely Joins
- `order_items.order_id` to `orders.order_id`
- `order_items.product_id` to `products.product_id`
- `order_items.order_item_id` to `order_item_refunds.order_item_id`

### Why It Matters
This table enables product-level performance reporting, bundle analysis, item-level profitability analysis, and more precise refund analysis. It is the most detailed sales table in the core dataset.

## `order_item_refunds`

### Business Purpose
This table records refund activity tied to purchased items and the related order. It supports analysis of refund risk, refund amount, and product-level return behavior.

### Row Grain
One row represents one refunded order item event.

### Primary Key
- `order_item_refund_id`

### Important Fields
- `order_item_refund_id` – unique identifier for each refund event
- `created_at` – refund timestamp used for refund trend analysis
- `order_item_id` – links the refund to a specific purchased item
- `order_id` – links the refund to the associated order
- `refund_amount_usd` – dollar amount refunded

### Likely Joins
- `order_item_refunds.order_item_id` to `order_items.order_item_id`
- `order_item_refunds.order_id` to `orders.order_id`

### Why It Matters
This table makes it possible to analyze which products or orders generate more refund exposure and how refunds reduce realized performance. It is necessary for a more realistic profitability story.

## `products`

### Business Purpose
This table stores reference information for products so purchased items and orders can be labeled and grouped meaningfully in reporting.

### Row Grain
One row represents one product.

### Primary Key
- `product_id`

### Important Fields
- `product_id` – unique identifier for each product
- `created_at` – product launch timestamp
- `product_name` – descriptive product label used in reporting

### Likely Joins
- `products.product_id` to `order_items.product_id`
- `products.product_id` to `orders.primary_product_id`

### Why It Matters
This table gives product context to order and item data. Without it, reporting would rely only on product IDs instead of understandable business labels.

## Key Relationships
The main relationships expected in the project are:
- `website_sessions.website_session_id` -> `orders.website_session_id`
- `orders.order_id` -> `order_items.order_id`
- `order_items.product_id` -> `products.product_id`
- `order_items.order_item_id` -> `order_item_refunds.order_item_id`
- `orders.order_id` -> `order_item_refunds.order_id`

## Analytical Use Cases Supported
This dataset supports:
- Marketing channel and campaign performance analysis
- Device-level conversion analysis
- Revenue and gross profit reporting
- Product-level sales analysis
- Bundle and item mix analysis
- Refund trend and refund risk analysis
- New versus repeat session behavior analysis
- Time-based trend analysis across sessions, orders, revenue, and refunds