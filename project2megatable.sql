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
SELECT * FROM mega_table
LIMIT 100;