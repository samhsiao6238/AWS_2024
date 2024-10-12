# Task 2：建立 DynamoDB 資料表

_為了儲存和動態管理學生的鳥類觀察數據，將會在本任務中建立一個全新的 DynamoDB 資料表。此資料表將使用複合主鍵，包含分區鍵 (Partition Key) 和排序鍵 (Sort Key)。_

<br>

## 配置資料表屬性說明

1. 每個 DynamoDB 資料表都需要一個主鍵，在這個表中，將配置 `複合主鍵`，即同時具備分區鍵與排序鍵。另外配置兩個屬性，第一個屬性為 id，作為資料表的分區鍵。第二個屬性為 student_name_str，作為資料表的排序鍵。

<br>

2. 選擇主鍵時需謹慎，因為一旦資料表建立後，無法更改主鍵屬性；如果需要更改主鍵，必須建立一個新的資料表並將資料遷移過去。

<br>

3. 相關資訊可參閱 [Amazon DynamoDB 開發者指南](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)。

<br>

## 建立 DynamoDB 資料表

1. 搜尋並進入 `DynamoDB`。

<br>

2. 點擊 `Create table`。

<br>

3. 配置以下設定，`Table name` 輸入 `BirdSightings`；`Partition key` 輸入 `id`，並確保選擇 `String`；`Sort key` 輸入 `student_name_str`，並確保選擇 `String`。

<br>

4. 在之前準備的文字檔案中，記錄下資料表名稱、分區鍵及排序鍵，後續任務中將需要這些資訊，資料表名稱為 `BirdSightings`、分區鍵為 `id`、排序鍵 `student_name_str`。

<br>

5. 滾動至頁面底部點擊 `Create table`，等待資料表狀態顯示為 `Active`；這過程可能需要幾秒鐘。

<br>

## 檢查資料表狀態並進行掃描

1. 在 `Tables` 中，選擇剛剛建立的 `BirdSightings` 資料表。

<br>

2. 在左側欄中選擇 `Explore items`，確保 `BirdSightings` 資料表已選取。

<br>

3. 在主視窗中，於 `BirdSightings` 下方展開 `Scan/Query items` 區段，確保選擇 `Scan`，然後點擊 `Run` 執行掃描操作。

<br>

4. 確認結果沒有返回任何記錄，因為該資料表是新的，目前尚未有任何資料。

<br>

___

_END_