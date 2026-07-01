-- =====================================================
-- 02. PRODUCT ANALYSIS
-- =====================================================

-- 1. Top Selling Categories
-- Identifies the product categories with the highest number of items sold.

SELECT 
	ct.product_category_name_english AS product_category,
	COUNT(*) AS total_items_sold
FROM products p 
JOIN order_items oi
	ON p.product_id = oi.product_id
JOIN category_translation ct 
	ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY total_items_sold DESC
LIMIT 10  

-- 2. Highest Revenue Categories
-- Shows which product categories generate the most revenue.

SELECT 
	ct.product_category_name_english AS product_category,
	SUM(price)::numeric(14,2) AS total_revenue
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id
JOIN category_translation ct 
	ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10

-- 3. Average Review Score by Category
-- Compares customer satisfaction across product categories.

SELECT
	ct.product_category_name_english AS product_category,
	ROUND(
		AVG(review_score)
		,2)AS avg_review_score
FROM reviews r
JOIN order_items oi
	ON r.order_id = oi.order_id
JOIN products p
	ON oi.product_id = p.product_id
JOIN category_translation ct
	ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY avg_review_score DESC

-- 4. Average Product Price by Category
-- Compares the average selling price of products in each category.

SELECT
	ct.product_category_name_english As product_category,
	AVG(price)::numeric(14,2) AS avg_product_price
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id
JOIN category_translation ct
	ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY avg_product_price DESC