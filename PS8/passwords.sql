-- [Problem 1a]
CREATE DATABASE IF NOT EXISTS passwords;
USE passwords;
DROP TABLE IF EXISTS user_info;
-- Table that stores data for password mechanism
CREATE TABLE user_info (
    -- username (max 20 characters)
    username        VARCHAR(20),
    -- salt value (8 characters)
    salt            CHAR(8) NOT NULL,
    -- hashed value of password with 256 bits
    password_hash   CHAR(64) NOT NULL,
    -- username is primary key
    PRIMARY KEY (username)
);


-- [Problem 1b]
DROP PROCEDURE IF EXISTS sp_add_user;
-- Procedure generates a new salt and adds a new record to user_info
DELIMITER !
CREATE PROCEDURE sp_add_user(
    -- Parameters (username and password to be added)
    IN new_username VARCHAR(20),
    IN new_password VARCHAR(20)
)
BEGIN
    -- Used to hold new salt
    DECLARE salt CHAR(8);
    -- Uses provided make_salt function to generate new salt
    SET salt = make_salt(8);
    -- Inserts new record (assumes username is not already taken)
    INSERT INTO user_info
        VALUES (new_username, salt, SHA2(CONCAT(salt, new_password), 256));
END !
DELIMITER ;


-- [Problem 1c]
DROP PROCEDURE IF EXISTS sp_change_password;
-- Procedure that updates existing record in user_info
DELIMITER !
CREATE PROCEDURE sp_change_password(
    -- Parameters (existing username and new password)
    IN existing_username    VARCHAR(20),
    IN new_password         VARCHAR(20)
)
BEGIN
    -- Stores new_salt
    DECLARE new_salt CHAR(8);
    -- Uses provided make_salt function to generate new salt
    SET new_salt = make_salt(8);
    -- Updates user_info table appropriately
    UPDATE user_info
        SET salt = new_salt, 
            password_hash = SHA2(CONCAT(new_salt, new_password), 256)
        WHERE user_info.username = existing_username;
END !
DELIMITER ;


-- [Problem 1d]
DROP FUNCTION IF EXISTS authenticate;
-- Function that aunthenticates valid username and password 
-- Returns 1 = true or 0 = false
DELIMITER !
CREATE FUNCTION authenticate(
    -- Inputted username and password
    username    VARCHAR(20),
    password    VARCHAR(20)
) RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE salted_password VARCHAR(28); -- Holds password after salt
    DECLARE hashed_password CHAR(64); -- Holds password after hashing
    DECLARE true_password CHAR(64); -- Holds actual password for comparison
    -- Checks if username is in user_info, returns 0 (false) if so
    IF username NOT IN (SELECT username FROM user_info) THEN
        RETURN 0; -- Implies invalid username (unknown to "hackers")
    END IF;
    -- Generates salted password
    SET salted_password = CONCAT((
        SELECT salt FROM user_info 
        WHERE user_info.username = username), password);
    -- Generates password after hashing
    SET hashed_password = SHA2(salted_password, 256);
    -- Finds true password
    SET true_password = (SELECT password_hash 
        FROM user_info 
        WHERE user_info.username = username);
    -- Compares passwords for authenticity
    IF hashed_password = true_password THEN
        RETURN 1; -- Implies username and password is authenticated
    ELSE
        RETURN 0; -- Implies invalid password (unknown to "hackers")
    END IF;
END !
DELIMITER ;



