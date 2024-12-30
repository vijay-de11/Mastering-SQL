-- Please solve these problems. You have option to solve them in MySQL, sql server and postgres. All are free questions.

--1- https://www.namastesql.com/coding-problem/38-product-reviews
--Sol: 
SELECT *
FROM  product_reviews
WHERE (LOWER(review_text) NOT LIKE '%not excellent%') AND (LOWER(review_text) NOT LIKE '%not amazing%') AND (LOWER(review_text) LIKE '%excellent%' OR
         LOWER(review_text) LIKE '%amazing%')
                                                                                                                                     
--2- https://www.namastesql.com/coding-problem/61-category-sales-part-1
-- Sol: 
SELECT category, SUM(amount) AS total_sales
FROM  sales
WHERE (DATEPART(year, order_date) = 2022) AND (DATEPART(month, order_date) = 2) AND (DATEPART(weekday, order_date) NOT IN (1, 7))
GROUP BY category
ORDER BY total_sales

3- https://www.namastesql.com/coding-problem/62-category-sales-part-2
-- Sol: 
SELECT c.category_name, CASE WHEN SUM(s.amount) IS NULL THEN 0 ELSE SUM(s.amount) END AS total_sales
FROM  categories AS c LEFT OUTER JOIN
         sales AS s ON c.category_id = s.category_id
GROUP BY c.category_name
ORDER BY total_sales

4- https://www.namastesql.com/coding-problem/71-department-average-salary
-- Sol: 
SELECT d.department_name, CAST(AVG(e.salary) AS DECIMAL(10, 2)) AS average_salary
FROM  employees AS e LEFT OUTER JOIN
         departments AS d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING (COUNT(e.employee_name) > 2)
ORDER BY average_salary DESC

5- https://www.namastesql.com/coding-problem/72-product-sales
-- Sol: 
SELECT p.product_name, SUM(s.quantity * p.price) AS total_sales
FROM  products AS p LEFT OUTER JOIN
         sales AS s ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY p.product_name

6- https://www.namastesql.com/coding-problem/73-category-product-count
-- Sol: 
SELECT category, LEN(products) - LEN(REPLACE(products, ',', '')) + 1 AS number_of_products
FROM  categories
ORDER BY number_of_products

7- https://www.namastesql.com/coding-problem/103-employee-mentor
--Sol: 
SELECT name
FROM  employees
WHERE (mentor_id IS NULL) OR
         (mentor_id <> 3);