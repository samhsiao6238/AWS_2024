<?php
/* 定義資料庫連接常量 */
define(
    'DB_SERVER',
    'XXXXXX.XXXXXXl.us-east-1.rds.amazonaws.com'
);
define('DB_USERNAME', 'admin');
define('DB_PASSWORD', 'XXXXXX');
define('DB_DATABASE', 'XXXXXX');

/* 連接到 MySQL 並選擇資料庫 */
$conn = mysqli_connect(
    DB_SERVER,
    DB_USERNAME,
    DB_PASSWORD,
    DB_DATABASE
);

// 檢查連接是否成功
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    exit;
} else {
    echo "db connected </br>";
}

// 執行查詢
$sql = "SELECT * FROM ch8";
$result = mysqli_query($conn, $sql);

// 檢查查詢是否成功
if (!$result) {
    echo "DB Error, could not query the database\n";
    // 使用 mysqli_error 來獲取錯誤訊息
    echo 'MySQL Error: ' . mysqli_error($conn);
    exit;
}

// 輸出查詢結果
while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
    echo "Platform=" . $row['Platform'] . " ;  Synchronize=" . $row['Synchronize'] . "; Asyn=" . $row['Asyn'] . "; Hybrid= " . $row['Hybrid'] . "</br>";
}

// 關閉連接
mysqli_close($conn);
