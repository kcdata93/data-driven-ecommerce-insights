-- ================================================
-- MODULE 5: SELLER ANALYSIS
-- E-Commerce Project
-- ================================================

--Seller Performance by Revenue and Review Score
SELECT 
    s.seller_id AS Seller_ID,
    s.seller_city AS Seller_City,
    s.seller_state AS Seller_State,
    ROUND(AVG(orw.review_score), 2) AS Average_Review_Score,
    ROUND(SUM(op.payment_value), 2) AS Total_Revenue
FROM
    sellers AS s
        JOIN
    order_items AS oi ON s.seller_id = oi.seller_id
        JOIN
    order_payments AS op ON oi.order_id = op.order_id
        JOIN
    order_reviews AS orw ON op.order_id = orw.order_id
GROUP BY Seller_ID, Seller_City, Seller_State
ORDER BY Total_Revenue DESC;

--Total Orders per Seller
SELECT 
    s.seller_id AS Seller_ID,
    COUNT(o.order_purchase_timestamp) AS Total_Order
FROM
    sellers AS s
        JOIN
    order_items AS oi ON s.seller_id = oi.seller_id
        JOIN
    orders AS o ON oi.order_id = o.order_id
GROUP BY Seller_ID
ORDER BY Total_Order DESC;

--Seller Distribution by City
SELECT 
    COUNT(seller_id) AS Total_Seller, seller_city AS City
FROM
    sellers
GROUP BY City
ORDER BY Total_Seller DESC;

--Total Revenue by Sellers
WITH Seller_Revenue as (SELECT 
    s.seller_id AS Seller_ID,
    ROUND(SUM(payment_value), 2) AS Total_Revenue
FROM
    sellers AS s
        JOIN
    order_items AS oi ON s.seller_id = oi.seller_id
        JOIN
    order_payments AS op ON oi.order_id = op.order_id
GROUP BY Seller_ID
ORDER BY Total_Revenue DESC)

SELECT 
	RANK() OVER (ORDER BY Total_Revenue DESC) AS Rank_No, 
    Total_Revenue, 
    Seller_ID
FROM Seller_Revenue 
ORDER BY Total_Revenue DESC