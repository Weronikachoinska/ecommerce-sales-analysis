-- =====================================================
-- 06. RFM ANALYSIS
-- =====================================================

-- 1. RFM Segment Performance
-- Compares customer segments by revenue, customer share, lifetime value, and average order value.

SELECT
	segment,
	SUM(total_spent)::numeric(14,2) AS total_revenue,
	(SUM(total_spent) * 100/
	(
		SELECT SUM(total_spent) 
		FROM customer_metrics
	))::numeric(14,2) AS pct_total_revenue,
	COUNT(*) AS total_customers,
	(COUNT(*) * 100.0 /
	(
		SELECT COUNT(*) 
		FROM customer_metrics
		))::numeric(14,2) AS pct_customers,
	AVG(total_spent)::numeric(14,2) AS avg_lifetime_value,
	(SUM(total_spent) /
		SUM(total_orders))::numeric(14,2) AS avg_order_value
FROM rfm 
JOIN customer_metrics cm
	ON rfm.customer_unique_id = cm.customer_unique_id
GROUP BY segment
ORDER BY total_revenue DESC
