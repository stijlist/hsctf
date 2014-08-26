<?php
$mysqli = new mysqli("localhost", "root");
$mysqli->query("CREATE DATABASE app");
if ($mysqli->errno == 0) {
    $password = file_get_contents("./password");
    $key = bin2hex(openssl_random_pseudo_bytes(16));
    //DB doesn't exist so we populate it. Super hacky lol
    $mysqli->select_db("app");
    $mysqli->query("CREATE TABLE secrets(password varchar(50), secret varchar(50))");
    $mysqli->query("INSERT INTO secrets(password, secret) VALUES ('" . $key . "', '". $password . "')");
}
?>