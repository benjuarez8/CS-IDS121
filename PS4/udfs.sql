-- [Problem 1a]
-- UDF that takes in a date and returns a 1 if
-- the date is on a weekend (0 otherwise)
DELIMITER !
CREATE FUNCTION is_weekend(
    date DATE
) RETURNS TINYINT DETERMINISTIC
BEGIN
    -- Holds result
    DECLARE x TINYINT DEFAULT 0;
    
    -- Mon-Fri = 0-4
    IF (WEEKDAY(date) > 4) THEN
        SET x = 1;
    END IF;
    
    RETURN x;
END !
DELIMITER ;

-- [Problem 1b]
-- UDF that takes in date and returns appropriate holiday
-- or NULL if not a designated holiday
DELIMITER !
CREATE FUNCTION is_holiday(
    date DATE
) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
    -- Holds result
    DECLARE holiday         VARCHAR(30) DEFAULT NULL; 
    -- Holds result
    DECLARE month           INT DEFAULT EXTRACT(MONTH FROM date); 
    -- Month of input
    DECLARE day_of_week     INT DEFAULT WEEKDAY(date); 
    -- Day of the week of input
    DECLARE day_of_month    INT DEFAULT EXTRACT(DAY FROM date); 
    -- Day of the month of input
    
    -- January 1st
    IF (month = 1 AND day_of_month = 1) THEN
    SET holiday = 'New Year''s Day';
    
    -- July 4th
    ELSEIF (month = 7 AND day_of_month = 4) THEN
    SET holiday = 'Independence Day';
    
    -- 1st Monday in September
    ELSEIF (month = 9 AND 
        day_of_week = 0 AND 
        day_of_month BETWEEN 0 AND 7) THEN
    SET holiday = 'Labor Day';
    
    -- Last Monday in May
    ELSEIF (month = 5 AND
        day_of_week = 0 AND
        day_of_month BETWEEN 24 AND 31) THEN
    SET holiday = 'Memorial Day';
    
    -- 4th Thursday in November
    ELSEIF (month = 11 AND
        day_of_week = 3 AND
        day_of_month BETWEEN 22 AND 29) THEN
    SET holiday = 'Thanksgiving';
    
    END IF;
    
    RETURN holiday;
END !
DELIMITER ;

-- [Problem 2a]
-- Returns submissions that were submitted on holidays
SELECT holiday, COUNT(sub_date) AS num_submissions
FROM (
    SELECT sub_date, is_holiday(sub_date) AS holiday
    FROM fileset) AS holiday_submissions
GROUP BY holiday
ORDER BY holiday DESC;

-- [Problem 2b]
-- Returns time of week of submissions
SELECT 
    CASE WHEN is_weekend(sub_date) = 1 THEN 'weekend'
        ELSE 'weekday' END AS time_of_week,
    COUNT(sub_date) AS num_submissions
FROM fileset
GROUP BY time_of_week;

