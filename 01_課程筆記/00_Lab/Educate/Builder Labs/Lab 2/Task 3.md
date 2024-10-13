# Task 3：使用批次腳本將多筆記錄新增至資料表

_雖然可用手動方式在 `DynamoDB` 主控台中逐一新增記錄，但對於大規模資料集來說並不符合效益且容易出錯；可使用批次處理腳本模式，透過腳本從檔案讀取多筆記錄並將其新增至資料表中。_

<br>

## 檢視即將載入的數據

_返回 Cloud9 IDE_

<br>

1. 在終端機左側的 Environment 視窗中，展開 `node_server` 資料夾，找到並打開 `past_sightings.json` 檔案。

    ![](images/img_22.png)

<br>

2. 點擊兩下可開啟文件，這是後續要載入到 `BirdSightings` 資料表的數據，內容包含 `25` 筆記錄，每筆記錄包含多個屬性。

    ```json
    [
        {
            "student_name_str": "Li Juan",
            "bird_name_str": "American Crow",
            "count_int": 3,
            "location_str": "park",
            "date_str": "2021-12-10",
            "class_level_str": "3rd Grade"
        },
        {
            "student_name_str": "Li Juan",
            "bird_name_str": "Baltimore Oriole",
            "count_int": 1,
            "location_str": "Home",
            "date_str": "2021-12-13",
            "class_level_str": "3rd Grade"
        }
    ]
    ```

<br>

3. 點擊文件右側 `x` 可關閉檔案。

    ![](images/img_23.png)

<br>

## 檢視並更新批次腳本

1. 在 `node_server` 資料夾中找到並打開 `load_past_sightings.js` 檔案。

<br>

2. 使用代碼匯入 AWS SDK 並配置 DynamoDB 的文件客戶端，設置為 `us-east-1` 區域。

    ```javascript
    var AWS = require("aws-sdk");
    var docClient = new AWS.DynamoDB.DocumentClient(
        {region: 'us-east-1'}
    );
    ```

<br>

3. 接下來的代碼將從 `past_sightings.json` 檔案中構建一個名為 `items_array` 的陣列，並將此陣列用於配置資料庫調用的參數。變數 `params` 定義了接收記錄的資料表名稱以及要載入的數據（即 `items_array`）。

    ```javascript
    var params = {
        RequestItems: { 
            '<table_name>': items_array
        }
    };
    ```

<br>

4. 以下代碼使用 AWS SDK 的 `batchWrite` 方法來同時將多筆記錄新增至資料表；注意參數 `params` 被傳遞給此方法。

    ```javascript
    docClient.batchWrite(params, function(err, data) {
        if (err) {
            console.log(err); 
        } else  {
            console.log(
                'Added ' + items_array.length + ' items to DynamoDB'
            );
        }   
    });
    ```

<br>

5. 更新腳本中的資料表名稱，將 `<Table-名稱>` 替換為 `BirdSightings`。

    ```javascript
    var params = {
        RequestItems: { 
            '<Table-名稱>': items_array
        }
    };
    ```

<br>

6. 儲存對 `load_past_sightings.js` 的更改，並關閉檔案。

<br>

## 執行批次腳本

1. 在 AWS Cloud9 IDE 中，打開第二個終端機窗口；特別注意：不要停止當前正在運行的 Node.js 伺服器，需使用新的終端窗口進行以下步驟。

<br>

2. 執行以下命令來進入 `node_server` 目錄並運行批次腳本。

    ```bash
    cd /home/ec2-user/environment/node_server
    node load_past_sightings.js
    ```

<br>

3. 輸出結果如下。

    ```bash
    ... Truncated for brevity
    { PutRequest: { Item: [Object] } },
    { PutRequest: { Item: [Object] } },
    ...
    Added 25 items to DynamoDB
    ```

<br>

## 檢視新增的記錄

1. 回到 DynamoDB 主控台的標籤頁。

<br>

2. 在 `Scan or query items` 區域中，確保選擇 `Scan`，然後選擇 `Run` 進行掃描操作。

<br>

3. 在 `Items returned` 區域中，將顯示來自 `past_sightings.json` 檔案的 25 筆記錄。

<br>

4. 注意到資料表現在有 7 個屬性，儘管在建立時只設定了 2 個屬性，這是因為 DynamoDB 是一個 `NoSQL 非關聯式資料庫`，如果資料表中尚未包含載入的屬性，這些新屬性將自動新增。

<br>

5. 此外，注意到日期欄位已轉換為整數值，這是因為 `JavaScript` 代碼進行了該操作；代碼還自動為每筆記錄生成了唯一的 `id` 值。

<br>

___

_END_