-- Practice Questions

/*
1. Create a temporary table that joins the orders, order_products,
and products tables to get information about each order, 
including the products that were purchased and their department and aisle information.
*/
CREATE TEMPORARY TABLE order_product_info AS
SELECT
    o.order_id,
    o.user_id,
    o.order_number,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order,
    op.product_id,
    op.add_to_cart_order,
    op.reordered,
    p.product_name,
    p.aisle_id,
    p.department_id,
    d.department,
    a.aisle
FROM orders o
INNER JOIN order_products op ON o.order_id = op.order_id
INNER JOIN products p ON op.product_id = p.product_id
INNER JOIN departments d ON p.department_id = d.department_id
INNER JOIN aisles a ON p.aisle_id = a.aisle_id;

-- Testing temporary table
SELECT *
FROM order_product_info;

/*
2. Create a temporary table that groups the orders by product
and finds the total number of times each product was purchased,
the total number of times each product was reordered,
and the average number of times each product was added to a cart.
*/
CREATE TEMPORARY TABLE product_purchase_analysis AS
SELECT
    p.product_name,
    COUNT(op.product_id) AS total_products_purchased,
    SUM(op.reordered) AS total_products_reordered,
    AVG(op.add_to_cart_order) AS average_of_times_added_to_cart
FROM orders o
INNER JOIN order_products op ON o.order_id = op.order_id
INNER JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name;

-- Testing temporary table
SELECT *
FROM product_purchase_analysis;

/*
3. Create a temporary table that groups the orders by department
and finds the total number of products purchased,
the total number of unique products purchased,
the total number of products purchased on weekdays vs weekends, 
and the average time of day that products in each department are ordered.
*/
CREATE TEMPORARY TABLE department_purchase_analysis AS
SELECT
    d.department,
    COUNT(op.product_id) AS total_products_purchased,
    COUNT(DISTINCT op.product_id) AS total_unique_products_purchased,
    COUNT(CASE WHEN o.order_dow IN (0, 6) THEN 1 END) AS total_products_purchased_weekends,
    COUNT(CASE WHEN o.order_dow IN (1, 2, 3, 4, 5) THEN 1 END) AS total_products_purchased_weekdays,
    AVG(o.order_hour_of_day) AS average_time_of_day_products
FROM orders o
INNER JOIN order_products op ON o.order_id = op.order_id
INNER JOIN products p ON op.product_id = p.product_id
INNER JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department;

-- Testing temporary table
SELECT *
FROM department_purchase_analysis;

/*
4. Create a temporary table that groups the orders by aisle
and finds the top 10 most popular aisles,
including the total number of products purchased
and the total number of unique products purchased from each aisle.
*/
CREATE TEMPORARY TABLE orders_aisle_analysis AS
SELECT
    a.aisle,
    COUNT(op.product_id) AS total_products_purchased,
    COUNT(DISTINCT op.product_id) AS total_unique_products_purchased
FROM orders o
INNER JOIN order_products op ON o.order_id = op.order_id
INNER JOIN products p ON op.product_id = p.product_id
INNER JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_products_purchased DESC
LIMIT 10;

-- Testing temporary table
SELECT *
FROM orders_aisle_analysis;

/*
5. Combine the information from the previous temporary tables into a final table that shows the 
product ID, product name, department ID, department name, aisle ID, aisle name,
total number of times purchased, total number of times reordered, average number of times added to cart,
total number of products purchased, total number of unique products purchased, total number of products purchased on weekdays, 
total number of products purchased on weekends, and average time of day products are ordered in each department.
*/
CREATE TEMPORARY TABLE final_analysis AS
SELECT
    opi.product_id,
    opi.product_name,
    opi.department_id,
    opi.department,
    opi.aisle_id,
    opi.aisle,
    ppa.total_products_purchased,
    ppa.total_products_reordered,
	ppa.average_of_times_added_to_cart,
	dpa.total_products_purchased AS total_products_department_purchased,
	dpa.total_unique_products_purchased AS total_unique_products_department_purchased,
	dpa.total_products_purchased_weekdays,
	dpa.total_products_purchased_weekends,
	dpa.average_time_of_day_products
FROM order_product_info opi
INNER JOIN product_purchase_analysis ppa ON opi.product_name = ppa.product_name
INNER JOIN department_purchase_analysis dpa ON opi.department = dpa.department;

-- Testing temporary table
SELECT *
FROM final_analysis;