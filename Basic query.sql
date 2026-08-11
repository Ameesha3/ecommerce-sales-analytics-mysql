# KPI's
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_units_sold,
    ROUND(AVG(revenue), 2) AS average_order_value,
    ROUND(AVG(customer_rating), 2) AS average_rating,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM sales_analysis;

# Which product category generted highest value?
 SELECT
    product_category,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_analysis
GROUP BY product_category
ORDER BY total_revenue DESC
LIMIT 5;

# Which product category generted highest value?
 SELECT
    product_category,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_analysis
GROUP BY product_category
ORDER BY total_revenue DESC
LIMIT 5;

#What is the monthly revenue trend?
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_analysis
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

#Which payment method generates the most revenue?
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM sales_analysis
GROUP BY payment_method
ORDER BY total_revenue DESC;

#. Which customers have placed more than one order?
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(revenue), 2) AS total_spent
FROM sales_analysis
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY order_count DESC;

# Which region has the fastest average delivery?
SELECT
    region,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(customer_rating), 2) AS avg_rating
FROM sales_analysis
GROUP BY region
ORDER BY avg_delivery_days ASC;

#Rank product categories by total revenue.
SELECT
    product_category,
    ROUND(SUM(revenue), 2) AS total_revenue,

    RANK() OVER (
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank

FROM sales_analysis

GROUP BY product_category

ORDER BY revenue_rank;