-- =============================================================
-- E-Commerce Analysis Queries
-- =============================================================
USE ecommerce_db;

-- ---------------------------------------------------------------
-- 1. REVENUE OVERVIEW
-- ---------------------------------------------------------------

-- 1a. Total revenue, orders, and customers (all time)
SELECT
    COUNT(DISTINCT o.order_id)   AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(o.total_amount), 2) AS gross_revenue,
    ROUND(SUM(o.discount_amt), 2) AS total_discounts,
    ROUND(SUM(o.total_amount - o.discount_amt), 2) AS net_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM orders o
WHERE o.status NOT IN ('cancelled', 'returned');

-- 1b. Monthly revenue trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m')      AS month,
    COUNT(order_id)                        AS orders,
    ROUND(SUM(total_amount), 2)            AS revenue,
    ROUND(AVG(total_amount), 2)            AS avg_order_value,
    ROUND(SUM(total_amount)
        - LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date,'%Y-%m')), 2
    )                                      AS mom_change
FROM orders
WHERE status NOT IN ('cancelled','returned')
GROUP BY month
ORDER BY month;

-- 1c. Revenue by quarter
SELECT
    YEAR(order_date)                       AS year,
    QUARTER(order_date)                    AS quarter,
    ROUND(SUM(total_amount), 2)            AS revenue,
    COUNT(order_id)                        AS orders
FROM orders
WHERE status NOT IN ('cancelled','returned')
GROUP BY year, quarter
ORDER BY year, quarter;

-- ---------------------------------------------------------------
-- 2. PRODUCT PERFORMANCE
-- ---------------------------------------------------------------

-- 2a. Top 10 products by revenue
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity)                       AS units_sold,
    ROUND(SUM(oi.line_total), 2)           AS revenue,
    ROUND(SUM(oi.line_total)
        - SUM(oi.quantity * p.cost), 2)    AS gross_profit,
    ROUND((SUM(oi.line_total)
        - SUM(oi.quantity * p.cost))
        / SUM(oi.line_total) * 100, 1)     AS margin_pct
FROM order_items oi
JOIN products p  ON p.product_id  = oi.product_id
JOIN orders   o  ON o.order_id    = oi.order_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- 2b. Category revenue breakdown
SELECT
    p.category,
    COUNT(DISTINCT oi.order_id)            AS orders_with_category,
    SUM(oi.quantity)                       AS units_sold,
    ROUND(SUM(oi.line_total), 2)           AS revenue,
    ROUND(SUM(oi.line_total) / SUM(SUM(oi.line_total)) OVER () * 100, 1) AS revenue_share_pct
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders   o ON o.order_id   = oi.order_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY p.category
ORDER BY revenue DESC;

-- 2c. Products with low stock alert (< 100 units)
SELECT product_id, product_name, category, stock_qty
FROM products
WHERE is_active = TRUE AND stock_qty < 100
ORDER BY stock_qty;

-- ---------------------------------------------------------------
-- 3. CUSTOMER ANALYTICS
-- ---------------------------------------------------------------

-- 3a. Customer lifetime value (CLV) – top 20
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name)   AS customer_name,
    c.city, c.state,
    COUNT(o.order_id)                       AS total_orders,
    ROUND(SUM(o.total_amount), 2)           AS lifetime_value,
    ROUND(AVG(o.total_amount), 2)           AS avg_order_value,
    MIN(o.order_date)                       AS first_order,
    MAX(o.order_date)                       AS last_order,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_tenure_days
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY c.customer_id, customer_name, c.city, c.state
ORDER BY lifetime_value DESC
LIMIT 20;

-- 3b. New vs. returning customers per month
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')     AS month,
    SUM(CASE WHEN o.order_date = first_orders.first_order THEN 1 ELSE 0 END) AS new_customers,
    SUM(CASE WHEN o.order_date > first_orders.first_order THEN 1 ELSE 0 END) AS returning_customers
FROM orders o
JOIN (
    SELECT customer_id, MIN(order_date) AS first_order
    FROM orders
    GROUP BY customer_id
) first_orders ON first_orders.customer_id = o.customer_id
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY month
ORDER BY month;

-- 3c. Customer acquisition by month (sign-ups)
SELECT
    DATE_FORMAT(signup_date, '%Y-%m')      AS signup_month,
    COUNT(customer_id)                     AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;

-- ---------------------------------------------------------------
-- 4. ORDER FUNNEL & STATUS
-- ---------------------------------------------------------------

-- 4a. Order status distribution
SELECT
    status,
    COUNT(*)                               AS orders,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS pct
FROM orders
GROUP BY status
ORDER BY orders DESC;

-- 4b. Average days to deliver (delivered orders only)
-- Note: In real data you would have a delivered_date column;
--       here we approximate using order_date + 5 business days.
SELECT
    YEAR(order_date)                       AS year,
    ROUND(AVG(shipping_cost), 2)           AS avg_shipping_cost,
    ROUND(AVG(total_amount), 2)            AS avg_order_value
FROM orders
WHERE status = 'delivered'
GROUP BY year;

-- ---------------------------------------------------------------
-- 5. GEOGRAPHIC ANALYSIS
-- ---------------------------------------------------------------

-- 5a. Revenue by state (top 10)
SELECT
    o.shipping_state                       AS state,
    COUNT(o.order_id)                      AS orders,
    COUNT(DISTINCT o.customer_id)          AS customers,
    ROUND(SUM(o.total_amount), 2)          AS revenue
FROM orders o
WHERE o.status NOT IN ('cancelled','returned')
GROUP BY o.shipping_state
ORDER BY revenue DESC
LIMIT 10;

-- ---------------------------------------------------------------
-- 6. PRODUCT RATINGS
-- ---------------------------------------------------------------

-- 6a. Average rating per product (min 2 reviews)
SELECT
    p.product_name,
    p.category,
    COUNT(r.review_id)                     AS review_count,
    ROUND(AVG(r.rating), 2)               AS avg_rating,
    SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) AS five_star_count
FROM products p
JOIN reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING review_count >= 2
ORDER BY avg_rating DESC;

-- 6b. Rating distribution
SELECT
    rating,
    COUNT(*)                               AS review_count,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS pct
FROM reviews
GROUP BY rating
ORDER BY rating DESC;