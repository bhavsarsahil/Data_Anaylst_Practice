select * from employees

-- Like Operator 
select email  from employees where email like '%gmail.com';

--Order By Asc/Desc
select * from employees order by department asc
select * from employees order by age desc
select * from employees order by department asc, age desc

-- Top 5,10,20....
select  top 5 * from employees
select top 10 * from employees order by age desc, department asc

--Use Of Between 
select * from employees where age between 20 and 30;
select * from employees where salary between 70000 and 100000;

-- IN Function()
select * from employees where department IN ('IT' , 'Marketing');

--Not In function()
select * from employees where department NOT IN ('IT' , 'Marketing');
select * from employees where department NOT IN ('IT' , 'Marketing') and last_name NOT in('Wolf', 'Wong');

--String Function()
select first_name,last_name,CONCAT(first_name,' ' ,last_name) as Full_Name from employees

--Length Funtion()
select   email,LEN(email) as DigitCount from employees

-- Upper Case Funtion()
select first_name,UPPER(first_name) as UpperCaseFirstName from employees
select first_name,LOWER(first_name) as LowerCaseFirstName from employees

-- Left Function()
select first_name,LEFT(first_name, 4) as UserName  from employees
select first_name,RIGHT(first_name, 4) as LastNamePart  from employees
select first_name,SUBString(first_name, 2,4) as UserName  from employees

--Data Aggregation
select COUNT(employee_id) as NumberOfEmployees from employees
select AVG(salary) as AVG_Salary from employees

select round(AVG(salary),1) as AVG_Salary from employees --use round function to reduce float values
select CEILING(avg(salary)) as Higher_salary from employees
select FLOOR(avg(salary)) as Higher_salary from employees

select MAX(salary) as AVG_Salary from employees
select MIN(salary) as AVG_Salary from employees

--Date&time Function
select * from Orders
SELECT orderDate,shippedDate ,DATEDIFF(day, orderDate, shippedDate) AS Dates FROM Orders;
select orderDate,DATENAME(WEEKDAY,orderDate) as Dayname_order from orders
select orderDate,DATENAME(MM,orderDate) as Dayname_order from orders
select orderDate,YEAR(orderDate) as Dayname_order from orders

--	CASE Operator in SQL
select * from [products]
select productName,quantityInStock,
CASE 
	when quantityInStock < 1000 then 'Urgent need of stock'
	else 'no requirement'
end as production_details
from products


