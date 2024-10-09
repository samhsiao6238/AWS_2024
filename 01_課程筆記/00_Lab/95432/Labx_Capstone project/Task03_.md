# Task 3：轉換新的文件並將其添加至資料集

在 Capstone 專案的這一部分，您將把 SAU-EEZ-242-v48-0.csv 數據文件添加到 Amazon S3 的資料集中。

---

#### 分析 SAU-EEZ-242-v48-0.csv 文件的數據結構

比較該文件中的列與之前已上傳到 S3 的其他數據文件的列。使用與之前相同的方法來發現 EEZ 文件的列名稱。

提示：  
大部分的列名稱在三個文件中是一致的，但有兩個列名稱在 EEZ 文件中並不完全匹配。需要對這兩個列名稱進行修改，才能將其與現有的數據對齊。具體來說：
- `fish_name` 列需要與 HighSeas 數據集中的 `common_name` 列合併。
- `country` 列需要與 HighSeas 數據集中的 `fishing_entity` 列合併。

---

#### 使用 pandas 修正列名稱並轉換文件格式

使用 Python 的 pandas 庫來更改列名稱，並將 EEZ 文件轉換為 Parquet 格式。以下是所需的步驟代碼：

1. 備份原始文件：
   ```bash
   cp SAU-EEZ-242-v48-0.csv SAU-EEZ-242-v48-0-old.csv
   ```

2. 運行 Python 交互式 shell：
   ```python
   python3
   ```

3. 加載並修改數據：
   ```python
   import pandas as pd
   
   # 加載 CSV 文件
   data_location = 'SAU-EEZ-242-v48-0-old.csv'
   df = pd.read_csv(data_location)

   # 查看當前的列名稱
   print(df.head(1))

   # 修改列名稱，將 <FMI_1> 替換為具體的列名稱
   df.rename(columns={"<FMI_1>": "<FMI_2>", "<FMI_3>": "<FMI_4>"}, inplace=True)

   # 驗證列名稱是否已更改
   print(df.head(1))

   # 保存修改後的 CSV 文件
   df.to_csv('SAU-EEZ-242-v48-0.csv', header=True, index=False)

   # 將文件轉換為 Parquet 格式
   df.to_parquet('SAU-EEZ-242-v48-0.parquet')

   exit()
   ```

---

#### 將新的 EEZ 數據文件上傳至 S3

將更新後的 CSV 文件和 Parquet 文件上傳到 S3 的 data-source Bucket 。

---

#### 更新 AWS Glue 表的元數據

運行 AWS Glue Crawler 以更新表的元數據，這將包括現在添加的新列。

---

#### 使用 Athena 查詢更新後的數據集

1. 驗證 area_name 列的值：
   ```sql
   SELECT DISTINCT area_name FROM fishdb.data_source_#####;
   ```

2. 查詢 Fiji 在公海中的魚類捕撈價值（自 2001 年以來）：
   ```sql
   SELECT year, fishing_entity AS Country, 
          CAST(CAST(SUM(landed_value) AS DOUBLE) AS DECIMAL(38,2)) AS ValueOpenSeasCatch
   FROM fishdb.data_source_#####
   WHERE area_name IS NULL AND fishing_entity='Fiji' AND year > 2000
   GROUP BY year, fishing_entity
   ORDER BY year;
   ```

3. 查詢 Fiji 在 Fiji EEZ 中的魚類捕撈價值（自 2001 年以來）：
   ```sql
   SELECT year, fishing_entity AS Country, 
          CAST(CAST(SUM(landed_value) AS DOUBLE) AS DECIMAL(38,2)) AS ValueEEZCatch
   FROM fishdb.data_source_#####
   WHERE area_name LIKE '%Fiji%' AND fishing_entity='Fiji' AND year > 2000
   GROUP BY year, fishing_entity
   ORDER BY year;
   ```

4. 查詢 Fiji 在 Fiji EEZ 或公海中的魚類捕撈總價值（自 2001 年以來）：
   ```sql
   SELECT year, fishing_entity AS Country, 
          CAST(CAST(SUM(landed_value) AS DOUBLE) AS DECIMAL(38,2)) AS ValueEEZAndOpenSeasCatch
   FROM fishdb.data_source_#####
   WHERE (area_name LIKE '%Fiji%' OR area_name IS NULL) AND fishing_entity='Fiji' AND year > 2000
   GROUP BY year, fishing_entity
   ORDER BY year;
   ```

分析：  
如果數據格式正確且 AWS Glue Crawler 更新了元數據表，那麼第一個和第二個查詢的結果加起來應等於第三個查詢的結果。這表明您的解決方案工作正常。

---

#### 在 Athena 中建立一個視圖

運行以下查詢來建立視圖，以便更好地查看數據：

```sql
CREATE OR REPLACE VIEW MackerelsCatch AS
SELECT year, area_name AS WhereCaught, fishing_entity AS Country, SUM(tonnes) AS TotalWeight
FROM fishdb.data_source_#####
WHERE common_name LIKE '%Mackerels%' AND year > 2014
GROUP BY year, area_name, fishing_entity, tonnes
ORDER BY tonnes DESC;
```

---

#### 查詢 MackerelsCatch 視圖的數據

1. 查詢每年國家捕撈鯖魚的最大值：
   ```sql
   SELECT year, Country, MAX(TotalWeight) AS Weight
   FROM fishdb.mackerelscatch 
   GROUP BY year, Country
   ORDER BY year, Weight DESC;
   ```

2. 查詢中國的鯖魚捕撈數據：
   ```sql
   SELECT * FROM fishdb.mackerelscatch 
   WHERE Country IN ('China');
   ```

---

#### 提交工作

在完成所有步驟後，記得提交工作並檢查分數。