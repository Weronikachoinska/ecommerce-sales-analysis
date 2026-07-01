-- =====================================================
-- 03. DELIVERY PERFORMANCE
-- =====================================================

-- 1. Delivery Status Distribution
-- Shows the proportion of early, on-time, and delayed deliveries.

SELECT 
	delivery_status,
	COUNT(*) As total_orders,
	ROUND(
	COUNT(*) * 100.00
	/SUM(COUNT(*)) OVER()
	,2) AS pct_of_orders
FROM delivery_orders
GROUP BY delivery_status
ORDER BY total_orders DESC

-- 2. Review Score Distribution
-- Shows the distribution of customer review scores.

SELECT 
	review_score, 
	COUNT(*) AS total_reviews,
	ROUND(
	COUNT(*) * 100.00
	/SUM(COUNT(*)) OVER()
	,2) AS pct_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC

-- 3. Impact of Delivery on Reviews
-- Measures how delivery performance affects customer satisfaction.

SELECT
	delivery_status,
	ROUND(
		AVG(review_score)
		,2) AS avg_review_score
FROM delivery_orders o 
JOIN reviews r
	ON o.order_id = r.order_id
GROUP BY delivery_status
ORDER BY avg_review_score DESC

-- 4. Monthly Delay Rate
-- Compares the percentage of delayed deliveries across months.

SELECT
	TO_CHAR(
		DATE_TRUNC('month', order_purchase_timestamp),
		'YYYY-MM'
		) AS order_month,
	COUNT(*) AS total_orders,
	ROUND(
		SUM(CASE WHEN delivery_status = 'Delayed' THEN 1.0 ELSE 0 END) * 100
		/COUNT(*) 
		,2) AS delay_rate
FROM delivery_orders
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
HAVING COUNT(*) > 1
ORDER BY DATE_TRUNC('month', order_purchase_timestamp)

-- 5. Delay Groups Analysis
-- Analyzes review scores and the distribution of delayed orders by delay duration.

WITH delays_groups AS(
	SELECT
		delay_days, 
		order_id,
	CASE
		WHEN delay_days <= 10 THEN '1-10'
		WHEN delay_days <= 20 THEN '11-20'
		WHEN delay_days <= 30 THEN '21-30'
		WHEN delay_days > 30 THEN '31+'
	END
		AS delay_group
	FROM delivery_orders
	WHERE delivery_status = 'Delayed'
)
SELECT
	delay_group,
	ROUND(
	AVG(review_score)
	,2) AS avg_review_score,
	COUNT (*) AS total_orders,
	ROUND(
		COUNT(*) * 100.00/
			(SELECT COUNT(*) 
			FROM delivery_orders
			WHERE delivery_status = 'Delayed')
		,2)AS delayed_orders_pct
FROM delays_groups dg
JOIN reviews r
	ON dg.order_id = r.order_id
GROUP BY delay_group
ORDER BY 
CASE delay_group
    WHEN '1-10' THEN 1
    WHEN '11-20' THEN 2
    WHEN '21-30' THEN 3
    WHEN '31+' THEN 4
END


-- 6. Delay Rate by Customer State
-- Identifies the states with the highest percentage of delayed deliveries.

SELECT
	customer_state AS state,
	ROUND(
		SUM(CASE WHEN delivery_status = 'Delayed' THEN 1.0 ELSE 0 END) * 100
		/COUNT(*) 
	,2) AS delay_rate
FROM delivery_orders o
JOIN customers c
	ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY delay_rate DESC

-- 7. Average Delivery Time by Customer State
-- Compares average delivery time across customer states.

SELECT
	customer_state AS state,
	ROUND(
		AVG(delivery_days) 
		,2)AS avg_delivery_days
FROM delivery_orders o
JOIN customers c
	ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC
 
-- 8. Average Delay Days by Customer State
-- Compares the average delay duration across customer states.
 
SELECT
	customer_state AS state,
	ROUND(
		AVG(delay_days) 
		,2)AS avg_delay_days
FROM delivery_orders o
JOIN customers c
	ON o.customer_id = c.customer_id
WHERE delivery_status = 'Delayed'
GROUP BY c.customer_state
ORDER BY avg_delay_days DESC


-- 9. Delay Rate by Product Category
-- Identifies product categories with the highest percentage of delayed deliveries.

SELECT 
	ct.product_category_name_english AS product_category,
	ROUND(
		SUM(CASE WHEN delivery_status = 'Delayed' THEN 1.0 ELSE 0 END) * 100
		/COUNT(*) 
	,2) AS delay_rate
FROM delivery_orders d 
JOIN order_items o
	ON d.order_id = o.order_id
JOIN products p 
	ON o.product_id = p.product_id
JOIN category_translation ct
	ON p.product_category_name = ct.product_category_name
GROUP BY product_category_name_english 
ORDER BY delay_rate DESC

-- 10. Average Delivery Time by Category
-- Compares the average delivery time across product categories.

SELECT
	ct.product_category_name_english AS product_category,
	ROUND(
		AVG(delivery_days)
		,2) AS avg_delivery_days
FROM delivery_orders d 
JOIN order_items o
	ON d.order_id = o.order_id
JOIN products p 
	ON o.product_id = p.product_id
JOIN category_translation ct
	ON p.product_category_name = ct.product_category_name
GROUP BY product_category_name_english 
ORDER BY avg_delivery_days DESC


-- 11. Average Delay Days by Category
-- Compares the average delay duration across product categories.

SELECT
	ct.product_category_name_english AS product_category,
	ROUND(
		AVG(delay_days)
		,2) AS avg_delay_days
FROM delivery_orders d 
JOIN order_items oi
	ON d.order_id = oi.order_id
JOIN products p 
	ON oi.product_id = p.product_id
JOIN category_translation ct
	ON p.product_category_name = ct.product_category_name
WHERE delivery_status = 'Delayed'
GROUP BY product_category_name_english 
ORDER BY avg_delay_days DESC













