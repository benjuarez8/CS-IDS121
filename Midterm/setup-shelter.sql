-- DROP TABLE statements (no CREATE/USE)
DROP TABLE IF EXISTS employees; 
DROP TABLE IF EXISTS applications, previous_applications;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS applicants;
DROP TABLE IF EXISTS shelters;

-- Shelter Database Table Definitions

-- This table represents a particular animal shelter 
-- with animals available for adoption
CREATE TABLE shelters (
    -- shelter serial ID
    shelter_id      SERIAL,
    -- name of shelter
    name            VARCHAR(100) NOT NULL,
    -- address of shelter
    address         VARCHAR(100) NOT NULL,
    -- zipcode of shelter
    zipcode         CHAR(5) NOT NULL,
    -- city where shelter is located
    city            VARCHAR(100) NOT NULL,
    -- state where shelter is located
    state           CHAR(2) NOT NULL,
    -- shelter ID is primary key
    PRIMARY KEY (shelter_id)
);

-- This table represents potential adopters of pets 
-- (before or after the adoption process)
CREATE TABLE applicants (
    -- applicant serial ID
    applicant_id    SERIAL,
    -- name of applicant 
    name            VARCHAR(100) NOT NULL UNIQUE,
    -- phone number of applicant
    phone           CHAR(12) NOT NULL UNIQUE,
    -- address of applicant
    address        VARCHAR(100) NOT NULL,
    -- zipcode of applicant
    zipcode         CHAR(5) NOT NULL,
    -- number of current pets
    curr_pet_count  TINYINT(100) NOT NULL,
    -- size of household (including applicant)
    household_size  TINYINT(100) NOT NULL,
    -- notes regarding applicant
    notes           VARCHAR(1000),
    -- applicant ID is the primary key
    PRIMARY KEY (applicant_id),
    -- pet count cannot be negative
    CHECK (curr_pet_count >= 0),
    -- household size must be at least 1
    CHECK (household_size > 0)
);

-- This table represents all of the animals being 
-- currently managed in the database
CREATE TABLE animals (
    -- animal serial ID
    animal_id       SERIAL,
    -- name of animal
    name            VARCHAR(100) NOT NULL,
    -- gender of animal
    gender          VARCHAR (100),
    -- type of animal
    animal_type     VARCHAR(50) NOT NULL,
    -- breed of animal
    breed           VARCHAR(100),
    -- approximate age in years of animal
    age_est         INT,
    -- notes regarding animal
    notes           VARCHAR(1000),
    -- ID of shelter where animal resides
    shelter_id      BIGINT UNSIGNED NOT NULL,
    -- date when animal joined shelter
    join_date       DATE NOT NULL,
    -- adoption price for animal
    adoption_price  DECIMAL(5,2) NOT NULL,
    -- animal ID is primary key
    PRIMARY KEY (animal_id),
    -- shelter ID references shelters table
    FOREIGN KEY (shelter_id)
        REFERENCES shelters(shelter_id)
            ON DELETE CASCADE,
    -- ensures valid age
    CHECK (age_est >= 0)
);

-- This table holds information about submitted applications for 
-- potential adoptions, relating adopter applicants to animals 
-- available for adoption at different shelters
CREATE TABLE applications (
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


-- This table represents the employees at a shelter, some of 
-- which are volunteers 
CREATE TABLE employees (
    -- employee serial ID
    emp_id         SERIAL,
    -- name of employee
    name            VARCHAR(100) NOT NULL UNIQUE,
    -- gender of employee 
    gender          VARCHAR(100),
    -- indicates volunteer status of employee (0 = volunteer, 0 = otherwise)
    is_volunteer    TINYINT(1) NOT NULL,
    -- phone number of employee
    phone           CHAR(12) NOT NULL UNIQUE,
    -- email of employee
    email           VARCHAR(100) NOT NULL,
    -- employee role
    role            VARCHAR(100) NOT NULL,
    -- date when employee joined shelter
    join_date       DATE NOT NULL, 
    -- serial ID of shelter where employee is located
    shelter_id      BIGINT UNSIGNED NOT NULL,
    -- employee ID is primary key
    PRIMARY KEY (emp_id),
    -- shelter ID references shelters table
    FOREIGN KEY (shelter_id) 
        REFERENCES shelters(shelter_id)
            ON DELETE CASCADE,
    -- volunteer status must be 0 or 1
    CHECK (is_volunteer IN (0, 1))
);