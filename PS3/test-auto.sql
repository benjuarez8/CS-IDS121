-- [Problem 2a]
-- Inserting into person
INSERT INTO person 
VALUES
    ('0123456789', 'Ben', '1234 Beaver Drive'),
    ('8888888888', 'Jack', '666 California Blvd'),
    ('1111111111', 'Josh', '900 Huntington Drive');
    
-- Inserting into car
INSERT INTO car
VALUES 
    ('ABCDEFG', 'truck', 2020),
    ('CALTECH', 'sedan', 2021);

INSERT INTO car(license, model)
VALUES
    ('OOOOOOO', 'coupe');

-- Inserting into accident

INSERT INTO accident (date_occurred, location, description)
VALUES 
    ('2018-12-20 09:00:00', 
        'corner of California Blvd. and Lake Ave.', 'rear-end collision'),
    ('2019-04-21 12:00:00', 
        'trader joe\'s parking lot', 'collision with pedestrian'),
    ('2020-01-01 12:00:00', 
        'CVS pharmacy parking lot', 'collision with light post');

-- Inserting into owns
INSERT INTO owns
VALUES 
    ('0123456789', 'ABCDEFG'),
    ('8888888888', 'CALTECH'),
    ('1111111111', 'OOOOOOO');

-- Inserting into particpated
INSERT INTO participated (driver_id, license, damage_amount)
VALUES 
    ('0123456789', 'ABCDEFG', 500.00),
    ('8888888888', 'CALTECH', 600.00),
    ('1111111111', 'OOOOOOO', 1000.00);


-- [Problem 2b]
-- Updating person
UPDATE person
SET driver_id = '9876543210'
WHERE driver_id = '0123456789';

-- Updating car
UPDATE CAR
SET license = 'AAAAAAA'
WHERE license = 'ABCDEFG';


-- [Problem 2c]
-- Deleting from car (returns an expected error)
DELETE FROM car
WHERE license = 'OOOOOOO';