select * from runners;
select * from customer_orders;
select * from runner_orders;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;




--1.How many pizzas were ordered?
select count(order_id) as orders_count
from customer_orders;





--2.How many unique customer orders were made?
select count(distinct order_id) as unique_orders_count
from customer_orders;



--3.How many successful orders were delivered by each runner?
--asli hanim
select runner_id, count(*) as successful_orders
from runner_orders
where pickup_time is not null and pickup_time <> 'null'
group by runner_id 
order by runner_id;


--SOLUTION
with clean_runner_orders as (
select *,
	case when cancellation in ('null','NaN','') then NULL else
cancellation end as clean_cancellation
from runner_orders
)
select 
	runner_id,
	count(*) as successful_deliveries
from clean_runner_orders
where clean_cancellation  is NULL 
group by runner_id  
order by runner_id;  


--4.How many of each type of pizza was delivered?
--asli hanim
select 
	C.pizza_id,
	COUNT(*) AS delivered_count
from customer_orders C 
join runner_orders R
	on C.order_id = R.order_id 
where R.cancellation is null 
	or R.cancellation ='null'
	or R.cancellation = 'nan'
	or R.cancellation = ''
group by C.pizza_id
order by C.pizza_id;




--SOLUTION
with cro as (
select order_id,
	case when cancellation in ('null','NaN','') then NULL else
cancellation end as cancellation
from runner_orders
)
select 
	pn.pizza_name,
	count(*) as delivered_count
from customer_orders co
join cro on co.order_id = cro.order_id 
join pizza_names pn on co.pizza_id = pn.pizza_id
where cro.cancellation  is NULL 
group by pn.pizza_name;



--5.How many Vegetarian and Meatlovers were ordered by each customer?

--SOLUTION
select
	co.customer_id,
	pn.pizza_name,
	count(*) as order_count
from customer_orders co
join pizza_names pn on co.pizza_id = pn.pizza_id 
group by co.customer_id , pn.pizza_name 
order by co.customer_id , pn.pizza_name; 











