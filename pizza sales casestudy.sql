-- create and import the data from csv file
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);
-- Q3. To find total order values

select count(order_id) as 'TOTAL ORDER' from ORDERS; 

-- Q2. To find total sales 

SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS 'total sales'
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id;
    
    -- Q3. Identify the highest price pizza
    
    SELECT 
    pt.name, p.price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- Q4. identify most common pizza order

SELECT 
    p.size, COUNT(od.order_details_id) AS order_count
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;

-- Q5 top 5 pizza order along with their quantity

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;

-- Q6 join the necessary table to show the total quantity of each pizza category

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY category
ORDER BY quantity DESC;

-- Q7 determine the distrubation of orders by hour of the day

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) order_count
FROM
    orders
GROUP BY hour;

-- Q8 Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Q9 Group the orders by date and 
-- calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        order_details AS od
    JOIN orders AS o ON od.order_id = o.order_id
    GROUP BY order_date) AS data;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    name, round(SUM(quantity * price),0) AS revenue
FROM
    (SELECT 
        p.pizza_id,
            p.pizza_type_id,
            p.size,
            p.price,
            od.order_details_id,
            od.order_id,
            od.quantity,
            o.order_date,
            o.order_time,
            pt.name,
            pt.category,
            pt.ingredients
    FROM
        pizzas AS p
    JOIN order_details AS od ON p.pizza_id = od.pizza_id
    JOIN orders AS o ON o.order_id = od.order_id
    JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id) AS new_data
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;
-- Q10  find the cumulative revenue as well as regular revenue

select order_date,revenue,
sum(revenue) over (order by order_date) as cum_revenue
from
(select orders.order_date,sum(order_details.quantity * pizzas.price) as revenue
from pizzas join order_details on
pizzas.pizza_id = order_details.pizza_id
join orders on
orders.order_id = order_details.order_id
group by orders.order_date)as sales;



