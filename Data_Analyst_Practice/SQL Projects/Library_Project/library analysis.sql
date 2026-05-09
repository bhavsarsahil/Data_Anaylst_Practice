-- Project TASK
select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
-- ### 2. CRUD Operations


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
);


-- Task 2: Update an Existing Member's Address
update members
set member_address = '125 Main St'
where member_id = 'C101';
select * from members;


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.
SELECT * FROM issued_status
WHERE issued_id = 'IS112';

delete from issued_status
where issued_id = 'IS112';

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * from issued_status
where issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
select 
	issued_member_id
from issued_status
group by issued_member_id
having count(*) > 1;

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
select b.isbn,b.book_title,
COUNT(ist.issued_id) as no_issued
from books as b 
join issued_status as ist 
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2

-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:
SELECT * from books
where category = "Classic"

-- Task 8: Find Total Rental Income by Category:
select
category,
sum(rental_price),
count(*)
 from books
 GROUP BY 1;

-- Task 9. **List Members Who Registered in the Last 180 Days**:
SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;

INSERT into members(member_id,member_name,member_address,reg_date)
VALUES
('C120','Smith', '456 Birch St', '2026-03-05'),
('C121','Smith', '123 Main St', '2026-02-05');

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:
SELECT *
from employees as e
join branch as b
on e.branch_id = b.branch_id
join employees e2
ON e2.emp_id=b.manager_id;

SELECT 
    e1.*,
    b.manager_id, 
    e2.emp_name AS manager_name
FROM employees e1
JOIN branch b ON e1.branch_id = b.branch_id
JOIN employees e2 ON b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7
SELECT * FROM Books
WHERE rental_price > 7;

-- Task 12: Retrieve the List of Books Not Yet Returned
select DISTINCT ist.issued_book_name
from issued_status as ist
LEFT JOIN return_status rs
on ist.issued_id=rs.issued_id
where rs.return_id is null;


-- ### Advanced SQL Operations

--but first we add some recorde in table to perform other operations
select * from issued_status;
INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 day,  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 day,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 day,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 day,  '978-0-375-50167-0', 'E101');

--Task 13: Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.
-- issued_status == members == books == return_status
-- filter books which is return 
-- overdue > 30
select 
m.member_name,
b.book_title,
ist.issued_date,
 DATEDIFF(CURRENT_DATE, ist.issued_date) as over_dues_days
from issued_status as ist 
join members as m
on ist.issued_member_id = m.member_id
join books as b 
on b.isbn = ist.issued_book_isbn
left join return_status as rs 
on rs.issued_id = ist.issued_id
where rs.return_date is NULL AND  DATEDIFF(CURRENT_DATE, ist.issued_date) > 30;

--Task 14: Update Book Status on Return
--Write a query to update the status of books in the books table to "available" when they are returned (based on entries in the return_status table).
SELECT * from issued_status
where issued_book_isbn = '978-0-451-52994-2';

select * from books
where isbn='978-0-451-52994-2';

update books
set status = 'no'
where isbn = '978-0-451-52994-2978-0-451-52994-2';

SELECT* from return_status
where issued_id = 'IS130';

insert into return_status(return_id,issued_id,return_date,book_quality)
VALUES
('RS125','IS130',CURRENT_DATE,'Good');

SELECT * from return_status
where issued_id ='IS130';

--store procedures 
-- 1. Drop if it exists (MySQL's version of OR REPLACE)
DROP PROCEDURE IF EXISTS add_return_records;

-- 2. Change delimiter to allow semicolons inside

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10), 
    IN p_issued_id VARCHAR(10), 
    IN p_book_quality VARCHAR(10)
)
BEGIN
    -- Declare variables at the very top of the BEGIN block
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);
    
    -- Insert into returns
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    -- Select into variables
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- MySQL's version of RAISE NOTICE
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS Message;
    
END 

CALL add_return_records('RS120', 'IS135', 'Good');


--Task 15: Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
select * from branch;
select * from issued_status;
select * from employees;
select * from books;
SELECT * from return_status;

CREATE OR REPLACE VIEW branch_performance AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS no_of_book_issued,
    COUNT(rs.return_id) AS no_of_book_return,
    SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
JOIN branch AS b ON b.branch_id = e.branch_id
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
GROUP BY 1, 2
ORDER BY 1;

select * from branch_performance;


--Task 16: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.
select * from members
where member_id in(
    select 
        DISTINCT issued_member_id
        from issued_status
        where issued_date >= CURRENT_DATE- interval 2 month;);


--Task 17: Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
select 
e.emp_name,
b.*,
count(ist.issued_id) as no_book_issued
from issued_status as ist
join employees as e 
on e.emp_id=ist.issued_emp_id
join branch as b
on b.branch_id=e.branch_id
GROUP BY 1,2
order by no_book_issued DESC
LIMIT 3;


--Task 18: Identify Members Issuing High-Risk Books
--Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    
SELECT 
    m.member_name,
    b.book_title,
    COUNT(ist.issued_id) AS damage_count
FROM issued_status AS ist
JOIN members AS m ON ist.issued_member_id = m.member_id
JOIN books AS b ON ist.issued_book_isbn = b.isbn
JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.book_quality = 'Damaged'
GROUP BY m.member_name, b.book_title
HAVING COUNT(ist.issued_id) > 2;


--Task 19: Stored Procedure
--Objective: Create a stored procedure to manage the status of books in a library system.
  --  Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
  --If a book is issued, the status should change to 'no'.
  --a book is returned, the status should change to 'yes'.

  DROP PROCEDURE IF EXISTS manage_book_status;

DELIMITER //

CREATE PROCEDURE manage_book_status(
    IN p_action VARCHAR(10),   -- Use 'ISSUE' or 'RETURN'
    IN p_isbn VARCHAR(50)
)
BEGIN
    -- If issuing, set status to 'no'
    IF p_action = 'ISSUE' THEN
        UPDATE books 
        SET status = 'no' 
        WHERE isbn = p_isbn;
        SELECT 'Book status updated to NO (Issued)' AS Message;
        
    -- If returning, set status to 'yes'
    ELSEIF p_action = 'RETURN' THEN
        UPDATE books 
        SET status = 'yes' 
        WHERE isbn = p_isbn;
        SELECT 'Book status updated to YES (Available)' AS Message;
        
    ELSE
        SELECT 'Invalid Action. Please use ISSUE or RETURN.' AS Error;
    END IF;
END //

DELIMITER ;


--Task 20: Create Table As Select (CTAS)
--Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
CREATE OR REPLACE VIEW overdue_fines_view AS
SELECT 
    m.member_id,
    m.member_name,
    COUNT(ist.issued_id) AS number_of_overdue_books,
    -- Calculate $0.50 fine per day for books over 30 days
    SUM(DATEDIFF(CURDATE(), ist.issued_date) * 0.50) AS total_fines
FROM issued_status AS ist
JOIN members AS m ON ist.issued_member_id = m.member_id
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL 
  AND DATEDIFF(CURDATE(), ist.issued_date) > 30
GROUP BY m.member_id, m.member_name;

select *from overdue_fines_view;

--Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
--    The number of overdue books.
--    The total fines, with each day's fine calculated at $0.50.
--    The number of books issued by each member.
--    The resulting table should show:
--    Member ID
--    Number of overdue books
--    Total fines