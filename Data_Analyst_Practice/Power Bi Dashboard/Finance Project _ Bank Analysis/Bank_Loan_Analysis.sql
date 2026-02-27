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

select 
	(count(
		CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN
		id END) * 100)
	/
	COUNT(id) as Good_Loan_Percentage
from bank_loan_data