<?php

if (isset($_POST['f_submit'])) {

    require_once("conn.php");

    $bigint_summons_number = $_POST['summons_number'];
    $var_plate_id = $_POST['plate_id'];
    $var_registration_state = $_POST['registration_state'];
    $var_plate_type = $_POST['plate_type '];

    $query = "INSERT INTO mega_table (summons_number, plate_id, registration_state, plate_type) "
            . "VALUES (:summons_number, :plate_id, :registration_state, :plate_type)";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':summons_number', $bigint_summons_number, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':plate_id', $var_plate_id, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':registration_state', $var_registration_state, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':plate_type', $var_plate_type, PDO::PARAM_STR);
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
        <li><a href="insertParkingData.php">Insert ParkingData</a></li>
      </ul>
    </div>

<h1> Insert ParkingData </h1>

    <form method="post">
    	<label for="summons_number">summons_number</label>
    	<input type="text" name="summons_number" id="id_summons_number"> 

    	<label for="plate_id">plate_id</label>
    	<input type="text" name="plate_id" id="id_plate_id">

    	<label for="registration_state">registration_state</label>
    	<input type="text" name="registration_state" id="id_registration_state">

    	<label for="plate_type">plate_type</label>
    	<input type="text" name="plate_type" id="id_plate_type">
    	
    	<input type="submit" name="f_submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['f_submit'])) {
        if ($result) { 
    ?>
          parking data was inserted successfully.
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