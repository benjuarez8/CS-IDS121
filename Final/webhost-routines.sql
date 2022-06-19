-- [Problem 5a]
-- Function that returns the total cost of all packages
-- given a username (returns 0 appropriately)
DROP FUNCTION IF EXISTS monthly_pkgs_cost;
DELIMITER !
CREATE FUNCTION monthly_pkgs_cost (
    -- inputted username
    username_in VARCHAR(20)
) RETURNS NUMERIC(8, 2) DETERMINISTIC
BEGIN
    -- holds result to return 
    -- (note that NUMERIC(8, 2) implies max monthly cost of $999,999.99)
    DECLARE total_cost NUMERIC(8, 2) DEFAULT 0;
    -- checks if there exists username associated with any packages
    IF username_in NOT IN (SELECT username FROM customer_pkgs) 
    THEN
        RETURN total_cost;
    END IF;
    -- stores sum of monthly prices for package(s) associated with username
    SELECT SUM(monthly_price) INTO total_cost
    FROM customer_pkgs NATURAL LEFT JOIN software_pkgs
    WHERE username = username_in;
    -- returns total cost of all packages
    RETURN total_cost;
END !
DELIMITER ;


-- [Problem 5b]
-- Procedure that changes the type of account given username, hostname, 
-- and previous account type
DROP PROCEDURE IF EXISTS update_account;
DELIMITER !
CREATE PROCEDURE update_account (
    -- inputs
    IN username_in     VARCHAR(20),
    IN hostname_in     VARCHAR(40),
    IN acct_type_in    TINYINT
)
BEGIN
    -- declares appropriate error messages to be outputted
    DECLARE error_1 VARCHAR(200) DEFAULT 
        CONCAT('No user found for ', username_in);
    DECLARE error_2 VARCHAR(200) DEFAULT 
        CONCAT(username_in, ' does not have account with ', hostname_in);
    DECLARE error_3a VARCHAR(200) DEFAULT 
        CONCAT(username_in, ' already has basic account for ', hostname_in);
    DECLARE error_3b VARCHAR(200) DEFAULT 
        CONCAT(username_in, ' already has preferred account for ', hostname_in);
    DECLARE error_4 VARCHAR(200) DEFAULT 
        'Accounts can only be basic or preffered';
    -- holds new hostname to be associated with updated account
    DECLARE new_hostname VARCHAR(40);
    -- holds info to be transferred between accounts
    DECLARE new_email VARCHAR(100);
    DECLARE new_url VARCHAR(200);
    DECLARE new_created TIMESTAMP;
    DECLARE new_price NUMERIC(5, 2);
    -- used to keep track of presence of error
    DECLARE error BOOLEAN DEFAULT true;


    -- checks if no user associated with inputted username
    IF username_in NOT IN (SELECT username FROM accounts) 
    THEN
        SET error = false;
        SELECT error_1;
        
    -- checks if there exists instance of inputted hostname associated
    -- with inputted username
    ELSEIF hostname_in NOT IN (
        SELECT hostname FROM basic_accts WHERE username = username_in 
            UNION
        SELECT hostname FROM preferred_accts WHERE username = username_in) 
    THEN
        SET error = false;
        SELECT error_2;
        
    -- checks if username already has account of given type w/ given hostname
    ELSEIF acct_type_in = (SELECT acct_type FROM accounts 
        WHERE username = username_in) AND
        hostname_in = (SELECT hostname FROM accounts 
            NATURAL LEFT JOIN basic_accts 
            NATURAL LEFT JOIN preferred_accts 
            WHERE hostname = hostname_in)
    THEN
        SET error = false;
        -- checks inputted acct_type in order to select appropriate error msg
        IF acct_type_in = 0
        THEN
            SELECT error_3a;
        ELSEIF acct_type_in = 1
        THEN
            SELECT error_3b;
        END IF;
        
    -- checks if inputted account type is neither basic or preferred (0 or 1)
    ELSEIF acct_type_in NOT IN (0, 1)
    THEN
        SET error = false;
        SELECT error_4;
    END IF;
    
    
    -- checks if inputted account type is basic (0)
    -- (only goes inside loop if no errors have been reported)
    IF acct_type_in = 0 AND error = true
    THEN
        -- retrieves info to be transferred
        SELECT email, website_url, created_acct, sub_price
        INTO new_email, new_url, new_created, new_price
        FROM preferred_accts WHERE username = username_in;
        -- updates appropriate row in accounts (superclass)
        UPDATE accounts
            SET acct_type = acct_type_in
            WHERE username = username_in;
        -- deletes outdated data from preferred_accts
        DELETE FROM preferred_accts WHERE username = username_in;
        -- retrieves new valid hostname
        -- (assume that there always exists a used shared 
        -- server that is not at maximum site capacity)
        SELECT hostname INTO new_hostname 
        FROM basic_accts NATURAL LEFT JOIN shared_servers
        GROUP BY hostname, site_capacity 
        HAVING COUNT(*) < site_capacity 
        LIMIT 1;
        -- inserts updated info into basic_accts
        INSERT INTO basic_accts
            VALUES (username_in, new_email, new_url, new_created, 
                new_price, acct_type_in, new_hostname);
    -- checks if inputted account type is preferred (1)
    -- (only goes inside loop if no errors have been reported)
    ELSEIF acct_type_in = 1 AND error = true
    THEN
        -- retrieves info to be transferred
        SELECT email, website_url, created_acct, sub_price
        INTO new_email, new_url, new_created, new_price
        FROM basic_accts WHERE username = username_in;
        -- updates appropriate row in accounts (superclass)
        UPDATE accounts
            SET acct_type = acct_type_in
            WHERE username = username_in;
        -- deletes outdated data from basic_accts
        DELETE FROM basic_accts WHERE username = username_in;
        -- retrieves new valid hostname
        -- (assume that there always exists a dedicated server
        -- that is not at max capacity)
        SELECT hostname INTO new_hostname FROM dedicated_servers
        WHERE hostname NOT IN (SELECT hostname FROM preferred_accts)
        LIMIT 1;
        -- inserts updated info into basic_accts
        INSERT INTO preferred_accts
            VALUES (username_in, new_email, new_url, new_created, 
                new_price, acct_type_in, new_hostname);
    END IF;
END !
DELIMITER ;

