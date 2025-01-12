--1- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.
with top_3_products as
(
	select category, product_id, datepart(year, order_date) as order_year, datepart(month, order_date) as order_month, sum(sales) as total_sales
	from orders
	where datepart(year, order_date)=2020 and datepart(month, order_date)=01
	group by category, product_id, datepart(year, order_date),  datepart(month, order_date)
)
,
intermediate_result as
(
select *,
sum(total_sales) over(partition by category order by category rows between 2 preceding and current row) rolling_sum,
row_number() over(partition by category order by total_sales desc) rn
from top_3_products
)
select * from intermediate_result where rn <= 3;
----
--2- write a query to find products for which month over month sales has never declined.
with never_declined_sales as
(
select product_id, datepart(year, order_date) as order_year, datepart(month, order_date) as order_month, sum(sales) as month_sales
from orders 
group by product_id, datepart(year, order_date), datepart(month, order_date)
),
intermediate_declined_results as
(
select 
*, lag(month_sales,1,0) over(partition by product_id order by order_year, order_month) mom_sales
from never_declined_sales
)
select distinct product_id from intermediate_declined_results where product_id not in
(select product_id from intermediate_declined_results where month_sales < mom_sales group by product_id);

--3- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.
with category_wise_sales as
(
select category, datepart(year, order_date) as order_year, datepart(month, order_date) as order_month, sum(sales) as month_sales
from orders 
group by category, datepart(year, order_date), datepart(month, order_date)
),
intermediate_result as
(
select 
category, order_year, order_month, month_sales,
sum(month_sales) over(partition by category  order by order_year, order_month rows between 2 preceding and 1 preceding) two_months_rolling_sales
from category_wise_sales
)
select * from intermediate_result where month_sales > two_months_rolling_sales
order by category, order_year, order_month;