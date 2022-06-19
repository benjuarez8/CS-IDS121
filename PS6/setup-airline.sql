-- [Problem 5]

-- DROP TABLE commands:
DROP TABLE IF EXISTS flight_info;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS customer_phones, travelers, purchasers;
DROP TABLE IF EXISTS customers, flights, seats;
DROP TABLE IF EXISTS airplanes;


-- CREATE TABLE commands:

-- Creates table to store info regarding types of aircraft
CREATE TABLE airplanes (
    -- IATA aircraft type code
    aircraft_code   CHAR(3),
    -- Manufacturer's company
    manu_company    VARCHAR(100) NOT NULL,
    -- Aircraft model
    model           VARCHAR(50) NOT NULL,
    -- Aircraft code is primary key
    PRIMARY KEY (aircraft_code)
);


-- Creates table to store info regarding airplane seats
CREATE TABLE seats (
    -- IATA aircraft type code
    aircraft_code   CHAR(3),
    -- Seat number for row and seat position
    seat_number     VARCHAR(3),
    -- Class of seat ("first class", "business class", "coach")
    class           VARCHAR(50) NOT NULL,
    -- Specifies position of seat ("W", "M", "A")
    type            CHAR(1) NOT NULL,
    -- Flag specifying exit row classification of seat (1 for yes, 0 for no)
    exit_row        TINYINT(1) NOT NULL,
    -- Combination of (aircraft_code, seat_number) identifies each unique seat
    PRIMARY KEY (aircraft_code, seat_number),
    -- Aircraft code is a foreign key to airplanes.aircraft_code
    -- Existence of seat in aircraft depends on existence of aircraft itself
    FOREIGN KEY (aircraft_code)
        REFERENCES airplanes(aircraft_code)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    -- Checks appropriate values for class, type, exit_row
    CHECK (class IN ('first class', 'business class', 'coach')),
    CHECK (type IN ('W', 'M', 'A')),
    CHECK (exit_row IN (1, 0))
);


-- Creates table to store info regarding flights
CREATE TABLE flights (
    -- Flight number 
    flight_number   VARCHAR(20),
    -- Date of flight
    flight_date     DATE,
    -- Time of flight
    flight_time     TIME NOT NULL,
    -- IATA airport code of source airport
    source          CHAR(3) NOT NULL,
    -- IATA airport code of destination airport
    destination     CHAR(3) NOT NULL,
    -- Flag specifying domestic (1) or international (0)
    domestic        TINYINT(1) NOT NULL,
    -- Aircraft code of airplane
    aircraft_code   CHAR(3) NOT NULL,
    -- Combination of (flight_number, flight_date) identifies each flight
    PRIMARY KEY (flight_number, flight_date),
    -- Aircraft code is a foreign key to airplanes.aircraft_code
    -- Existence of seat in aircraft depends on existence of aircraft itself
    FOREIGN KEY (aircraft_code)
        REFERENCES airplanes(aircraft_code)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    -- Checks appropriate values for domestic
    CHECK (domestic IN (1, 0))
);


-- Creates table to store info regarding customers (travelers or purchasers)
CREATE TABLE customers (
    -- Integer ID for customer
    customer_id     SERIAL,
    -- First name of customer
    first_name      VARCHAR(100) NOT NULL,
    -- Last name of customer
    last_name       VARCHAR(100) NOT NULL,
    -- Email of customer
    email_address   VARCHAR(100) NOT NULL,
    -- Customer ID uniquely identifies each customer
    PRIMARY KEY (customer_id)
);


-- Creates table to store info regarding purchasers of tickets
CREATE TABLE purchasers (
    -- Integer ID for purchaser (customer)
    customer_id         BIGINT UNSIGNED,
    -- (Optional) card number for payment
    card_number         NUMERIC(16, 0),
    -- (Optional) expiration date for card
    expiration_date     CHAR(5),
    -- (Optional) verification code for card
    verification_code   NUMERIC(3, 0),
    -- Customer ID uniquely identifies each purchaser
    PRIMARY KEY (customer_id),
    -- Customer ID is a foreign key to customers.customer_id
    -- Existence of purchaser depends on existence of customer itself
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


-- Creates table to store info regarding travelers
CREATE TABLE travelers (
     -- Integer ID for traveler (customer)
     customer_id            BIGINT UNSIGNED,
     -- (Optional) passport number
     passport_number        VARCHAR(40),
     -- (Optional) country of citizenship
     citizenship_country    VARCHAR(100),
     -- (Optional) emergency contact name
     emergency_contact      VARCHAR(100),
     -- (Optional) emergency contact phone
     emergency_phone        VARCHAR(15),
     -- (Optional) frequent flyer number
     frequent_flyer_number  CHAR(7),
     -- Customer ID uniquely identifies each traveler
     PRIMARY KEY (customer_id),
     -- Customer ID is a foreign key to customers.customer_id
     -- Existence of traveler depends on existence of customer itself
     FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


-- Creates table to store info regarding customer phone numbers
-- Used to handle multiple phone numbers (if any) for customers
CREATE TABLE customer_phones (
    -- Integer ID for customer
    customer_id     BIGINT UNSIGNED,
    -- Phone number of customer 
    phone_number    VARCHAR(15),
    -- Combination of (customer_id, phone_number) is necessary for primary key
    PRIMARY KEY (customer_id, phone_number),
    -- Customer ID is a foreign key to customers.customer_id
    -- Existence of phone number depends on existence of customer itself 
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


-- Creates table to store info regarding purchases
CREATE TABLE purchases (
    -- Integer ID of purchase transaction
    purchase_id     SERIAL,
    -- Date of purchase
    purchase_date   TIMESTAMP NOT NULL,
    -- Confirmation number for purchase
    confirmation    CHAR(6) NOT NULL,
    -- Customer ID of purchaser
    customer_id     BIGINT UNSIGNED NOT NULL,
    -- Purchase ID uniquely identifies each purchase
    PRIMARY KEY (purchase_id),
    -- Customer ID is a foreign key to customers.customer_id
    -- Existence of purchase depends on existence of customer itself 
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    -- Confirmation number is unique to each purchase
    UNIQUE (confirmation)
);


-- Creates table to store info regarding tickets
CREATE TABLE tickets (
    -- Ticket ID
    ticket_id       SERIAL,
    -- Price of ticket (LESS THAN $10,000.00)
    ticket_price    NUMERIC(6, 2) NOT NULL,
    -- Customer ID of traveler associated with ticket
    customer_id     BIGINT UNSIGNED NOT NULL,
    -- Purchase ID of purchase of ticket by customer
    purchase_id     BIGINT UNSIGNED NOT NULL,
    -- Ticket ID uniquely identifies each ticket
    PRIMARY KEY (ticket_id),
    -- Customer ID is a foreign key to customers.customer_id
    -- Existence of ticket depends on existence of customer itself 
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE, 
    -- Purchase ID is a foreign key to purchases.purchase_id
    -- Existence of ticket depends on existence of purchase itself 
    FOREIGN KEY (purchase_id)
        REFERENCES purchases(purchase_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


-- Creates table to store detailed info regarding flights 
CREATE TABLE flight_info (
    -- Flight number
    flight_number   VARCHAR(20),
    -- Date of flight
    flight_date     DATE,
    -- IATA aircraft type code
    aircraft_code   CHAR(3),
    -- Seat number for row and position
    seat_number     VARCHAR(3),
    -- Ticket ID
    ticket_id       BIGINT UNSIGNED NOT NULL,
    -- Combination of (flight_number, flight_date, aircraft_code, seat_number)
    -- uniquely identifies each flight 
    PRIMARY KEY (flight_number, flight_date, aircraft_code, seat_number),
    -- (flight_number, flight_date) is a foreign key to 
    -- flights(flight_number, flight_date)
    -- Existence of flight info depends on existence of flight
    FOREIGN KEY (flight_number, flight_date)
        REFERENCES flights(flight_number, flight_date)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    -- (aircraft_code, seat_number) is a foreign key to
    -- seats(aircraft_code, seat_number)
    -- Existence of flight info depends on existence of aircraft + seat
    FOREIGN KEY (aircraft_code, seat_number)
        REFERENCES seats(aircraft_code, seat_number)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
