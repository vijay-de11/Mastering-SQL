-- Write a query to print emp_name, salary and dep_id of highest salaried employee in each department;
select * from employee;
select * from dept;

-- Using subquery
select emp_name, t.* from
(
select e.dept_id, max(e.salary) as highest_salary
from employee e
group by e.dept_id
) t
join employee e
on t.dept_id = e.dept_id and e.salary = highest_salary;

-- ROW_NUMBER
select * from (
select e.*,
ROW_NUMBER() OVER(partition by e.dept_id order by e.salary desc) as rn
from employee e
) t 
where rn <= 2;

-- RANK
select e.*,
ROW_NUMBER() OVER(partition by e.dept_id order by e.salary desc) as rn,
RANK() OVER(partition by e.dept_id order by e.salary desc) as rnk,
ROW_NUMBER() OVER(partition by e.dept_id, e.salary order by e.salary desc) as rn1
from employee e

-- whenever we use row_number(), rank() its necessary to use over(order by <col_name>) whereas partition by is optional and in that case there will be a single window of all the records
-- We can have more than one columns in partition by and the combinations of those columns will be considered as a single window

--DENSE_RANK() -- it doesn't skip the ranks unlike in RANK() where it was skipping the ranks if two rows have same rank
select e.*,
ROW_NUMBER() OVER(partition by e.dept_id order by e.salary desc) as rn,
RANK() OVER(partition by e.dept_id order by e.salary desc) as rnk,
DENSE_RANK() OVER(partition by e.dept_id order by e.salary desc) as dr
from employee e

--- Find the top 2 highest selling product in each category
select category, product_id, total_sales from (
select t.* , row_number() over(partition by t.category order by t.total_sales desc) rn from
(
select category, product_id, sum(sales) as total_sales
from orders
group by category, product_id
) t
) q
where rn <= 5;

--- LEAD()
select *,
LEAD(e.emp_id, 1) OVER(order by e.salary desc) as lead_emp
from employee e;

select *,
LEAD(e.salary, 1) OVER(partition by dept_id order by e.salary desc) as lead_emp
from employee e;

select *,
LEAD(e.salary, 1, salary) OVER(partition by dept_id order by e.salary desc) as lead_emp
from employee e

-- LAG()
select *,
LAG(e.emp_id, 1) OVER(order by e.salary desc) as lag_emp
from employee e;

select *,
LAG(e.salary, 1) OVER(partition by dept_id order by e.salary desc) as lag_emp
from employee e;

select *,
LEAD(e.salary, 1) OVER(partition by dept_id order by e.salary asc) as lead_emp
from employee e;

select *,
LAG(e.salary, 1) OVER(partition by dept_id order by e.salary desc) as lag_emp
from employee e;

-- FIRST_VALUE, LAST_VALUE
select *,
LEAD(e.salary, 1) OVER(partition by dept_id order by e.emp_name desc) as lead_emp,
FIRST_VALUE(e.salary) over(partition by dept_id order by e.emp_name desc) as first_value
--,LAST_VALUE(e.salary) over(partition by dept_id order by e.emp_name desc) as last_value
from employee e;