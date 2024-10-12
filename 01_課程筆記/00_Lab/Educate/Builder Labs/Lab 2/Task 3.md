### Task 3: 使用批次腳本將多筆記錄新增至資料表

手動使用 DynamoDB 主控台逐一新增記錄雖然可行，但對於大規模資料集來說並不理想，既耗時又容易出錯。更有效的方法是使用批次處理腳本，透過腳本從檔案讀取多筆記錄並將其新增至資料表中。此腳本還能在載入記錄之前進行數據清理或修改。

#### 步驟 1：檢視即將載入的數據

1. **返回 AWS Cloud9 IDE** 的瀏覽器標籤。

2. **檢視即將載入到 `BirdSightings` 資料表的數據**：
   - 在終端機左側的 **Environment** 視窗中，展開 `node_server` 資料夾。
   - 找到並打開 `past_sightings.json` 檔案。檔案內容如下：
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
   - 這個檔案包含 25 筆記錄，每筆記錄包含多個屬性。

3. **關閉 `past_sightings.json` 檔案**。

#### 步驟 2：檢視並更新批次腳本

1. **檢視載入記錄的腳本**：
   - 在 `node_server` 資料夾中找到並打開 `load_past_sightings.js` 檔案。

2. **檢視腳本中的關鍵代碼**：
   - 此代碼匯入 AWS SDK 並配置 DynamoDB 的文件客戶端，設置為 `us-east-1` 區域。
     ```javascript
     var AWS = require("aws-sdk");
     var docClient = new AWS.DynamoDB.DocumentClient({region: 'us-east-1'});
     ```

   - 接下來的代碼將從 `past_sightings.json` 檔案中構建一個名為 `items_array` 的陣列，並將此陣列用於配置資料庫調用的參數。變數 `params` 定義了接收記錄的資料表名稱以及要載入的數據（即 `items_array`）。
     ```javascript
     var params = {
         RequestItems: { 
             '<table_name>': items_array
         }
     };
     ```

   - 此代碼使用 AWS SDK 的 `batchWrite` 方法來同時將多筆記錄新增至資料表。注意參數 `params` 被傳遞給此方法。
     ```javascript
     docClient.batchWrite(params, function(err, data) {
         if (err) {
             console.log(err); 
         } else  {
             console.log('Added ' + items_array.length + ' items to DynamoDB');
         }   
     });
     ```

3. **更新腳本中的資料表名稱**：
   - 將 `<table_name>` 佔位符替換為 `BirdSightings`，最終代碼如下：
     ```javascript
     var params = {
         RequestItems: { 
             'BirdSightings': items_array
         }
     };
     ```
   - 儲存對 `load_past_sightings.js` 的更改，並關閉檔案。

#### 步驟 3：執行批次腳本

1. **開啟新的終端機**：
   - 在 AWS Cloud9 IDE 中，打開第二個終端機窗口。注意：不要停止當前正在運行的 Node.js 伺服器，需使用新的終端窗口進行以下步驟。

2. **切換至 `node_server` 資料夾並運行腳本**：
   - 執行以下命令來進入 `node_server` 目錄並運行批次腳本：
     ```bash
     cd /home/ec2-user/environment/node_server
     node load_past_sightings.js
     ```

3. **確認腳本輸出**：
   - 輸出結果類似如下：
     ```bash
     ... Truncated for brevity
     { PutRequest: { Item: [Object] } },
     { PutRequest: { Item: [Object] } },
     ...
     Added 25 items to DynamoDB
     ```

#### 步驟 4：檢視新增的記錄

1. **返回 DynamoDB 主控台**：
   - 回到 DynamoDB 主控台的標籤頁。

2. **掃描資料表以檢視新記錄**：
   - 在 **Scan/Query items** 區域中，確保選擇 **Scan**，然後選擇 **Run** 進行掃描操作。
   - 在 **Items returned** 區域中，將顯示來自 `past_sightings.json` 檔案的 25 筆記錄。

3. **確認資料表屬性**：
   - 注意到資料表現在有 7 個屬性，儘管在建立時只設定了 2 個屬性。這是因為 DynamoDB 是一個 NoSQL（非關聯式）資料庫，如果資料表中尚未包含載入的屬性，這些新屬性將自動新增。
   - 此外，注意到日期欄位已轉換為整數值，這是因為 JavaScript 代碼進行了該操作。代碼還自動為每筆記錄生成了唯一的 `id` 值。

透過這些步驟，已成功使用批次腳本將多筆記錄載入至 DynamoDB 資料表，並確認資料成功新增且無需手動更改資料表結構。