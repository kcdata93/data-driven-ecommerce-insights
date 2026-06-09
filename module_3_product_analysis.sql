-- ================================================
-- MODULE 3: PRODUCT ANALYSIS
-- E-Commerce Project
-- ================================================

--Order Distribution by Category
SELECT 
    pct.product_category_name_english AS Category_Name,
    COUNT(o.order_id) AS Total_Order
FROM
    orders AS o
        JOIN
    order_items AS oi ON o.order_id = oi.order_id
        JOIN
    products AS p ON oi.product_id = p.product_id
        JOIN
    product_category_translation AS pct ON p.product_category_name = pct.product_category_name
GROUP BY Category_Name
ORDER BY Total_Order DESC;

--Revenue Distribution by Category
SELECT 
    ROUND(SUM(op.payment_value), 2) AS Total_Revenue,
    pct.product_category_name_english AS Category_Name
FROM
    order_payments AS op
        JOIN
    order_items AS oi ON op.order_id = oi.order_id
        JOIN
    products AS p ON oi.product_id = p.product_id
        JOIN
    product_category_translation AS pct ON p.product_category_name = pct.product_category_name
GROUP BY Category_Name
ORDER BY Total_Revenue DESC;