select * from dannys_diner_members members 


select * from dannys_diner_menu ddm 


select * from dannys_diner_sales dds 

--8.What is the total items and amount spent for each member before they became a member?

select
    dds.customer_id,
	count(dds.product_id) as total_items,
	sum(ddm.price) as total_sales
from dannys_diner_sales dds 
inner join dannys_diner_members members  on dds.customer_id = members.customer_id
and dds.order_date < members.join_date
inner join dannys_diner_menu ddm on dds.product_id = ddm.product_id
group by dds.customer_id 
order by dds.customer_id;







--samime hanim
select
    dds.customer_id,
	count(dds.product_id) as total_items,
	sum(ddm.price) as total_sales
--	order_date
from dannys_diner_sales dds 
inner join dannys_diner_members members  on dds.customer_id = members.customer_id
inner join dannys_diner_menu ddm on dds.product_id = ddm.product_id
where dds.order_date < members.join_date
group by dds.customer_id 
order by dds.customer_id;




--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier -
-- how many points would each customer have?
with points_cte as (
select
	ddm.product_id,
	case 
		when product_id = 1 then price * 20
		else price * 10 
	end as points
from dannys_diner_menu ddm)
select 
	dds.customer_id,
	sum(points_cte.points) as total_points
from dannys_diner_sales dds 
inner join points_cte on dds.product_id = points_cte.product_id 
group by dds.customer_id 
order by dds.customer_id;

	
--ikinci cozum:
select 
    dds.customer_id,
    sum(
        case 
            when dds.product_id = 1 then ddm.price * 20
            else ddm.price * 10
        end
    ) as total_points
from dannys_diner_sales dds
join dannys_diner_menu ddm
    on dds.product_id = ddm.product_id
group by dds.customer_id
order by dds.customer_id;



--ucuncu cozum
select 
    dds.customer_id,
    sum(
        case 
            when ddm.product_name = 'sushi' then ddm.price * 20
            else ddm.price * 10
        end
    ) as total_points
from dannys_diner_sales dds
join dannys_diner_menu ddm
    on dds.product_id = ddm.product_id
group by dds.customer_id
order by dds.customer_id;


--10:
--In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi -
--how many points do customer A and B have at the end of January?
with dates_cte as (
select 
	customer_id,
	join_date,
	join_date + interval '6 days' as valid_date,
	date_trunc('month', '2021-01-31'::date)
		+ interval '1 month'
		- interval '1 day' as last_date
from dannys_diner_members
)
select
	dds.customer_id,
	sum(
	case 
--            when ddm.product_name = 'sushi' then ddm.price * 20
            when dds.order_date
            between dates.join_date and dates.valid_date then ddm.price * 20
            else ddm.price * 10
        end
) as points
from dannys_diner_sales dds 
join dates_cte dates on dds.customer_id = dates.customer_id 
and dds.order_date between dates.join_date and dates.last_date 
join dannys_diner_menu ddm on dds.product_id = ddm.product_id 
group by dds.customer_id;










--dogru cevap mi?
WITH dates_cte AS (
  SELECT 
    customer_id, 
    join_date, 
    join_date + INTERVAL '6 days' AS valid_date
  FROM dannys_diner_members
)
SELECT 
  s.customer_id, 
  SUM(
    CASE 
      WHEN s.order_date BETWEEN d.join_date AND d.valid_date THEN m.price * 20
      WHEN m.product_name = 'sushi' THEN m.price * 20
      ELSE m.price * 10 
    END
  ) AS points
FROM dannys_diner_sales s
JOIN dates_cte d ON s.customer_id = d.customer_id
JOIN dannys_diner_menu m ON s.product_id = m.product_id
WHERE s.order_date <= '2021-01-31' 
GROUP BY s.customer_id;































