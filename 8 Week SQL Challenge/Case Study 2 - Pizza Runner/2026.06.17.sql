select * from runners;
select * from customer_orders;
select * from runner_orders;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;


--6.What was the maximum number of pizzas delivered in a single order?
WITH cro AS (
SELECT order_id,
	CASE WHEN cancellation IN ('null', 'NaN','') THEN NULL ELSE cancellation END AS cancellation
FROM runner_orders
)
SELECT max(pizza_count) AS max_pizza_in_one_order
FROM (
  SELECT co.order_id, COUNT(*) AS pizza_count
  FROM customer_orders co
  JOIN cro ON co.order_id = cro.order_id
  WHERE cro.cancellation IS NULL
  GROUP BY co.order_id
) sub;

--another solution
SELECT COUNT(*) AS max_pizzas_in_one_order
FROM customer_orders co
JOIN runner_orders ro
    ON co.order_id = ro.order_id
WHERE ro.cancellation IN ('null', 'NaN', '')
   OR ro.cancellation IS NULL
GROUP BY co.order_id
ORDER BY COUNT(*) DESC
LIMIT 1;




--another solution
SELECT MAX(pizza_count) AS max_pizzas_in_one_order
FROM (
    SELECT co.order_id,
           COUNT(*) AS pizza_count
    FROM customer_orders co
    JOIN runner_orders ro
        ON co.order_id = ro.order_id
    WHERE ro.cancellation IN ('null', 'NaN', '')
       OR ro.cancellation IS NULL
    GROUP BY co.order_id
) t;


--7.For each customer, 
--how many delivered pizzas had at least 1 change and how many had no changes?
WITH cco AS (
SELECT order_id,customer_id, pizza_id,
	CASE WHEN exclusions IN ('null', 'NaN','') THEN NULL ELSE exclusions END AS exclusions,
	CASE WHEN extras IN ('null', 'NaN','') THEN NULL ELSE extras END AS extras
FROM customer_orders
),
cro AS (
SELECT order_id,
	CASE WHEN cancellation IN ('null', 'NaN','') THEN NULL ELSE cancellation END AS cancellation
FROM runner_orders)
SELECT
cco.customer_id,
  SUM(CASE WHEN cco.exclusions IS NOT NULL OR cco.extras IS NOT NULL THEN 1 ELSE 0 END) AS with_changes,
  SUM(CASE WHEN cco.exclusions IS NULL     AND cco.extras IS NULL     THEN 1 ELSE 0 END) AS no_changes
FROM cco
JOIN cro ON cco.order_id = cro.order_id
WHERE cro.cancellation IS NULL
GROUP BY cco.customer_id
ORDER BY cco.customer_id;




--another solution
SELECT
    co.customer_id,
    SUM(
        CASE
            WHEN co.exclusions NOT IN ('null', 'NaN', '')
              OR co.extras NOT IN ('null', 'NaN', '')
            THEN 1
            ELSE 0
        END
    ) AS with_changes,
    SUM(
        CASE
            WHEN (co.exclusions IN ('null', 'NaN', '') OR co.exclusions IS NULL)
             AND (co.extras IN ('null', 'NaN', '') OR co.extras IS NULL)
            THEN 1
            ELSE 0
        END
    ) AS no_changes
FROM customer_orders co
JOIN runner_orders ro
    ON co.order_id = ro.order_id
WHERE ro.cancellation IN ('null', 'NaN', '')
   OR ro.cancellation IS NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;





--another solution
SELECT
    co.customer_id,
    COUNT(
        CASE
            WHEN (co.exclusions NOT IN ('null', 'NaN', '') AND co.exclusions IS NOT NULL)
              OR (co.extras NOT IN ('null', 'NaN', '') AND co.extras IS NOT NULL)
            THEN 1
        END
    ) AS with_changes,
    COUNT(
        CASE
            WHEN (co.exclusions IN ('null', 'NaN', '') OR co.exclusions IS NULL)
             AND (co.extras IN ('null', 'NaN', '') OR co.extras IS NULL)
            THEN 1
        END
    ) AS no_changes
FROM customer_orders co
JOIN runner_orders ro
    ON co.order_id = ro.order_id
WHERE ro.cancellation IN ('null', 'NaN', '')
   OR ro.cancellation IS NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;





















