-- [Problem 1a]
-- Creates view containing account numbers and customer names 
-- for Stonewall branch accounts
CREATE VIEW stonewall_customers AS
    SELECT account_number, customer_name
    FROM depositor NATURAL JOIN account
    WHERE branch_name = 'Stonewell';

-- [Problem 1b]
-- Creates view with information regarding customers who
-- have an account but no loan
CREATE VIEW onlyacct_customers AS
    SELECT customer_name, customer_street, customer_city
    FROM customer
    WHERE customer_name IN (
        SELECT customer_name FROM depositor d
        WHERE NOT EXISTS (
            SELECT * FROM borrower b
            WHERE b.customer_name = d.customer_name));

-- [Problem 1c]
-- Creates view that lists branches in the bank with total
-- account balance for each branch and average balance for
-- each branch
CREATE VIEW branch_deposits AS
    SELECT branch_name, 
        IFNULL(SUM(balance), 0) AS total_balance, 
        AVG(balance) AS avg_balance
    FROM branch NATURAL LEFT JOIN account
    GROUP BY branch_name;