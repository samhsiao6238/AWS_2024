# Task 4: 在狀態機器中新增 `GeneratePresignedURL` Lambda 函數

在此任務中，將創建一個簡單的 `report.html` 文件並上傳至 Amazon S3，然後透過 AWS CLI 生成並測試一個預簽名 URL。接著，將檢查 S3 存儲桶的策略，確認該文件只能透過預簽名 URL 訪問。之後，會測試一個已創建的 Lambda 函數來生成預簽名 URL 並傳遞該報告，最終會將此 Lambda 函數新增至先前創建的 Step Functions 狀態機器中。

## 創建示例報告，將其上傳至 Amazon S3 並測試訪問

### 創建示例報告文件
1. 返回 AWS Cloud9 IDE。
2. 在 Environment 窗口中，選擇 Cloud9 Instance 資料夾，然後選擇 File > New File。
3. 在打開的文件中粘貼以下內容：
   ```html
   <output>Hello! This is some sample HTML.</output>
   ```
4. 選擇 File > Save，將文件命名為 `report.html`，然後選擇 Save。

### 將文件上傳至 Amazon S3 並檢查 S3 存儲桶策略
1. 打開 AWS Cloud9 終端機，執行以下命令上傳 `report.html` 文件至 S3，並將 `cache-control` 設置為 `max-age=0`，防止文件被緩存：
   ```bash
   cd /home/ec2-user/environment
   bucket=`aws s3api list-buckets --query "Buckets[].Name" | grep s3bucket | tr -d ',' | sed -e 's/"//g' | xargs`
   aws s3 cp report.html s3://$bucket/ --cache-control "max-age=0"
   ```
2. 打開 AWS 管理控制台，搜索並選擇 S3，然後選擇上傳文件的 S3 存儲桶。
3. 驗證 `report.html` 文件已存在於存儲桶中，並選擇 Permissions（權限）標籤。
4. 在 Bucket policy（存儲桶策略）部分檢查策略，確認以下策略存在：
   ```json
   {
       "Sid": "DenyOneObjectIfRequestNotSigned",
       "Effect": "Deny",
       "Principal": "*",
       "Action": "s3:GetObject",
       "Resource": "arn:aws:s3:::your-bucket-name/report.html",
       "Condition": {
           "StringNotEquals": {
               "s3:authtype": "REST-QUERY-STRING"
           }
       }
   }
   ```

### 測試直接訪問
1. 在 Amazon S3 控制台中，選擇 Objects（對象）標籤，然後選擇 `report.html`。
2. 複製對象 URL 並在瀏覽器中打開。會收到 AccessDenied 錯誤，這是由於存儲桶策略阻止了直接訪問。

### 創建並測試預簽名 URL
1. 返回 AWS Cloud9 終端機，運行以下命令生成一個有效期 30 秒的預簽名 URL：
   ```bash
   aws s3 presign s3://$bucket/report.html --expires-in 30
   ```
2. 複製返回的預簽名 URL 並在瀏覽器中打開，將會成功加載報告。
3. 等待 30 秒後刷新頁面，會再次看到 AccessDenied 錯誤，這是預期的行為。

> 結論：您已成功測試預簽名 URL，並確認該文件只能通過預簽名 URL 訪問。

## 測試 `GeneratePresignedURL` Lambda 函數
### 查看 Lambda 函數的 IAM 角色
1. 打開 AWS 管理控制台，搜索並選擇 IAM。
2. 選擇 Roles（角色），搜索並選擇 RoleForAllLambdas 角色。
3. 在 Permissions（權限）標籤下展開 lambdaPolicyForAllLambdaSteps 策略，該角色允許對 Amazon S3、SNS 和 DynamoDB 的操作。
4. 在 Trust relationships（信任關係）標籤中，確認 Lambda 服務 (`lambda.amazonaws.com`) 被授權假設此角色。

### 測試 `GeneratePresignedURL` Lambda 函數
1. 在 AWS 管理控制台中，搜索並選擇 Lambda。
2. 選擇名為 `GeneratePresignedURL` 的 Lambda 函數。
3. 選擇 Test，輸入事件名稱 `test1`，然後選擇 Create。
4. 選擇 Test 以運行函數，結果將返回一個預簽名 URL。
5. 複製該 URL 並在瀏覽器中打開，確認可以加載 `report.html` 文件。

## 在狀態機器中新增 `GeneratePresignedURL` Lambda 函數
1. 打開 Step Functions 控制台，選擇 MyStateMachine，然後選擇 Edit。
2. 在「States browser」搜尋框中輸入 Lambda，將 AWS Lambda Invoke 對象拖動到 SNS Publish 對象上方的箭頭處。
3. 配置以下選項：
   - State name：輸入 `GeneratePresignedURL`。
   - Function name：選擇 GeneratePresignedURL:$LATEST。
   - Payload：選擇 No payload。
   - Next state：選擇 SNS Publish。
4. 選擇 Save，然後選擇 Execute（執行）以測試狀態機器。
5. 在代碼編輯器中刪除第二行的名稱-值對，保留以下代碼：
   ```json
   {
   }
   ```
6. 選擇 Start execution，然後檢查電子郵件中的預簽名 URL，確認可以加載生成的報告。

> 提示：若電子郵件客戶端未識別完整的預簽名 URL，需手動複製整個 URL 並粘貼至瀏覽器進行測試。

這樣就完成了任務 4。