-- [Problem 4a]
-- Reports the hostname of any shared server that has 
-- more accounts than value of max. sites for server
SELECT hostname
FROM basic_accts NATURAL LEFT JOIN shared_servers
GROUP BY hostname, site_capacity
HAVING COUNT(*) > site_capacity;


-- [Problem 4b]
-- Substracts $2 from account-price of all basic accounts
-- that use 3+ software packages (ensures no negative prices)
UPDATE basic_accts
    SET sub_price = sub_price - 2
    WHERE username IN (
        SELECT username FROM customer_pkgs
        GROUP BY username
        HAVING COUNT(*) >= 3) AND sub_price > 2;