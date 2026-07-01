-- =====================================================
-- 01. SALES PERFORMANCE
-- =====================================================

-- 1. Monthly Sales Trend
-- Shows the evolution of total orders and revenue over time.

SELECT
	TO_CHAR(
		DATE_TRUNC('month', order_purchase_timestamp),
		'YYYY-MM') AS order_month,
	COUNT(*) AS total_orders,
	SUM(order_value)::numeric(14,2) AS total_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', order_purchase_timestamp)

-- 2. Daily Sales Trend
-- Shows the evolution of total orders and revenue by day of week.
SELECT
	 TO_CHAR(order_purchase_timestamp, 'FMDay') AS day_name,
	SUM(order_value)::numeric(14,2) AS total_revenue,
	COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(ISODOW FROM order_purchase_timestamp) ,day_name
ORDER BY EXTRACT(ISODOW FROM order_purchase_timestamp) 

-- 3. Payment Method Distribution
-- Shows the popularity of each payment method.

SELECT 
	payment_type,
	COUNT(*) AS payment_transactions
FROM payments
GROUP BY payment_type
ORDER BY payment_transactions DESC

-- 3. Revenue by Customer State
-- Identifies the regions generating the highest sales.

SELECT 
	customer_state AS state,
	SUM(order_value)::numeric(14) AS total_revenue
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
GROUP BY customer_state
ORDER BY total_revenue DESC
