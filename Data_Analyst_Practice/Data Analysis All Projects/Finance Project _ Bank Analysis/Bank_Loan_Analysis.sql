select * from bank_loan_data

-- total no of loan application
select count(id) as Total_Loan_Applications from bank_loan_data

-- total no of month_to_date_loan application
select count(id) as MTD_Total_Loan_Applications from bank_loan_data
where MONTH(issue_date) = 12

-- total no of previous_month_to_date_loan application
select count(id) as PMTD_Total_Loan_Applications from bank_loan_data
where MONTH(issue_date) = 11 And YEAR(issue_date) = 2021

-- total funded_amount 
select SUM(loan_amount) as Total_Funded_Amount from bank_loan_data

--total month_to_date_funded_ammount 
select sum(loan_amount) as MTD_Total_Funded_Amount from bank_loan_data
where MONTH(issue_date) = 12

--total previous_month_to_date_funded_ammount 
select sum(loan_amount) as PMTD_Total_Funded_Amount from bank_loan_data
where MONTH(issue_date) = 11

-- total Recived_amount 
select SUM(total_payment) as Total_Funded_Amount from bank_loan_data

--total month_to_date_Recived_amount
select sum(total_payment) as MTD_Total_Funded_Amount from bank_loan_data
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021

--total Previous_month_to_date_Recived_amount
select sum(total_payment) as PMTD_Total_Funded_Amount from bank_loan_data
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021

-- AVG Interest rate
select round(AVG(int_rate),4) * 100 as Avg_Interest_Rate from bank_loan_data

 -- Month_to_date AVG Interest rate
select round(AVG(int_rate),4) * 100 as MTD_Avg_Interest_Rate from bank_loan_data
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021

 -- Previous_Month_to_date AVG Interest rate
select round(AVG(int_rate),4) * 100 as PMTD_Avg_Interest_Rate from bank_loan_data
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021

-- DTI_AVG Interest rate
select round(AVG(dti),4) * 100 as DTI_Avg_Interest_Rate from bank_loan_data

 -- Month_to_date AVG Interest rate
select round(AVG(dti),4) * 100 as MTD_DTI_Avg_Interest_Rate from bank_loan_data
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021

 -- Previous_Month_to_date AVG Interest rate
select round(AVG(dti),4) * 100 as PMTD_DTI_Avg_Interest_Rate from bank_loan_data
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021

--Good Loan Percentage
select 
	(count(
		CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN
		id END) * 100)
	/
	COUNT(id) as Good_Loan_Percentage
from bank_loan_data

--Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--Good Loan Funded Amount
select sum(loan_amount) as Good_Loan_Funded_amount  from bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data

--Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--LOAN STATUS
select  
	loan_status,
	count(id) as Total_loan_application,
	SUM(loan_amount) AS Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
    FROM
        bank_loan_data
    GROUP BY
        loan_status

SELECT 
	loan_status, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount,
	SUM(total_payment) AS MTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status


--B.	BANK LOAN REPORT | OVERVIEW
--MONTH

select
MONTH(issue_date) as Month_Number,
DATENAME(MONTH, issue_date) as Month_Name,
COUNT(id) as Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
from bank_loan_data
group by MONTH(issue_date) , DATENAME(MONTH, issue_date)
order by MONTH(issue_date)

--STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state

--TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term

--EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length

--PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose

--HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership

--See the results when we hit the Grade A in the filters for dashboards.
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose
