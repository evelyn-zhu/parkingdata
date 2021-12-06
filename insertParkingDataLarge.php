<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");

    $var_summons_number = $_POST['summons_number'];
    $var_issue_date = $_POST['issue_date'];
    $var_violation_code = $_POST['violation_code'];
    $var_violation_precinct = $_POST['violation_precinct'];
    $var_violation_time = $_POST['violation_time'];
    $var_date_first_observed = $_POST['date_first_observed'];
    $var_time_first_observed = $_POST['time_first_observed'];
    $var_front_or_opposite = $_POST['front_or_opposite'];
    $var_law_section = $_POST['law_section'];
    $var_sub_division = $_POST['sub_division'];
    $var_meter_number = $_POST['meter_number'];
    $var_feet_from_curb = $_POST['feet_from_curb'];
    $var_violation_description = $_POST['violation_description'];
    $var_house_number = $_POST['house_number'];
    $var_intersecting_street = $_POST['intersecting_street'];
    $var_issuer_code = $_POST['issuer_code'];
    $var_full_street_code = $_POST['full_street_code'];
    $var_street_name = $_POST['street_name'];
    $var_plate_id = $_POST['plate_id'];
    $var_registration_state = $_POST['registration_state'];

    $query = "INSERT INTO Ticket (summons_number, issue_date, violation_code, violation_precinct, violation_time,
    date_first_observed, time_first_observed, front_or_opposite, law_section, sub_division, meter_number, 
    feet_from_curb, violation_description, house_number, intersecting_street, issuer_code, full_street_code,
    street_name, plate_id, registration_state) "
            . "VALUES (:summons_number, :issue_date, :violation_code, :violation_precinct,
            :violation_time, :date_first_observed, :time_first_observed, front_or_opposite, :law_section, 
            :sub_division, :meter_number, :feet_from_curb, :violation_description, :house_number,
            :intersecting_street, ;issuer_code, :full_street_code, :street_name, :plate_id, :registration_state)";
    $query2 = "SELECT * FROM Vehicle WHERE plate_id = :plate_id AND registration_state = :registration_state";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt2 = $dbo->prepare($query2);
      
      $prepared_stmt->bindValue(':summons_number', $var_summons_number, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':issue_date', $var_issue_date, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':violation_code', $var_violation_code, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':violation_precinct', $var_violation_precinct, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':violation_time', $var_violation_time, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':date_first_observed', $var_date_first_observed, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':time_first_observed', $var_time_first_observed, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':front_or_opposite', $var_front_or_opposite, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':law_section', $var_law_section, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':sub_division', $var_sub_division, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':meter_number', $var_meter_number, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':feet_from_curb', $var_feet_from_curb, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':violation_description', $var_violation_description, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':house_number', $var_house_number, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':intersecting_street', $var_intersecting_street, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':issuer_code', $var_issuer_code, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':full_street_code', $var_full_street_code, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':street_name', $var_street_name, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':plate_id', $var_plate_id, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':registration_state', $var_registration_state, PDO::PARAM_STR);

      $prepared_stmt2->bindValue(':plate_id', $var_plate_id, PDO::PARAM_STR);
      $prepared_stmt2->bindValue(':registration_state', $var_registration_state, PDO::PARAM_STR);

      $result2 = $prepared_stmt2->execute();
      $result = $prepared_stmt->execute();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo "Insert Failed"; // HTTP 500 - Internal Server Error
    }
}

?>

<html>
  <head>
    <!-- THe following is the stylesheet file. The CSS file decides look and feel -->
    <link rel="stylesheet" type="text/css" href="project.css" />
  </head> 

  <body>
    <div id="navbar">
      <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="getParkingData.php">Search</a></li>
        <li><a href="insertParkingData.php">Insert</a></li>
				<li><a href="updateVehicle.php">Update</a></li>
        <li><a href="deleteTicket.php">Delete</a></li>
        <li><a href="stats.php">Stats</a></li>
      </ul>
    </div>

<h1>Insert Ticket</h1>

    <form method="post">
      <div class="sub-entry">
        <label for="summons_number">Summons Number</label>
        <input type="text" name="summons_number" id="id_summons_number">

        <label for="issue_date">Issue Date</label>
        <input type="text" name="issue_date" id="id_issue_date">

        <label for="violation_code">Violation Code</label>
        <input type="text" name="violation_code" id="id_violation_code">

        <label for="violation_precinct">Violation Precinct</label>
        <input type="text" name="violation_precinct" id="id_violation_precinct">

        <label for="violation_time">Violation Time</label>
        <input type="text" name="violation_time" id="id_violation_time">
      </div>
      <div class="sub-entry">
      <label for="date_first_observed">Date First Observed</label>
      <input type="text" name="date_first_observed" id="id_date_first_observed">

      <label for="time_first_observed">Time First Observed</label>
      <input type="text" name="time_first_observed" id="id_time_first_observed">

      <label for="front_or_opposite">Front Or Opposite</label>
      <input type="text" name="front_or_opposite" id="id_front_or_opposite">

      <label for="law_section">Law Section</label>
      <input type="text" name="law_section" id="id_law_section">

      <label for="sub_division">Sub Division</label>
      <input type="text" name="sub_division" id="id_sub_division">
      </div>
      <div class="sub-entry">

      <label for="meter_number">Meter Number</label>
      <input type="text" name="meter_number" id="id_meter_number">

      <label for="feet_from_curb">Feet From Curb</label>
      <input type="text" name="feet_from_curb" id="id_feet_from_curb">

      <label for="violation_description">Violation Description</label>
      <input type="text" name="violation_description" id="id_violation_description">

      <label for="house_number">House Number</label>
      <input type="text" name="house_number" id="house_number">

      <label for="intersecting_street">Intersecting Street</label>
      <input type="text" name="intersecting_street" id="id_intersecting_street">
      </div>

      <div class="sub-entry">
      <label for="issuer_code">Issuer Code</label>
      <input type="text" name="issuer_code" id="id_issue_code">
      
      <label for="full_street_code">Full Street Code</label>
      <input type="text" name="full_street_code" id="id_full_street_code">

    	<label for="street_name">Street Name</label>
      <input type="text" name="street_name" id="id_street_name">
      
      <label for="plate_id">Plate ID</label>
    	<input type="text" name="plate_id" id="id_plate_id">

    	<label for="registration_state">Registration State (XX)</label>
    	<input type="text" name="registration_state" id="id_registration_state">
    	
      <input type="submit" name="f_submit" value="Submit">
    </div>
    </form>
    <?php
      if (isset($_POST['f_submit'])) {
        if ($result) { 
    ?>
      <h3> Parking data was inserted successfully.
      </h3>
    <?php 
        } else { 
    ?>
      <h3> Sorry, there was an error. Parking data was not inserted. </h3>
    <?php 
        }
      } 
    ?>

    <?php if ($result2 && $prepared_stmt2->rowCount() < 1) {
        echo "New Vehicle! Go to Update and provide details";
      }
    ?>

  </body>
</html>