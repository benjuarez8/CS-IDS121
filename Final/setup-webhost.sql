-- [Problem 3]
-- Drop table statements
DROP TABLE IF EXISTS customer_pkgs;
DROP TABLE IF EXISTS pkg_installations;
DROP TABLE IF EXISTS basic_accts;
DROP TABLE IF EXISTS preferred_accts;
DROP TABLE IF EXISTS shared_servers;
DROP TABLE IF EXISTS dedicated_servers;
DROP TABLE IF EXISTS software_pkgs;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS servers;

-- Table that holds info regarding servers
CREATE TABLE servers (
    -- hostname
    hostname            VARCHAR(40),
    -- indicates type of server (0 for shared, 1 for dedicated)
    server_type         TINYINT NOT NULL,
    -- hostname is primary key
    PRIMARY KEY (hostname),
    -- ensures proper server_type
    CHECK (server_type BETWEEN 0 AND 1)
);

-- Table that holds info regarding customer accounts
CREATE TABLE accounts (
    -- username of customer
    username        VARCHAR(20),
    -- URL of website
    website_url     VARCHAR(200) NOT NULL,
    -- indicates type of account (0 for basic, 1 for preferred)
    acct_type       TINYINT NOT NULL,
    -- username is primary key
    PRIMARY KEY (username),
    -- website URL is unique
    UNIQUE (website_url),
    -- ensures proper account type
    CHECK (acct_type BETWEEN 0 AND 1)
);

-- Table that holds info regarding software packages for customers
CREATE TABLE software_pkgs (
    -- name of package
    pkg_name        VARCHAR(40),
    -- version of package
    version         VARCHAR(20),
    -- description of package
    description     VARCHAR(1000) NOT NULL,
    -- monthly price for package
    -- implies max price is $999.99
    monthly_price   NUMERIC(5, 2) NOT NULL,
    -- (pkg_name, version) is unique
    PRIMARY KEY (pkg_name, version)
);

-- Table that holds info regarding dedicated servers
CREATE TABLE dedicated_servers (
    -- hostname
    hostname            VARCHAR(40),
    -- type of operating system
    operating_system    VARCHAR(30) NOT NULL,
    -- maximum number of sites that can be hosted on machine
    site_capacity       INT NOT NULL,
    -- indicates type of server (0 for shared, 1 for dedicated)
    server_type         TINYINT NOT NULL,
    -- hostname is primary key
    PRIMARY KEY (hostname),
    -- hostname comes from superclass (servers)
    FOREIGN KEY (hostname)
        REFERENCES servers (hostname)
            -- appropriate cascades ensure proper implementation
            -- (should not exist in dedicated_servers if not in superclass)
            ON DELETE CASCADE 
            ON UPDATE CASCADE,
    -- ensures correct type of server
    CHECK (site_capacity = 1)
);

-- Table that holds info regarding shared servers
CREATE TABLE shared_servers (
    -- hostname
    hostname            VARCHAR(40),
    -- type of operating system
    operating_system    VARCHAR(30) NOT NULL,
    -- maximum number of sites that can be hosted on machine
    site_capacity       INT NOT NULL,
    -- indicates type of server (0 for shared, 1 for dedicated)
    server_type         TINYINT NOT NULL,
    -- hostname is primary key
    PRIMARY KEY (hostname),
    -- hostname comes from superclass (servers)
    FOREIGN KEY (hostname)
        REFERENCES servers (hostname)
            -- appropriate cascades ensure proper implementation
            -- (should not exist in shared_servers if not in superclass)
            ON DELETE CASCADE 
            ON UPDATE CASCADE,
    -- ensures correct type of server
    CHECK (site_capacity > 1)
);

-- Table that holds info regarding preferred customer account
CREATE TABLE preferred_accts (
    -- username of customer
    username        VARCHAR(20),
    -- email address of customer
    email           VARCHAR(100) NOT NULL,
    -- URL of website
    website_url     VARCHAR(200) NOT NULL,
    -- timestamp that customer created account
    created_acct    TIMESTAMP NOT NULL,
    -- monthly subscription price
    -- implies max price is $999.99
    sub_price       NUMERIC(5, 2) NOT NULL,
    -- indicates type of account (0 for basic, 1 for preferred)
    acct_type       TINYINT NOT NULL,
    -- hostname of dedicated server associated with account
    hostname        VARCHAR(40) NOT NULL,
    -- username is primary key
    PRIMARY KEY (username),
    -- hostname is unique for preferred accounts
    UNIQUE (hostname),
    -- website URL is unique for each account
    UNIQUE (website_url),
    -- handles foreign keys
    -- assume that database is implemented appropriate w/o cascades
    -- note that cascades here would restrict implementation of update_account
    FOREIGN KEY (username)
        REFERENCES accounts (username),
    -- note that dedicated server may exist w/o preferred account
    FOREIGN KEY (hostname)
        REFERENCES dedicated_servers (hostname),
    -- ensures proper account type
    CHECK (acct_type = 1)
);

-- Table that holds info regarding basic customer account
CREATE TABLE basic_accts (
    -- username of customer
    username        VARCHAR(20),
    -- email address of customer
    email           VARCHAR(100) NOT NULL,
    -- URL of website
    website_url     VARCHAR(200) NOT NULL,
    -- timestamp that customer created account
    created_acct    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- monthly subscription price
    -- implies max price is $999.99
    sub_price       NUMERIC(5, 2) NOT NULL,
    -- indicates type of account (0 for basic, 1 for preferred)
    acct_type       TINYINT NOT NULL,
    -- hostname of dedicated server associated with account
    hostname        VARCHAR(40) NOT NULL,
    -- username is primary key
    PRIMARY KEY (username),
    -- website URL is unique for each account
    UNIQUE (website_url),
    -- handles foreign keys
    -- assume that database is implemented appropriate w/o cascades
    -- note that cascades here would restrict implementation of update_account
    FOREIGN KEY (username)
        REFERENCES accounts (username),
    -- note that shared server may exist w/o basic account
    FOREIGN KEY (hostname)
        REFERENCES shared_servers (hostname),
    -- ensures proper account type
    CHECK (acct_type = 0)
);

-- Table that holds info regarding relationship between servers and packages
CREATE TABLE pkg_installations (
    -- hostname of server
    hostname    VARCHAR(40),
    -- name of software package
    pkg_name    VARCHAR(40),
    -- version of package
    version     VARCHAR(20),
    -- (hostname, pkg_name, version) is primary key
    PRIMARY KEY (hostname, pkg_name, version),
    -- handles foreign keys
    FOREIGN KEY (hostname)
        REFERENCES servers (hostname),
    FOREIGN KEY (pkg_name, version)
        REFERENCES software_pkgs (pkg_name, version)
);

-- Table that holds info regarding relationship between customers and packages
CREATE TABLE customer_pkgs (
    -- customer username
    username    VARCHAR(20),
    -- name of software package
    pkg_name    VARCHAR(40),
    -- version of package
    version     VARCHAR(20),
    -- (username, pkg_name, version) is primary key
    PRIMARY KEY (username, pkg_name, version),
    -- handles foreign keys
    FOREIGN KEY (username)
        REFERENCES accounts (username),
    FOREIGN KEY (pkg_name, version)
        REFERENCES software_pkgs (pkg_name, version)
);