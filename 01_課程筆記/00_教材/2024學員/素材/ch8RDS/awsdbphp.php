<?php
define('DB_SERVER', 'XXXXXX.XXXXXXl.us-east-1.rds.amazonaws.com');
define('DB_USERNAME', 'admin');
define('DB_PASSWORD', 'XXXXXX');
define('DB_DATABASE', 'XXXXXX');
/* Connect to MySQL and select the database. */
$conn = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);
if 	(mysqli_connect_errno())  echo "Failed to connect to MySQL: " . mysqli_connect_error();
 else echo "db connected </br>" ;
$sql="select * from db202208241.ch8";
$result = mysqli_query($conn, $sql);
if (!$result) {
    echo "DB Error, could not query the database\n";
    echo 'MySQL Error: ' . mysql_error();
    exit;
}
while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
    echo "Platform=".$row['Platform']." ;  Synchronize=".$row['Synchronize']."; Asyn=".$row['Asyn']."; Hybrid= ".$row['Hybrid']."</br>";
}
mysqli_close($conn);
?>
