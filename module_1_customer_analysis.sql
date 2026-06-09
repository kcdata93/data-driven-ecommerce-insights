-- ================================================
-- MODULE 1: CUSTOMER ANALYSIS
-- E-Commerce Project
-- ================================================

--Customer Distribution by States
SELECT 
    COUNT(DISTINCT customer_unique_id) AS Total_Customer,
    customer_state AS States
FROM
    customers
GROUP BY States
ORDER BY Total_Customer DESC;

-- Returning Customers
SELECT 
    c.customer_unique_id AS Unique_Customer,
    COUNT(o.order_id) AS Total_Order
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY Unique_Customer
HAVING Total_Order > 1
ORDER BY Total_Order DESC;

--Customer Loyalty Status (Detail)
SELECT 
    c.customer_unique_id AS Unique_Customer,
    COUNT(o.order_id) AS Total_Order,
    CASE
        WHEN COUNT(o.order_id) < 2 THEN 'ALERT'
        WHEN COUNT(o.order_id) BETWEEN 3 AND 5 THEN 'NORMAL'
        ELSE 'GOOD LOYALTY'
    END AS 'Loyalty Status'
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY Unique_Customer
ORDER BY Total_Order DESC;

--Customer Loyalty Summary
SELECT 
    `Loyalty Status`,
    COUNT(*) AS Total_Customers
FROM (
    SELECT 
        c.customer_unique_id AS Unique_Customer,
        COUNT(o.order_id) AS Total_Order,
        CASE
            WHEN COUNT(o.order_id) < 2 THEN 'ALERT'
            WHEN COUNT(o.order_id) BETWEEN 3 AND 5 THEN 'NORMAL'
            ELSE 'GOOD LOYALTY'
        END AS 'Loyalty Status'
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    GROUP BY Unique_Customer
    ORDER BY Total_Order DESC
) AS loyalty_table
GROUP BY `Loyalty Status`;