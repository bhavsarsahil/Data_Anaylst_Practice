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

