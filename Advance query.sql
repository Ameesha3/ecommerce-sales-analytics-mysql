#Advance problem 
#. Does discount level affect average order value?
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount < 0.10 THEN 'Low Discount'
        WHEN discount < 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_group,

    COUNT(*) AS total_orders,

    ROUND(AVG(revenue), 2) AS avg_order_value,

    ROUND(SUM(revenue), 2) AS total_revenue

FROM sales_analysis

GROUP BY discount_group

ORDER BY avg_order_value DESC;

#What are the top 3 product categories in each region?
WITH category_region_sales AS (

    SELECT
        region,
        product_category,
        SUM(revenue) AS total_revenue

    FROM sales_analysis

    GROUP BY
        region,
        product_category
),

ranked_categories AS (

    SELECT
        region,
        product_category,
        total_revenue,

        RANK() OVER (
            PARTITION BY region
            ORDER BY total_revenue DESC
        ) AS category_rank

    FROM category_region_sales
)

SELECT
    region,
    product_category,
    ROUND(total_revenue, 2) AS total_revenue,
    category_rank

FROM ranked_categories

WHERE category_rank <= 3

ORDER BY region, category_rank;

#What percentage of total revenue comes from each product category?
WITH category_sales AS (

    SELECT
        product_category,
        SUM(revenue) AS category_revenue

    FROM sales_analysis

    GROUP BY product_category
)

SELECT
    product_category,

    ROUND(category_revenue, 2) AS total_revenue,

    ROUND(
        category_revenue /
        SUM(category_revenue) OVER () * 100,
        2
    ) AS revenue_percentage

FROM category_sales

ORDER BY revenue_percentage DESC;

#Which customers are among the top 10 revenue contributors?
WITH customer_revenue AS (

    SELECT
        customer_id,
        SUM(revenue) AS total_spent

    FROM sales_analysis

    GROUP BY customer_id
),

ranked_customers AS (

    SELECT
        customer_id,
        total_spent,

        RANK() OVER (
            ORDER BY total_spent DESC
        ) AS customer_rank

    FROM customer_revenue
)

SELECT
    customer_id,
    ROUND(total_spent, 2) AS total_spent,
    customer_rank

FROM ranked_customers

WHERE customer_rank <= 10

ORDER BY customer_rank;

#Is faster delivery associated with better customer ratings?
SELECT
    CASE
        WHEN delivery_days <= 3 THEN 'Fast'
        WHEN delivery_days <= 7 THEN 'Standard'
        ELSE 'Slow'
    END AS delivery_category,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,

    ROUND(AVG(customer_rating), 2) AS avg_rating

FROM sales_analysis

GROUP BY delivery_category

ORDER BY avg_delivery_days;