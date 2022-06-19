-- [Problem a]
-- The given query computes the number of loans each customer has in order
-- by descreasing number of loans (includes customer who have 0 loans)
SELECT customer_name, COUNT(loan_number) AS num_loans
FROM customer NATURAL LEFT JOIN borrower
GROUP BY customer_name
ORDER BY num_loans DESC;


-- [Problem b]
-- The given query computes the names of branchs whose assets are less than
-- the sum of the loans at the respective branch
SELECT branch_name FROM (
    SELECT branch_name, SUM(amount) AS loan_total, assets
    FROM branch NATURAL JOIN loan
    GROUP BY branch_name, assets) AS branch_info
WHERE loan_total > assets;

-- [Problem c]
-- Computes the number of accounts and loans at each branch ordered by
-- increasing branch name
SELECT branch_name, 
    (SELECT COUNT(*) 
    FROM account a
    WHERE b.branch_name = a.branch_name)
    AS num_accounts, 
    (SELECT COUNT(*) 
    FROM loan l
    WHERE b.branch_name = l.branch_name)
    AS num_loans
FROM branch b 
ORDER BY branch_name;


-- [Problem d]
-- Produces decorrelated version of previous query
SELECT branch_name, 
    COUNT(DISTINCT account_number) AS num_accounts, 
    COUNT(DISTINCT loan_number) AS num_loans
FROM branch NATURAL LEFT JOIN account NATURAL LEFT JOIN loan
GROUP BY branch_name
ORDER BY branch_name;

