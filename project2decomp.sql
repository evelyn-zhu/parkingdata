# Creating Database
DROP DATABASE IF EXISTS parking_data;
CREATE DATABASE parking_data;
USE parking_data;

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
    time_first_observed VARCHAR(10), #MOSTLY NULL VALUES, could be dropped
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
    feet_from_curb VARCHAR(10), # almost all 0's, could also drop
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
    
## CLEANING COUNTY DATA
UPDATE mega_table
SET
	violation_county = 'Q'
WHERE violation_county = 'QUEEN';

UPDATE mega_table
SET
	violation_county = 'K'
WHERE violation_county = 'KINGS';

UPDATE mega_table
SET
	violation_county = 'RC'
WHERE violation_county = 'RICH' or violation_county = 'RC';

UPDATE mega_table
SET
	violation_county = 'NYC'
WHERE violation_county = 'NY';

UPDATE mega_table
SET
	violation_county = 'BRONX'
WHERE violation_county = 'BX';

## CLEANING STREET DATA
UPDATE mega_table
SET
	street_name = LOWER(street_name);
    
UPDATE mega_table
SET
	street_name = REPLACE(street_name, 'avenue', 'ave');

UPDATE mega_table
SET
	street_name = REPLACE(street_name, 'street', 'st');

## CREATING STREET TABLE
DROP TABLE IF EXISTS Street;
CREATE TABLE Street AS
	(SELECT
    DISTINCT street_name,
    violation_county,
    days_parking_in_effect,
    from_hours_in_effect,
    to_hours_in_effect
    FROM mega_table);

ALTER TABLE Street ADD COLUMN street_id INT DEFAULT 0;
ALTER TABLE Street MODIFY street_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

SELECT * FROM Street;


DROP TABLE IF EXISTS Ticket;
CREATE TABLE Ticket AS 
	(SELECT 
    summons_number,
    issue_date,
    violation_code,
    violation_precinct,
    violation_time,
    date_first_observed,
    time_first_observed,
    front_or_opposite,
    law_section,
    sub_division,
    meter_number,
    feet_from_curb,
    violation_description,
    intersecting_street,
    house_number,
    plate_id,
    street_name,
    issuer_code FROM mega_table);

# ALTER TABLE Ticket ADD COLUMN street_id INT DEFAULT 0;

# Should work to create identifier, but times out, don't use
# UPDATE Ticket, Street
# SET 
#	Ticket.street_id = Street.street_id
# WHERE Ticket.street_name = Street.street_name;

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


DROP TABLE IF EXISTS Vehicle;
CREATE TABLE Vehicle AS 
	(SELECT 
    DISTINCT plate_id,
    registration_state,
    plate_type,
    vehicle_body_type,
    vehicle_make,
    vehicle_expiration_date,
    vehicle_color,
    unregistered_vehicle,
    vehicle_year FROM mega_table);
    
DROP TABLE IF EXISTS Issuer;
CREATE TABLE Issuer AS 
	(SELECT 
    DISTINCT issuer_code,
    issuing_agency,
    issuer_precint,
    issuer_command,
    issuer_squad
    FROM mega_table);

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Ticket ADD CONSTRAINT fk_plate_id FOREIGN KEY (plate_id) REFERENCES Vehicle(plate_id);
ALTER TABLE Ticket ADD CONSTRAINT fk_issuer_code FOREIGN KEY (issuer_code) REFERENCES Issuer(issuer_code);
ALTER TABLE Ticket ADD CONSTRAINT fk_street_name FOREIGN KEY (street_name) REFERENCES Street(street_name);
