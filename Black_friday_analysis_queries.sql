-- =====================================================
-- 05. SEASONAL SALES ANALYSIS(BLACK FRIDAY)
-- =====================================================

-- 1. Create Black Friday View
-- Creates a reusable view containing orders from October to December 2017.

CREATE VIEW black_friday_periods AS
	SELECT 
		o.order_id,
	    o.customer_id,
	    c.customer_unique_id,
	    o.order_purchase_timestamp,
	    o.order_value,
	    c.customer_state,
	CASE
		WHEN DATE_TRUNC('month', order_purchase_timestamp) = DATE'2017-10-01' THEN 'October'
		WHEN DATE_TRUNC('month', order_purchase_timestamp) = DATE '2017-11-01' THEN 'November'
		WHEN DATE_TRUNC('month', order_purchase_timestamp) = DATE '2017-12-01' THEN 'December'
		END AS  period
	FROM orders o
	JOIN customers c
	ON o.customer_id = c.customer_id
	WHERE order_purchase_timestamp >= '2017-10-01' 
		AND order_purchase_timestamp < '2018-01-01'


-- 2. Revenue and Order Volume Comparison
-- Compares sales performance before, during, and after Black Friday.

SELECT
	period,
	SUM(order_value)::numeric(14,2) AS total_revenue,
	COUNT(*) AS total_orders
FROM black_friday_periods
GROUP BY period
ORDER BY
	CASE period
	    WHEN 'October' THEN 1
	    WHEN 'November' THEN 2
	    ELSE 3
	END;

-- 3. Average Review Score Comparison
-- Compares customer satisfaction across the Black Friday period.

SELECT
	period,
	ROUND(
		AVG(review_score)
		,2)AS avg_review_score
FROM black_friday_periods b_f
LEFT JOIN reviews r
	ON b_f.order_id = r.order_id
GROUP BY period
ORDER BY
	CASE period
	    WHEN 'October' THEN 1
	    WHEN 'November' THEN 2
	    ELSE 3
	END;


-- 4. Average Delivery Time Comparison
-- Evaluates delivery performance before, during, and after Black Friday.

SELECT
	period,
	ROUND(
		AVG(delivery_days)
		,2)AS avg_delivery_days
FROM delivery_orders d_o 
JOIN black_friday_periods b_f
	ON b_f.order_id = d_o.order_id
GROUP BY period
ORDER BY
	CASE period
	    WHEN 'October' THEN 1
	    WHEN 'November' THEN 2
	    ELSE 3
	END;

-- 5. Average Delay Duration Comparison
-- Compares the average delay length for delayed orders across periods.

SELECT
	period,
	ROUND(
		AVG(delay_days) 
		,2)AS avg_delay_days
FROM delivery_orders d_o
JOIN black_friday_periods b_f
	ON b_f.order_id = d_o.order_id
WHERE delivery_status = 'Delayed'
GROUP BY period
ORDER BY
	CASE period
	    WHEN 'October' THEN 1
	    WHEN 'November' THEN 2
	    ELSE 3
	END;

-- 6. Delay Rate Comparison
-- Compares the percentage of delayed deliveries before, during, and after Black Friday.

SELECT
    period,
    ROUND(
        SUM(CASE WHEN delivery_status = 'Delayed' THEN 1.0 ELSE 0 END) * 100 /
        COUNT(*)
    ,2) AS delay_rate
FROM black_friday_periods b_f
JOIN delivery_orders d_o
    ON b_f.order_id = d_o.order_id
GROUP BY period
ORDER BY
	CASE period
	    WHEN 'October' THEN 1
	    WHEN 'November' THEN 2
	    ELSE 3
	END;
