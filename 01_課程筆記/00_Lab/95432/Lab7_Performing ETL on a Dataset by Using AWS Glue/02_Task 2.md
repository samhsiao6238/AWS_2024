# ETL

_使用 AWS Glue 對數據集進行 ETL 操作_

<br>

## 任務 2，使用 Athena 查詢表格

_已經建立了 `Data Catalog`，可以進一步使用 Athena 來查詢數據_

<br>

1. 配置一個 S3 Bucket來存儲 Athena 查詢結果。

<br>

2. 在 Athena 中預覽資料庫表格。

<br>

3. 為 1950 年之後的數據建立一個表格。

<br>

4. 對選定數據運行查詢。

<br>

## 配置 S3 Bucket來存儲 Athena 查詢結果

1. 在左側欄中的 `atabases` 下點擊 `Tables`；然後點擊進入 `by_year`。

    ![](images/img_26.png)

<br>

2. 展開右上角的 `Actions` 並選擇 `View data`。

    ![](images/img_27.png)

<br>

3. 出現彈窗警告將被重定向至 `Athena` 控制台，點擊 `Proceed` 前往，這時會開啟新的網頁頁籤。

    ![](images/img_28.png)

<br>

4. 在新開啟的 `Athena` 主控台中，切換頁籤到 `Settings`，然後點擊 `Manage`。

    ![](images/img_29.png)

<br>

5. 點擊 `Location of query result - optional` 右側的 `Browse S3`。

    ![](images/img_30.png)

<br>

6. 勾選名稱前綴為 `data-science-bucket-XXXXXX` 的 Bucket，切勿選擇前綴為 `glue-1950-bucket` 的 Bucket；然後點擊右下方 `Choose`。

    ![](images/img_31.png)

<br>

7. 保留其他預設的設置，然後點擊右下角的 `Save`。

    ![](images/img_32.png)

<br>

## 在 Athena 中預覽表格

1. 切換頁籤為 `Editor`，在 `Data` 區塊中，確認 `Data source` 為 `AwsDataCatalog`、`Database` 為 `weatherdata`；確認後，點擊 `Tables` 內 `by_year` 右側的三點圖標展開選單，點擊其中的 `Preview Table`；如需查看該表格中的列名稱及其數據類型，可選擇表格名稱左側的圖標。

    ![](images/img_33.png)

<br>

2. 第一頁會顯示來自 `weatherdata` 表格的前 10 條記錄，注意運行時間和查詢掃描的數據量，在開發應用程式時，減少資源消耗來優化成本是很重要的。

    ```sql
    SELECT * FROM "weatherdata"."by_year" limit 10;
    ```

<br>

## 為 1950 年之後的數據建立表格

1. 首先，需要檢索預設建立的存儲數據的 S3 Bucket名稱。

<br>

2. 在 AWS 管理控制台中的搜索框旁輸入 `S3` 並選擇 S3 服務。

<br>

3. 在Bucket列表中，將包含 `glue-1950-bucket` 的 Bucket 名稱複製到選擇的文本編輯器中。

<br>

4. 返回 Athena 查詢編輯器。

<br>

5. 將以下查詢複製並粘貼到編輯器的查詢標籤中。將 `<glue-1950-bucket>` 替換為你之前記錄的Bucket名稱：

    ```sql
    CREATE table weatherdata.late20th
    WITH (
        format='PARQUET',
        external_location='s3://<glue-1950-bucket>/lab3'
    ) AS SELECT date, type, observation 
    FROM by_year
    WHERE date/10000 BETWEEN 1950 AND 2015;
    ```

<br>

6. 選擇 `Run`，運行時間和掃描數據的大小類似如下。

    ```bash
    排隊時間：128 毫秒
    運行時間：1 分鐘 8.324 秒
    掃描數據量：98.44 GB
    ```

<br>

7. 如需預覽結果，在 `late20th` 表格旁邊選擇三點圖標，然後選擇 `Preview Table`。

<br>

## 對新表格運行查詢

1. 首先，建立一個僅包含最大溫度讀數（`TMAX`）值的視圖。

<br>

2. 在新查詢標籤中運行以下查詢。

    ```sql
    CREATE VIEW TMAX AS
    SELECT date, observation, type
    FROM late20th
    WHERE type = 'TMAX';
    ```

<br>

3. 如需預覽結果，在 `tmax` 視圖旁邊選擇三點圖標，然後選擇 `Preview View`。

<br>

4. 在新的查詢標籤中運行以下查詢，該查詢的目的是計算每年數據集中平均最高溫度。

    ```sql
    SELECT date/10000 as Year, avg(observation)/10 as Max
    FROM tmax
    GROUP BY date/10000
    ORDER BY date/10000;
    ```

<br>

5. 查詢運行完成後，運行時間和掃描的數據大小類似如下。

    ```bash
    排隊時間：0.211 秒
    運行時間：25.109 秒
    掃描數據量：2.45 GB
    ```

<br>

6. 結果顯示了 1950 年到 2015 年間的每年平均最高溫度。

<br>

___

_END_