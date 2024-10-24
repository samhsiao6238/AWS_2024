<?php
define('DB_SERVER', 'rds20240713.cndjgjxtqom1.us-east-1.rds.amazonaws.com');
define('DB_USERNAME', 'admin');
define('DB_PASSWORD', 'USCRDS20240713%');
define('DB_DATABASE', 'db20240713');
/* Connect to MySQL and select the database. */
$conn = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);
if  (mysqli_connect_errno())  echo "Failed to connect to MySQL: " . mysqli_connect_error();
 else echo "db connected </br>" ;
$sql="select * from db20240713.ch8";
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