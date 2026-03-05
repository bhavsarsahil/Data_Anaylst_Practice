select * from coffee_shop_sales

-- 1. Replace dots with colons so it looks like '07:06:11'
UPDATE coffee_shop_sales
SET transaction_time = REPLACE(transaction_time, '.', ':');

-- 2. Now you can safely change the column type to TIME
ALTER TABLE coffe_shop_sales
ALTER COLUMN transaction_time TIME;

select sum(unit_price *  transaction_qty) as sales from coffee_shop_sales