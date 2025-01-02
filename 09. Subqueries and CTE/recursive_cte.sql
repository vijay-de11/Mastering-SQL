-- recursive cte

with cte_numbers as
(
	select 1 as num -- ancchor query
	union all
	select num+1 -- recursive query
	from cte_numbers
	where num < 6 -- filter to stop the recursion
)
select num from cte_numbers;

------
-- Leetcode Premium Problem: Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name and report_year.

-- Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.
CREATE TABLE Product (
    product_id INT NOT NULL,
    product_name VARCHAR(50) NOT NULL
);

INSERT INTO product (product_id, product_name)
VALUES
    (1, 'LC Phone'),
    (2, 'LC T-Shirt'),
    (3, 'LC Keychain');

CREATE TABLE sales (
    product_id INT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    average_daily_sales INT NOT NULL
);

INSERT INTO sales(product_id, period_start, period_end, average_daily_sales)
VALUES
    (1, '2019-01-25', '2019-02-28', 100),
    (2, '2018-12-01', '2020-01-01', 10),
    (3, '2019-12-01', '2020-01-31', 1);

-- Sol:
select * from sales;

with all_dates as
(
	select min(period_start) as min_date,
	max(period_end) as max_date 
	from sales
	union all
	select dateadd(day, 1, min_date) as dates, max_date
	from all_dates
	where dateadd(day, 1, min_date) < max_date
)
select product_id, year(min_date) as report_year, sum(average_daily_sales) as total_amount from all_dates
inner join sales s
on dateadd(day, 1, min_date) between period_start and period_end
group by product_id, year(min_date)
option (maxrecursion 1000);