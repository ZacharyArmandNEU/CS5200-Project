/*
Zachary Armand
CS 5200
Final Project
December 7, 2023
Creates database and needed schemas
*/


-- Create database
DROP DATABASE IF EXISTS new_england_ice_cream;
CREATE DATABASE new_england_ice_cream;
USE new_england_ice_cream;

-- Create tables

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
	user_ID INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(32) NOT NULL,
    first_name VARCHAR(32) NOT NULL,
    last_name VARCHAR(32) NOT NULL	
);

DROP TABLE IF EXISTS chains;
CREATE TABLE chains
(
	chain_ID INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(64) NOT NULL
);

DROP TABLE IF EXISTS flavors;
CREATE TABLE flavors
(
	flavor_ID INT AUTO_INCREMENT PRIMARY KEY,
	flavor_name VARCHAR(64) NOT NULL,
    ice_cream_type ENUM("Hard Serve", "Gelato", "Sherbet", "Sorbet", "Frozen Yogurt", "Soft Serve", "Other"),
    in_stock BOOLEAN,
    chain_ID INT,
    UNIQUE(flavor_name, ice_cream_type, chain_id),
    CONSTRAINT flavor_chain_fk
		FOREIGN KEY (chain_ID)
        REFERENCES chains(chain_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings
(
	rating_ID INT AUTO_INCREMENT PRIMARY KEY,
	rating_date DATE NOT NULL,
    stars ENUM('1', '2', '3', '4', '5') NOT NULL,
    remarks TEXT,
    flavor_ID INT NOT NULL, 
    brand INT NOT NULL,
    user_ID INT,
    CONSTRAINT ratings_flavor_fk
		FOREIGN KEY (flavor_ID)
        REFERENCES flavors(flavor_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT ratings_chains_fk
		FOREIGN KEY (brand)
        REFERENCES chains(chain_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT ratings_user_fk
		FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS base;
CREATE TABLE base
(
	base_name VARCHAR(64) PRIMARY KEY,
    base_description TEXT DEFAULT NULL
);

DROP TABLE IF EXISTS mixin;
CREATE TABLE mixin
(
	mixin_name VARCHAR(64) PRIMARY KEY,
    mixin_description TEXT DEFAULT NULL
);

-- many-to-many
DROP TABLE IF EXISTS flavor_base;
CREATE TABLE flavor_base
(
	flavor_ID INT NOT NULL,
    base_name VARCHAR(64) NOT NULL,
    UNIQUE(flavor_ID, base_name),
    CONSTRAINT flavor_to_base_fk
		FOREIGN KEY (flavor_ID)
        REFERENCES flavors(flavor_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT base_to_flavor_fk
		FOREIGN KEY (base_name)
        REFERENCES base(base_name)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS flavor_mixin;
CREATE TABLE flavor_mixin
(
	flavor_ID INT NOT NULL,
    mixin_name VARCHAR(64) NOT NULL,
    UNIQUE(flavor_ID, mixin_name),
    CONSTRAINT flavor_to_mixin_fk
		FOREIGN KEY (flavor_ID)
        REFERENCES flavors(flavor_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT mixin_to_flavor_fk
		FOREIGN KEY (mixin_name)
        REFERENCES mixin(mixin_name)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);



