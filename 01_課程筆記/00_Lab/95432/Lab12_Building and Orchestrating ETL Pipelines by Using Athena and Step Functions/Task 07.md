# Task 07：優化數據格式並使用壓縮技術

_任務目標是優化資料表格，使其更高效，具體來說，是將數據儲存格式修改為 `Parquet`，並使用 `Snappy` 壓縮技術；這樣的更新將有助於更快且具成本效益的數據操作。_

<br>

## 說明

1. 由於出租車數據涵蓋多年且隨著時間不斷更新，因此將數據按時間序列進行分段儲存是合理的選擇。

<br>

2. 此步驟將使用 `nyctaxi_lookup_csv` 表作為來源，建立與其具有相同欄位名稱的 `Parquet` 版本表，並聲明 `Snappy` 作為壓縮類型。

<br>

## 更新工作流以建立具 Snappy 壓縮的 Parquet 表

_在 `Step Functions` 主控台中，使用與之前步驟相同的方法開啟 `WorkflowPOC` 狀態機，進入 `Workflow Studio`。_

<br>

1. 在 `Actions` 面板中，搜尋 `athena`；將 `StartQueryExecution` 任務拖曳到 `Run Create lookup Table Query` 與 `End` 任務之間。

    ![](images/img_106.png)

<br>

2. 同時在右側 `State name` 中更名為 `Run Create Parquet lookup Table Query`。

    ![](images/img_107.png)

<br>

3. 將下方 `API Parameters` 的預設 JSON 代碼替換為以下內容，並將兩處 `<替換-S3-Bucket>` 替換為實際的 `S3 Bucket` 名稱。

    ```json
    {
        "QueryString": "CREATE table if not exists nyctaxidb.nyctaxi_lookup_parquet WITH (format='PARQUET',parquet_compression='SNAPPY', external_location = 's3://<替換-S3-Bucket>/nyctaxidata/optimized-data-lookup/') AS SELECT locationid, borough, zone , service_zone , latitude ,longitude  FROM nyctaxidb.nyctaxi_lookup_csv",
        "WorkGroup": "primary",
        "ResultConfiguration": {
          "OutputLocation": "s3://<替換-S3-Bucket>/athena/"
        }
    }
    ```

<br>

4. 勾選 `Wait for task to complete`，在 `Next state` 中保持預設的 `Go to end`，點擊 `Save` 保存工作流。

    ![](images/img_108.png)

<br>

## 測試並驗證結果

1. 在 `Glue` 主控台中選擇 `Tables`，選取兩個資料表然後進行刪除，這將確保工作流在下次執行時選擇正確的路徑。

    ![](images/img_109.png)

<br>

2. 回到 `Step Functions` 主控台，在狀態機 `WorkflowPOC` 中點擊右上角 `Excute`，並將測試命名為 `TaskSevenTest` 後點擊 `Start execution`。

    ![](images/img_110.png)

<br>

3. 等待工作流成功執行完成，將顯示以下圖示。

    ![](images/img_111.png)

<br>

4. 再次回到 `Glue` 主控台，刷新以確認成功建立新的 `nyctaxi_lookup_parquet` 表。

    ![](images/img_112.png)

<br>

5. 點擊 `nyctaxi_lookup_parquet` 表，切換到 `Schema` 頁籤查看結構；特別注意，在 Lab 中假如提示了這個步驟，那就一定要確實點擊進行查看，否則提交後將無法通過 Lab 的驗證。至此已成功建立具 `Snappy` 壓縮的 `Parquet` 格式 lookup 表。

    ![](images/img_113.png)

<br>

___

_END_