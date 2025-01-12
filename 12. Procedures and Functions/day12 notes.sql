--procedure
drop procedure spemp;
alter procedure spemp (@dept_id int , @cnt int out)
as
select @cnt = count(1) from employee where dept_id=@dept_id
if @cnt=0
print 'there is no employee in this dept'
else
print 'total employees ' + cast(@cnt as varchar(10))
;

declare @cnt1 int
exec spemp  100 , @cnt1  out
print @cnt1;

select datepart(year,order_date),order_date,row_id, quantity,[dbo].[fnproduct](row_id,quantity) from orders;

alter function fnproduct (@a int , @b int = 200)
returns decimal(5,2)
as
begin
return (select @a * @b)
end
select [dbo].[fnproduct](4,default)
;
--pivot and unpivot
select * from orders
--category, sales_2020,sales_2021
select
category
,sum(case when datepart(year,order_date)=2020 then sales end) as sales_2020 
,sum(case when datepart(year,order_date)=2021 then sales end) as sales_2021
from
orders
group by category;

select * from
(select category , datepart(year,order_date) as yod , sales
from orders) t1
pivot (
sum(sales) for yod in ([2020],[2021])
) as t2;

select * from
(select category , region , sales
from orders) t1
pivot (
sum(sales) for region in (West,East,South)
) as t2;

select * into sales_yearwise from
(select category , region , sales
from orders) t1
pivot (
sum(sales) for region in (West,East,South)
) as t2
select * from sales_yearwise

select * into orders_back from orders

--create table orders_east as (select *  from orders where region='East')

select * from orders_east

insert into  orders select * from orders_back;























































