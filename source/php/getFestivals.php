<?php
$response = file_get_contents('https://api.festivalsapp.de/festivals?include=image');
echo $response;
?>
