-- [Problem 1]
DROP TABLE IF EXISTS participated, owns;
DROP TABLE IF EXISTS person, car, accident;

-- Table person: drivers' personal information
CREATE TABLE person (
    -- driver ID (exactly 10 characters)
    driver_id   CHAR(10) NOT NULL,
    -- name of driver (varying character length)
    name        VARCHAR(20) NOT NULL,
    -- address of driver (varying character length)
    address     VARCHAR(300) NOT NULL,
    PRIMARY KEY (driver_id)
);

-- Table car: information related to licensed cars
CREATE TABLE car (
    -- license for car (exactly 7 characters)
    license    CHAR(7) NOT NULL, 
    -- car model (varying character length)
    model      VARCHAR(15),
    -- car year (year data type)
    year       YEAR,
    PRIMARY KEY (license)
);

-- Table accident: accident information
CREATE TABLE accident (
    -- accident report number (auto-incrementing integer)
    report_number    INT NOT NULL AUTO_INCREMENT,
    -- date of accident (datetime format)
    date_occurred    DATETIME NOT NULL,
    -- location of accident (varying character length)
    location         VARCHAR(300) NOT NULL,
    -- description of accident (text format)
    description      TEXT(5000),
    PRIMARY KEY (report_number)
);

-- Table owns: ownership information
CREATE TABLE owns (
    -- driver ID (exactly 10 character)
    driver_id    CHAR(10) NOT NULL,
    -- license for car (exactly 7 characters)
    license      CHAR(7) NOT NULL,
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id)
        REFERENCES person(driver_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (license)
        REFERENCES car(license)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

-- Table participated: information relating drivers to accidents
CREATE TABLE participated (
    -- driver ID (exactly 10 characters)
    driver_id      CHAR(10) NOT NULL,
    -- license for car (exactly 7 cahracters)
    license        CHAR(7) NOT NULL,
    -- accident report number (auto-incrementing integer)
    report_number  INT NOT NULL AUTO_INCREMENT,
    -- dollar amount of damage (decimal format)
    damage_amount  DECIMAL(10, 2),
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id)
        REFERENCES person(driver_id)
            ON UPDATE CASCADE,
    FOREIGN KEY (license)
        REFERENCES car(license)
            ON UPDATE CASCADE,
    FOREIGN KEY (report_number)
        REFERENCES accident(report_number)
            ON UPDATE CASCADE
);