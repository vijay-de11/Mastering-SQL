select top 5*
from orders 
order by order_date desc
;
--to get distinct value of a column
select distinct order_date from orders
order by order_date;

select distinct ship_mode,segment from orders;

select distinct * from orders;
---filters-----
select * from orders
where ship_mode='First Class';

select * from orders
where order_date='2020-12-08';

select order_date,quantity 
from orders
where quantity != 5
order by quantity desc;


select * from orders
where order_date < '2020-12-08'
order by order_date desc
;


select * from orders
where order_date between '2020-12-08' and '2020-12-12'
order by order_date desc

select * from orders
where quantity between 3 and 5
order by quantity desc;

select distinct ship_mode from orders
where ship_mode in ('First Class','Same Day');


select * from orders
where quantity in (3, 5 , 4)
order by quantity desc;

select distinct ship_mode from orders
where ship_mode not in ('First Class','Same Day');


select distinct ship_mode from orders
where ship_mode >= 'Second Class'

select order_date, ship_mode,segment from orders
where ship_mode = 'First Class' and segment='Consumer'


select order_date, ship_mode,segment from orders
where ship_mode = 'First Class' or segment='Consumer'

select distinct ship_mode from orders
where ship_mode in ('First Class','Same Day');

select * from orders
where ship_mode = 'First Class' or ship_mode='Same Day'; --or filter always increase rows

select * from orders where quantity>5 and order_date<'2020-11-08' -- and will decrease;

select *,profit/sales as ratio,profit*sales,getdate() as total
from orders
where order_date between  '2022-11-01 12:00:00' and  '2022-11-01 12:40:00'
order by order_date
;
--pattern matching like operator
select order_id,order_date,customer_name
from orders
where customer_name like 'Chris%';

select order_id,order_date,customer_name
from orders
where customer_name like '%t';

select order_id,order_date,customer_name
from orders
where customer_name like '%ven%';


select order_id,order_date,customer_name,upper(customer_name) as name_upper
from orders
where upper(customer_name) like 'A%A' ;


select order_id,order_date,customer_name
from orders
where customer_name like '_l%' ;
--%--0 or more any characters
-- _ - > one character

select order_id,order_date,customer_name
from orders
where customer_name like 'C[albo]%'


select order_id,order_date,customer_name
from orders
where customer_name like 'C[^albo]%';


select order_id,order_date,customer_name
from orders
where order_id like 'CA-20[][1-2]%'
order by customer_name



















 











