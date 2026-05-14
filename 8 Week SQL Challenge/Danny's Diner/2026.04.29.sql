select * from dannys_diner_members ddm 


select * from dannys_diner_menu ddm 


select * from dannys_diner_sales dds 

--1. What is the total amount each customer spent at the restaurant?
select
	dds.customer_id,
	sum(ddm.price) as total_sales
from dannys_diner_sales dds
left join dannys_diner_menu ddm on dds.product_id = ddm.product_id 
group by dds.customer_id 
order by dds.customer_id;

--2. How many days has each customer visited the restaurant?
select
	customer_id,
	count(distinct order_date) as visit_count
from dannys_diner_sales dds 
group by customer_id;



--3. What was the first item from the menu purchased by each customer?
--samime hanim
select
	dds.customer_id,
	dds.order_date,
	ddm.product_name
from dannys_diner_sales dds
left join dannys_diner_menu ddm on dds.product_id = ddm.product_id 
--group by dds.customer_id
order by dds.customer_id , dds.order_date

--hilal hanim
SELECT 
	dds.customer_id, 
	ddm.product_name
FROM dannys_diner_sales dds
JOIN dannys_diner_menu ddm ON dds.product_id = ddm.product_id
WHERE (dds.customer_id, dds.order_date) IN (
SELECT 
	customer_id, 
	MIN(order_date)
FROM dannys_diner_sales dds
GROUP BY customer_id);

--window functions
with cte as (
select
	dds.customer_id,
	dds.order_date,
	ddm.product_name,
	dense_rank() over(partition by dds.customer_id 
					  order by dds.order_date) as rank
from dannys_diner_sales dds
left join dannys_diner_menu ddm on dds.product_id = ddm.product_id 
)
select
	customer_id,
	product_name 
from cte  
where rank = 1
group by customer_id, product_name;

























