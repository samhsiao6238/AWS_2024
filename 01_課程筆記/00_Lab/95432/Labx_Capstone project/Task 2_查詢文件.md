# Task 2：查詢文件

_配置 AWS Glue Crawler 來探索數據的結構，然後使用 Athena 查詢這些數據。_

<br>

## 查看文件的數據內容

_`head -6 SAU-GLOBAL-1-v48-0.csv` 及 `SAU-HighSeas-71-v48-0.csv`_

<br>

1. 使用 `head` 命令查看該 CSV 文件的列標題和前幾行數據；`SAU-HighSeas-71-v48-0.csv` 文件包含了 `SAU-GLOBAL-1-v48-0.csv` 文件所有的欄位，另外還有其他額外的欄位。

    ```bash
    head -6 SAU-GLOBAL-1-v48-0.csv
    head -6 SAU-HighSeas-71-v48-0.csv
    ```

<br>

2. 數據集 `SAU-HighSeas-71-v48-0` 描述在名為 `Pacific, Western Central` 的高海域中的魚類捕撈數據；在這個數據集中特別值得關注的兩個額外欄位是 `area_name` 與 `common_name`； `area_name` 欄位在每一行中都包含 `Pacific, Western Central` 的值，`common_name` 欄位則描述某些類型的魚類，例如 `鯖魚`、`金槍魚`、`鰹魚`。

<br>

## 再次轉換

_運行與之前相同模式，將 `SAU-HighSeas-71-v48-0.csv` 文件轉換為 `Parquet` 格式並上傳至 `data-source Bucket`_

<br>

1. 啟用虛擬環境。

    ```bash
    source envCapstone/bin/activate
    ```

<br>

2. 開啟 Python 交互式終端。

    ```bash
    python3
    ```

<br>

3. 使用以下 Python 代碼將 CSV 文件轉換為 Parquet 格式。

    ```bash
    import pandas as pd
    df = pd.read_csv('SAU-HighSeas-71-v48-0.csv')
    df.to_parquet('SAU-HighSeas-71-v48-0.parquet')
    ```

<br>

4. 退出交互式終端。

    ```bash
    exit()
    ```

<br>

5. 關閉虛擬環境。

    ```bash
    deactivate
    ```

<br>

6. 上傳 S3。

    ```bash
    aws s3 cp SAU-HighSeas-71-v48-0.parquet s3://data-source-99991
    ```

<br>

7. 前往 S3 查看。

    ![](images/img_16.png)

<br>

## 建立 AWS Glue 資料庫與 Crawler

1. 進入 Glue 並點擊 Databases。

    ![](images/img_17.png)

<br>

2. 建立 AWS Glue 資料庫。

    ![](images/img_18.png)

<br>

3. 命名 `fishdb`，點擊右下角建立。

    ![](images/img_19.png)

<br>

4. 進入 Crawler，並點擊建立。

    ![](images/img_20.png)

<br>

5. 命名 `fishcrawler` 並點擊 `Next`。

    ![](images/img_21.png)

<br>

6. 點擊 `Add a data source`。

    ![](images/img_22.png)

<br>

7. 點擊 `Browse S3`。

    ![](images/img_23.png)

<br>

8. 選取前綴為 `data-source` 的 Bucket。

    ![](images/img_24.png)

<br>

9. 在路徑中輸入 `/`。

    ![](images/img_25.png)

<br>

10. 點擊右下角 `add`。

    ![](images/img_26.png)

<br>

11. 點擊 `Next`。

    ![](images/img_27.png)

<br>

12. 使用教程預設的角色 `CapstoneGlueRole`；其餘無需設定，點擊 `Next`。

    ![](images/img_28.png)

<br>

13. 目標資料庫選取 `fishdb`，爬取頻率使用預設的 `On Demand`，點擊 `Next`。

    ![](images/img_29.png)

<br>

14. 點擊 `Create`。

    ![](images/img_30.png)

<br>

## 運行 Crawler 以在 AWS Glue 資料庫中建立包含元數據的表

1. 選取並運行 Crawler；過程中會顯示 `Running`，稍等片刻。

    ![](images/img_31.png)

<br>

2. 完成時，進入 Tables 確認成功建立了。

    ![](images/img_32.png)

<br>

3. 點擊進入可查看該表將所爬取數據的結構和元數據；所謂 `元數據（Metadata）` 是關於數據的描述或資訊，用來定義數據的結構和屬性，所以元數據通常指的是數據的結構，而不是實際的數據內容。

    ![](images/img_33.png)

<br>

## 使用 Athena 查詢新表中的數據

1. 進入 `Athena` 並點擊 `Query Editor`，切換到 `Settings` 頁籤，並點擊 `Manage`。

    ![](images/img_34.png)

<br>

2. 點擊 `Browse S3`，選取 `query-results-99991`，然後點擊 `Choose`；返回設定頁面後，點擊右下角 `Save`。

    ![](images/img_35.png)

<br>

3. 切換回到 `Editor` 頁籤，可直接使用以下範例查詢，名稱部分依照自己的命名替換，點擊 `Run`。

    ```sql
    SELECT DISTINCT area_name FROM fishdb.data_source_99991;
    ```

<br>

4. 此查詢將返回兩個結果，對於來自 `SAU-GLOBAL-1-v48-0.parquet` 的行，`area_name` 為 `null`；對於來自 `SAU-HighSeas-71-v48-0.parquet` 的行，`area_name` 為 `Pacific, Western Central`。

    ![](images/img_36.png)

<br>

## 查詢特定數據

1. 要查詢自 `2001 年` 以來，`Fiji` 在 `Pacific, Western Central` 高海域中的魚類捕撈價值（以美元計算），並按年分組，可使用以下 SQL 查詢；這裡使用了 `CAST` 函數來將捕撈價值 (`landed_value`) 的顯示格式轉換為便於閱讀的美元格式。

    ```sql
    SELECT year, fishing_entity AS Country, 
          CAST(CAST(SUM(landed_value) AS DOUBLE) AS DECIMAL(38,2)) AS ValuePacificWCSeasCatch
    FROM fishdb.data_source_99991
    WHERE area_name LIKE '%Pacific%' 
      AND fishing_entity='Fiji' 
      AND year > 2001
    GROUP BY year, fishing_entity
    ORDER By year;
    ```

    ![](images/img_37.png)

<br>

## 挑戰任務

_查詢 Fiji 在所有高海域的魚類捕撈總價值_

<br>

1. 搜尋自 `2001 年` 以來 `Fiji` 在所有高海域的捕撈價值，並將美元值欄位命名為 `ValueAllHighSeasCatch`；`area_name IS NULL` 使用 `IS NULL` 表示搜尋不屬於任何國家的高海域資料，`fishing_entity = 'Fiji'` 過濾出來自 `Fiji` 的捕撈數據，`year > 2000` 過濾自 `2001 年` 以來的數據，`CAST` 將捕撈價值轉換為讀者友好的格式，以兩位小數顯示。

    ```sql
    SELECT 
        year, 
        fishing_entity AS Country, 
        CAST(CAST(SUM(landed_value) AS DOUBLE) AS DECIMAL(38,2)) AS ValueAllHighSeasCatch
    FROM 
        fishdb.data_source_99991
    WHERE 
        area_name IS NULL 
        AND fishing_entity = 'Fiji' 
        AND year > 2000
    GROUP BY 
        year, 
        fishing_entity
    ORDER BY 
        year;
    ```

    ![](images/img_38.png)

<br>

## 建立視圖

1. 展開 `Create` 並選取 `View from query`。

    ![](images/img_39.png)

<br>

2. 將視圖命名為 `challenge`，然後點擊 `Create`。

    ![](images/img_40.png)

<br>

3. 左側可看到 `Views` 中添加了 `challenge`。

    ![](images/img_41.png) 

<br>

___

_END_