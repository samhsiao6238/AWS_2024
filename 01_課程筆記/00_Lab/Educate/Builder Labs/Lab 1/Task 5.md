# Task 5: 將 `generateHTML` Lambda 函數加入狀態機器

在此任務中，將測試一個生成 HTML 報告的 Lambda 函數。此報告包含一個類似於 JSON 文檔的 JavaScript 對象數據。該函數會將結果文件寫入 Amazon S3 並覆蓋現有的 `report.html` 文件。完成測試後，將此 Lambda 函數新增至 Step Functions 狀態機器中，並與之前的 `GeneratePresignedURL` Lambda 函數並行運行，以提高狀態機器的執行效率。

## 測試 `generateHTML` Lambda 函數

### 查看並檢查 Lambda 函數的 IAM 角色
1. 打開 AWS 管理控制台，從服務列表中選擇 Lambda。
2. 搜索並選擇名為 `generateHTML` 的 Lambda 函數。
3. 在函數界面，選擇 Configuration（配置）標籤。
4. 選擇 Permissions（權限），在 Execution Role（執行角色）下確認該函數使用的是 RoleForAllLambdas 角色。
   - 此角色允許 Lambda 函數與 Amazon S3、SNS 和 DynamoDB 進行交互，這與 `GeneratePresignedURL` 函數使用的角色相同。

### 測試 `generateHTML` Lambda 函數
1. 進入 Code（代碼）標籤，然後選擇 Test（測試）。
2. 在 Event name（事件名稱）欄位中輸入 `test2`。
3. 複製以下 JSON 代碼作為測試事件的輸入，並替換現有內容：
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
4. 選擇 Save（保存），然後再次選擇 Test 以運行函數。
5. 執行結果應返回如下 JSON 響應：
   ```json
   {
     "msg_str": "Report published to S3"
   }
   ```
6. 注意：若 Lambda 函數運行成功，會覆蓋 S3 中的 `report.html` 文件。雖無法直接從 S3 控制台打開文件，但可選擇下載 `report.html` 文件，並在本地檢視文件內容。

## 將 `generateHTML` Lambda 函數加入狀態機器

### 新增並行狀態至狀態機器
1. 在 AWS 管理控制台中，搜索並選擇 Step Functions。
2. 選擇 MyStateMachine，然後選擇 Edit（編輯）。
3. 在 States browser 左側窗格中選擇 Flow（流程）標籤。
4. 將 Parallel（並行）對象拖動至 Lambda: Invoke GeneratePresignedURL 對象上方。
5. 將 Lambda: Invoke GeneratePresignedURL 對象拖動至並行狀態的右側 Drop state here 區域。

### 新增 `generateHTML` Lambda 函數至狀態機器
1. 在左側窗格中選擇 Actions（操作）標籤，搜索 Lambda。
2. 將 AWS Lambda Invoke 對象拖動至並行狀態的左側 Drop state here 區域。
3. 配置 Lambda Invoke 對象的參數：
   - State name：輸入 `generateHTML`。
   - Function name：選擇 `generateHTML:$LATEST`。
   - Payload：選擇 Use state input as payload。
   - Next state：選擇 Go to end。
4. 保存更改，並在畫布上選擇並行狀態對象，將 State name 設為 `Process Report`。

### 更新 SNS Publish 對象的消息格式
1. 進入 Code 模式，找到靠近代碼底部的 `"Message.$": "$.presigned_url_str"` 行。
2. 將該行的值 `$"presigned_url_str"` 替換為 `$`，以允許將 `generateHTML` 和 `GeneratePresignedURL` 狀態的數據一併傳遞至 SNS Publish 狀態。
3. 更新後的代碼應如下：
   ```json
   "SNS Publish": {
     "Type": "Task",
     "Resource": "arn:aws:states:::sns:publish",
     "Parameters": {
       "Message.$": "$",
       "TopicArn": "arn:aws:sns:us-east-1:1234567890:EmailReport"
     },
     "End": true
   }
   ```
4. 選擇 Save 保存變更。

### 測試更新後的狀態機器
1. 選擇 Start execution 並配置以下選項：
   - Type：選擇 Synchronous（同步）。
2. 在代碼編輯器中，將現有 JSON 代碼替換為以下內容：
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
3. 選擇 Start execution，並檢查電子郵件中的通知。
   - 電子郵件內容應包含兩個鍵值對：`msg_str` 和 `presigned_url`。
   - `msg_str` 是來自 `generateHTML` 狀態的數據，而 `presigned_url` 則是來自 `GeneratePresignedURL` 狀態。

此任務順利完成後，您應成功將 `generateHTML` Lambda 函數並行加入狀態機器並進行測試。