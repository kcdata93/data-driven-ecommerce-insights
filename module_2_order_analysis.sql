-- ================================================
-- MODULE 2: ORDER ANALYSIS
-- E-Commerce Project
-- ================================================

--Order Status Distribution
SELECT 
    COUNT(order_id) AS Total_Order,
    order_status AS Order_Status
FROM
    orders
GROUP BY order_status
ORDER BY Order_Status;

--Monthly Order Trend
SELECT 
    COUNT(order_id) AS Total_Order,
    MONTH(order_purchase_timestamp) AS 'Month',
    YEAR(order_purchase_timestamp) AS 'Year'
FROM
    orders
GROUP BY Month, Year
ORDER BY YEAR(order_purchase_timestamp) ASC, MONTH(order_purchase_timestamp) ASC;

--Average Delivery Time
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            1) AS delivery_time
FROM
    orders
WHERE
    order_delivered_customer_date IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL
        AND order_delivered_customer_date != ''
        AND order_purchase_timestamp != '';

--Average Delivery Time by State Analysis 
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            2) AS Average_Delivery_Time,
    c.customer_state AS State
FROM
    customers AS c
        JOIN
    orders AS o ON c.customer_id = o.customer_id
WHERE
    order_delivered_customer_date IS NOT NULL
        AND order_delivered_customer_date != ' '
        AND order_purchase_timestamp IS NOT NULL
        AND order_purchase_timestamp != ' '
GROUP BY State
ORDER BY Average_Delivery_Time DESC;

--Delivery Status by City
SELECT 
    ROW_NUMBER() OVER (ORDER BY o.order_id) as Total_Order, 
    c.customer_city as City,
    CASE
        WHEN o.order_estimated_delivery_date < o.order_delivered_customer_date THEN 'LATE'
        WHEN o.order_estimated_delivery_date = o.order_delivered_customer_date THEN 'AT TIME'
        ELSE 'EARLY'
    END AS Delivery_Status
FROM
    orders as o 
    join customers as c on o.customer_id=c.customer_id
ORDER BY Delivery_Status DESC;

--Delivery Status Summary
SELECT 
    Delivery_Status,
    COUNT(*) AS Total
FROM (
    SELECT 
        CASE
            WHEN o.order_estimated_delivery_date < o.order_delivered_customer_date THEN 'LATE'
            WHEN o.order_estimated_delivery_date = o.order_delivered_customer_date THEN 'AT TIME'
            ELSE 'EARLY'
        END AS Delivery_Status
    FROM orders AS o
    JOIN customers AS c ON o.customer_id = c.customer_id
) AS delivery_table
GROUP BY Delivery_Status
ORDER BY Total DESC;

