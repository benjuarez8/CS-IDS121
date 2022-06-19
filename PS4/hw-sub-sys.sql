-- [Problem 1a]
-- Computes perfect score in course
SELECT SUM(perfectscore) AS perfect_total_score
FROM assignment;

-- [Problem 1b]
-- Generates list of all sections names with size
SELECT sec_name, COUNT(username) AS size
FROM student NATURAL JOIN section
GROUP BY sec_name
ORDER BY sec_name;

-- [Problem 1c]
-- Creates view of total scores over all assignments
CREATE VIEW totalscores AS
    SELECT username, SUM(score) AS total_score
    FROM student NATURAL LEFT JOIN submission
    WHERE graded = 1
    GROUP BY username;

-- [Problem 1d]
-- Creates view of students that are passing
CREATE VIEW passing AS
    SELECT username, total_score
    FROM totalscores
    WHERE total_score >= 40;

-- [Problem 1e]
-- Creates view of students that are failing
CREATE VIEW failing AS
    SELECT username, total_score
    FROM totalscores
    WHERE total_score < 40;

-- [Problem 1f]
-- Generates list of students that failed to submit at least
-- one assignment yet passed
-- RESULT: harris, ross, miller, turner, edwards, murphy, simmons
-- tucker, coleman, flores, gibson
WITH 
    no_lab_sub AS (
        SELECT username, sub_id FROM submission NATURAL LEFT JOIN assignment
        WHERE shortname LIKE 'lab%')
SELECT DISTINCT username FROM no_lab_sub
WHERE username IN (SELECT username FROM passing) AND
    sub_id NOT IN (SELECT sub_id FROM fileset);
     
-- [Problem 1g]
-- Generates list of students that failed to submit midterm/final
-- one assignment yet passed
-- RESULT: collins
WITH 
    no_test_sub AS (
        SELECT username, sub_id FROM submission NATURAL LEFT JOIN assignment
        WHERE shortname LIKE 'final%' OR shortname LIKE 'midterm%')
SELECT DISTINCT username FROM no_test_sub
WHERE username IN (SELECT username FROM passing) AND
    sub_id NOT IN (SELECT sub_id FROM fileset);

-- [Problem 2a]
-- Returns usernames of students that submitted work for
-- midterm after due date
SELECT DISTINCT username FROM fileset 
    NATURAL LEFT JOIN submission 
    NATURAL LEFT JOIN assignment
WHERE shortname LIKE 'midterm%' AND sub_date > due
ORDER BY username;

-- [Problem 2b]
-- Returns number of labs submitted for each hour
SELECT EXTRACT(HOUR FROM sub_date) AS hour, COUNT(sub_id) AS num_submits
FROM fileset 
    NATURAL LEFT JOIN submission 
    NATURAL LEFT JOIN assignment
WHERE shortname LIKE 'lab%'
GROUP BY EXTRACT(HOUR FROM sub_date)
ORDER BY hour;

-- [Problem 2c]
-- Returns number of finals submitted within 30 min time period
-- before due date
SELECT COUNT(sub_id) AS num_submits
FROM fileset 
    NATURAL LEFT JOIN submission 
    NATURAL LEFT JOIN assignment
WHERE (shortname LIKE 'final%') AND
    (sub_date BETWEEN due - INTERVAL 30 MINUTE AND due);

-- [Problem 3a]
-- Adds email column, populates column, modifies column
ALTER TABLE student
    ADD email VARCHAR(200)
        AFTER username;
        
UPDATE student
    SET email = CONCAT(username, '@school.edu');
    
ALTER TABLE student
    MODIFY email VARCHAR(200) NOT NULL;

-- [Problem 3b]
-- Adds submit_files column with default 1 and updates to 0 for
-- daily quiz assignments
ALTER TABLE assignment
    ADD submit_files TINYINT DEFAULT 1;
    
UPDATE assignment
    SET submit_files = 0
    WHERE shortname LIKE 'dq%';

-- [Problem 3c]
-- Creates and fills gradescheme table, renames gradescheme column
-- in assignment as scheme_id and adds foreign key
CREATE TABLE gradescheme (
    scheme_id   INT(10),
    scheme_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (scheme_id)
);

INSERT INTO gradescheme
VALUES 
    (0, 'Lab assignment with min-grading.'),
    (1, 'Daily quiz.'),
    (2, 'Midterm or final exam.');

ALTER TABLE assignment
    RENAME COLUMN gradescheme TO scheme_id;

ALTER TABLE assignment    
    MODIFY scheme_id INT(10) NOT NULL;
    
ALTER TABLE assignment
    ADD FOREIGN KEY (scheme_id) REFERENCES gradescheme(scheme_id);