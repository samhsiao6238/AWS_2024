### Task 4：將 GeneratePresignedURL Lambda 函數加入到狀態機中

在此任務中，將建立一個 `report.html` 文件並將其上傳到 Amazon S3，然後使用 AWS CLI 建立並測試一個預簽名 URL（presigned URL），確認能夠通過該 URL 訪問報告。接著，將測試一個用來生成預簽名 URL 的 Lambda 函數，並將該函數添加到之前建立的狀態機中。

#### 1. 建立一個範例報告，將其上傳至 Amazon S3，並測試訪問
1. 建立範例 `report.html` 頁面：
   - 返回 AWS Cloud9 IDE。
   - 在 Cloud9 Instance 文件夾中，選擇 File > New File。
   - 在新的文件中貼上以下代碼：
     ```html
     <output>Hello! This is some sample HTML.</output>
     ```
   - 選擇 File > Save，將文件命名為 `report.html`。

2. 上傳範例報告文件到 S3 Bucket：
   - 在 AWS Cloud9 終端中運行以下指令，將文件上傳至 S3 並設置 `cache-control` 為 `max-age=0`：
     ```bash
     cd /home/ec2-user/environment
     bucket=`aws s3api list-buckets --query "Buckets[].Name" | grep s3bucket | tr -d ',' | sed -e 's/"//g' | xargs`
     aws s3 cp report.html s3://$bucket/ --cache-control "max-age=0"
     ```

3. 驗證 Bucket 設定：
   - 在 AWS 管理控制台，選擇 S3 服務並找到上傳的 `report.html` 文件。
   - 在 Permissions（權限）標籤中查看 Bucket Policy，注意以下策略段落：
     ```json
     {
         "Sid": "DenyOneObjectIfRequestNotSigned",
         "Effect": "Deny",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::bucket-name/report.html",
         "Condition": {
             "StringNotEquals": {
                 "s3:authtype": "REST-QUERY-STRING"
             }
         }
     }
     ```

4. 測試訪問範例報告：
   - 在 S3 控制台中，複製 `report.html` 的 Object URL 並在新瀏覽器標籤中打開，應會看到 `AccessDenied` 錯誤，這是由於 Bucket Policy 的限制。

5. 建立並測試預簽名 URL：
   - 在 Cloud9 終端中，運行以下指令生成有效期為 30 秒的預簽名 URL：
     ```bash
     aws s3 presign s3://$bucket/report.html --expires-in 30
     ```
   - 在瀏覽器中打開該 URL，確認能夠在 30 秒內訪問報告。超過 30 秒後，URL 將過期並返回 `AccessDenied` 錯誤。

#### 2. 測試 GeneratePresignedURL Lambda 函數
1. 查看 Lambda 函數的 IAM 角色：
   - 打開 IAM 控制台，搜尋並選擇 RoleForAllLambdas 角色。
   - 在 Permissions 標籤中展開 lambdaPolicyForAllLambdaSteps 政策，確認允許對 Amazon S3、Amazon SNS 和 DynamoDB 執行操作。
   - 在 Trust relationships 標籤中，確認 Lambda 服務可以假設此角色。

2. 測試 GeneratePresignedURL Lambda 函數：
   - 返回 AWS 管理控制台，搜尋並選擇 Lambda 服務。
   - 查找並選擇 GeneratePresignedURL 函數。
   - 選擇 Test，設置 Event name 為 `test1`，並再次點擊 Test。
   - 確認返回的響應中包含預簽名 URL，並在瀏覽器中打開 URL，確認能夠正確加載 `report.html`。

#### 3. 將 GeneratePresignedURL Lambda 函數添加至狀態機
1. 編輯狀態機：
   - 返回 Step Functions 控制台，選擇 MyStateMachine，並點擊 Edit。
   - 在頁面左側的 States 瀏覽器中搜尋 Lambda，並將 AWS Lambda Invoke 對象拖到 SNS Publish 之前。
   
2. 配置 Lambda 調用設置：
   - State name：輸入 `GeneratePresignedURL`。
   - Function name：選擇 `GeneratePresignedURL:$LATEST`。
   - Payload：選擇 No payload。
   - Next state：選擇 SNS Publish。
   - 點擊 Save。

3. 測試更新後的狀態機：
   - 選擇 Execute，並刪除第 2 行中的名稱和值對，只保留空大括號 `{}` 作為輸入。
   - 選擇 Start execution 開始執行狀態機，檢查執行詳情，並確認收到的郵件中包含的預簽名 URL 是否能夠正確打開報告。

#### 總結
在此任務中，成功建立了一個範例報告並將其上傳至 S3，測試了預簽名 URL 功能，並將用於生成預簽名 URL 的 Lambda 函數集成到 Step Functions 狀態機中。這確保了報告只能通過安全的預簽名 URL 訪問。