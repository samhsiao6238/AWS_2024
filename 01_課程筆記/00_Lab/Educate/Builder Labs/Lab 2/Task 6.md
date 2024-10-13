### Task 6: 為資料表新增全域次要索引 (GSI)

Ms. García 希望每週收到一份報告，該報告只顯示三年級學生過去 7 天內的活動數據。隨著更多年級開始使用此應用程式，四年級學生也在積極新增數據，這使得必須確保報告中只包含三年級學生的資料。為了達到此目標，需要使用全域次要索引 (GSI) 來進行基於年級和日期的查詢。

#### 步驟 1：載入額外數據至資料表

在新增 GSI 之前，先執行以下命令，將額外的數據載入至 `BirdSightings` 資料表。此數據包含一些四年級學生的觀察記錄。

1. 運行以下命令：
   - 打開 AWS Cloud9 IDE 的終端機，並執行以下指令來載入新的數據集：
     ```bash
     cd /home/ec2-user/environment/node_server
     node load_past_sightings_2.js
     ```

2. 確認輸出結果：
   - 終端機的輸出應類似如下內容：
     ```bash
     { PutRequest: { Item: [Object] } },
     { PutRequest: { Item: [Object] } },
     ...
     Added 9 items to DynamoDB
     ```
   - 成功載入了 9 筆記錄至 DynamoDB。

#### 步驟 2：在資料表中建立 GSI

為了能夠依據年級和日期篩選記錄，需在 `BirdSightings` 資料表上新增一個全域次要索引 (GSI)。

1. 進入 DynamoDB 主控台：
   - 返回瀏覽器中已打開的 DynamoDB 主控台標籤。

2. 選擇資料表：
   - 在左側導航窗格中選擇 Tables（資料表）。
   - 點選 BirdSightings 資料表名稱。

3. 建立索引：
   - 選擇 Actions > Create index（動作 > 建立索引）。

4. 配置索引詳情：
   - 在 Index details（索引詳情）區域，配置以下設定：
     - Partition key（分區鍵）：輸入 `class_level_str` 並確保選擇 String。
     - Sort key（排序鍵）：輸入 `date_int` 並確保選擇 Number。
     - Index name（索引名稱）：輸入 `class-date-index`。

5. 建立索引：
   - 選擇 Create index（建立索引）。
   - 記錄下索引名稱、索引分區鍵及排序鍵的資訊，稍後會使用這些資訊進行查詢。

#### 步驟 3：確認索引建立狀態

1. 等待索引完成建立：
   - 索引的建立過程可能需要幾分鐘時間。在繼續下一個任務之前，請確保索引的狀態顯示為 Active（啟用）。

#### 小結

在這個任務中，已成功為 `BirdSightings` 資料表新增了全域次要索引 (GSI)。這個 GSI 使用 `class_level_str` 作為分區鍵，並使用 `date_int` 作為排序鍵，允許依據年級與日期來進行高效的查詢。下一步，將編寫腳本來根據這些條件篩選出報告數據。