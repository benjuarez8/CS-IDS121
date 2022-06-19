-- [Problem 1]
-- Function that calculates the minimum interval in seconds
-- for submission given sub_id input (Returns null appropriately)
DELIMITER !
CREATE FUNCTION min_submit_interval(
    s_id INT -- sub_id
) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE min     INT; -- holds minimal interval
    DECLARE temp    INT; -- holds temp interval for comparison
    DECLARE t1      TIMESTAMP; -- holds timestamp for submission
    DECLARE t2      TIMESTAMP; -- holds timestamp for submission
    DECLARE done    INT DEFAULT 0; -- to detect when to stop cursing
    
    -- Cursor
    DECLARE cur CURSOR FOR 
        SELECT sub_date 
        FROM fileset AS f
        WHERE f.sub_id = s_id
        ORDER BY sub_date;
        
    -- When fetch is complete, handler sets flag
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
    OPEN cur;
        FETCH cur INTO t1;
        WHILE NOT done DO FETCH cur INTO t2;
            IF NOT done THEN 
                SET temp = UNIX_TIMESTAMP(t2) - UNIX_TIMESTAMP(t1);
                -- If temp interval is less than min, set temp as new min
                IF temp < min THEN 
                    SET min = temp;
                -- Handles first case when min is null
                ELSEIF ISNULL(min) THEN
                    SET min = temp;
                END IF;
                SET t1 = t2;
            END IF;
        END WHILE;
    CLOSE cur;
    
    RETURN min;
END !
DELIMITER ;


-- [Problem 2]
-- Function that calculates the maximum interval in seconds
-- for submission given sub_id input (Returns null appropriately)
DELIMITER !
CREATE FUNCTION max_submit_interval(
    s_id INT -- sub_id
) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE max     INT DEFAULT -1; -- holds max interval
    DECLARE temp    INT; -- holds temp interval for comparison
    DECLARE t1      TIMESTAMP; -- holds timestamp for submission
    DECLARE t2      TIMESTAMP; -- holds timestamp for submission
    DECLARE done    INT DEFAULT 0; -- to detect when to stop cursing
    
    -- Cursor
    DECLARE cur CURSOR FOR 
        SELECT sub_date 
        FROM fileset AS f
        WHERE f.sub_id = s_id
        ORDER BY sub_date;
        
    -- When fetch is complete, handler sets flag
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
        
    OPEN cur;
        FETCH cur INTO t1;
        WHILE NOT done DO FETCH cur INTO t2;
            IF NOT done THEN
                SET temp = UNIX_TIMESTAMP(t2) - UNIX_TIMESTAMP(t1);
                -- If temp interval is greater than max, set temp as new max
                IF temp > max THEN
                    SET max = temp;
                END IF;
                SET t1 = t2;
            END IF;
        END WHILE;
    CLOSE cur;
    
    -- Handles case when max isn't changed (since max had to be
    -- initalized to -1 
    IF max = -1 THEN RETURN NULL;
    END IF;
    
    RETURN max;
END !
DELIMITER ;


-- [Problem 3]
-- Function that computes average interval of submissions
-- in seconds given inputted sub_id (Returns null appropriately)
DELIMITER !
CREATE FUNCTION avg_submit_interval(
    s_id int -- sub_id
) RETURNS DOUBLE DETERMINISTIC
BEGIN
    DECLARE avg_i DOUBLE; -- holds avg. interval to return
    
    -- Calculates average interval as total interval size divided
    -- by number of intervals
    SELECT (UNIX_TIMESTAMP(MAX(sub_date)) - 
        UNIX_TIMESTAMP(MIN(sub_date))) / (COUNT(*) - 1)
    INTO avg_i
    FROM fileset AS f
    WHERE f.sub_id = s_id;
    
    RETURN avg_i;
END !
DELIMITER ;

-- [Problem 4]
-- Index on fileset for min/max of sub_date
CREATE INDEX idx_sub_id ON fileset (sub_id, sub_date);