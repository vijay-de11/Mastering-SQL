--Run the following command to add and update dob column in employee table
alter table  employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate());

-- Write a query to print emp name, their manager name, and difference in their age (in days) for employees whose year of birth is before their manager's year of birth.
select e1.emp_name as emp_name, e2.emp_name as manager_name, datediff(day, e1.dob, e2.dob) as age_difference
from employee e1
join employee e2
on e1.manager_id = e2.emp_id
where datepart(year, e1.dob) < datepart(year, e2.dob);

--** Write a query to find subcategories that never had any return orders in the month of November (irrespective of years).
select sub_category
from orders o
left join returns r on o.order_id=r.order_id
where DATEPART(month,order_date)=11
group by sub_category
having count(r.order_id)=0;

-- Write a query to find order IDs where there is only 1 product bought by the customer.
select distinct o.order_id from orders o
group by o.order_id
having count(o.order_id) = 1;

-- Write a query to print manager names along with the comma-separated list (order by emp salary) of all employees directly reporting to him.
select e1.emp_name as manager, string_agg(e2.emp_name, ',') within group (order by e2.salary) as employees
from employee e1
join
employee e2 on e2.manager_id = e1.emp_id
group by e1.emp_name;

-- ** Write a query to get the number of business days between order_date and ship_date (exclude weekends). Assume that all order date and ship date are on weekdays only.
-- OPTIMIZED QUERY
select order_date, ship_date, datediff(day, order_date, ship_date)-2*datediff(week, order_date, ship_date) as business_days from orders; 

--select datepart(weekday, '2024-12-29') as day_of_week;

-- ** Write a query to print 3 columns: category, total_sales, and (total sales of returned orders).
select o.category, sum(o.sales) as total_sales, 
sum(
	case
		when r.order_id is not null then o.sales
		else 0
	end) as total_sales_returned_orders
from orders o
left join returns r
on o.order_id = r.order_id
group by o.category;

-- Write a query to print the below 3 columns: category, total_sales_2019 (sales in the year 2019), total_sales_2020 (sales in the year 2020).
select o.category, sum(case 
when DATEPART(year, order_date) = 2019 then o.sales else 0 end)  as sales_in_2019,
sum(case when datepart(year, order_date) = 2020 then o.sales else 0 end) as sales_in_2020
from orders o
group by o.category;

-- Write a query to print the top 5 cities in the west region by the average number of days between order date and ship date.
select top 5 city, avg(datediff(day, order_date, ship_date)) as avg_no_days 
from orders
where region = 'West'
group by city
order by avg_no_days;

-- Write a query to print emp name, manager name, and senior manager name (senior manager is the manager's manager).
select e1.emp_name as emp_name, e2.emp_name as manager_name, e3.emp_name as senior_manager_name
from 
employee e1
join
employee e2
on e1.manager_id = e2.emp_id
join 
employee e3
on e2.manager_id = e3.emp_id;