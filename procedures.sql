USE parking_data2;

DELIMITER //
DROP PROCEDURE IF EXISTS hours_correction;
CREATE PROCEDURE hours_correction()
BEGIN
	DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
		
    START TRANSACTION;
		UPDATE Address
        SET from_hours_in_effect = 'ALL'
			to_hours_in_effect = 'ALL'
        WHERE from_hours_in_effect = '' OR from_hours_in_effect = '0  :'
	
    IF sql_error = FALSE THEN
		COMMIT;
        SELECT 'Transaction committed';
	ELSE
		ROLLBACK;
        SELECT 'Transaction failed';
	END IF;
END //
DELIMITER ;
Call hours_correction();

DROP TRIGGER IF EXISTS prevent_missing
DELIMITER //
CREATE TRIGGER prevent_missing
BEFORE UPDATE
ON Ticket
FOR EACH ROW
BEGIN
	IF LENGTH(new.plate_id) > 8 OR
    LENGTH(new.state_registration != 2) OR
    LENGTH(new.summons_number != 10) OR
    new.street_name = '' OR
    LENGTH(new.issuer_code != 6) THEN
	SIGNAL SQLSTATE '45000';
    END IF;
END //
DELIMITER ;


DROP VIEW IF EXISTS address_view;
CREATE VIEW address_view AS
SELECT summons_number, issue_date, violation_code, violation_precinct, violation_time, time_first_observed,
front_or_opposite, law_section, sub_division, meter_number, house_number, intersecting_street,
t.full_street_code, t.street_name, violation_county, days_parking_in_effect, from_hours_in_effect, to_hours_in_effect,
CONCAT(t.full_street_code, ' ', t.street_name) AS code_plus_name
FROM Ticket t
INNER JOIN Address a ON 
	t.full_street_code = a.full_street_code AND t.street_name = a.street_name;


DROP VIEW IF EXISTS issuer_view;
CREATE VIEW issuer_view AS
SELECT summons_number, issue_date, violation_code, violation_precinct, violation_time,
date_first_observed, time_first_observed, front_or_opposite, law_section, sub_division, meter_number,
feet_from_curb, violation_description, street_name, t.issuer_code, issuing_agency, issuer_precinct,
issuer_command, issuer_squad
FROM Ticket t
INNER JOIN Issuer i ON 
	t.issuer_code = i.issuer_code;
    

DROP VIEW IF EXISTS vehicle_view;
CREATE VIEW vehicle_view AS
SELECT summons_number, issue_date, violation_code, violation_precinct, violation_time,
feet_from_curb, violation_description, street_name, t.plate_id, t.registration_state,
plate_type, vehicle_body_type, vehicle_make, vehicle_expiration_date, vehicle_color,
unregistered_vehicle, vehicle_year, CONCAT(t.plate_id, t.registration_state) AS full_plate
FROM Ticket t
INNER JOIN Vehicle v ON 
	t.plate_id = v.plate_id AND t.registration_state = v.registration_state;

SELECT * FROM issuer_view;

DROP VIEW IF EXISTS v_tix_count;
CREATE VIEW v_tix_count AS
SELECT plate_id, registration_state, COUNT(full_plate) AS ticket_count
FROM vehicle_view
WHERE plate_id != 'BLANKPLATE' AND plate_id != 'N/A'
GROUP BY full_plate
ORDER BY ticket_count DESC;

DROP VIEW IF EXISTS i_tix_count;
CREATE VIEW i_tix_count AS
SELECT issuer_code, issuer_precinct, COUNT(issuer_code) AS ticket_count
FROM issuer_view
WHERE issuer_code != '0'
GROUP BY issuer_code
ORDER BY ticket_count DESC;






