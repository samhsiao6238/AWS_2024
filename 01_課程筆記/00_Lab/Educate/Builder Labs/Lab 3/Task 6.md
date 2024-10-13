# Task 6：將 `getRealData` Lambda 函數添加到狀態機

_在這個任務中，將測試並加入一個 Lambda 函數來從 DynamoDB 表中檢索實際的鳥類觀察紀錄，並將該函數集成到現有的狀態機中，讓 `generateHTML` 狀態使用真實的數據來生成報告。_

## 測試 `getRealData` Lambda 函數

1. 首先進行查看並測試 `getRealData` Lambda 函數；搜尋並進入 `Lambda` 服務。

2. 選擇名為 `getRealData` 的 Lambda 函數。檢查該函數的 IAM Role，確認它使用的是 `RoleForAllLambdas`，這個角色允許 Lambda 與 Amazon S3、Amazon SNS 和 Amazon DynamoDB 互動。該函數的代碼將從 DynamoDB 中檢索所有鳥類觀察紀錄，並以 JSON 格式返回。

## 測試 `getRealData` Lambda 函數：

1. 選擇 Code 標籤，然後選擇 Test。

2. 將事件名稱設為 `test3`，並將測試事件輸入設為 `{}`。

3. 選擇 Save 並再次選擇 Test。

4. 在執行結果中，應該會看到返回的鳥類觀察紀錄數據。

## 將 `getRealData` Lambda 函數添加到狀態機

1. 編輯狀態機以添加 `getRealData` 函數：
   - 返回 Step Functions 控制台，選擇 MyStateMachine，然後選擇 Edit。
   - 在左側的 States browser 搜尋 Lambda。
   - 將 AWS Lambda Invoke 對象拖到 `Parallel` 狀態（`Process Report`）上方，作為它之前執行的一步。

2. 配置 Lambda Invoke 詳細信息：
   - State name：輸入 `getRealData`。
   - Function name：選擇 `getRealData:$LATEST`。
   - Payload：選擇 No payload。
   - 在右上角選擇 Save。

#### 3. 更新 SNS Publish 物件的消息格式

1. 改善消息格式：
   - 打開 Code 模式，定位到接近底部的 `SNS Publish` 狀態。
   - 將 `Message.$` 的值從 `"$"` 修改為 `States.Format`，以更好地格式化發送的消息。
     ```json
     "Message.$": "States.Format('The report has completed successfully! Here is your secure URL:\n\n{}', $[1].presigned_url_str)"
     ```
   - 這樣，SNS 消息將以格式化文本發送 URL 給收件人。

2. 保存更新：
   - 保存修改後的 ASL 代碼，在彈出視窗中選擇 Save anyway。

#### 4. 測試完整的狀態機

1. 開始執行狀態機：
   - 選擇 Execute，在編輯器中只保留 `{}` 作為輸入。
   - 選擇 Start execution 開始執行狀態機。

2. 檢查電子郵件通知：
   - 檢查的郵箱，應收到一封包含格式化的消息和預簽名 URL 的電子郵件。
   - 確認可以通過該 URL 加載生成的報告。

#### 總結

在這個任務中，成功將 `getRealData` Lambda 函數添加到狀態機中，並使其在 `generateHTML` 之前運行，以檢索實際的數據來生成報告。此外，還更新了 SNS Publish 狀態，使用格式化消息來更清晰地向用戶傳遞報告 URL。最後，通過電子郵件驗證了整個工作流程的正確性。