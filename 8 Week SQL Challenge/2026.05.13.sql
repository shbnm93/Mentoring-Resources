select * from dannys_diner_members ddm 


select * from dannys_diner_menu ddm 


select * from dannys_diner_sales dds 



--7.Which item was purchased just before the customer became a member?
WITH ranked_orders AS (
    SELECT 
        s.customer_id,
        s.order_date,
        m.product_name,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC
        ) AS rn
    FROM dannys_diner_sales s
    JOIN dannys_diner_members mem
        ON s.customer_id = mem.customer_id
    JOIN menu m
        ON s.product_id = m.product_id
    WHERE s.order_date < mem.join_date
)
SELECT 
    customer_id,
    product_name,
    order_date
FROM ranked_orders
WHERE rn = 1;