--Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- Q1) Write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909
UPDATE orders SET city = null WHERE order_id in ('CA-2020-161389' , 'US-2021-156909');

-- Q2) write a query to find orders where city is null (2 rows)
SELECT * FROM orders WHERE city IS NULL;

-- Q3) write a query to get total profit, first order date and latest order date for each category
SELECT category, SUM(profit) AS total_profit, MIN(order_date) AS first_order_date, MAX(order_date) AS latest_order_date 
FROM orders
GROUP BY category;

-- Q4) write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category
SELECT sub_category --, AVG(profit) AS avg_profit, MAX(profit) AS max_profit
FROM orders
GROUP BY sub_category
HAVING AVG(profit) > 0.5*MAX(profit);

-- create the exams table with below script;

/*
create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);
*/
-- Q5) write a query to find students who have got same marks in Physics and Chemistry.
SELECT student_id, marks, count(marks) AS counts FROM exam
WHERE subject IN ('Physics', 'Chemistry')
GROUP BY student_id, marks
HAVING count(marks) = 2;

-- Q6) write a query to find total number of products in each category.
SELECT category, count(DISTINCT product_id) 
FROM orders
GROUP BY category;

-- Q7) write a query to find top 5 sub categories in west region by total quantity sold
SELECT TOP  5 sub_category, SUM(quantity) AS total_quantity_sold FROM orders
WHERE region = 'West'
GROUP BY sub_category
ORDER BY total_quantity_sold DESC;

-- Q8) write a query to find total sales for each region and ship mode combination for orders in year 2020
SELECT region, ship_mode, SUM(sales) AS total_sales
FROM orders
WHERE order_date LIKE '%2020%'
GROUP BY region, ship_mode
ORDER BY region;
/*
select region,ship_mode ,sum(sales) as total_sales
from orders
where order_date between '2020-01-01' and '2020-12-31'
group by region,ship_mode
ORDER BY region;
*/