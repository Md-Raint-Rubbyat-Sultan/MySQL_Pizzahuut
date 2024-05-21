-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
-- Determine the distribution of orders by hour of the day.
-- Find the category-wise distribution of pizzas.
-- Group the orders by date and calculate the average number of pizzas ordered per day.
-- Determine the top 3 most ordered pizza types based on revenue.

-- Ans

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category, sum(od.quantity) as total_order from order_details as od
inner join pizzas as p
on p.pizza_id = od.pizza_id
inner join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.category;

-- Determine the distribution of orders by hour of the day.
select `hour`, total_order from
(select hour(`time`) as `hour`, count(order_id) as total_order from orders
group by hour(`time`)) as hourly_order
order by total_order desc;

-- Find the category-wise distribution of pizzas.
select category, count(category) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
with order_per_day as (
	select `date`, sum(quantity) as quantity from orders as o
	inner join order_details as od
	on od.order_id = o.order_id
	group by `date`
)
select round(avg(quantity), 0) as average_order_per_day from order_per_day;

-- Determine the top 3 most ordered pizza types based on revenue.
select pt.name, pt.pizza_type_id, sum(p.price* od.quantity) as revenue from order_details as od
inner join pizzas as p
	on p.pizza_id = od.pizza_id
inner join pizza_types as pt
	on pt.pizza_type_id = p.pizza_type_id
group by pt.pizza_type_id
	order by revenue desc
    limit 3;