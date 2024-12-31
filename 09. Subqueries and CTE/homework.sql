-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- 1- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.
--select customer_name, count(distinct order_id) as total_orders
--from orders 
--group by customer_name;

--with total_orders as
--(
--	select customer_name, count(distinct order_id) as total_orders_per_customer
--from orders
--group by customer_name
--),
--avg_orders as
--(
--select customer_name, avg(total_orders_per_customer) as avg_orders_per_customer
--from total_orders
--group by customer_name
--)
--select a.customer_name, a.avg_orders_per_customer, t.total_orders_per_customer from total_orders t join avg_orders a
--on a.customer_name = t.customer_name where t.total_orders_per_customer >= a.avg_orders_per_customer;

-- 2- write a query to find employees whose salary is more than average salary of employees in their department
select e.*, avg_salary_dept from employee e
inner join 
(select e.dept_id, avg(e.salary) as avg_salary_dept from employee e
group by e.dept_id) a
on e.dept_id = a.dept_id
where e.salary > avg_salary_dept;

-- 3- write a query to find employees whose age is more than average age of all the employees.
select * from employee where emp_age > (
select avg(emp_age) as avg_age from employee
);

-- 4- write a query to print emp name, salary and dep id of highest salaried employee in each department 
select * from employee;
--select * from dept;

select d.dept_id, e.emp_name, e.salary from employee e
inner join 
(select dept_id, max(salary) as highest_salary from employee
group by dept_id) d
on e.dept_id = d.dept_id and e.salary = d.highest_salary;

-- 5- write a query to print emp name, salary and dep id of highest salaried overall
select e.dept_id, e.emp_name, e.salary from employee e
inner join 
(select max(salary) as highest_salary from employee) d
on e.salary = d.highest_salary;

-- 6- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
select top 5 * from orders;

select category, product_id, sum(quantity) as total_sales
from orders
group by category, product_id
order by total_sales desc;

-- 7-*** https://www.namastesql.com/coding-problem/8-library-borrowing-habits
-- Sol: 
select borr.borrowername as BorrowerName, string_agg(book.bookname, ',') within group (order by book.bookname) as BorrowedBooks
from borrowers borr
join books book
on  book.bookid = borr.bookid
group by borr.borrowername
order by BorrowedBooks;

-- 8- https://www.namastesql.com/coding-problem/52-loan-repayment
--Sol: 
select temp.loan_id, temp.loan_amount, max(temp.due_date) as due_date,
case when temp.loan_amount = sum(temp.amount_paid) then 1 else 0 end as fully_paid_flag,
case when temp.loan_amount = sum(temp.amount_paid) and max(temp.payment_date) <=  max(temp.due_date) then 1 else 0 end as on_time_flag
from loans l
join 
(
select l.loan_id, l.loan_amount, l.due_date, p.amount_paid, p.payment_date
from loans l
inner join payments p
on l.loan_id = p.loan_id ) temp
on l.loan_id = temp.loan_id
group by temp.loan_id, temp.loan_amount;

-- 9- https://www.namastesql.com/coding-problem/55-lowest-price
--Sol: 
with higher_ratings as
(
select category, min(price) as price
from 
(select pr.category, pr.price
from products pr
left join purchases pu
on pr.id = pu.product_id
where stars >= 4) t
group by category
),
lower_ratings as
(
  select pr.category, '0' as price
  from products pr
  left join purchases pu
  on pr.id = pu.product_id
  where pu.stars < 4  and pr.category not in (select category from higher_ratings) or pu.product_id is null
)
select category, price from higher_ratings
union
select category, price from lower_ratings;