<?php

$dbhost = '127.0.0.1'; // localhost
$dbuname = 'root';
$dbpass = 'root';
$dbname = 'parking_data'; //Database name


//$dbo = new PDO('mysql:host=abc.com;port=8889;dbname=$dbname, $dbuname, $dbpass);

$dbo = new PDO('mysql:host=' . $dbhost . ';port=8889;dbname=' . $dbname, $dbuname, $dbpass);

?>
