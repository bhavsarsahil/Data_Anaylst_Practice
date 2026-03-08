select * from coffee_shop_sales

alter table coffee_shop_sales
alter column transaction_time Time

SELECT 
    transaction_time,
    TRY_CONVERT(TIME, REPLACE(transaction_time, '.', ':')) AS converted_time
FROM coffee_shop_sales;

UPDATE coffee_shop_sales
SET transaction_time = 
    REPLACE(LTRIM(RTRIM(transaction_time)), '.', ':');

	ALTER TABLE coffee_shop_sales
ALTER COLUMN transaction_time TIME;

SELECT transaction_time
FROM coffee_shop_sales
WHERE TRY_CONVERT(TIME, transaction_time) IS NULL
AND transaction_time IS NOT NULL;

select * from coffee_shop_sales

select round(sum(unit_price * transaction_qty),0) as Total_Sales
from coffee_shop_sales
 where MONTH(transaction_date) = 3

 --selected month / CM  - may=5
 --pm month/PM -April = 4
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty),0) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


 --TOTAL ORDERS
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5 -- for month of (CM-May)

--TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH
SELECT  
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id),0) AS total_orders,
   (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
   OVER (ORDER BY MONTH(transaction_date))) * 100.0 / 
   LAG(COUNT(transaction_id), 1) OVER (ORDER BY MONTH(transaction_date)) AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


--TOTAL QUANTITY SOLD
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)

--TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty),0) AS total_quantity_sold,
    -- Multiply by 100.0 first to ensure decimal results
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) * 100.0 / 
    LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

--CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS
SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; --For 18 May 2023

--If you want to get exact Rounded off values then use below query to get the result:
SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000.0, 1), 'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000.0, 1), 'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000.0, 1), 'K') AS total_quantity_sold
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18';


SELECT 
    CASE 
        WHEN DATEPART(weekday, transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    SUM(unit_price * transaction_qty) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5
GROUP BY 
    CASE 
        WHEN DATEPART(weekday, transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;

--SALES BY STORE LOCATION
SELECT 
	store_location,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY Total_Sales DESC

select avg(unit_price*transaction_qty) as Avg_sales
from coffee_shop_sales
where month(transaction_date) = 5

--SALES TREND OVER PERIOD
SELECT
	concat(round(AVG(total_sales) / 1000 ,1),'K') AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;

--DAILY SALES FOR MONTH SELECTED
SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);

--COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales 
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

--SALES BY PRODUCT CATEGORY
SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC

--SALES BY PRODUCTS (TOP 10)
SELECT top 10
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY Total_Sales DESC

--SALES BY PRODUCTS (TOP 10) and product category = coffee
SELECT top 10
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 AND product_category = 'Coffee'
GROUP BY product_type
ORDER BY Total_Sales DESC

--SALES BY DAY | HOUR
SELECT 
    ROUND(SUM(unit_price * transaction_qty), 0) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DATEPART(WEEKDAY, transaction_date) = 3 -- Tuesday
    AND DATEPART(HOUR, transaction_time) = 8 -- 8 AM
    AND MONTH(transaction_date) = 5;         -- May

--TO GET SALES FOR ALL HOURS FOR MONTH OF MAY
SELECT 
    datepart(HOUR,transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty),0) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    datepart(HOUR,transaction_time)
ORDER BY 
    datepart(HOUR,transaction_time);

--TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
SELECT 
    DATENAME(WEEKDAY, transaction_date) AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty), 0) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5
GROUP BY 
    DATENAME(WEEKDAY, transaction_date),
    DATEPART(WEEKDAY, transaction_date) -- Added to help with sorting
ORDER BY 
    DATEPART(WEEKDAY, transaction_date);

