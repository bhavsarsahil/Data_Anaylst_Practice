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
