-- Cross Join
create table products
(id int, name varchar(2));

create table colors
(color_id int, color varchar(10));

create table sizes
(size_id int, size varchar(2));

create table transactions
(product_name varchar(2),
color varchar(10),
size varchar(2),
total_amount int);

insert into transactions
values
('A', 'Blue', 'L', 300),
('B', 'Blue', 'XL', 150),
('B', 'Green', 'L', 250),
('C', 'Blue', 'L', 250),
('D', 'Green', 'M', 250),
('D', 'Orange', 'L', 200),
('E', 'Green', 'L', 270);

insert into products
values
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

insert into colors
values
(1, 'Blue'),
(2, 'Green'),
(3, 'Orange');

insert into sizes
values
(1, 'M'),
(2, 'L'),
(3, 'XL');

select * from products;
select * from colors;
select * from sizes;
select * from transactions;

-- Ques). The manager wants all the products name, color and size with total sales for each combination;
select product_name, color, size, sum(total_amount) as sales
from transactions group by product_name, color, size;

-- usecase 1: prepare master data
with master_data as
(select p.name as product_name, c.color as color, s.size as size from products p, colors c, sizes s)
,
sales as
(select product_name, color, size, sum(total_amount) as total_amount
from transactions group by product_name, color, size)
select md.product_name, md.color, md.size, isnull(s.total_amount, 0) as total_amount
from master_data md
left join sales s
on md.product_name = s.product_name and md.color = s.color and md.size = s.size
order by s.total_amount;

-- usecase 2: prepare large no of rows for performance testing
-- ** To generate the larger dataset just cross join the smaller table with bigger table, but make sure we shouldn't have duplicate order_ids as in our case we will join the transaction table with orders table
select * from transactions t, orders o;
select row_number() over (order by o.order_id) as order_id, t.product_name, t.color, t.size, t.total_amount from transactions t, orders o;

-- To put the above query result into a table
create table transactions_test
(order_id int, product_name varchar(1), color varchar(10), size varchar(2), total_amount int);

insert into transactions_test
select row_number() over (order by o.order_id) as order_id, t.product_name, t.color, t.size, t.total_amount from transactions t, orders o;