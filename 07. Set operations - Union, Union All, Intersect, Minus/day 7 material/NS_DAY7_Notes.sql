--string functions
select order_id,customer_name
,trim(' ankit bansal ')
,reverse(customer_name) as rev
,REPLACE(order_id,'CA','PB') as replace_ca
,REPLACE(customer_name,' ','') as replace_space
,TRANSLATE(customer_name,'AC','B@') as translate_AG
,len(customer_name) as len_name
,left(customer_name,4) as name_4
,right(customer_name,5) as name_5
--,SUBSTRING(order_id,4,4) as order_year
,left(customer_name,CHARINDEX(' ',customer_name)) as first_name
,CHARINDEX(' ',customer_name) as space_position
,CHARINDEX('n',customer_name) as first_position
,concat(order_id,'-',customer_name)
,order_id+'-'+customer_name 
from orders;
--null handling function
select order_id,city,isnull(city,'unknown') as new_city,
isnull(sales,1) as new_city,
state,coalesce(city,state,region,'unknown') as neww_city
from orders
--where city is null
order by city;

select top 5 order_id,sales,cast(sales as int) as sales_int
,round(sales,1) as sales_int from orders;
--set queries 
--union all, union
create table orders_west
(
order_id int,
region varchar(10),
sales int
);


create table orders_east
(
order_id int,
region varchar(10),
sales int
);

insert into orders_west values(1,'west',100),(2,'west',200);
insert into orders_east values(3,'east',100),(4,'east',300);
insert into orders_west values(3,'east',100)
insert into orders_west values(1,'west',100)
select * from orders_west
union all
select * from orders_east;

select * from orders_west
union 
select * from orders_east;

select * from orders_east;
select * from orders_west;

select sales,order_id as sale from orders_east
union all
select order_id,sales from orders_west;

(select * from orders_east
except 
select * from orders_west)
union all
(select * from orders_west
except 
select * from orders_east);


select * from orders_east
union  
select * from orders_east

select *,null from orders_east
intersect  
select *,null from orders_east































