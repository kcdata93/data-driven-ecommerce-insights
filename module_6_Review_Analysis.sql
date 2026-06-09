-- ================================================
-- MODULE 6: REVIEW ANALYSIS
-- E-Commerce Project
-- ================================================

--Review Score Distribution
SELECT 
    COUNT(review_id) AS Total_Review,
    review_score AS Score,
    CASE 
        WHEN review_score > (SELECT AVG(review_score) FROM order_reviews) 
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS Status
FROM
    order_reviews
GROUP BY review_score
ORDER BY Score DESC;

--Delivery Time and Review Score Analysis
WITH delivery_scores AS (
    SELECT 
        orw.review_score AS Score,
        DATEDIFF(o.order_delivered_customer_date, 
                o.order_purchase_timestamp) AS Delivery_Time
    FROM orders AS o
    JOIN order_reviews AS orw ON o.order_id = orw.order_id
    WHERE order_delivered_customer_date != ''
        AND order_purchase_timestamp != ''
)

SELECT 
    Score,
    ROUND(AVG(Delivery_Time), 2) AS Avg_Delivery,
    CASE 
        WHEN AVG(Delivery_Time) > (SELECT AVG(Delivery_Time) FROM delivery_scores)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS Status
FROM delivery_scores
GROUP BY Score
ORDER BY Score DESC