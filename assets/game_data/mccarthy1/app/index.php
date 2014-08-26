<?php
include "setup.php";
$mysqli = new mysqli("localhost", "root", "", "app");
?>
<h1>Hacker Schmool Anonymous Feedback Bot</h1>
<p>Welcome to the Hacker Schmool Secret Sharing Extravaganza </p>
<p>Enter a secret and a password and we will store it for you.</p>
<?php 
if ($_GET["mode"] == "get_secret") {
    $result = $mysqli->query("SELECT secret FROM secrets WHERE password = '" . $_GET["password"] . "'");
    while($row = $result->fetch_assoc()){ 
        echo"Your secret is:" . $row["secret"];
    } 
    $result->close();
}
elseif ($_GET["mode"] == "put_secret") {
    $result = $mysqli->query("INSERT into secrets(password, secret) VALUES('" . $_GET["password"] . "', '" . $_GET["secret"] . "')");
    echo "Your secret is safe with us";
    $result->close();
}
else {

?>
    <form method="get" action = "/">
    <label>Password </label>
    <input type="text" name="password"/>
    <label>Secret: </label>
    <input type="text" name="secret"/>
    <input type="hidden" name="mode" value="put_secret"/>
    <input type ="submit" value="Save Secret"/>
    </form>    
    <hr/>
    <form method="get" action = "/">
    <label>Password: </label>
    <input type="text" name="password"/>
    <input type="hidden" name="mode" value="get_secret"/>
    <input type ="submit" value="Retrieve Secret"/>
    </form>                 
<?php } ?>