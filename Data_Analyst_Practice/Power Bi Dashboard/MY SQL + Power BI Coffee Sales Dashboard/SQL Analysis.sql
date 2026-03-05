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

