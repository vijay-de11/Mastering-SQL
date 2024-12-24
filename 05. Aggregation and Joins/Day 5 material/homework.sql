-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- Q1) write a query to get region wise count of return orders
select o.region, count(distinct r.order_id) as returned_orders -- added distinct after referring to soln
from returns r inner join orders o
on r.order_id = o.order_id
group by o.region;

-- Q2) write a query to get category wise sales of orders that were not returned
select o.category, count(o.order_id) as not_returned_orders, sum(o.sales) as total_sales
from orders o left join returns r
on o.order_id = r.order_id
where r.order_id is null
group by o.category;

-- Q3) write a query to print dep name and average salary of employees in that dep .
select d.dep_name as dept_name, avg(e.salary) as avg_salary
from dept d join employee e
on d.dep_id = e.dept_id
group by d.dep_name;

-- Q4) ** write a query to print dep names where none of the employees have same salary.
select d.dep_name
from dept d
join employee e
on d.dep_id = e.dept_id
group by d.dep_name
having count(e.salary) = count(distinct e.salary);

-- Q4) ** write a query to print dep names where none of the employees have same salary.
select d.dep_name from dept d
join employee e
on d.dep_id = e.dept_id
group by d.dep_name
having count(e.salary) != count(distinct e.salary);

-- ** Q5) write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)
select distinct o.sub_category as sub_category from orders o
join returns r
on o.order_id = r.order_id
group by o.sub_category
having count(distinct r.return_reason) = 3;

-- Q6) write a query to find cities where not even a single order was returned.
select o.city
from orders o
left join returns r on o.order_id=r.order_id
group by o.city
having count(r.order_id)=0

-- Q6) If you want cities where at least one order was not returned
select distinct o.city from orders o
left join returns r
on o.order_id = r.order_id
where r.order_id is null;

-- Q7) write a query to find top 3 subcategories by sales of returned orders in east region
select top 3 o.sub_category, sum(o.sales) as sales
from orders o
join returns r
on o.order_id = r.order_id
where o.region = 'East'
group by o.sub_category
order by sales desc;

-- Q8) write a query to print dep name for which there is no employee
select d.dep_name as dep_name
from dept d left join employee e
on d.dep_id = e.dept_id
where e.dept_id is null;

select d.dep_id,d.dep_name
from dept d 
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;

-- Q9) write a query to print employees name for dep id is not avaiable in dept table
select e.emp_name
from employee e left join dept d
on e.dept_id = d.dep_id
where d.dep_id is null;