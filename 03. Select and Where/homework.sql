-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- Q1) write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)
SELECT * FROM orders WHERE customer_name like '_a_d%';

-- Q2) write a sql to get all the orders placed in the month of dec 2020 (352 rows) 
SELECT * FROM orders WHERE CAST(order_date as date) BETWEEN '2020-12-01' AND '2020-12-31';

-- Q3) write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)
SELECT * FROM orders WHERE ship_mode not in ('Standard Class', 'First Class') AND CAST(ship_date AS date) >= '2020-12-01'; 

-- Q4) write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)
SELECT * FROM orders WHERE customer_name not like 'A%n';

-- Q5) write a query to get all the orders where profit is negative (1871 rows)
SELECT * FROM orders WHERE profit < 0;

-- Q6) write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)
SELECT * FROM orders WHERE quantity < 3 OR profit = 0;

-- Q7) your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)
SELECT * FROM orders WHERE region = 'South' AND discount > 0;

-- Q8) write a query to find top 5 orders with highest sales in furniture category 
SELECT TOP 5 * FROM orders ORDER BY sales DESC; 

-- Q9) write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)
SELECT * FROM orders WHERE category IN ('Technology', 'Furniture') AND order_date LIKE '%2020%';

-- Q10) write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)
SELECT * FROM orders WHERE order_date LIKE '%2020%' AND ship_date LIKE '%2021%';