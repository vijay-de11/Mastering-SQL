-- Whenever we are retrieving any record, then it does the full-scan of the table which is inefficient, so if we have indexes then it retrieves the record much faster because now it doesn't need to scan the full table instead it uses BTree to search for the particular record.

-- Whenever we create a table using Primary Key , by default the Clustered Indexing is applied on PK column i.e. the data will always get inserted in sorted manner. We can see this from Indexes under table properties. We can have only 1 column in CLUSTERED INDEX

-- Non-cluster indexing -> This will also be applied on a column but it will have key-value pair (key-> column , value -> address)

-- Create table w/o primary key
create table emp_wo_pk
(
emp_id int,
emp_name varchar(20),
salary int
);
insert into emp_wo_pk
values
(4, 'Vijay', 1000),
(1, 'Bharti', 2000),
(3, 'Rohit', 3000),
(2, 'Sanjay', 4000);
select * from emp_wo_pk;
--drop table emp_wo_pk;
-- Lets create a table w/ primary key
create table emp_pk
(
emp_id int primary key,
emp_name varchar(20),
salary int
);
insert into emp_pk
values
(4, 'Vijay', 1000),
(1, 'Bharti', 2000),
(3, 'Rohit', 3000),
(2, 'Sanjay', 4000);
select * from emp_pk;
--drop table emp_pk;

-- Syntax to Create INDEXES
create index idx_emp on emp_wo_pk(emp_id);

-- If we don't specify the type of index during creation of index by default it will be non-clustered index
-- While creating an index we can specify how we want the data to be stored asc or desc

-- To see the index property applied on a table, we can run the below command:
execute sp_helpindex emp_wo_pk;

-- Learn the differences b/w Clustered Index and Non-Clustered Index
-- Clustered index is more efficient but the only limitation is we can have only one column as the index.
-- For more column to be part of Indexes we need to use Non-Clustered Index

select  row_number() over(order by a.row_id) as rn, a.* into orders_index 
from orders a, (select top 100 * from orders) b ;

select * from orders_index where rn=100; 
-- Right Click -> Display Estimated Execution Plan -> Hover over Table Scan below terminal -> Estimated number of rows to be read = 999400
-- Estimated Subtree Cost ~ 43
-- RID Lookup is also there because in nonclustered index first it will get the value then it will look in the table for the address associated to that value.

-- Now lets create index
create nonclustered index idx_rn on orders_index(rn);
-- Right Click -> Display Estimated Execution Plan -> Earlier we were seeing the Table Scan, now it is showing Index Seek -> Over hover Index Seek -> Estimated number of rows to be read = 1
-- Estimated Subtree Cost ~ 0.00328

-- Indexing should be done on columns which we are using in WHERE clause
-- Indexing can also be done on columns which are participating in joins to 2 or more tables

-- Let see the other scenario when we are just selecting the column name which is used in INDEXING
select rn from orders_index where rn=100;
-- Right Click -> Display Estimated Execution Plan -> Earlier we were getting RID Lookup also in the Execution plan, but now we don't see because we are just selecting the rn where it is 100 which we can get directly from the value, so we don't need the address associated to the value.

-- Now let say we want customer_id also to be part of index along with rn
drop index idx_rn on orders_index;
create nonclustered index idx_rn on orders_index(rn) include(customer_id);
select rn, customer_id from orders_index where rn=100;

-- Interview Question - Limitations of Index
-- It will make the Insert query slower because it has to insert the data in sorted order
-- The answer is DROP the Index , once the data is inserted then recreate the INDEX

-- Unique and Non-unique index
create unique nonclustered index idx_rn on orders_index(customer_id);
-- The operation failed because an index or statistics with name 'idx_rn' already exists on table 'orders_index'.
-- Unique index is faster

-- If we don't supply unique then it will be by default non-unique index
-- For an index to be unique, all the values of column must be unique on which indexing is applied
select * from orders_index where customer_id = 'DB-13270';
select * from orders_index where customer_id LIKE 'DB%';

create nonclustered index idx_cust on orders_index(customer_id asc, customer_name desc);

select customer_id, customer_name from orders_index where customer_id like 'DB%' and sales > 100;
-- If we run the Execution plan for this query, then SQL Server also suggests that we can use the suggested Index : it starts with Missing Index
-- Lets create the suggested Index and see the execution plan whether it uses lookup or not
create nonclustered index idx_sales on orders_index(customer_id asc, sales asc);
select customer_id, customer_name from orders_index where customer_id like 'DB%' and sales > 100;
-- Now if we see the QEP, then there isn't any lookup involved here which is faster than above index

-- How to delete duplicate records in a table (Interview Question)
-- Consider a case when we don't have primary key column in a table

create table emp_dup
(
emp_id int,
emp_name varchar(20),
create_time datetime
);
insert into emp_dup
values
(1, 'Vijay', CURRENT_TIMESTAMP),
(2, 'Rohit', CURRENT_TIMESTAMP)

delete from emp_dup where emp_id in 
(
select emp_id from emp_dup
group by emp_id having count(1) > 1
);
-- This command will delete both the records where emp_id=1 but we want the latest record
delete emp_dup from emp_dup e
join  
(
select emp_id, min(create_time) as create_time from emp_dup
group by emp_id having count(1) > 1
) d
on e.emp_id=d.emp_id and e.create_time=d.create_time
--
select * from emp_dup;

-- Suppose if the create_time column doesn't exists then we cannot delete the duplicate rows, but in Oracle it has a pesudo column called row_id which is useful in this kind of situations
-- In this kind of situation, we can create a backup of original table and just insert the distinct records
create table emp_dup1
(
emp_id int,
emp_name varchar(20)
);
insert into emp_dup1
values
(1, 'Vijay'),
(1, 'Vijay'),
(2, 'Rohit');
select distinct * from emp_dup1;
select distinct * into emp_dup1_bkp from emp_dup1;
select * from emp_dup1_bkp;
-- Now we can truncate the table emp_dup1
truncate table emp_dup1;
insert into emp_dup1 select * from emp_dup1_bkp;
select * from emp_dup1;

-- What if we have more than 2 duplicates for a single record
create table emp_dup
(
emp_id int,
emp_name varchar(20),
create_time datetime
);
insert into emp_dup
values
(1, 'Vijay', CURRENT_TIMESTAMP),
(2, 'Rohit', CURRENT_TIMESTAMP)

delete emp_dup 
--select * 
from emp_dup e
left join  
(
select emp_id, max(create_time) as create_time from emp_dup
group by emp_id 
) d
on e.emp_id=d.emp_id and e.create_time=d.create_time
where d.emp_id is null;
--
select * from emp_dup order by emp_id, create_time desc;

with delete_duplicates as
(
select 
*,
row_number() over(partition by emp_id order by create_time desc) rn
from emp_dup
)
--delete
select * 
from delete_duplicates where rn>1;

select * from emp_dup;
select * from emp_dup1;
--
-- Delete duplicate records from table where create_time column not exists
with delete_duplicates as
(
select 
*,
row_number() over(partition by emp_id order by emp_id desc) rn
from emp_dup1
)
--delete
select * 
from delete_duplicates where rn>1;

select * from emp_dup1;