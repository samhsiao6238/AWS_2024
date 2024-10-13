### Task 5: 將 generateHTML Lambda 函數加入到狀態機

在此任務中，將測試用於生成 HTML 報告的 Lambda 函數，該函數將生成的報告文件寫入到 S3 Bucket 中。隨後，將把這個 Lambda 函數添加到狀態機的工作流程中，並與之前的 GeneratePresignedURL 函數並行運行，以提高效率。

#### 1. 測試 generateHTML Lambda 函數
1. **查看並測試 generateHTML Lambda 函數**：
   - 打開 AWS 管理控制台，搜尋並選擇 **Lambda** 服務。
   - 選擇名為 `generateHTML` 的函數。
   - 在 **Configuration**（配置）標籤下選擇 **Permissions**（權限），確認該函數使用的角色為 `RoleForAllLambdas`，這與之前的 `GeneratePresignedURL` 函數使用的角色相同。
   - 這個角色允許 Lambda 函數與 Amazon S3、Amazon SNS 以及 DynamoDB 進行互動。

2. **測試 generateHTML Lambda 函數**：
   - 選擇 **Code** 標籤，然後選擇 **Test**。
   - 將事件名稱設為 `test2`，並將以下代碼貼上作為輸入：
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
   - 選擇 **Save**，然後再選擇 **Test**，確認返回的 JSON 消息中顯示：
     ```json
     {
       "msg_str": "Report published to S3"
     }
     ```
   - 這表示 Lambda 函數成功運行並覆蓋了 S3 中的 `report.html` 文件。

#### 2. 將 generateHTML 函數添加到狀態機
1. **編輯狀態機以添加並行狀態**：
   - 返回 **Step Functions** 控制台，選擇 **MyStateMachine**，然後選擇 **Edit**。
   - 在頁面左側的 **Flow** 標籤中，將 **Parallel** 對象拖到 `Lambda: Invoke GeneratePresignedURL` 上方。
   - 將 **Lambda: Invoke GeneratePresignedURL** 拖到 Parallel 狀態的右側區域。
   
2. **添加 generateHTML 函數並配置**：
   - 在左側 **Actions** 標籤下，搜尋 **Lambda**。
   - 將 **AWS Lambda Invoke** 對象拖到 Parallel 狀態的左側區域，並設置以下詳細信息：
     - **State name**：輸入 `generateHTML`。
     - **Function name**：選擇 `generateHTML:$LATEST`。
     - **Payload**：選擇 **Use state input as payload**。
     - **Next state**：選擇 **Go to end**。
   
3. **配置並行狀態的詳細信息**：
   - 選擇 Parallel 狀態對象，並設置 **State name** 為 `Process Report`。

4. **修改 SNS Publish 狀態中的消息設置**：
   - 在早先的步驟中，將 `Message.$` 設為 `$.presigned_url_str`，這是用於測試的。但是現在，希望將來自 `GeneratePresignedURL` 和 `generateHTML` 的數據一併發送給 SNS，故需要將 `Message.$` 恢復為 `$.`。
   - 在 JSON 編輯模式中，找到 `"Message.$": "$.presigned_url_str",`，並將其更改為 `"$"`，如下所示：
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
   - 保存更改。

#### 3. 測試更新後的狀態機
1. **開始執行狀態機**：
   - 選擇 **Start execution**，並將輸入的 JSON 代碼更改為以下內容：
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
   - 選擇 **Start execution** 開始執行，確認電子郵件中包含 `msg_str` 和 `presigned_url` 兩個鍵值對，分別來自 `generateHTML` 和 `GeneratePresignedURL`。

### 總結
在這一任務中，成功測試了 `generateHTML` Lambda 函數，並將其添加到狀態機中與 `GeneratePresignedURL` 函數並行運行。這樣可以加快報告生成和 URL 預簽名過程，並將這些結果通過 SNS 發送給用戶。