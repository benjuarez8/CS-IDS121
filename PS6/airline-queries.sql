-- [Problem 6a]
-- Returns purchases and associated ticket info for purchaser
-- with customer ID 54321
SELECT purchase_date, flight_date, last_name AS traveler_last_name, 
    first_name AS traveler_first_name
FROM (
    (SELECT purchase_id, purchase_date FROM purchases 
        WHERE customer_id = 54321) AS purchase
    NATURAL LEFT JOIN tickets NATURAL LEFT JOIN customers
    NATURAL LEFT JOIN flight_info)
ORDER BY purchase_date DESC, flight_date, last_name, first_name;


-- [Problem 6b]
-- Returns total ticket revenue for each kind of airplane from flights
-- occuring within last two weeks (includes ALL airplanes)
SELECT aircraft_code, IFNULL(rev, 0) AS total_revenue
FROM airplanes NATURAL LEFT JOIN (
    SELECT aircraft_code, SUM(ticket_price) AS rev
    FROM tickets NATURAL LEFT JOIN flight_info NATURAL LEFT JOIN flights
    WHERE TIMESTAMP(flight_date, flight_time) 
        BETWEEN (NOW() - INTERVAL 2 WEEK) AND NOW()
    GROUP BY aircraft_code) AS airplane_info;


-- [Problem 6c]
-- Returns info regarding international travelers that have not specified
-- all of their international flight info
SELECT first_name, last_name, customer_id
FROM customers NATURAL LEFT JOIN tickets NATURAL LEFT JOIN 
    flights NATURAL LEFT JOIN travelers
WHERE domestic = 0 AND (ISNULL(passport_number) OR 
    ISNULL(citizenship_country) OR 
    ISNULL(emergency_contact) OR 
    ISNULL(emergency_phone));