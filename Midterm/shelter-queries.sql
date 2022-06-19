-- [Problem 1]
-- Returns name, type, notes, and shelters of animals which are in
-- 'bonded pairs' (key is to give name in shelters an alias)
SELECT name, animal_type, notes, shelter_name
FROM animals NATURAL JOIN (
    SELECT shelter_id, name AS shelter_name 
    FROM shelters) AS shelter_info
WHERE notes LIKE '%Bonded pair%';

-- [Problem 2]
-- Creates view which merges shelter ID for each animal in 
-- applications table
CREATE VIEW shelter_applications AS
    SELECT app_id, applicant_id, animal_id, shelter_id
    FROM applications NATURAL LEFT JOIN 
        (SELECT animal_id, shelter_id FROM animals) AS id_info;


-- [Problem 3]
-- Returns number of applications and accepted applications for each shelter
SELECT name, COUNT(app_id) AS total_apps,
    SUM(CASE WHEN status LIKE '%Accepted%' THEN 1
    ELSE 0 END) AS accepted_apps
FROM shelter_applications 
    NATURAL LEFT JOIN shelters 
        NATURAL LEFT JOIN applications 
GROUP BY name
ORDER BY total_apps DESC, accepted_apps DESC; 


-- [Problem 4]
-- Returns appropriate application info for employees
SELECT DISTINCT applicant_name, animal_id, name, animal_type
FROM shelter_applications 
    NATURAL LEFT JOIN (
        SELECT applicant_id, name AS applicant_name 
        FROM applicants) AS applicant_info
    NATURAL LEFT JOIN animals
WHERE applicant_name IN (SELECT NAME FROM employees);


-- [Problem 5]
-- Removes all records of rock animal type (once parent rows are removed
-- then child rows are removed automatically)
DELETE FROM animals
WHERE animal_type = 'Rock'; 


-- [Problem 6]
-- Transfers and removes old applications from applications

-- This table holds information about old applications 
CREATE TABLE previous_applications (
    -- application serial ID
    app_id              SERIAL,
    -- ID of person who submitted application
    applicant_id        BIGINT UNSIGNED NOT NULL,
    -- ID of animal being applied for
    animal_id           BIGINT UNSIGNED NOT NULL,
    -- application status
    status              VARCHAR(15) NOT NULL DEFAULT 'Submitted',
    -- date of application submission
    application_date    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- application ID is primary key
    PRIMARY KEY (app_id),
    -- applicant ID references applicant table
    FOREIGN KEY (applicant_id)
        REFERENCES applicants(applicant_id)
            ON DELETE CASCADE,
    -- animal ID references animal table
    FOREIGN KEY (animal_id)
        REFERENCES animals(animal_id)
            ON DELETE CASCADE
);

INSERT INTO previous_applications
SELECT * FROM applications
WHERE status = 'Accepted' OR status = 'Rejected';

DELETE FROM applications
WHERE status = 'Accepted' OR status = 'Rejected';


-- [Problem 7]
-- Function that returns number of animals of given type for each
-- shelter
DELIMITER !
CREATE FUNCTION count_type(
    type VARCHAR(50) -- input
) RETURNS TINYINT DETERMINISTIC -- returns integer
BEGIN
    DECLARE num_animals TINYINT DEFAULT 0; -- holds result
    
    -- Checks if input is other
    IF (type = 'Other') THEN 
        -- Uses counts of animals that are not cats/dogs
        SELECT COUNT(*) INTO num_animals
        FROM animals
        WHERE animal_type NOT IN ('dog', 'cat');
    -- Otherwise, uses count for specific type
    ELSE
        SELECT COUNT(*) INTO num_animals
        FROM animals
        WHERE animal_type = type;
    END IF;
    
    RETURN num_animals; -- Returns result
END !
DELIMITER ;


-- [Problem 8]
-- Creates view showing number of animals for each type (dog/cat/other)
CREATE VIEW animal_types AS
    SELECT DISTINCT animal_type, count_type(animal_type) AS animal_count
    FROM animals
    WHERE animal_type = 'dog' OR animal_type = 'cat'
        UNION
    SELECT 'Other Animals' AS animal_type, 
        count_type('other') AS animal_count;


-- [Problem 9]
-- Prodedure which appriopriately updates tables based on the acceptance
-- of a particular adoption
DELIMITER !
CREATE PROCEDURE accept_adoption(
    IN an_id    BIGINT, -- animal_id input
    IN appl_id  BIGINT -- applicant_id input
)
BEGIN
    -- Only performs procedure if pair of input IDs is in applications
    IF (an_id IN (SELECT * FROM applications 
            WHERE appl_id = applicant_id)) 
    THEN
        -- Changes appropriate status to accepted
        UPDATE applications
        SET status = 'Accepted'
        WHERE animal_id = an_id AND applicant_id = appl_id;
            
        -- Changes other applications for same animal to rejected
        UPDATE applications
        SET status = 'Rejected'
        WHERE animal_id = an_id AND applicant_id <> appl_id;
            
        -- Updates accepted status in notes for adopted animal
        UPDATE animals
        SET notes = CONCAT('Adoption approved for ', appl_id)
        WHERE animal_id = an_id;
    END IF;
END !
DELIMITER ;


-- [Problem 10]
-- Takes in a zipcode and returns animal information for animals 
-- located in nearby shelters
DELIMITER !
CREATE PROCEDURE nearby_animals(
    IN zip CHAR(5), -- zipcode input
    OUT num_shelters TINYINT, -- number of nearby shelters
    OUT num_animals TINYINT -- number of animals in nearby shelters
)
BEGIN
    -- Gets first 3 digits from input zipcode
    DECLARE zip3 CHAR(3) DEFAULT SUBSTRING(zip, 1, 3); 
    
    -- Creates table for nearby shelters
    DROP TEMPORARY TABLE IF EXISTS nearby_shelters;
    CREATE TEMPORARY TABLE nearby_shelters AS
        SELECT * FROM shelters
        WHERE SUBSTRING(zipcode, 1, 3) = zip3;
        
    SELECT COUNT(DISTINCT shelter_id), COUNT(*)
    INTO num_shelters, num_animals
    FROM animals
    WHERE shelter_id IN (SELECT shelter_id FROM nearby_shelters);
END !
DELIMITER ;

CALL nearby_animals('98104', @num_shelters, @num_animals);
SELECT @num_shelters, @num_animals;

-- [Problem 11]
-- Creates view of animals who have been in shelters since 2019 and 
-- do not currently have an adoption application submitted
-- THEY WANT TO BE ADOPTED!
CREATE VIEW animals_to_adopt AS
    SELECT name AS animal_name, animal_type, age_est, shelter_name, 
        adoption_price
    FROM animals NATURAL LEFT JOIN (
            SELECT shelter_id, name AS shelter_name 
            FROM shelters) AS shelter_info
    WHERE YEAR(join_date) < 2020 AND 
        animal_id NOT IN (SELECT animal_id FROM shelter_applications);