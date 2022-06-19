-- [Problem 0a]
-- Using FLOAT or DOUBLE instead of NUMERIC in reagrds to bank account 
-- balances could go wrong since these types are just approximations
-- which could result in inaccurate values for money CHECK

-- [Problem 0b]
-- One attribute in account which could be represented with a type 
-- different than VARCHAR would be account_number since the
-- account numbers are all of the same length which means that
-- using CHAR would be more efficient

-- [Problem 1a]
-- Returns loan_number and amount of loans with amounts 
-- between 1000 and 2000        
USE banking;
SELECT loan_number, amount FROM loan
WHERE amount >= 1000 AND amount <= 2000;

-- [Problem 1b]
-- Returns loan number (ascending) and amount of loans ownded by Smith
SELECT loan_number, amount FROM borrower NATURAL JOIN loan
WHERE customer_name = 'Smith'
ORDER BY loan_number;

-- [Problem 1c]
-- Returns city of branch where account number A-446 exists
SELECT branch_city FROM branch NATURAL JOIN account
WHERE account_number = 'A-446';

-- [Problem 1d]
-- Returns appropriate info from depositor natural joined with account
-- when customer name begins with 'J'
SELECT customer_name, account_number, branch_name, balance
FROM depositor NATURAL JOIN account
WHERE SUBSTRING(customer_name, 1, 1) = 'J'
ORDER BY customer_name;

-- [Problem 1e]
-- Returns names of customers who have more than 5 accounts
SELECT customer_name FROM depositor
GROUP BY customer_name
HAVING COUNT(account_number) > 5;

-- [Problem 2a]
-- Returns cities in which customers live where no branch is located
-- by simulating set difference
SELECT DISTINCT customer_city FROM customer
WHERE customer_city NOT IN 
    (SELECT DISTINCT branch_city FROM branch);

-- [Problem 2b]
-- Selects names from customer that do not exist in
-- borrower and depositor (indicating no accounts/loans)
SELECT DISTINCT customer_name
FROM customer c
WHERE NOT EXISTS ((
    SELECT customer_name FROM borrower 
    WHERE customer_name = c.customer_name) UNION (
    SELECT customer_name FROM depositor
    WHERE customer_name = c.customer_name));

-- [Problem 2c]
-- Increases balance by $75 to accounts which are held in branches
-- located in the city of Horseneck
SET SQL_SAFE_UPDATES=0;
UPDATE account
    SET balance = balance + 75
    WHERE branch_name IN (
        SELECT branch_name FROM branch 
        WHERE branch_city = 'Horseneck');
SET SQL_SAFE_UPDATES=1;

-- [Problem 2d]
-- Increases balance by $75 to accounts which are held in branches
-- located in the city of Horseneck
SET SQL_SAFE_UPDATES=0;
UPDATE branch b, account a
    SET a.balance = a.balance + 75
    WHERE b.branch_name = a.branch_name AND 
        branch_city = 'Horseneck';
SET SQL_SAFE_UPDATES=1;

-- [Problem 2e]
-- Returns necessary info from account natural joined with 
-- table where max balance of each branch is calculated 
SELECT account_number, branch_name, balance 
FROM account NATURAL JOIN (
    SELECT branch_name, MAX(balance) as balance
    FROM account GROUP BY branch_name) AS branch_maxes;

-- [Problem 2f]
-- Implements the same query using IN predicate
SELECT account_number, branch_name, balance FROM account
WHERE (branch_name, balance) IN (
    SELECT branch_name, MAX(balance) as balance
    FROM account GROUP BY branch_name);

-- [Problem 3]
-- Computes appropriate rank of all bank branches based on assets
SELECT branch_name, assets, COUNT(*) AS `rank` FROM (
    SELECT x.branch_name, x.assets
    FROM branch x, branch y
    WHERE x.assets < y.assets OR x.branch_name = y.branch_name) 
    AS rankings
GROUP BY branch_name, assets
ORDER BY `rank`, branch_name; 