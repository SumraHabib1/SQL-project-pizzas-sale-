-- retrieve totla no of orders placed
select count(order_id) from orders as total_order_count;

-- total revenue generated from pizza sale
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
   --  identify highest priced pizza
   
   SELECT 
    pizzas.price, pizza_types.name
FROM
    pizzas
        JOIN
    pizza_types
WHERE
    pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC ;

-- identify most common pizza size ordered
select pizzas.size,count(order_details.order_details_id) as count from pizzas 
join order_details where pizzas.pizza_id= order_details.pizza_id
 group by size order by count desc;
 
 --  top 5 most ordered pizza types along with their quantities
 SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
   
   -- join tables to  find the quantity of each pizza category
   select pizza_types.category, sum(order_details.quantity)
   from order_details join pizzas
   on order_details.pizza_id=pizzas.pizza_id
   join pizza_types on pizza_types.pizza_type_id=pizzas.pizza_type_id
   group by pizza_types.category	;
   
   -- determine the distribution of orders by hour of the day 
   select hour(order_time) as hour  ,  count(order_id) as  order_count  from orders
   group by hour(order_time);
   
   -- categories wise ditribution of pizzas
   select category , count(name) from pizza_types
   group by category;
   
   -- group the orders by date and calculate average of pizzas ordered per day
   
 SELECT 
    ROUND(AVG(tot_quantity), 0) AS avg
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS tot_quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.ordre_id
    GROUP BY order_date) AS order_quantity;
    
    -- top 3 most ordered pizzas types based on reveneue
    SELECT 
    pizza_types.name,
   sum( order_details.quantity * pizzas.price) AS revenue
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
    join  pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
    group by pizza_types.name order by revenue desc limit 3;
    
    
    
    
    -- percentage contribution  of each pizza type in  to total revenue
    select pizza_types.category, 
    round(sum(pizzas.price * order_details.quantity )/ 
    ( select round(sum( order_details.quantity * pizzas.price), 2) AS tot_sales
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
    join  pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id  ) * 100 ,2 ) as revenue
    from pizzas join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
    join order_details on pizzas.pizza_id=order_details.pizza_id
    group by category order by revenue;
    
    
    
    
    -- analyze a cummulative revenue generated over a time
    
    select order_date, sum(revenue)
over(order by order_date) as cum_revenue from 
   ( select orders.order_date ,
  sum( pizzas.price* order_details.quantity) as revenue 
  from pizzas join order_details on pizzas.pizza_id=order_details.pizza_id
  join orders on orders.order_id=order_details.ordre_id
  group by orders.order_date)  as sales;
  
  -- determine top 3 most ordered pizza types based on revenue for each pizza category
  select name, revenue from
 ( select name, category, revenue,
  rank() over(partition by category order by revenue desc) as rn
  from
 ( select pizza_types.name, pizza_types.category, 
  sum(pizzas.price* order_details.quantity) as revenue
  from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
  join order_details on order_details.pizza_id=pizzas.pizza_id
  group by pizza_types.category, pizza_types.name  )  as sale)  as b  where rn<=3;
  
    
   
