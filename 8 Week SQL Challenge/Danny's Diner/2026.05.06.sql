select * from dannys_diner_members members 


select * from dannys_diner_menu ddm 


select * from dannys_diner_sales dds 



--4. What is the most purchased item on the menu and how many times 
--was it purchased by all customers?
select 
	ddm.product_name,
	count(dds.product_id) as most_purchased_item
from dannys_diner_sales dds
join dannys_diner_menu ddm on dds.product_id = ddm.product_id 
group by ddm.product_name
order by most_purchased_item desc
limit 1;


--Hilal Akyıldız
SELECT 
    m.product_name,
    COUNT(*) AS total_orders
FROM dannys_diner_sales s
JOIN dannys_diner_menu m 
    ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_orders DESC
LIMIT 1;

--5.Which item was the most popular for each customer?
with most_popular as (
select
	dds.customer_id,
	ddm.product_name,
	count(ddm.product_id) as order_count,
	dense_rank() over(partition by dds.customer_id
					 order by count(dds.customer_id) desc) as rank
from dannys_diner_sales dds
join dannys_diner_menu ddm on dds.product_id = ddm.product_id 
group by dds.customer_id , ddm.product_name
)
select 
customer_id,
product_name,
order_count
from most_popular
where rank = 1;


--Hilal Akyıldız
WITH customer_orders AS (
    SELECT 
        s.customer_id,
        m.product_name,
        COUNT(*) AS order_count
    FROM dannys_diner_sales s
    JOIN dannys_diner_menu m 
        ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY customer_id 
            ORDER BY order_count DESC
        ) AS rnk
    FROM customer_orders
)
SELECT 
    customer_id,
    product_name,
    order_count
FROM ranked
WHERE rnk = 1;


--6.Which item was purchased first by the customer 
--after they became a member?
with joined_as_member as (
select
	members.customer_id,
	dds.product_id,
	row_number() over(partition by members.customer_id
	                 order by dds.order_date) as row_num
from dannys_diner_sales dds
join dannys_diner_members members on members.customer_id = dds.customer_id
and dds.order_date > members.join_date
)
select
customer_id,
product_name
from joined_as_member
join dannys_diner_menu ddm on  joined_as_member.product_id = ddm.product_id
where row_num = 1
order by customer_id asc;








