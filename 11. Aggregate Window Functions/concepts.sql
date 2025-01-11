-- calculate avg_salary, max_salary, min_salary of each employee per department
select 
emp_id,
emp_name,
dept_id,
avg(salary) over(partition by dept_id) avg_salary,
max(salary) over(partition by dept_id) max_salary,
min(salary) over(partition by dept_id) min_salary
from employee;

-- If we use order by in aggregate window function then it will give the running (window function name) as per order by column
-- And if we just use order by without partition by then it will give the running (window function name) as per order by column
select 
emp_id,
emp_name,
dept_id,
salary,
sum(salary) over(partition by dept_id) sum_salary,
sum(salary) over(partition by dept_id order by emp_id) dept_running_sum
from employee;

-- In the below case if there are duplicates in the salary column, it will treat them as one single partition and add the values, so in order by we need to give one more column to make it unique (because currently we are doing order by on dept_id which has duplicates)
select 
emp_id,
emp_name,
dept_id,
salary,
sum(salary) over(order by dept_id desc) sum_salary
from employee;

--
select 
emp_id,
emp_name,
dept_id,
salary,
sum(salary) over(order by dept_id, emp_id desc) sum_salary
from employee;

-- ROLLING SUM
-- rows between 2 preceding and current row (take previous 2 rows + current row)
select 
emp_id,
emp_name,
dept_id,
salary,
sum(salary) over(order by emp_id rows between 2 preceding and current row) rolling_sum_v1,
sum(salary) over(order by emp_id rows between 1 preceding and 1 following) as rolling_sum_v2,
sum(salary) over(order by emp_id rows between 5 following and 10 following) as rolling_sum_v3
from employee;

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW (current row + all the previous row)
select 
*,
sum(salary) over(partition by dept_id order by emp_id) dept_running_salary,
sum(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and current row) as dept_running_salary_v1,
sum(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and unbounded following) as dept_running_salary_v2
from employee;

-- FIRST_VALUE(), LAST_VALUE()
select 
*,
FIRST_VALUE(salary) over(order by salary) first_salary,
LAST_VALUE(salary) over(order by salary) last_salary
from employee;

-- Actually both the FIRST_VALUE() and LAST_VALUE() looks at the current row and check the first_value() and last_value() till that row
-- So, we have to use ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
select 
*,
FIRST_VALUE(salary) over(order by salary rows between unbounded preceding and unbounded following) first_salary,
LAST_VALUE(salary) over(order by salary rows between unbounded preceding and unbounded following) last_salary
from employee;

-- Find the quarterly sales for orders
with total_sales as
(
	select datepart(year, order_date) as year_order, datepart(month, order_date) as month_order, sum(sales) as total_sales
	from orders
	group by datepart(year, order_date), datepart(month, order_date)
)
select 
year_order, month_order, total_sales,
sum(total_sales) over(order by year_order, month_order rows between 2 preceding and current row) rolling_sales 
from total_sales;