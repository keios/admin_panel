<?php

/*****************************************************
* modules/adc/get.php
* ADC get command file
*(c)virt2real.ru 2013
* draft, by Gol
/*****************************************************/

// common include
include('../../parts/global.php');

$vref = 14.3;
$max_raw = 1 << 10;

$filename = "/dev/v2r_adc";
$handle = fopen($filename, "r");

$contents = fread($handle, 6);

for ($i = 0; $i < 6; $i++) {

fclose($handle);

$json = json_encode($result);
echo $json;

?>