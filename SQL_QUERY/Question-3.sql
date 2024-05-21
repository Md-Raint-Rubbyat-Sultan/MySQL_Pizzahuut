-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
-- Analyze the cumulative revenue generated over time.
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

-- Ans

-- Calculate the percentage contribution of each pizza type to total revenue.
with revenue_per_type as (
    select
        pt.pizza_type_id, 
        SUM(p.price * od.quantity) as revenue
    from
        order_details as od
    inner join
        pizzas as p on p.pizza_id = od.pizza_id
    inner join
        pizza_types as pt on pt.pizza_type_id = p.pizza_type_id
    group by
        pt.pizza_type_id
),

total_revenue as (
    select
        SUM(revenue) as total_revenue
    from
        revenue_per_type
)

select
    rpt.pizza_type_id,
    round(((rpt.revenue / tr.total_revenue) * 100), 2) as percentage_contribution
from
    revenue_per_type as rpt,
    total_revenue as tr
	order by rpt.pizza_type_id;
    
-- Analyze the cumulative revenue generated over time.
select `time`, sum(revenue) over(order by `time`) as cumulative_revenue from
(select o.`time`,
sum(p.price*od.quantity) as revenue from orders as o
inner join order_details as od
	on od.order_id = o.order_id
inner join pizzas as p
	on p.pizza_id = od.pizza_id
group by o.`time`) as rev_t;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select pizza_type_id, category, revenue from
(select category, pizza_type_id, revenue,
rank() over(partition by category order by revenue desc) as rn from
(select pt.category, pt.pizza_type_id, sum(p.price*od.quantity) as revenue from orders as o
inner join order_details as od
	on od.order_id = o.order_id
inner join pizzas as p
	on p.pizza_id = od.pizza_id
inner join pizza_types as pt 
	on pt.pizza_type_id = p.pizza_type_id
group by pt.pizza_type_id, pt.category) as a) as b
where rn <= 3;