--- filtering null values 
select * from orders
where city is null;
select * from orders
where city is not null ;
---aggregation
select  count(*) as cnt
,sum(sales) as total_sales
,max(sales) as max_sales
,min(profit) as min_profit
,avg(profit) as avg_profit
from orders;
--group by
select region, count(*) as cnt
,sum(sales) as total_sales
,max(sales) as max_sales
,min(profit) as min_profit
,avg(profit) as avg_profit
from orders
group by region;

select region,category,sum(sales) as total_sales
from orders
group by region;

select region,sum(sales) as total_sales
from orders
group by region;

select top 2 region,sum(sales) as total_sales
from orders
where profit>50
group by region
order by total_sales desc
;
select sub_category,sum(sales) as total_sales
from orders
group by sub_category
having sum(sales) > 100000
order by total_sales desc;

select top 5 sub_category,sum(sales) as total_sales
from orders
where profit>50
group by sub_category
having sum(sales) > 100000
order by total_sales desc



select top 5 sub_category,sum(sales) as total_sales
from orders
where sub_category = 'Phones'
group by sub_category
order by total_sales desc;

select sub_category,sum(sales) as total_sales
from orders
group by sub_category
having max(order_date) > '2020-01-01'
order by total_sales desc;

chairs, '2019-01-01', 100
chairs, '2019,10-10', 200
bookcases, '2019-01-01', 300
bookcases, '2020,10-10',400
bookcases,400
bookcases,700

select sub_category,min(order_date),sum(sales) as total_sales--, max(order_date)
from orders
group by sub_category
having max(order_date) > '2020-01-01'
order by total_sales desc;
bookcases
west

select sub_category,sum(sales) as total_sales--, max(order_date)
from orders
where order_date > '2020-01-01'
group by sub_category
order by total_sales desc;
chairs,300,'2019,10-10'
bookcases,700,'2020,10-10'

bookcases,700
---count
select count(distinct region),
count(*),
count(city),
sum(sales)
from
orders;
--9994
region, sales
'east',100
'east',0
'east',200
2, 3--> 2+3/2
select region, avg(sales) as avg_sales--150 -- sum(sales)/count(sales)
,sum(sales)/count(region) -- 100
from orders
group by region






















