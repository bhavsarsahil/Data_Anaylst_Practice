select * from Retail_Sales_Analysis

--check null value in transaction column if exist 
select * from Retail_Sales_Analysis 
where transactions_id is null or
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or
age is null or
category is null or
quantiy is null or
price_per_unit is null or
cogs is null or 
total_sale is null 

--fill age value as average age in age column where age is null
UPDATE Retail_Sales_Analysis
SET age = (SELECT AVG(age) FROM Retail_Sales_Analysis)
WHERE age IS NULL;

-- delete rows where have null values
delete from Retail_Sales_Analysis
where transactions_id is null or
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or
age is null or
category is null or
quantiy is null or
price_per_unit is null or
cogs is null or 
total_sale is null 

--how many unique customer we have
select  count(distinct customer_id)  as total_customer from Retail_Sales_Analysis

--how many unique category we have
select  distinct category as total_category from Retail_Sales_Analysis



-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from Retail_Sales_Analysis where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM Retail_Sales_Analysis
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND sale_date >= '2022-11-01' 
  AND sale_date <= '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, 
sum(total_sale) as total_sale,
count(*) as total_orders
from Retail_Sales_Analysis
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as avg_age
from Retail_Sales_Analysis
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from Retail_Sales_Analysis
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,
count(total_sale)
from Retail_Sales_Analysis
group by category, gender

				--batter version--
SELECT 
    category,
    COUNT(CASE WHEN gender = 'Male' THEN total_sale END) AS Male,
    COUNT(CASE WHEN gender = 'Female' THEN total_sale END) AS Female
FROM Retail_Sales_Analysis
GROUP BY category;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
