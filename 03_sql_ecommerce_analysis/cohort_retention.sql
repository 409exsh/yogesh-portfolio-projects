-- =============================================================
-- Cohort Retention Analysis
-- Tracks monthly cohorts and measures order-based retention
-- =============================================================
USE ecommerce_db;

-- ---------------------------------------------------------------
-- STEP 1 – Assign each customer to their acquisition cohort
--          (the month of their first order)
-- ---------------------------------------------------------------
WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month
    FROM orders
    WHERE status NOT IN ('cancelled','returned')
    GROUP BY customer_id
),

-- ---------------------------------------------------------------
-- STEP 2 – Calculate each customer's "order month index"
--          (0 = acquisition month, 1 = one month later, …)
-- ---------------------------------------------------------------
customer_orders AS (
    SELECT
        o.customer_id,
        cc.cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m')    AS order_month,
        TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(CONCAT(cc.cohort_month, '-01'), '%Y-%m-%d'),
            STR_TO_DATE(CONCAT(DATE_FORMAT(o.order_date, '%Y-%m'), '-01'), '%Y-%m-%d')
        )                                      AS month_index
    FROM orders o
    JOIN customer_cohorts cc USING (customer_id)
    WHERE o.status NOT IN ('cancelled','returned')
),

-- ---------------------------------------------------------------
-- STEP 3 – Count distinct active customers per cohort × period
-- ---------------------------------------------------------------
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_customers
    FROM customer_cohorts
    GROUP BY cohort_month
),

retention_raw AS (
    SELECT
        cohort_month,
        month_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM customer_orders
    GROUP BY cohort_month, month_index
)

-- ---------------------------------------------------------------
-- STEP 4 – Final retention table (rate as %)
-- ---------------------------------------------------------------
SELECT
    r.cohort_month,
    cs.cohort_customers                        AS cohort_size,
    r.month_index,
    r.active_customers,
    ROUND(r.active_customers / cs.cohort_customers * 100, 1) AS retention_rate_pct
FROM retention_raw r
JOIN cohort_size cs USING (cohort_month)
ORDER BY r.cohort_month, r.month_index;

-- ---------------------------------------------------------------
-- BONUS: Pivot-style cohort grid (months 0-5)
-- Works in MySQL 8+; adjust CASE periods as needed
-- ---------------------------------------------------------------
WITH customer_cohorts AS (
    SELECT customer_id,
           DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month
    FROM orders
    WHERE status NOT IN ('cancelled','returned')
    GROUP BY customer_id
),
customer_orders AS (
    SELECT o.customer_id, cc.cohort_month,
           TIMESTAMPDIFF(MONTH,
               STR_TO_DATE(CONCAT(cc.cohort_month,'-01'),'%Y-%m-%d'),
               o.order_date
           ) AS month_index
    FROM orders o
    JOIN customer_cohorts cc USING (customer_id)
    WHERE o.status NOT IN ('cancelled','returned')
),
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_customers
    FROM customer_cohorts
    GROUP BY cohort_month
),
retention_raw AS (
    SELECT cohort_month, month_index,
           COUNT(DISTINCT customer_id) AS active_customers
    FROM customer_orders
    GROUP BY cohort_month, month_index
)
SELECT
    r.cohort_month,
    cs.cohort_customers,
    ROUND(MAX(CASE WHEN r.month_index = 0 THEN r.active_customers / cs.cohort_customers * 100 END),1) AS `M0_%`,
    ROUND(MAX(CASE WHEN r.month_index = 1 THEN r.active_customers / cs.cohort_customers * 100 END),1) AS `M1_%`,
    ROUND(MAX(CASE WHEN r.month_index = 2 THEN r.active_customers / cs.cohort_customers * 100 END),1) AS `M2_%`,
    ROUND(MAX(CASE WHEN r.month_index = 3 THEN r.active_customers / cs.cohort_customers * 100 END),1) AS `M3_%`,
    ROUND(MAX(CASE WHEN r.month_index = 4 THEN r.active_customers / cs.cohort_customers * 100 END),1) AS `M4_%`,
    ROUND(MAX(CASE WHEN r.month_index = 5 THEN r.active_customers / cs.cohort_customers * 100 END),1) AS `M5_%`
FROM retention_raw r
JOIN cohort_size cs USING (cohort_month)
GROUP BY r.cohort_month, cs.cohort_customers
ORDER BY r.cohort_month;