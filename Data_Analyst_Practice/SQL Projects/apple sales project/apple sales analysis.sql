CREATE TABLE stores (
    store_id VARCHAR(20) PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE category (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id VARCHAR(20),
    launch_date DATE,
    price DECIMAL(10,2),

    CONSTRAINT fk_category
    FOREIGN KEY (category_id)
    REFERENCES category(category_id)
);

CREATE TABLE sales (
    sale_id VARCHAR(25) PRIMARY KEY,
    sale_date DATE NOT NULL,
    store_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT CHECK (quantity > 0),

    CONSTRAINT fk_store
    FOREIGN KEY (store_id)
    REFERENCES stores(store_id),

    CONSTRAINT fk_product
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE warranty (
    claim_id VARCHAR(20) PRIMARY KEY,
    claim_date DATE,
    sale_id VARCHAR(25),
    repair_status VARCHAR(30),

    CONSTRAINT fk_sale
    FOREIGN KEY (sale_id)
    REFERENCES sales(sale_id)
);

-- STORES
BULK INSERT stores
FROM 'D:\GitHub Data_Analyst\Data_Anaylst_Practice\Data_Analyst_Practice\SQL Projects\apple sales project\stores.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- CATEGORY
BULK INSERT category
FROM 'D:\GitHub Data_Analyst\Data_Anaylst_Practice\Data_Analyst_Practice\SQL Projects\apple sales project\category.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- PRODUCTS
BULK INSERT products
FROM 'D:\GitHub Data_Analyst\Data_Anaylst_Practice\Data_Analyst_Practice\SQL Projects\apple sales project\products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- SALES
BULK INSERT sales
FROM 'D:\GitHub Data_Analyst\Data_Anaylst_Practice\Data_Analyst_Practice\SQL Projects\apple sales project\sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- WARRANTY
BULK INSERT warranty
FROM 'D:\GitHub Data_Analyst\Data_Anaylst_Practice\Data_Analyst_Practice\SQL Projects\apple sales project\warranty.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

select * from sales;
select * from category;
select * from stores;
select * from warranty;
select * from products;

--EDA
select DISTINCT repair_status from warranty;
select count(*) from sales;

--execution plan ctrl+m
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

--impoving query performance 
select * from sales 
where product_id = 'P-44';

create index sales_product_id on sales(product_id);

select * from sales 
where store_id = 'ST-31';

create index sales_store_id on sales(store_id);
create index sales_sale_date on sales(sale_date);

--Business Problem 
-- 1.Find the number of stores in each country.
select country,
count(store_id) as no_of_store
from stores
group by country
order by no_of_store desc;

-- 2.Calculate the total number of units sold by each store.
select 
s.store_id,
st.store_name,
sum(s.quantity) as total_unit_sold
from sales as s
join stores as st
on s.store_id=st.store_id
group by s.store_id,st.store_name
order by total_unit_sold desc;

-- 3.Identify how many sales occurred in December 2023.
select count(*) as total_sales
from sales
where year(sale_date) = 2023 
and
month(sale_date) = 12

-- 4.Determine how many stores have never had a warranty claim filed.
select * from stores 
where store_id not in (
select  DISTINCT store_id
from sales as s
RIGHT JOIN  warranty as w
on s.sale_id=w.sale_id);

SELECT COUNT(*) AS stores_without_warranty_claim
FROM stores st
WHERE st.store_id NOT IN (
    SELECT DISTINCT s.store_id
    FROM sales s
    INNER JOIN warranty w
    ON s.sale_id = w.sale_id
);

-- 5.Calculate the percentage of warranty claims marked as "In Progress".

select DISTINCT repair_status from warranty

SELECT 
    CAST(
        100.0 * SUM(
            CASE 
                WHEN LTRIM(RTRIM(LOWER(repair_status))) = 'in progress'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) 
    AS DECIMAL(5,2)) AS in_progress_percentage
FROM warranty;

SELECT DISTINCT repair_status
FROM warranty
WHERE LOWER(repair_status) LIKE '%progress%';

SELECT*from warranty;

-- 6.Identify which store had the highest total units sold in the last year.
SELECT TOP 1
    st.store_id,
    st.store_name,
    SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN stores st
ON s.store_id = st.store_id
WHERE YEAR(s.sale_date) = YEAR(GETDATE()) - 5
GROUP BY st.store_id, st.store_name
ORDER BY total_units_sold DESC;

-- 7.Count the number of unique products sold in the last year.
SELECT 
    COUNT(DISTINCT product_id) AS unique_products_sold
FROM sales
WHERE YEAR(sale_date) = YEAR(GETDATE()) - 5;

-- 8.Find the average price of products in each category.
SELECT 
    c.category_name,
    CAST(AVG(p.price) AS DECIMAL(10,2)) AS average_price
FROM products p
JOIN category c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY average_price DESC;

-- 9.How many warranty claims were filed in 2020?

SELECT 
    COUNT(*) AS total_warranty_claims
FROM warranty
WHERE YEAR(claim_date) = 2024;

-- 10.For each store, identify the best-selling day based on highest quantity sold.

WITH store_sales AS (
    SELECT 
        st.store_id,
        st.store_name,
        s.sale_date,
        SUM(s.quantity) AS total_quantity,
        
        RANK() OVER (
            PARTITION BY st.store_id
            ORDER BY SUM(s.quantity) DESC
        ) AS rnk

    FROM sales s
    JOIN stores st
    ON s.store_id = st.store_id

    GROUP BY st.store_id, st.store_name, s.sale_date
)

SELECT 
    store_id,
    store_name,
    sale_date AS best_selling_day,
    total_quantity
FROM store_sales
WHERE rnk = 1;

--Medium to Hard (5 Questions)
--Identify the least selling product in each country for each year based on total units sold.



--Calculate how many warranty claims were filed within 180 days of a product sale.
--Determine how many warranty claims were filed for products launched in the last two years.
--List the months in the last three years where sales exceeded 5,000 units in the USA.
--Identify the product category with the most warranty claims filed in the last two years.
