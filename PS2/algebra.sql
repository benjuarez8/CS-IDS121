-- [Problem 1]
-- Projects attribute A (distinctly) from r
SELECT DISTINCT A FROM r; 

-- [Problem 2]
-- Selects tuples where B = 42 in r
SELECT * FROM r WHERE B = 42;

-- [Problem 3]
-- Returns cartesian product of r and s
SELECT * FROM r, s;

-- [Problem 4]
-- Projects A and F from tuples where C = D in the 
-- cartesian product of r and s
SELECT DISTINCT A, F FROM r, s WHERE C = D;

-- [Problem 5]
-- Performs union operation on r1 and r2
SELECT A, B, C FROM r1 UNION
SELECT A. B, C FROM r2;

-- [Problem 6]
-- Simulates intersection operation on r1 and r2
SELECT A, B, C
FROM r1
WHERE A IN (SELECT A FROM r2)
    AND B IN (SELECT B FROM r2)
    AND C IN (SELECT C FROM r2);

-- [Problem 7]
-- Simulates set difference operation on r1 and r2
SELECT A, B, C
FROM r1
WHERE A NOT IN (SELECT A FROM r2)
    AND B NOT IN (SELECT B FROM r2)
    AND C NOT IN (SELECT C FROM r2);
