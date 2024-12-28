-- CASE 1:
-- Create two tables t1 and t2 with 2 and 3 records with same values and single column
create table t1
(id int);

create table t2
(id int);

insert into t1 
values
(1), (1);

insert into t2 
values
(1), (1), (1);

select * from t1;
select * from t2;

select * from t1
inner join  t2 on t1.id = t2.id;

select * from t1
left join  t2 on t1.id = t2.id;

select * from t1
right join  t2 on t1.id = t2.id;

select * from t1
full outer join  t2 on t1.id = t2.id;

-- If in 2 tables all the records are same, then regardless of join type the result will be (no.of rows in table 1) X (no. of rows in table 2)

-- Case 2:
insert into t1 
values
(2);

insert into t2 
values
(3);

select * from t1;
select * from t2;

select * from t1
inner join  t2 on t1.id = t2.id; -- 6

select * from t1
left join  t2 on t1.id = t2.id; -- 7

select * from t1
right join  t2 on t1.id = t2.id; -- 7

select * from t1
full outer join  t2 on t1.id = t2.id; -- 8

-- Case 3:
insert into t1 
values
(2);

insert into t2 
values
(2);

select * from t1;
select * from t2;

select * from t1
inner join  t2 on t1.id = t2.id; -- 8

select * from t1
left join  t2 on t1.id = t2.id; -- 8

select * from t1
right join  t2 on t1.id = t2.id; -- 9

select * from t1
full outer join  t2 on t1.id = t2.id; -- 9

-- Case 4:
insert into t1 
values
(4);

insert into t2
values
(2);

select * from t1;
select * from t2;

select * from t1
inner join  t2 on t1.id = t2.id; -- 12

select * from t1
left join  t2 on t1.id = t2.id; -- 13

select * from t1
right join  t2 on t1.id = t2.id; -- 13

select * from t1
full outer join  t2 on t1.id = t2.id; -- 14

-- Case 5:
insert into t1 
values
(null);

insert into t2
values
(null);

select * from t1;
select * from t2;

select * from t1
inner join  t2 on t1.id = t2.id; -- 12

select * from t1
left join  t2 on t1.id = t2.id; -- 14

select * from t1
right join  t2 on t1.id = t2.id; -- 14

select * from t1
full outer join  t2 on t1.id = t2.id; -- 15

-- ** NULL cannot be matched with NULL that's why in Inner Join, we see only 12 records