# Task 3：創建一個用於發送電子郵件的 State Machine

在此任務中，將創建一個 AWS Step Functions 狀態機，該狀態機將透過 SNS 主題發送電子郵件通知。需要首先確保這個狀態機具備訪問 Lambda 服務的權限，並且訂閱 SNS 主題的電子郵件會正確接收報告通知。

#### 1. 查看 Step Functions 的 IAM 角色
- 打開 AWS Management Console，從 Services 菜單搜尋並選擇 IAM。
- 在左側導航欄中，選擇 Roles（角色）。
- 在搜索框中搜尋並選擇 RoleForStepToCreateAReport 角色。
- 進入 Permissions（權限）標籤，展開 stepPolicyForCreateReport 政策，這些權限允許對特定 Lambda 函數執行多個 Lambda 操作，並對所有資源執行日誌操作。
- 展開 AWSLambdaRole 管理政策，該政策允許 `lambda:InvokeFunction` 操作，這將允許從 Lambda 控制台測試函數。
- 進入 Trust relationships（信任關係）標籤，確認這個信任關係允許 Step Functions 服務（states.amazonaws.com）假設該角色。

#### 2. 創建發送電子郵件的狀態機
1. 打開 AWS Management Console，搜尋並選擇 Step Functions。
2. 在左側導航欄中，選擇 State machines（狀態機）。
3. 選擇 Create state machine（創建狀態機）。
4. 在 Choose a template 頁面，選擇 Blank 模板，然後點擊 Select。
5. Workflow Studio 將以設計模式顯示。

#### 3. 設計工作流程
1. 在頁面左側的 States 瀏覽器中，搜尋 SNS。
2. 將 Amazon SNS Publish 物件拖到標記為 Drag first state here 的框內。
3. 在 SNS Publish 面板中，配置以下選項：
   - Topic：選擇之前創建的 EmailReport SNS 主題的 ARN。
   - Message 設置為 Use state input as message。

#### 4. 修改狀態機代碼
1. 點擊頁面頂部的 Code 按鈕進入代碼模式。
2. 在代碼中，將 `"Message.$"` 的值從 `"$"` 更改為 `"$..presigned_url_str"`。這表示應用程式將傳入一個 JSON 負載，包含 `presigned_url_str`，這會作為郵件內容發送。
3. 代碼中的參數部分應類似以下內容：

```json
"Parameters": {
  "Message.$": "$.presigned_url_str",
  "TopicArn": "arn:aws:sns:us-east-1:account-id:EmailReport"
}
```

#### 5. 設定狀態機
1. 點擊頁面頂部的 Config 按鈕進入配置模式。
2. State machine name（狀態機名稱）：輸入 `MyStateMachine`。
3. Execution role（執行角色）：選擇 Choose an existing role，並選擇 RoleForStepToCreateAReport。
4. Log level（日誌等級）：選擇 ALL，這會記錄每次狀態機執行的詳細資訊。

#### 6. 創建並測試狀態機
1. 完成設置後，點擊 Create 創建狀態機。
2. 創建完成後，選擇 Start execution 開始執行。
3. 在代碼編輯器中，將預設的 JSON 替換為以下內容：

```json
{
  "presigned_url_str": "Testing that my email message works"
}
```

4. 點擊 Start execution 開始執行狀態機。
5. 檢查執行詳細頁面，並確認執行狀態。
6. 檢查的電子郵件，應該收到一封內容為 `Testing that my email message works` 的電子郵件。

### 結論
已成功創建了一個基本的狀態機，該狀態機通過 SNS 主題發送電子郵件。接下來，可以進一步優化應用程式，讓老師 Ms. Garcia 獲取所有學生觀察記錄的安全報告通知。