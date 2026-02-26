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

--Identify the most common pizza size ordered.
--List the top 5 most ordered pizza types along with their quantities.


--Intermediate:
--Join the necessary tables to find the total quantity of each pizza category ordered.
--Determine the distribution of orders by hour of the day.
--Join relevant tables to find the category-wise distribution of pizzas.
--Group the orders by date and calculate the average number of pizzas ordered per day.
--Determine the top 3 most ordered pizza types based on revenue.

--Advanced:
--Calculate the percentage contribution of each pizza type to total revenue.
--Analyze the cumulative revenue generated over time.
--Determine the top 3 most ordered pizza types based on revenue for each pizza category.