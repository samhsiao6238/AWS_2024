# ETL

_Extract、Transform、Load，提取、轉換、加載；使用 AWS Glue 對數據集進行 ETL 操作_

<br>

## 任務 1，使用 AWS Glue 爬網程式處理 GHCN-D 資料集

_可能不知道需要分析的數據結構，可將 AWS Glue 指向存儲在 AWS 上的數據，該服務將會將相關的元數據存儲在 AWS Glue Data Catalog 中，可通過建立爬網程式來實現這一點，該程式會檢查數據源並根據數據推斷結構。_

<br>

1. 配置並建立 AWS Glue 爬網程式。

<br>

2. 運行爬網程式以提取、轉換和加載數據到 AWS Glue 資料庫中。

<br>

3. 查看爬網程式建立的表格的元數據。

<br>

4. 編輯表格的結構。

<br>

## 配置並建立 AWS Glue 爬網程式

_配置並建立一個爬網程式來發現 `GHCN-D` 資料集的結構，並從中提取數據_

<br>

1. 搜尋並進入 `Glue`。

    ![](images/img_01.png)

<br>

2. 在左側欄位的 `Databases` 下選擇 `Tables`。

    ![](images/img_02.png)

<br>

3. 選擇使用爬網程式添加表格 `Add tables using crawler`。

    ![](images/img_03.png)

<br>

4. 在 `Name` 命名為 `Weather`，其餘按預設即可，點擊下方的 `Next`。

    ![](images/img_04.png)

<br>

5. 點擊添加數據源 `Add a data source`

    ![](images/img_05.png)

<br>

6. `Data source` 使用預設的 `S3`，`Location of S3 data` 選擇 `In a different account`。

    ![](images/img_06.png)

<br>

7. `S3 path` 輸入以下公開資料集的 `S3 Bucket`。

    ```bash
    s3://noaa-ghcn-pds/csv/by_year/
    ```

    ![](images/img_07.png)

<br>

8. `Subsequent crawler runs` 使用預設的 `Crawl all sub-folders` 爬網所有子文件夾；然後點擊右下角 `Add an S3 data source`。

    ![](images/img_08.png)

<br>

9. 接下來這個頁面 `Choose data sources and classifiers`，選擇 `Next`。

    ![](images/img_09.png)

<br>

10. 在 `Existing IAM role` 中，選擇 `gluelab`。

    ![](images/img_10.png)

<br>

## 關於 Role

1. 特別說明，這個 Role 是在 Lab 中已經預設並提供使用的，詳細內容可前往 `CloudFormation` 查看，進入後點擊 `Stack details`，選擇對應的 Stack，並切換到 `Template` 頁籤就可查看。

    ![](images/img_11.png)

<br>

## 回到 Glue

1. 點擊 `Next` 後會進入 `Set output and scheduling`，選擇 `Add database`；會自動開啟新的頁面。

    ![](images/img_12.png)

<br>

2. 在新開啟的頁面中，為資料庫命名 `weatherdata`，然後點擊 `Create database`。

    ![](images/img_13.png)

<br>

3. 會自動回到 Databases 清單中，可看到建立的資料庫 ``。

    ![](images/img_34.png)

<br>

## 返回 `Set output and scheduling`

_手動切換頁面到前面步驟的畫面中_

<br>

1. 返回頁面中，可先手動刷新頁面。

    ![](images/img_14.png)

<br>

2. 下拉 `Target database` 選單，選擇前面步驟建立的 `weatherdata` 資料庫作為目標資料庫。

    ![](images/img_15.png)

<br>

3. 在最下方的 `Crawler schedule` 區塊，將 `Frequency` 保留預設的 `On demand`；然後點擊 `Next`。

    ![](images/img_16.png)

<br>

4. 可瀏覽一下爬網程式相關配置，確認無誤後點擊 `Create crawler`。

    ![](images/img_17.png)

<br>

## 運行爬網程式

1. 在 `Weather` 頁面中，可點擊 `Run crawler` 啟動爬往程式。

    ![](images/img_35.png)

<br>

2. 或是在 `Crawlers` 頁面中，選擇剛建立的 `Weather` 爬網程式，然後點擊 `Run`。

    ![](images/img_18.png)

<br>

3. 運行時爬網程式的狀態會更改為 `Running`，這個過程約耗時三分鐘。

    ![](images/img_19.png)

<br>

4. 可點擊 `Crawlers` 回到清單中。

    ![](images/img_36.png)

<br>

5. 過程中還會顯示 `Stopping` 不用擔心，完成時狀態會變更為 `Ready`。

    ![](images/img_20.png)

<br>

## 查看 AWS Glue 建立的元數據

1. 在左側欄中選擇 `Databases`，接著點擊 `weatherdata` 資料庫。

    ![](images/img_21.png)

<br>

2. 在 `Tables` 部分，點擊 `by_year`。

    ![](images/img_22.png)

<br>

3. 查看爬網程式捕獲的元數據，在下方的 `Schema` 頁籤中會顯示檢測到的欄位。

    ![](images/img_23.png)

<br>

## 編輯表格結構

1. 展開頁面右上角的 `Actions`，選擇 `Edit schema`。

    ![](images/img_24.png)

<br>

2. 或直接在 `Schema` 區塊點擊右上角的 `Edit schema`。

    ![](images/img_37.png)

<br>

3. 除此，若要更快速修正，可直接點擊 `Edit schema as JSON` 編輯 JSON 文件。

    ![](images/img_38.png)

<br>

4. 修改欄位名稱，根據以下指示進行修改：`id -> station`、`date` 不變、`element -> type`、`data_value -> observation`；剩餘項目將字串中的底線 `_` 刪除：`m_flag -> mflag`、`q_flag -> qflag`、`s_flag -> sflag`、`obs_time -> time`；特別注意，AWS Glue 只支持小寫的列名稱，完成時點擊 `Save as new table version`。

    ![](images/img_39.png)

<br>

5. 修改完成如下。

    ![](images/img_25.png)

<br>

___

_END_