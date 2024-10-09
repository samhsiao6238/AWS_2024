# Task 2：使用 AWS Glue Crawler 搭配 Athena 查詢多個文件

_配置 AWS Glue Crawler 來發現數據的結構，然後使用 Athena 查詢這些數據。_

## 查看 SAU-HighSeas-71-v48-0.csv 文件的數據

1. 使用 `head` 命令查看該 CSV 文件的列標題和前幾行數據。該文件已經下載至 AWS Cloud9 IDE。

2. SAU-HighSeas-71-v48-0.csv 文件與 SAU-GLOBAL-1-v48-0.csv 文件具有相同的列，但還包含一些額外的列。

3. 數據分析，SAU-HighSeas-71-v48-0 數據集描述了在名為「Pacific, Western Central」的高海域中的魚類捕撈數據。

4. 該數據集中特別值得關注的兩個額外列是：`area_name` 列，該列在每一行中都包含「Pacific, Western Central」的值，`common_name` 列，該列描述了某些類型的魚類（例如「鯖魚、金槍魚、鰹魚」）。



## 將 SAU-HighSeas-71-v48-0.csv 文件轉換為 Parquet 格式並上傳至 data-source Bucket 

運行與之前相似的步驟，使用 pandas 將文件轉換為 Parquet 格式，並將其上傳到 S3 的 data-source Bucket 。



## 建立 AWS Glue 資料庫與 Crawler

1. 建立 AWS Glue 資料庫，命名 `fishdb`。

2. 建立 AWS Glue Crawler，命名 `fishcrawler`，使用 CapstoneGlueRole IAM 角色來爬取 S3 Bucket `data-source` 的內容。
   - 將爬取結果輸出至 `fishdb` 資料庫。
   - 爬取頻率：設置為「按需」運行。



#### 運行 Crawler 以在 AWS Glue 資料庫中建立包含元數據的表

運行 Crawler，驗證是否成功建立了期望的表。該表將包含所爬取數據的結構和元數據。

---

#### 使用 Athena 查詢新表中的數據

在進行查詢之前，配置 Athena Query Editor 將數據輸出至 `query-results` Bucket 。

範例查詢：
```sql
SELECT DISTINCT area_name FROM fishdb.data_source_xxxxx;
```
此查詢將返回兩個結果：
- 對於來自 `SAU-HighSeas-71-v48-0.parquet` 的行，`area_name` 為「Pacific, Western Central」。
- 對於來自 `SAU-GLOBAL-1-v48-0.parquet` 的行，`area_name` 為 `null`。

---

#### 查詢特定數據

要查詢自 2001 年以來，Fiji 在「Pacific, Western Central」高海域中的魚類捕撈價值（以美元計算），並按年分組，您可以使用以下 SQL 查詢：

```sql
SELECT year, fishing_entity AS Country, 
       CAST(CAST(SUM(landed_value) AS DOUBLE) AS DECIMAL(38,2)) AS ValuePacificWCSeasCatch
FROM fishdb.data_source_xxxxx
WHERE area_name LIKE '%Pacific%' 
  AND fishing_entity='Fiji' 
  AND year > 2001
GROUP BY year, fishing_entity
ORDER By year;
```

這裡使用了 `CAST` 函數來將捕撈價值 (`landed_value`) 的顯示格式轉換為便於閱讀的美元格式。

---

#### 挑戰任務：查詢 Fiji 在所有高海域的魚類捕撈總價值

要完成此挑戰，請編寫查詢以查找自 2001 年以來 Fiji 在所有高海域的捕撈價值，並將美元值列命名為 `ValueAllHighSeasCatch`。

提示：
- 使用 `WHERE` 子句中的兩個 `AND` 關鍵詞。
- 對於不包含特定列條目的行，可以使用 `IS NULL`。

完成查詢後，您可以根據查詢建立視圖：

1. 選擇 `Create > View from query`。
2. 將視圖命名為 `challenge`。