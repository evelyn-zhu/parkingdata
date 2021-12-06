<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");

    $bigint_summons_number = $_POST['summons_number'];
    $var_issuer_code = $_POST['issuer_code'];
    $var_full_street_code = $_POST['full_street_code'];
    $var_street_name = $_POST['street_name'];
    $var_plate_id = $_POST['plate_id'];
    $var_registration_state = $_POST['registration_state'];

    $query = "INSERT INTO Ticket (summons_number, issuer_code, full_street_code, street_name, plate_id, registration_state) "
            . "VALUES (:summons_number, :issuer_code, :full_street_code, :street_name, :plate_id, :registration_state)";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':summons_number', $bigint_summons_number, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':issuer_code', $var_issuer_code, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':full_street_code', $var_full_street_code, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':street_name', $var_street_name, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':plate_id', $var_plate_id, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':registration_state', $var_registration_state, PDO::PARAM_STR);
      $result = $prepared_stmt->execute();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo "Error inserting data";
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
        <li><a href="insertParkingDataLarge.php">Insert Full Ticket</a></li>
		    <li><a href="updateVehicle.php">Update</a></li>
        <li><a href="deleteTicket.php">Delete</a></li>
        <li><a href="stats.php">Stats</a></li>
      </ul>
    </div>

<h1> Insert ParkingData </h1>

    <form method="post">
    	<label for="summons_number">summons_number</label>
      <input type="text" name="summons_number" id="id_summons_number">
      
      <label for="issuer_code">issuer_code</label>
      <input type="text" name="issuer_code" id="id_issuer_code">
      
      <label for="full_street_code">full_street_code</label>
      <input type="text" name="full_street_code" id="id_full_street_code">
      
      <label for="street_name">street_name</label>
    	<input type="text" name="street_name" id="id_street_name">

    	<label for="plate_id">plate_id</label>
    	<input type="text" name="plate_id" id="id_plate_id">

    	<label for="registration_state">registration_state</label>
    	<input type="text" name="registration_state" id="id_registration_state">
    	
    	<input type="submit" name="f_submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['f_submit'])) {
        if ($result) { 
    ?>
        <h3> parking data was inserted successfully. </h3>
    <?php 
        } else { 
    ?>
          <h3> Sorry, there was an error. parking data was not inserted. </h3>
    <?php 
        }
      } 
    ?>


    
  </body>
</html>