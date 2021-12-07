# Creating Database
DROP DATABASE IF EXISTS parking_data;
CREATE DATABASE parking_data;
USE parking_data;
SET SQL_SAFE_UPDATES = 0;

# Creating mega_table
# IMPORTANT: NOTE THAT YOU MUST ADJUST YOUR MYSQL TIMEOUT SETTINGS
# THIS DATABASE TAKES ABOUT 3 MINUTES TO LOAD
DROP TABLE IF EXISTS mega_table;
CREATE TABLE mega_table (
	summons_number BIGINT NOT NULL, #primary key that identifies all tickets
    plate_id VARCHAR(20) NOT NULL, #probably could be a primary key for another table
    registration_state VARCHAR(2),
    plate_type VARCHAR(4),
    issue_date VARCHAR(15), #cast to date after
    violation_code INT(2),
    vehicle_body_type VARCHAR(10),
    vehicle_make VARCHAR(10),
    issuing_agency VARCHAR(2),
    street_code1 INT(7),
    street_code2 INT(7),
    street_code3 INT(7),
    vehicle_expiration_date INT(12), #should be cast into date after
    violation_location VARCHAR(10), #cast to INT after empties replaced
    violation_precinct INT(2),
    issuer_precint INT(3),
    issuer_code INT(8), #issuer table potentially useful
    issuer_command VARCHAR(5),
    issuer_squad VARCHAR(5), #cast to INT(5) after changing empties
    violation_time VARCHAR(5), # could be combined to make a datetime with date
    time_first_observed VARCHAR(12), #MOSTLY NULL VALUES, could be dropped
    violation_county VARCHAR(10),
    front_or_opposite VARCHAR(2),
    house_number VARCHAR(20), #cast to INT after replacing empties with 0
    street_name TEXT,
    intersecting_street VARCHAR(25), #MOSTLY NULL VALUES, could be dropped
    date_first_observed VARCHAR(20), # could cast to date, mostly 0's though so could be dropped. Perhaps replace 0's with issue date?
    law_section VARCHAR(100),
    sub_division VARCHAR(5),
    violation_legal_code VARCHAR(10), #all zeroes, MUST DROP
    days_parking_in_effect VARCHAR(10), # likely dependent on street
    from_hours_in_effect VARCHAR(10), #Cast to time, replace NULL with midnight?
    to_hours_in_effect VARCHAR(10), #Cast to time, replace NULL with midnight?
    vehicle_color VARCHAR(10),
    unregistered_vehicle VARCHAR(10), #empty = 0, 0 = registered, 1 =unregistered
    vehicle_year VARCHAR(10), #25% are 0 for this, maybe cast to NULL
    meter_number VARCHAR(100), # MOSTLY NULL, we can drop this
    feet_from_curb VARCHAR(10), # almost all 0s, could also drop
    violation_post_code TEXT, # could cast to INT after replacing empties with 0
    violation_description VARCHAR(100), # replace NULL with 'unspecified' or fill using rule
    no_standing_or_stopping VARCHAR(10), # ALL NULL, DROP
    hydrant_violation VARCHAR(10), # ALL NULL, DROP
    double_parking VARCHAR(10), # ALL NULL, DROP
    latitude VARCHAR(10), # ALL NULL, DROP (would have been useful)
    longitude VARCHAR(10), # DROP
    community_board VARCHAR(10), # ALL NULL, DROP
    community_council VARCHAR(10), # ALL NULL, DROP
    census_tract VARCHAR(10), # ALL NULL, DROP
    bin_no VARCHAR(10), # ALL NULL, DROP
    bbl VARCHAR(10), # ALL NULL, DROP
    nta VARCHAR(10), # ALL NULL, DROP
PRIMARY KEY (summons_number));

# we want to specifically use the 2013-2014 data, since it is by far the most complete
# so remember to only download and load that one in!

LOAD DATA INFILE '/Users/reillykoren/Desktop/Parking_Violations_Issued_-_Fiscal_Year_2014__August_2013___June_2014_.csv'
 INTO TABLE mega_table
 FIELDS TERMINATED BY ',' 
 ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
IGNORE 1 LINES;
ALTER TABLE mega_table
	DROP COLUMN no_standing_or_stopping,
	DROP COLUMN hydrant_violation,
	DROP COLUMN double_parking,
	DROP COLUMN latitude,
	DROP COLUMN longitude,
	DROP COLUMN community_board,
	DROP COLUMN community_council,
	DROP COLUMN census_tract,
	DROP COLUMN bin_no,
	DROP COLUMN bbl,
	DROP COLUMN nta;
    
ALTER TABLE mega_table
	DROP COLUMN violation_location;
ALTER TABLE mega_table
    DROP COLUMN violation_legal_Code;
-- -----------------------------------------------------
-- Table Issuer
-- -----------------------------------------------------
DROP TABLE IF EXISTS Issuer;
CREATE TABLE IF NOT EXISTS Issuer (
  issuer_code INT(8) NOT NULL,
  issuing_agency VARCHAR(2) NULL,
  issuer_precinct INT(3) NULL,
  issuer_command VARCHAR(5) NULL,
  issuer_squad VARCHAR(5) NULL,
  PRIMARY KEY (issuer_code))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Address
-- -----------------------------------------------------
DROP TABLE IF EXISTS Address;
CREATE TABLE IF NOT EXISTS Address (
  full_street_code VARCHAR(25) NULL,
  violation_county VARCHAR(45) NULL,
  street_name TEXT NULL,
  days_parking_in_effect VARCHAR(10) NULL,
  from_hours_in_effect VARCHAR(10) NULL,
  to_hours_in_effect VARCHAR(10) NULL,
  location_id INT(12) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (location_id))
ENGINE = InnoDB;

## Cleaning Street Data 
UPDATE mega_table
SET
	street_name = LOWER(street_name);
    
UPDATE mega_table
SET
	street_name = REPLACE(street_name, 'avenue', 'ave');

UPDATE mega_table
SET
	street_name = REPLACE(street_name, 'street', 'st');

-- -----------------------------------------------------
-- Table Vehicle
-- -----------------------------------------------------
DROP TABLE IF EXISTS Vehicle;
CREATE TABLE IF NOT EXISTS Vehicle (
  plate_id VARCHAR(20) NOT NULL,
  registration_state VARCHAR(2) NOT NULL,
  plate_type VARCHAR(4) NULL,
  vehicle_body_type VARCHAR(10) NULL,
  vehicle_make VARCHAR(10) NULL,
  vehicle_expiration_date INT(12) NULL,
  vehicle_color VARCHAR(10) NULL,
  unregistered_vehicle VARCHAR(10) NULL,
  vehicle_year VARCHAR(10) NULL,
  PRIMARY KEY (plate_id, registration_state))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ticket
-- -----------------------------------------------------
DROP TABLE IF EXISTS Ticket;
CREATE TABLE IF NOT EXISTS Ticket (
  summons_number BIGINT(20) NOT NULL,
  issue_date VARCHAR(15) NULL,
  violation_code INT(2) NULL,
  violation_precinct INT(2) NULL,
  violation_time VARCHAR(5) NULL,
  date_first_observed VARCHAR(12) NULL,
  time_first_observed VARCHAR(10) NULL,
  front_or_opposite VARCHAR(2) NULL,
  law_section VARCHAR(100) NULL,
  sub_division VARCHAR(5) NULL,
  meter_number VARCHAR(100) NULL,
  feet_from_curb VARCHAR(10) NULL,
  violation_description VARCHAR(45) NULL,
  house_number VARCHAR(45) NULL,
  intersecting_street VARCHAR(100) NULL,
  issuer_code INT(8) NOT NULL DEFAULT 0,
  full_street_code VARCHAR(100) NOT NULL,
  street_name TEXT NOT NULL,
  plate_id VARCHAR(20) NOT NULL,
  registration_state VARCHAR(2) NOT NULL,
  PRIMARY KEY (summons_number))
ENGINE = InnoDB;


SET SESSION sql_mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION";

## Filling Ticket
INSERT INTO Ticket (summons_number, issue_date, violation_code, violation_precinct, violation_time,
date_first_observed, time_first_observed, front_or_opposite, law_section, sub_division, meter_number,
feet_from_curb, violation_description, house_number, intersecting_street, issuer_code, full_street_code,
street_name, plate_id, registration_state)
SELECT summons_number, issue_date, violation_code, violation_precinct, violation_time,
date_first_observed, time_first_observed, front_or_opposite, law_section, sub_division, meter_number,
feet_from_curb, violation_description, house_number, intersecting_street, issuer_code, CONCAT(street_code1,'-',street_code2,'-',street_code3) AS full_street_code,
street_name, plate_id, registration_state
FROM mega_table
ORDER BY summons_number DESC;

# Cleaning Ticket
SET SQL_SAFE_UPDATES = 0;
UPDATE Ticket
SET
	date_first_observed = 
		CONCAT((SELECT SUBSTRING(date_first_observed, 5, 2)), '/', 
				(SELECT SUBSTRING(date_first_observed, 7, 2)), '/',
                (SELECT SUBSTRING(date_first_observed, 1, 4)))
WHERE date_first_observed != '0';

UPDATE Ticket
SET
	date_first_observed = issue_date
WHERE date_first_observed = '0';

UPDATE Ticket
SET
	time_first_observed = violation_time
WHERE time_first_observed = '';

## Filling Vehicle
INSERT INTO Vehicle(plate_id, registration_state, plate_type, vehicle_body_type, vehicle_make, vehicle_expiration_date,
vehicle_color, unregistered_vehicle, vehicle_year)
SELECT plate_id, registration_state, plate_type, vehicle_body_type, vehicle_make, vehicle_expiration_date,
vehicle_color, unregistered_vehicle, vehicle_year
FROM mega_table
GROUP BY
plate_id, registration_state;

## Filling Issuer
INSERT INTO Issuer(issuer_code, issuing_agency, issuer_precinct, issuer_command, issuer_squad)
SELECT issuer_code, issuing_agency, issuer_precint, issuer_command, issuer_squad
FROM mega_table
GROUP BY
issuer_code;


## Filling Address
INSERT INTO Address(full_street_code, violation_county, street_name, 
	days_parking_in_effect, from_hours_in_effect, to_hours_in_effect)
SELECT CONCAT(street_code1,'-',street_code2,'-',street_code3) AS full_street_code, violation_county,
	street_name, days_parking_in_effect, from_hours_in_effect, to_hours_in_effect
FROM mega_table
GROUP BY
full_street_code, street_name;

## CLEANING COUNTY DATA

UPDATE Address
SET
	violation_county = 'Q'
WHERE violation_county = 'QUEEN';

UPDATE Address
SET
	violation_county = 'K'
WHERE violation_county = 'KINGS';

UPDATE Address
SET
	violation_county = 'RC'
WHERE violation_county = 'RICH' or violation_county = 'RC';

UPDATE Address
SET
	violation_county = 'NYC'
WHERE violation_county = 'NY';

UPDATE Address
SET
	violation_county = 'BRONX'
WHERE violation_county = 'BX';


INSERT INTO Ticket (summons_number, issuer_code, full_street_code, street_name, plate_id, registration_state)
 VALUES (0123456789, 123456, '12345-67899-10112','Sesame Street', 'ABC123', 'NJ');
 
DELETE FROM Ticket WHERE summons_number = 0123456789;
SELECT * FROM Ticket;
