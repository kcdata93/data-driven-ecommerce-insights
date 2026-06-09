-- ================================================
-- MODULE 7: CUSTOMER SEGMENTATION
-- E-Commerce Project
-- ================================================

-- RFM Analysis
WITH RFM_Base AS (SELECT 
    c.customer_unique_id AS Unique_Customer_ID,
    DATEDIFF('2018-10-17',
            MAX(DATE(order_purchase_timestamp))) AS From_Last_Order,
    COUNT(o.order_id) AS Total_Order,
    ROUND(SUM(op.payment_value), 2) AS Total_Revenue
FROM
    customers AS c
        JOIN
    orders AS o ON c.customer_id = o.customer_id
        JOIN
    order_payments AS op ON o.order_id = op.order_id
GROUP BY Unique_Customer_ID),

RFM_Score as (SELECT 
    *,
    CASE
        WHEN From_Last_Order BETWEEN 0 AND 90 THEN '5'
        WHEN From_Last_Order BETWEEN 91 AND 180 THEN '4'
        WHEN From_Last_Order BETWEEN 181 AND 270 THEN '3'
        WHEN From_Last_Order BETWEEN 271 AND 360 THEN '2'
        ELSE '1'
    END AS Recency,
    CASE
        WHEN Total_Order < (SELECT (AVG(Total_Order) * 0.20) FROM RFM_Base) THEN '1'
        WHEN Total_Order BETWEEN 
			(SELECT (AVG(Total_Order) * 0.20) FROM RFM_Base) AND (SELECT (AVG(Total_Order) * 0.40) 
				FROM RFM_Base) THEN '2'
        WHEN Total_Order BETWEEN 
			(SELECT (AVG(Total_Order) * 0.40) FROM RFM_Base) AND (SELECT (AVG(Total_Order) * 0.60) 
				FROM RFM_Base) THEN '3'
        WHEN Total_Order BETWEEN 
			(SELECT (AVG(Total_Order) * 0.60) FROM RFM_Base) AND (SELECT (AVG(Total_Order) * 0.80)
				FROM RFM_Base) THEN '4'
		ELSE '5'
	END AS Frequency,
    
    CASE
        WHEN Total_Revenue BETWEEN 0 AND 500 THEN '1'
        WHEN Total_Revenue BETWEEN 501 AND 1000 THEN '2'
        WHEN Total_Revenue BETWEEN 1001 AND 2000 THEN '3'
        WHEN Total_Revenue BETWEEN 2001 AND 5000 THEN '4'
        ELSE '5'
    END AS Monetary
FROM RFM_Base)
    
SELECT *,
	CASE 
		WHEN Recency=5 AND Frequency=5 AND Monetary=5 THEN 'Top Customer' 
		WHEN Recency>4 AND Monetary>4 THEN 'Loyal Customer'
		WHEN Recency>=3 AND Frequency>=3 THEN 'Potential Customer'
		WHEN Recency<=2 THEN 'At Risk' 
			ELSE 'Regular' END 
					AS RFM_Status 
FROM RFM_Score;

--Customer Segment Summary
WITH RFM_Base AS (SELECT 
    c.customer_unique_id AS Unique_Customer_ID,
    DATEDIFF('2018-10-17',
            MAX(DATE(order_purchase_timestamp))) AS From_Last_Order,
    COUNT(o.order_id) AS Total_Order,
    ROUND(SUM(op.payment_value), 2) AS Total_Revenue
FROM
    customers AS c
        JOIN
    orders AS o ON c.customer_id = o.customer_id
        JOIN
    order_payments AS op ON o.order_id = op.order_id
GROUP BY Unique_Customer_ID),

RFM_Score as (SELECT 
    *,
    CASE
        WHEN From_Last_Order BETWEEN 0 AND 90 THEN '5'
        WHEN From_Last_Order BETWEEN 91 AND 180 THEN '4'
        WHEN From_Last_Order BETWEEN 181 AND 270 THEN '3'
        WHEN From_Last_Order BETWEEN 271 AND 360 THEN '2'
        ELSE '1'
    END AS Recency,
    CASE
        WHEN Total_Order < (SELECT (AVG(Total_Order) * 0.20) FROM RFM_Base) THEN '1'
        WHEN Total_Order BETWEEN 
			(SELECT (AVG(Total_Order) * 0.20) FROM RFM_Base) AND (SELECT (AVG(Total_Order) * 0.40) 
				FROM RFM_Base) THEN '2'
        WHEN Total_Order BETWEEN 
			(SELECT (AVG(Total_Order) * 0.40) FROM RFM_Base) AND (SELECT (AVG(Total_Order) * 0.60) 
				FROM RFM_Base) THEN '3'
        WHEN Total_Order BETWEEN 
			(SELECT (AVG(Total_Order) * 0.60) FROM RFM_Base) AND (SELECT (AVG(Total_Order) * 0.80)
				FROM RFM_Base) THEN '4'
		ELSE '5'
	END AS Frequency,
    
    CASE
        WHEN Total_Revenue BETWEEN 0 AND 500 THEN '1'
        WHEN Total_Revenue BETWEEN 501 AND 1000 THEN '2'
        WHEN Total_Revenue BETWEEN 1001 AND 2000 THEN '3'
        WHEN Total_Revenue BETWEEN 2001 AND 5000 THEN '4'
        ELSE '5'
    END AS Monetary
FROM RFM_Base),
    
RFM_Final as (SELECT *,
	CASE 
		WHEN Recency=5 AND Frequency=5 AND Monetary=5 THEN 'Top Customer' 
		WHEN Recency>4 AND Monetary>4 THEN 'Loyal Customer'
		WHEN Recency>=3 AND Frequency>=3 THEN 'Potential Customer'
		WHEN Recency<=2 THEN 'At Risk' 
			ELSE 'Regular' END 
					AS RFM_Status 
FROM RFM_Score)

SELECT 
count(Unique_Customer_ID) AS Total_Customer, 
RFM_Status 
FROM RFM_Final 
GROUP BY RFM_Status
ORDER BY Total_Customer DESC













