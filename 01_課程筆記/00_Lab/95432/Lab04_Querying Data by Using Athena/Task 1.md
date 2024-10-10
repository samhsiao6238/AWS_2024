# Task 1：建立並查詢 AWS Glue 資料庫與表格

_進入 Lab 之後_

<br>

## 步驟說明

1. 進入主控台搜尋並進入 `Athena`。

    ![](images/img_01.png)

<br>

2. 啟動查詢編輯器。

    ![](images/img_02.png)

<br>

3. 或展開選單，點擊 `Query editor` 進入。

    ![](images/img_22.png)

<br>

4. 切換到 `Settings` 頁籤，會看到當前所在是 `Query result and encryption settings`，點擊右側的 `Manage`。

    ![](images/img_03.png)

<br>

4. 在 `Location of query result` 選擇 `Browse S3`。

    ![](images/img_04.png)

<br>

5. 選取預設的 `S3 Bucket`，點擊右下角 `Choose`。

    ![](images/img_05.png)

<br>

6. 這個頁面其他部分使用預設值即可，點擊 `Save`。

    ![](images/img_06.png)

<br>

## 建立 `Glue` 資料庫

1. 切換頁籤到 `Editor`。

    ![](images/img_07.png)

<br>

2. 在 `Athena` 查詢編輯器中，輸入以下 SQL 指令建立資料庫，點擊下方的 `Run` 執行指令。

    ```sql
    CREATE DATABASE taxidata;
    ```

    ![](images/img_08.png)

<br>

3. 完成後，下方會顯示完成、成功等資訊。

    ![](images/img_23.png)

<br>

## 查看

_使用另一個服務 AWS Glue，這裡只是簡單示範如何查看，不細說功能。_

<br>

1. 搜尋並進入 `Glue`。

    ![](images/img_09.png)

<br>

2. 點擊左側欄中的 `Databases`，接著可在右側 `Databases` 清單中看到前面步驟建立的資料庫 `taxidata`。

    ![](images/img_10.png)

<br>

## 建立 Glue 表格

_回到 Athena_

<br>

1. 在左側 `Tables and views` 區塊中，展開選單 `Create` 並點擊 `S3 bucket data`。

    ![](images/img_11.png)

<br>

2. 設定 `表格名稱 (Table name)` 為 `yellow`，`描述 (Description)` 為 `Table for taxi data`；在 `Database configuration` 部分，下拉選單後點擊前面建立的 `taxidata` 資料庫。

    ![](images/img_12.png)

<br>

3. 輸入 S3 資料位置 `Location of input data set`，並勾選下方的 `I acknowledge ...`；這個路徑是 Lab 環境中固定的數據位置，包含預先準備好的數據集，提供在 Lab 中使用，通過這個路徑來指向該數據，以便在 Athena 表格中查詢；其中 `aws-tc-largeobjects` 是 Bucket 的名稱，而 `CUR-TF-200-ACDSCI-1` 是 Bucket 下的資料夾名稱，`Lab2` 是 Lab 名稱，`yellow` 則是自訂的 table 名稱。

    ```
    s3://aws-tc-largeobjects/CUR-TF-200-ACDSCI-1/Lab2/yellow/
    ```

    ![](images/img_13.png)

<br>

4. 在選擇數據格式 `Data format` 項目下的 `File format` 為 `CSV`。

    ![](images/img_14.png)

<br>

5. 在 `Column details` 部分，點擊 `Bulk add columns` 進行快速添加欄位名稱與類型。

    ![](images/img_15.png)

<br>

6. 在彈窗中輸入以下內容，這是快速添加 `metadata` 的方法；稍作觀察可發現，輸入的並非是資料庫語法，而是欄位與其數據格式。

    ```bash
    vendor string,
    pickup timestamp,
    dropoff timestamp,
    count int,
    distance int,
    ratecode string,
    storeflag string,
    pulocid string,
    dolocid string,
    paytype string,
    fare decimal,
    extra decimal,
    mta_tax decimal,
    tip decimal,
    tolls decimal,
    surcharge decimal,
    total decimal
    ```

<br>

8. 完成後點擊 `Add`。

    ![](images/img_16.png)

<br>

9. 可在 `Preview table query` 進行語法的預覽，這才是寫入前面欄位數據的語法；然後點擊右下角 `Create Table`；至此完成建立 Glue 資料庫與表格，並導入了 Lab 預設儲存在 S3 的數據。

    ![](images/img_17.png)

<br>

## 在 Glue table 預覽

1. 在左側 ` Data` 區塊，先點擊刷新圖標。

    ![](images/img_18.png)

<br>

2. 確認 `Database` 是 `taxidata`，然後 `Tables` 是 `yellow`；點擊 `yellow` 尾部的三個點來展開選單，點擊 `Preview Table`。

    ![](images/img_19.png)

<br>

3. 此時在 `Query` 視窗中會自動顯示以下語法；這條查詢會從資料庫 `taxidata` 中的 `yellow` 表格中選取所有欄位，並僅返回最多 10 筆資料，可藉此檢查表格中的數據樣本。

    ```sql
    SELECT * FROM "taxidata"."yellow" limit 10;
    ```

<br>

4. 點擊 `Run` 之後，在下方的 `Results` 會顯示前十筆資料。

    ![](images/img_20.png)

<br>

5. 可點擊個別查詢頁籤右側的 `X` 來關閉查詢。

    ![](images/img_21.png)

<br>

6. 彈窗中再次點擊 `Close query`。

    ![](images/img_24.png)

<br>

___

_END_