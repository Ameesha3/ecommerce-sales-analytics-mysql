create database sales_analysis;
use sales_analysis;
desc sales_analysis;
select*from sales_analysis limit 10;
ALTER TABLE sales_analysis
MODIFY COLUMN order_date DATE;
-- Are there any duplicate id?
SELECT
    order_id,
    COUNT(*) AS order_count
FROM sales_analysis
GROUP BY order_id
HAVING COUNT(*) > 1;
