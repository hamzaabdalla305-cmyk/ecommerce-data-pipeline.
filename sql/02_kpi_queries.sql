-- KPI queries for the Olist data warehouse
-- Run in olist_db after etl_pipeline.py

-- KPI 1: Total Revenue (canceled orders and freight excluded)
SELECT SUM(price) AS total_revenue
FROM fact_order_items
WHERE order_status != 'canceled';

-- KPI 2: Average Order Value (distinct eligible orders)
SELECT SUM(price) / COUNT(DISTINCT order_id) AS average_order_value
FROM fact_order_items
WHERE order_status != 'canceled';

-- KPI 3: Product Performance (top 10 categories by revenue)
SELECT
    p.product_category_name_english,
    COUNT(f.order_item_sk) AS items_sold,
    SUM(f.price) AS category_revenue
FROM fact_order_items f
JOIN dim_product p ON f.product_sk = p.product_sk
WHERE f.order_status != 'canceled'
GROUP BY p.product_category_name_english
ORDER BY category_revenue DESC
LIMIT 10;

-- KPI 4: Delivery Efficiency (average days and late percentage)
SELECT
    ROUND(AVG(order_delivered_customer_date::date - order_date_sk::text::date), 1) AS avg_delivery_days,
    ROUND(
        100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS late_delivery_percentage
FROM fact_order_items
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- KPI 5a: Customer Satisfaction (average score)
SELECT
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM stg_order_reviews;

-- KPI 5b: Customer Satisfaction (score distribution)
SELECT
    review_score,
    COUNT(*) AS num_reviews,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM stg_order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- Optional check: revenue including canceled orders
SELECT SUM(price) AS revenue_including_canceled
FROM fact_order_items;

-- Optional check: revenue of products without a category
SELECT COUNT(*) AS items_count, SUM(f.price) AS revenue
FROM fact_order_items f
JOIN dim_product p ON f.product_sk = p.product_sk
WHERE p.product_category_name_english = 'Unknown';

-- Optional check: delivery KPIs at order level (one row per order)
SELECT
    ROUND(AVG(delivery_days), 1) AS avg_delivery_days,
    ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_delivery_percentage
FROM (
    SELECT
        order_id,
        MIN(order_delivered_customer_date::date - order_date_sk::text::date) AS delivery_days,
        MAX(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS is_late
    FROM fact_order_items
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
    GROUP BY order_id
) o;