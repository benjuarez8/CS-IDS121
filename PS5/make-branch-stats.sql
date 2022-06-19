-- [Problem 1]
-- Account index which speeds up queries for min/max balance
CREATE INDEX idx_acc ON account (branch_name, balance);

-- [Problem 2]
-- Table for materialized branch account data
CREATE TABLE mv_branch_account_stats (
    branch_name     VARCHAR(15) NOT NULL PRIMARY KEY,
    num_accounts    INT NOT NULL,
    total_deposits  NUMERIC(12, 2) NOT NULL,
    min_balance     NUMERIC(12, 2) NOT NULL,
    max_balance     NUMERIC(12, 2) NOT NULL
);

-- [Problem 3]
-- Populates previously created materialized view table
INSERT INTO mv_branch_account_stats (
    SELECT branch_name, COUNT(*), SUM(balance),
        MIN(balance), MAX(balance)
    FROM account
    GROUP BY branch_name);


-- [Problem 4]
-- "Materialized view" of branch account stats
CREATE VIEW branch_account_stats AS
    SELECT branch_name, num_accounts, total_deposits, 
        (total_deposits / num_accounts) AS avg_balance,
        min_balance, max_balance
    FROM mv_branch_account_stats;


-- [Problem 5]
-- Trigger/procedures to handle inserts on account
DELIMITER !
-- Procedure to handle updating min/max balances
CREATE PROCEDURE sp_insert_min_max (
    IN new_branch   VARCHAR(15),
    IN new_balance  NUMERIC(12, 2)
)
BEGIN
    -- Checks if min balance need to be updated
    UPDATE mv_branch_account_stats
        SET min_balance = new_balance
        WHERE branch_name = new_branch AND min_balance > new_balance;
    -- Checks if min balance need to be updated
    UPDATE mv_branch_accont_stats
        SET max_balance = new_balance
        WHERE branch_name = new_branch AND max_balance < new_balance;
END !

DELIMITER !
-- Procedure to handle update trigger
CREATE PROCEDURE sp_handle_insert (
    IN new_branch   VARCHAR(15),
    IN new_balance  NUMERIC(12, 2)
)
BEGIN
    -- Checks if inputted branch is already in materialized data
    -- Adds new data if so
    IF new_branch NOT IN (SELECT branch_name FROM mv_branch_stats)
    THEN
        INSERT INTO mv_branch_account_stats 
            VALUES (new_branch, 1, new_balance, 
                new_balance, new_balance);
    -- Otherwise, updates materialized data for existing branch
    ELSE
        -- Updates appropriate columns
        UPDATE mv_branch_acount_stats
            SET num_accounts = num_accounts + 1,
                total_deposits = total_deposits + new_balance
            WHERE branch_name = new_branch;
        -- Handles min/max balances
        CALL sp_insert_min_max(new_branch, new_balance);
    END IF;
END !

DELIMITER !
-- Trigger to handle updates to materialized data
CREATE TRIGGER trg_insert 
    AFTER INSERT ON account 
    FOR EACH ROW
BEGIN
    -- Calls helper procedures
    CALL sp_handle_insert(NEW.branch_name, NEW.balance);
END !
DELIMITER ;


-- [Problem 6]
-- Trigger/procedures to handle deletes on account

DELIMITER !
-- Procedure to handle updating min/max balances
CREATE PROCEDURE sp_delete_min_max (
    IN old_branch   VARCHAR(15),
    IN old_balance  NUMERIC(12, 2)
)
BEGIN
    -- Checks if min balance needs to be updated
    IF old_balance = (SELECT min_balance FROM mv_branch_account_stats
        WHERE branch_name = old_branch)
    THEN
        UPDATE mv_branch_account_stats
            SET min_balance = (SELECT MIN(balance) FROM account
                WHERE branch_name = old_branch)
            WHERE branch_name = old_branch;
    -- Checks if max balance needs to be updated
    ELSEIF old_balance = (SELECT max_balance FROM mv_branch_account_stats
        WHERE branch_name = old_branch)
    THEN
        UPDATE mv_branch_account_stats
            SET max_balance = (SELECT MAX(balance) FROM account
                WHERE branch_name = old_branch)
            WHERE branch_name = old_branch;
    END IF;
END !
 
DELIMITER !
-- Procedure to handle delete trigger
CREATE PROCEDURE sp_handle_delete (
    IN old_branch  VARCHAR(15),
    IN old_balance  NUMERIC(12, 2)
)
BEGIN
    -- Deletes branch data from materialized data appropriately
    DELETE FROM mv_branch_account_stats
        WHERE branch_name = old_branch AND num_accounts = 1;
    -- Otherwise, if branch data still exists after deletion,
    -- updates materialized data accordingly
    IF old_branch IN (
        SELECT branch_name FROM mv_branch_account_stats)
    THEN 
        -- Updates appropriate columns
        UPDATE mv_branch_account_stats
            SET num_accounts = num_accounts - 1,
                total_deposits = total_deposits - old_balance
            WHERE branch_name = old_branch;
        -- Handles min/max balances    
        CALL sp_delete_min_max(old_branch, old_balance);
    END IF;
END !

DELIMITER !
-- Trigger to handle delete to materialized data
CREATE TRIGGER trg_delete
    AFTER DELETE ON account
    FOR EACH ROW
BEGIN
    -- Calls helper procedures
    CALL sp_handle_delete(OLD.branch_name, OLD.balance);
END !
DELIMITER ;


-- [Problem 7]
-- Trigger to handle updates to materialized data
DELIMITER !
CREATE TRIGGER trg_update 
    AFTER UPDATE ON account
    FOR EACH ROW
BEGIN
    -- Checks if branch name was updated and updates materialized data 
    IF OLD.branch_name <> NEW.branch_name THEN
        -- Calls helper procedures
        CALL sp_handle_delete(OLD.branch_name, OLD.balance);
        CALL sp_handle_insert(NEW.branch_name, NEW.balance);
    -- Checks if balance was updated and updates materialized data
    ELSEIF OLD.balance <> NEW.balance THEN
        -- Handles total_deposits and avg_balance
        UPDATE mv_branch_account_stats
            SET total_deposits = total_deposits + NEW.balance - OLD.balance
            WHERE branch_name = NEW.branch_name;
        -- Calls helper procedures to handle min/max balances
        CALL sp_insert_min_max(NEW.branch_name, NEW.balance);
        CALL sp_delete_min_max(OLD.branch_name, OLD.balance);
    END IF;
END !
DELIMITER ;