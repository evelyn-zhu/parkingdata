<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");
    $var_plate_id = $_POST['plate_id'];
    $var_registration_state = $_POST['registration_state'];
    $var_plate_type = $_POST['plate_type'];
    $var_vehicle_body_type = $_POST['vehicle_body_type'];
    $var_vehicle_make = $_POST['vehicle_make'];
    $var_vehicle_expiration_date = $_POST['vehicle_expiration_date'];
    $var_vehicle_color = $_POST['vehicle_color'];
    $var_unregistered_vehicle = $_POST['unregistered_vehicle'];
    $var_vehicle_year = $_POST['vehicle_year'];

    $query = "UPDATE Vehicle SET 
    plate_type = :plate_type, vehicle_body_type = :vehicle_body_type, vehicle_make = :vehicle_make,
    vehicle_expiration_date = :vehicle_expiration_date, vehicle_color = :vehicle_color,
    unregistered_vehicle = :unregistered_vehicle, vehicle_year = :vehicle_year
    WHERE plate_id = :plate_id AND registration_state = :registration_state";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':plate_id', $var_plate_id, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':registration_state', $var_registration_state, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':plate_type', $var_plate_type, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vehicle_body_type', $var_vehicle_body_type, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vehicle_make', $var_vehicle_make, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vehicle_expiration_date', $var_vehicle_expiration_date, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':vehicle_color', $var_vehicle_color, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':unregistered_vehicle', $var_unregistered_vehicle, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':vehicle_year', $var_vehicle_year, PDO::PARAM_STR);
      $result = $prepared_stmt->execute();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
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
        <label for="plate_id">Plate ID</label>
    	<input type="text" name="plate_id" id="id_plate_id">

    	<label for="registration_state">Registration State (XX)</label>
        <input type="text" name="registration_state" id="id_registration_state">
        
        <label for="plate_type">Plate Type (PAS = passenger)</label>
        <input type="text" name="plate_type" id="id_plate_type">
        
        <label for="vehicle_body_type">Vehicle Body Type (4DSD, SUV, etc)</label>
        <input type="text" name="vehicle_body_type" id="id_vehicle_body_type">
        
        <label for="vehicle_make">Vehicle Make</label>
        <input type="text" name="vehicle_make" id="id_vehicle_make">
        
        <label for="vehicle_expiration_date">Vehicle Expiration Date</label>
        <input type="text" name="vehicle_expiration_date" id="id_vehicle_expiration_date">
        
        <label for="vehicle_color">Vehicle Color</label>
        <input type="text" name="vehicle_color" id="id_vehicle_color">
        
        <label for="unregistered_vehicle">Unregistered Vehicle</label>
        <input type="text" name="unregistered_vehicle" id="id_unregistered_vehicle">
        
        <label for="vehicle_year">Vehicle Year</label>
    	<input type="text" name="vehicle_year" id="id_vehicle_year">
    	
    	<input type="submit" name="f_submit" value="Submit">
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

  </body>
</html>