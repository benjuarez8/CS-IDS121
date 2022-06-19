-- [Problem 1a]
-- Selects names of students who have taken at least one CS course      
USE university;
SELECT DISTINCT name 
FROM takes NATURAL JOIN course NATURAL JOIN (SELECT ID, name FROM student AS s) 
AS student_course_info
WHERE dept_name='Comp. Sci.';

-- [Problem 1b]
-- Selects value of maximum salary from instructor grouped by department name
SELECT MAX(salary) AS max_salary FROM instructor GROUP BY dept_name;

-- [Problem 1c]
-- Selects minimum value from maximum salaries by department
SELECT MIN(max_salary) FROM (
    SELECT MAX(salary) AS max_salary 
    FROM instructor GROUP BY dept_name)
AS min_max_salary;

-- [Problem 1d]
-- Performs same function as last query using WITH clause
WITH 
    max_salaries AS (SELECT MAX(salary) AS max_salary 
        FROM instructor GROUP BY dept_name)
SELECT MIN(max_salary) FROM max_salaries;

-- [Problem 2a]
-- Inserts new tuple into course with appropriate values
INSERT INTO course 
    VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 3);

-- [Problem 2b]
-- Inserts new tuple into section with appropriate values
INSERT INTO section 
    VALUES ('CS-001', '1', 'Winter', 2021, 'Watson', 100, 'A');

-- [Problem 2c]
-- Inserts new tuples in takes with appropriate section for each CS student
INSERT INTO takes (ID, course_id, sec_id, semester, year)
    SELECT ID, 'CS-001' as course_id, '1' as sec_id, 
        'Winter' as semester, 2021 as year
    FROM student WHERE dept_name = 'Comp. Sci.';

-- [Problem 2d]
-- Deletes tuples with section 1 in CS-001 in takes where name is Chavez
DELETE FROM takes 
    WHERE ID = (SELECT ID FROM student WHERE name = 'Chavez') 
        AND course_id = 'CS-001' 
        AND sec_id = '1';

-- [Problem 2e]
-- We need to delete any sections of CS-001 in sections first because 
-- these sections refer to the class itself in course.
-- It would not make sense to have CS-001 removed from course while
-- still having sections for it in section.
DELETE FROM section
    WHERE course_id = 'CS-001';
DELETE FROM course 
    WHERE course_id = 'CS-001';

-- [Problem 2f]
-- Deletes all tuples in takes where course_id has 'database' as part of title 
DELETE FROM takes
    WHERE course_id = (
        SELECT course_id FROM course 
        WHERE LOWER(title) LIKE '%database%');
    
-- [Problem 3a]
-- Selects distinct names of members from all tables natural joined 
-- where the borrowed book is published by 'McGraw Hill'
USE library;
SELECT DISTINCT name 
FROM book NATURAL JOIN borrowed NATURAL JOIN member 
WHERE publisher = 'McGraw-Hill';

-- [Problem 3b]
-- Selects names from table where number of distinct books published 
-- by 'McGraw-Hill' is the same as total number of books published
-- by 'McGraw-Hill'
SELECT name FROM book NATURAL JOIN borrowed NATURAL JOIN member
WHERE publisher = 'McGraw-Hill'
GROUP BY name
HAVING COUNT(DISTINCT title) = (
    SELECT COUNT(DISTINCT title) AS books
    FROM book
    WHERE publisher = 'McGraw-Hill');

-- [Problem 3c]
-- For each publisher, selects names of members who have borrowed at
-- 6 books.  The union of tables for each publisher is performed to
-- get the desired output
((SELECT name
FROM book NATURAL JOIN borrowed NATURAL JOIN member
WHERE publisher = 'McGraw-Hill' 
GROUP BY name
HAVING COUNT(publisher) > 5) UNION

(SELECT name
FROM book NATURAL JOIN borrowed NATURAL JOIN member
WHERE publisher = 'Microsoft Research' 
GROUP BY name
HAVING COUNT(publisher) > 5) UNION

(SELECT name
FROM book NATURAL JOIN borrowed NATURAL JOIN member
WHERE publisher = 'Prentice Hall' 
GROUP BY name
HAVING COUNT(publisher) > 5) UNION

(SELECT name
FROM book NATURAL JOIN borrowed NATURAL JOIN member
WHERE publisher = 'Caltech Publishing' 
GROUP BY name
HAVING COUNT(publisher) > 5));

-- [Problem 3d]
-- Returns the average number of books borrowed per person while
-- including members who have not borrowed a single book
SELECT AVG(num_books)
FROM (
    SELECT DISTINCT name, 0 as num_books FROM member
    WHERE NOT EXISTS (
        SELECT * FROM borrowed
        WHERE member.memb_no = borrowed.memb_no) UNION

    SELECT name, COUNT(title) AS num_books
    FROM book NATURAL JOIN borrowed NATURAL JOIN member as test
    GROUP BY name) AS books_per_person;
		

-- [Problem 3e]
-- Returns the average number of books borrowed per person while
-- including members who have not borrowed a single book (uses WITH)
WITH
    books_per_person AS (
        SELECT DISTINCT name, 0 as num_books 
        FROM member
        WHERE NOT EXISTS (
            SELECT * FROM borrowed
            WHERE member.memb_no = borrowed.memb_no) UNION

        SELECT name, COUNT(title) AS num_books
        FROM book NATURAL JOIN borrowed NATURAL JOIN member as test
        GROUP BY name)
SELECT AVG(num_books) FROM books_per_person;
