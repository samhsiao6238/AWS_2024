# Task 6: 將 `getRealData` Lambda 函數加入狀態機器

在這個任務中，將測試一個名為 `getRealData` 的 Lambda 函數，此函數從 DynamoDB 表中檢索鳥類觀察記錄，並將其以 JSON 格式返回。接著，將此 Lambda 函數新增至 Step Functions 狀態機器，以便 `generateHTML` 狀態使用真實的資料庫數據來生成 HTML 報告，而不再使用模擬的測試數據。

## 測試 `getRealData` Lambda 函數

### 查看並檢查 Lambda 函數的 IAM 角色

1. 登錄 AWS 管理控制台，從服務列表中選擇 Lambda。
2. 搜尋並選擇名為 `getRealData` 的 Lambda 函數。
3. 選擇 Configuration（配置）標籤。
4. 選擇 Permissions（權限），在 Execution Role（執行角色）下確認此函數使用的是 RoleForAllLambdas 角色。
   - 該角色允許 Lambda 函數與 Amazon S3、SNS 以及 DynamoDB 進行交互，與 `GeneratePresignedURL` 函數使用的角色相同。

### 測試 `getRealData` Lambda 函數

1. 進入 Code（代碼）標籤，然後選擇 Test（測試）。
2. 在 Event name（事件名稱）欄位中輸入 `test3`。
3. 輸入以下空的 JSON 請求作為測試事件的輸入：
   ```json
   {
   }
   ```
4. 選擇 Save（保存），然後再次選擇 Test 以運行函數。
5. 檢查 Execution results（執行結果）標籤，應顯示類似如下的輸出：
   ```json
   {
     "bird_obj_arr": [
       {
         "class_level_str": "3rd Grade",
         "location_str": "Home",
         "bird_name_str": "Northern Cardinal",
         "student_name_str": "Maria Garcia",
         "date_str": "2-21-2022",
         "id_str": "373453bd-722d-454f-8b4b-1ec53e2df9b0",
         "count_int": 2
       },
       {
         "class_level_str": "3rd Grade",
         "location_str": "Home",
         "bird_name_str": "Baltimore Oriole",
         "student_name_str": "Li Juan",
         "date_str": "12-20-2021",
         "id_str": "bd6560ac-ee19-4ef4-ac73-8deb61520601",
         "count_int": 1
       },
       {
         "class_level_str": "3rd Grade",
         "location_str": "Lake",
         "bird_name_str": "American Kestrel",
         "student_name_str": "Jorge Souza",
         "date_str": "01-30-2022",
         "id_str": "591d0b66-87ba-4e15-aadf-b0db6e63f089",
         "count_int": 5
       }
     ]
   }
   ```

## 將 `getRealData` Lambda 函數加入狀態機器

### 更新狀態機器以包含 `getRealData` Lambda 函數

1. 登錄 AWS 管理控制台，從服務列表中選擇 Step Functions。
2. 選擇 MyStateMachine，然後選擇 Edit（編輯）。
3. 在左側的 States browser（狀態瀏覽器）中，搜尋 Lambda。
4. 將 AWS Lambda Invoke 對象拖放至並行狀態 `Process Report` 之上的畫布區域。

### 配置 `getRealData` Lambda 函數的調用參數

1. 在 Lambda Invoke 窗格中配置以下參數：
   - State name：輸入 `getRealData`。
   - Function name：選擇 `getRealData:$LATEST`。
   - Payload：選擇 No payload。
2. 在右上角選擇 Save（保存）。

### 更新 SNS Publish 對象的消息格式

1. 進入 Code 模式，找到接近 JSON 文檔底部的 `"Message.$": "$"` 行（大約在第 89 行）。
2. 使用 ASL 內置函數 `States.Format` 來格式化 SNS 消息文本，將其替換為以下內容：
   ```json
   "Message.$": "States.Format('The report has completed successfully! Here is your secure URL:\\n\\n{}', $[1].presigned_url_str)"
   ```
3. 更新後的代碼應如下：
   ```json
   "SNS Publish": {
     "Type": "Task",
     "Resource": "arn:aws:states:::sns:publish",
     "Parameters": {
       "Message.$": "States.Format('The report has completed successfully! Here is your secure URL:\\n\\n{}', $[1].presigned_url_str)",
       "TopicArn": "arn:aws:sns:us-east-1:1234567890:EmailReport"
     },
     "End": true
   }
   ```
4. 選擇 Save 保存更改，並在 IAM 角色彈出窗口中選擇 Save anyway（仍然保存）。

### 測試更新後的狀態機器

1. 在 Step Functions 控制台中選擇 Execute（執行），並配置以下選項：
   - Type：選擇 Synchronous（同步）。
2. 在代碼編輯器中，將現有的 JSON 請求代碼清空，只保留如下格式：
   ```json
   {
   }
   ```
3. 選擇 Start execution 開始執行。
4. 檢查電子郵件中的通知，確認該郵件包含生成的報告的預簽名 URL。

### 故障排除提示

若電子郵件客戶端未能將整個 URL 設置為可點擊的鏈接，請複製電子郵件中的整個 URL，並將其粘貼到瀏覽器標籤中進行測試。

至此，完整的狀態機器應能順利運行，並如預期產生報告並發送預簽名 URL 的電子郵件通知。