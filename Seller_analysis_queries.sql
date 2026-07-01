-- =====================================================
-- 04. SELLER ANALYSIS
-- =====================================================
 
-- 1. Seller Performance
-- Compares sellers by total revenue, completed orders, and average review score.
 
SELECT
	s.seller_id,
	COUNT(DISTINCT oi.order_id) AS total_orders,
	SUM(price)::numeric(14,2) AS total_revenue, 
	ROUND(
		AVG(review_score)
		,2)AS avg_review_score
FROM sellers s
JOIN order_items oi
	ON s.seller_id = oi.seller_id
JOIN reviews r
	ON oi.order_id = r.order_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10

