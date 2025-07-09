<?php
define('DB_SERVER', 'database20230727.cor4lwuuxkis.us-east-1.rds.amazonaws.com');
define('DB_USERNAME', 'admin');
define('DB_PASSWORD', '2jjudxxuU');
define('DB_DATABASE', 'db20270727');
/* Connect to MySQL and select the database. */
$conn = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);
if 	(mysqli_connect_errno())  echo "Failed to connect to MySQL: " . mysqli_connect_error();
 else echo "db connected </br>" ;
$sql="select * from db20270727.data1";
$result = mysqli_query($conn, $sql);
if (!$result) {
    echo "DB Error, could not query the database\n";
    echo 'MySQL Error: ' . mysql_error();
    exit;
}
while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
    echo "name=".$row['name']." ;  fuel=".$row['fuel']."; Cat=".$row['categary']."; gas= ".$row['gas']."</br>";
}
mysqli_close($conn);
?>