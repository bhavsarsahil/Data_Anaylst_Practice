create table order_details(
order_details_id int primary key not null,
order_id int not null,
pizza_id varchar(20) not null,
quantity int not null
)

BULK INSERT order_details
FROM 'D:\GitHub Data_Analyst\Data_Anaylst_Practice\Data_Analyst_Practice\SQL Projects\pizza_sales\pizza_sales\order_details.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,        -- Skip header row
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n'
);

select * from order_details

--Basic:
--Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders

--Calculate the total revenue generated from pizza sales.
select 
round(sum(od.quantity * p.price),2) as revenue
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id

--Identify the highest-priced pizza.
select top 1 
p.name , ps.price
from pizza_types p
join pizzas ps
on p.pizza_type_id = p.pizza_type_id
order by ps.price desc

--Identify the most common pizza size ordered
select quantity, count(order_id)
from order_details
group by quantity

select  p.size , count(order_details_id) as order_count
from pizzas p
join order_details od
on p.pizza_id = od.pizza_id
group by p.size 
order by order_count desc

--List the top 5 most ordered pizza types along with their quantities.
select top 5 pt.name, sum(od.quantity) as quntity 
from pizza_types pt
join pizzas p
on p.pizza_type_id = pt.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.name 
order by quntity desc


--Intermediate:

--Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category, sum(od.quantity) as sum_quntity
from pizza_types pt
join pizzas p
on p.pizza_type_id = pt.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.category
order by sum_quntity desc

--Determine the distribution of orders by hour of the day.
select datepart(HH, o.order_time)  , count(o.order_id) as order_per_hour
from orders o
group by  datepart(HH, o.order_time)
order by order_per_hour desc

--Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) as pizza_name from pizza_types group by category

--Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) as avg_pizza_per_day from
(select o.order_date, sum(od.quantity) as quantity
from orders o
join order_details od
on od.order_id = o.order_id
group by o.order_date) as order_quantity

--Determine the top 3 most ordered pizza types based on revenue.
select top 3 pt.name, 
sum(od.quantity * p.price) as revenue
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.name
order by revenue desc


--Advanced:
--Calculate the percentage contribution of each pizza type to total revenue.
select  pt.category, 
round(
sum(od.quantity * p.price)
	/
	(select 
round(sum(od.quantity * p.price),2) as revenue
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id) * 100,2) as revenue
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.category
order by revenue desc

--Analyze the cumulative revenue generated over time.
select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select o.order_date,
sum(od.quantity * p.price) as revenue
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join orders o
on o.order_id = od.order_details_id
group by o.order_date) as sales 

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.
 
SELECT name, category, revenue
FROM (
    SELECT 
        pt.name, 
        pt.category, 
        SUM(od.quantity * p.price) AS revenue,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rn
    FROM pizza_types pt
    JOIN pizzas p ON p.pizza_type_id = pt.pizza_type_id
    JOIN order_details od ON od.pizza_id = p.pizza_id
    GROUP BY pt.name, pt.category
) AS ranked_pizzas
WHERE rn <= 3;