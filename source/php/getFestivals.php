<?php
$response = file_get_contents('https://api.simonsserver.de/festivals?include=image');
echo $response;
?>
