-- ================================================
-- MODULE 4: REVENUE ANALYSIS
--E-Commerce Project
-- ================================================

--Total Revenue and Average Order Value
SELECT 
    ROUND(SUM(payment_value), 2) AS Total_Revenue,
    ROUND(AVG(payment_value), 2) AS Average_Revenue
FROM
    order_payments;
    
--Payment Types Analysis
SELECT 
    COUNT(order_id) Total_Order, payment_type AS Type_of_Payment
FROM
    order_payments
GROUP BY payment_type
ORDER BY Type_of_Payment DESC;
--Revenue by Payment Type
SELECT 
    payment_type AS Payment_Method,
    ROUND(AVG(payment_value), 2) AS Average_Payment
FROM
    order_payments
GROUP BY Payment_Method
ORDER BY Average_Payment DESC;

