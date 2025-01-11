
select s.phone_number,s.rn,s.start_time,e.end_time, datediff(minute,start_time,end_time) as duration
from 
(select *,row_number() over(partition by phone_number order by start_time) as rn  from call_start_logs) s
inner join (select *,row_number() over(partition by phone_number order by end_time) as rn  from call_end_logs) e
on s.phone_number = e.phone_number and s.rn=e.rn;

--write a query to print top 3 products in each category by year over year sales growth in year 2020--
select * from employee;

select *
,max(salary) over(partition by dept_id ) as sum_salary
,max(salary) over(order by salary desc) as max_running_salary
from employee;

select *
,sum(salary) over(partition by dept_id ) as dep_salary
,sum(salary) over( order by emp_id) as dep_running_salary
from employee;

select *
,sum(salary) over(partition by dept_id) as dep_running_salary
,sum(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and unbounded following ) 
as total_salary
from employee;

select *
,first_value(salary) over(order by salary) as first_salary
,first_value(salary) over(order by salary desc) as last_salary
,last_value(salary) over(order by salary rows between unbounded preceding and current row ) as last_salary
from employee;

select order_id,sales,sum(sales) over( order by order_id,row_id) as running_sales
from orders;

with month_wise_sales as 
(select datepart(year,order_date) as year_order,datepart(month,order_date) as month_order,sum(sales) as total_sales
from orders
group by datepart(year,order_date),datepart(month,order_date))
select 
year_order,month_order,total_sales
,sum(total_sales) over(order by year_order,month_order rows between 2 preceding and current row) as rolling_3_sales
from month_wise_sales;

--update,delete advance
--exist and not exists
--pivot and unpivot
--stored procedure
--indexes --performance 

































