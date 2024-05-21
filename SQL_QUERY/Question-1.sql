-- Basic:
-- Retrieve the total number of orders placed.
-- Calculate the total revenue generated from pizza sales.
-- Identify the highest-priced pizza.
-- Identify the most common pizza size ordered.
-- List the top 5 most ordered pizza types along with their quantities.


-- Ans

-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id)
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS reveneu
FROM
    order_details AS od
        INNER JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizzas AS p
        INNER JOIN
    pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
WHERE
    p.price = (SELECT 
            MAX(price)
        FROM
            pizzas);

-- Identify the most common pizza size ordered.
SELECT 
    p.size, sum(od.quantity) AS no_of_orders
FROM
    pizzas AS p
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY no_of_orders DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) AS total_orders
FROM
    order_details AS od
        INNER JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        INNER JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id
ORDER BY total_orders DESC
LIMIT 5;