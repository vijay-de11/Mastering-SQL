-- To avoid redundant data in a table, we create dimensions
-- facts tables, dimensions tables
-- ER Diagram
-- columns -> attributes
-- tables -> entities
--> orders -> we are storing txns -> fact table
	--> customer -> dimension table
	--> product -> dimension table

-- First we will create ER diagram
-- To create ER diagram, we will use LUCID chart
-- Once we are done with ER diagram creation, we can export it as per different SQL engines and it will give us the DDL

-- Six things to keep in mind while creating ER diagram
--1. Entity
--2. Attributes
--3. Relationship
--4. Cardinality
--5. Primary Key (PK)
--6. Foreign Key (FK)

-- We can also create the ER diagram using CREATE TABLE commands in LUCID
-- Go to LUCID
-- Click Import -> Import your database -> Choose the DBMS -> Paste the DDL query from DBMS to LUCID
-- It will create the ER Diagram

-- This is also know as Dimension Modelling as we are segregating Facts and Dimensions

-- identity(1,1) - it will start the value from 1 and increase by 1 , its an auto increment which is applied on the primary key mostly

-- We must always populate the data into DIMENSION table first and then to FACT table
-- We can easily create the DIMENSION table using below command:
-- INSERT INTO dimension_table SELECT * FROM original_table;

-- While inserting data into FACT table, we may need to JOIN the DIMENSTION table to load the data
-- INSERT INTO fact_table select order_id, p.product_key from orders o inner join products p on o.product_id=p.product_id;
-- If there are duplicate rows in product table then FACT table will have more rows
-- To resolve this, we can use the concept of row_id which is surrogate key and is present in all the tables
/*
delete from orders where row_id in (
select min(row_id) from orders group by order_id, product_id
having count(1) > 1);
*/