# Task 05：為 Yellow Taxi 數據建立 AWS Glue 表

_任務目的是在工作流程中加入邏輯，以在 `Glue` 資料庫中建立表，當資料庫中不存在表時進行該操作。_

<br>

## 新增 Athena StartQueryExecution 任務以建立表

1. 切換回到 `Actions` 頁籤，搜尋 `Athena`，將 `StartQueryExecution` 任務拖曳到 `ChoiceStateFirstRun` 與 `REPLACE ME TRUE STATE` 之間；特別注意，拖曳過程中無需理會提示藍線是否顯示於 `not ... 方塊` 之上，完成如下。

    ![](images/img_70.png)

<br>

2. 接著選取新加入的任務 `StartQueryExecution`，在右側 `State name` 框中寫入新的名稱 `Run Create data Table Query`，保持下方 `Integration type` 為 `Optimized`。

    ![](images/img_71.png)

<br>

3. 修改 `API Parameters` 預設 JSON 的內容如下，並替換 `<替換-S3-Bucket-名稱>` 為實際的 S3 Bucket名稱。

    ```json
    {
        "QueryString": "CREATE EXTERNAL TABLE nyctaxidb.yellowtaxi_data_csv(  vendorid bigint,   tpep_pickup_datetime string,   tpep_dropoff_datetime string,   passenger_count bigint,   trip_distance double,   ratecodeid bigint,   store_and_fwd_flag string,   pulocationid bigint,   dolocationid bigint,   payment_type bigint,   fare_amount double,   extra double,   mta_tax double,   tip_amount double,   tolls_amount double,   improvement_surcharge double,   total_amount double,   congestion_surcharge double) ROW FORMAT DELIMITED   FIELDS TERMINATED BY ',' STORED AS INPUTFORMAT   'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT   'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat' LOCATION  's3://<替換-S3-Bucket-名稱>/nyctaxidata/data/' TBLPROPERTIES (  'skip.header.line.count'='1')",
        "WorkGroup": "primary",
        "ResultConfiguration": {
            "OutputLocation": "s3://<替換-S3-Bucket-名稱>/athena/"
        }
    }
    ```

<br>

4. 因為 API Parameters 輸入框並不會自動換行，所以僅會顯示如下，可向右滑動進行修改與查看；這個查詢會使用 `Athena` 的 `CREATE EXTERNAL TABLE` 語句建立一個指向 `S3 Bucket` 的 `Glue` 表，定義了數據的列和數據類型。

    ![](images/img_72.png)

<br>

5. 勾選 `Wait for task to complete`，確保表完全建立後才繼續執行工作流程，並在 `Next state` 中選擇 `Go to end`。

    ![](images/img_73.png)

<br>

6. 在畫布中，手動刪除狀態 `REPLACE ME TRUE STATE`；選取並點擊 `DELETE` 按鍵即可，或點擊右鍵選擇 `Delete state`。

    ![](images/img_74.png)

<br>

7. 點擊 `Save` 保存工作流。

    ![](images/img_75.png)

<br>

## 測試工作流程

1. 選擇 `Execute`。

    ![](images/img_76.png)

<br>

2. 將 `Name` 設為 `TaskFiveTest`，然後選擇 `Start execution` 開始執行工作流。

    ![](images/img_77.png)

<br>

3. 與前面步驟相同，等待工作流中每個步驟從白色變為藍色，再變為綠色，代表任務成功執行；此次運行不會建立新資料庫，但因為資料庫中找不到表，工作流將執行 `Run Create data Table` Query 任務來建立表。

    ![](images/img_78.png)

<br>

## 驗證表的建立

1. 進入 `S3` 主控台的 `gluelab` 中的 `athena` 資料夾，該資料夾中有新的元數據文件

    ![](images/img_80.png)

<br>

2. 另外還有一些空的文本文件，這些空文件是 `Step Functions` 任務的基本輸出，可予以忽略。

    ![](images/img_79.png)

<br>

3. 在 `Glue` 主控台中選擇 `Tables`，可以看到一個名為 yellowtaxi_data_csv 的表已存在。這是工作流運行時由 Athena 建立的 Glue 表。

    ![](images/img_88.png)

<br>

4. 可點擊表的鏈接查看詳細的結構，確認表格的架構定義是否正確。

    ![](images/img_89.png)

<br>

## 再次運行工作流

1. 回到 `WorkflowPOC` 中，再次點擊右上角 `Execute`，這會開啟 `Start execution` 新視窗。

    ![](images/img_90.png)

<br>

2. 將執行名稱設為 `NewTest` 並再次點擊右下角 `Start execution`。

    ![](images/img_91.png)

<br>

3. 工作流同樣會先檢查 `Table` 是否已存在，這在前面步驟已經確認了 `Table` 建立完成，所以工作流將走另一條邏輯路徑，並調用狀態 `REPLACE ME FALSE STATE`；特別注意，當運行沒有新建或複寫立資料庫或表時，仍會在 `S3` 中生成包含更新的 Glue 元數據輸出文件，可自行前往觀察，不贅述。

    ![](images/img_92.png)

<br>

## 測試

_確認將 Value `硬編碼` 為 `True` 可排除工作流會自動帶入 `False` 的問題；特別注意，假如要繼續後續的 Task，不需要自行進行以下測試，在後續的教程中會有相同的操作指引。_

<br>

1. 可嘗試將 Table 刪除。

    ![](images/img_93.png)

<br>

2. 然後再進行一次 `New execution`；以上成功建立指向 `Yellow Taxi` 數據的 `Glue` 表，並將其整合到工作流中，當資料庫中不存在表時自動建立，而工作流的另一條邏輯路徑則是確保在表已存在時，不會重新建立表。

    ![](images/img_94.png)

<br>

___

_END_

