-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- Q1- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
-- In case a department has less than 3 employees then print the details of highest salaried employee in that department.
select * from employee;
select * from dept;

select 
	emp_name, emp_age, dept_id, salary, rn
from 
(
select e.emp_name, e.emp_age, e.dept_id, e.salary,
row_number() over(partition by e.dept_id order by e.salary desc, e.emp_age asc) rn,
rank() over(partition by e.dept_id order by e.salary desc, e.emp_age asc) rnk
from employee e
) t
where rn=3 or (select count(*) from employee where dept_id = t.dept_id) < 3 and rn = 1;

--Q2- write a query to find top 3 and bottom 3 products by sales in each region.
select o.product_id, o.region, o.sales from orders o;

select product_id, region, sales from
(
select  o.product_id, o.region, o.sales,
row_number() over(partition by o.region order by o.sales desc) as rn
from orders o
) t
where rn <= 3 or rn > (select count(region) from orders where region=t.region)-3;
--
-- More optimized query
select product_id, region, sales from
(
select  o.product_id, o.region, o.sales,
row_number() over(partition by o.region order by o.sales desc) as rn1
from orders o
) t
where rn1 <= 3
union all
select product_id, region, sales from
(
select  o.product_id, o.region, o.sales,
row_number() over(partition by o.region order by o.sales asc) as rn1
from orders o
) t
where rn1 <= 3
order by region, sales desc;

--Q3- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.
select sub_category, sales from orders where DATEPART(month, order_date)=1 and DATEPART(year, order_date)=2020 order by sub_category;
select sub_category, sales, order_date,
lag(sales,1,0) over(partition by sub_category order by sales desc) lag_sales
from orders ;

--Q4- 4- write a query to print top 3 products in each category by year over year sales growth in year 2020.
select category, sales, year_over_year_growth from
(
select category, sales,
row_number() over(partition by category order by sales desc) rn,
lag(sales, 1, 0) over(partition by category order by sales desc) year_over_year_growth
from (
select category, sales, datepart(year, order_date) as sales_year
from orders where datepart(year, order_date)=2020
) t
) u
where rn <= 3

--Q5- create below 2 tables 
select * from call_start_logs;
select * from call_end_logs;

-- write a query to get start time and end time of each call from above 2 tables.Also create a column of call duration in minutes.  Please do take into account that there will be multiple calls from one phone number and each entry in start table has a corresponding entry in end table.

select a.phone_number, a.start_time, b.end_time, datepart(MINUTE,(b.end_time-a.start_time)) as call_duration_in_mins from
(
select csl.phone_number, csl.start_time,
row_number() over(partition by csl.phone_number order by csl.start_time) as rn_start
from call_start_logs csl
) a
inner join
(
select cel.phone_number, cel.end_time,
row_number() over(partition by cel.phone_number order by cel.end_time) as rn_end
from call_end_logs cel
) b
on a.phone_number=b.phone_number and a.rn_start=b.rn_end;

--Q6-https://www.namastesql.com/coding-problem/64-penultimate-order
--Sol:
select order_id, order_date, customer_name, product_name, sales from 
(select order_id, order_date, customer_name, product_name, sales,
row_number() over(partition by customer_name order by sales) sales_rn
from orders) t
where sales_rn=(select count(*) from orders where customer_name=t.customer_name)-1
or sales_rn=1 and (select count(*) from orders where customer_name=t.customer_name)=1;

--Q7-https://www.namastesql.com/coding-problem/26-dynamic-pricing
--Sol: 
select product_id, sum(price) as total_sales
from products
group by product_id;