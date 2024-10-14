# Task 3: 建立 StateMachine 發送電子郵件

在此任務中，將建立一個 Step Functions 狀態機器，透過 SNS 主題發送電子郵件通知。該狀態機器需要具備訪問 Lambda 服務的權限，因此首先需要查看一個已經為此目的創建的 IAM 角色。

## 審查 Step Functions 的 IAM 角色
1. 查看 IAM 角色詳細信息
   - 在 AWS 管理控制台中，打開「服務」菜單，搜索並選擇 IAM。
   - 在左側導航窗格中，選擇 Roles（角色）。
   - 在搜尋框中，搜索並選擇 RoleForStepToCreateAReport 角色。
   
2. 檢視角色的權限
   - 在「權限」標籤頁中，展開 stepPolicyForCreateReport 策略。
   - 這個角色允許對多個 Lambda 函數執行多個 Lambda 操作，並對所有資源執行記錄操作。
   - 同時展開附加的 AWSLambdaRole 管理策略，該策略允許對所有資源執行 `lambda:InvokeFunction` 操作，這將允許在 Lambda 控制台測試函數。
   
3. 檢視信任關係
   - 選擇 Trust relationships（信任關係）標籤。
   - 該信任關係允許 Step Functions 服務（`states.amazonaws.com`）來假設此角色。

> 注意：在這個實驗環境中，無法創建 IAM 角色。稍後實驗中會觀察其他已為您創建的 IAM 角色。如果擁有更多使用 IAM 服務的權限，可以手動創建此角色，並附加已觀察的管理策略和自訂策略。

## 創建發送電子郵件的 State Machine
1. 進入 Step Functions 控制台
   - 在 AWS 管理控制台中，搜索並選擇 Step Functions。
   - 在左側導航窗格中，選擇 State machines。
   - 選擇 Create state machine（創建狀態機器）。

2. 選擇模板
   - 在「Choose a template」頁面中，選擇 Blank（空白）。
   - 選擇 Select（選擇）。

3. 設計工作流程
   - 在「States browser」的搜尋框中輸入 SNS。
   - 將 Amazon SNS Publish 對象拖放到畫布上的「Drag first state here」框中。

4. 配置 SNS 發布狀態
   - 在「SNS Publish」面板中，配置以下選項：
     - Topic ARN：選擇先前創建的 EmailReport SNS 主題的 ARN。
     - Message：設置為 Use state input as message（使用狀態輸入作為消息）。

5. 修改狀態機器的 Amazon States Language (ASL) 代碼
   - 選擇畫布上方的 Code 按鈕進入代碼模式。
   - 在生成的 ASL 代碼中，找到第 9 行，將 `"Message.$": "$"` 修改為 `"Message.$": "$.presigned_url_str"`。
   - 此操作確保應用程序會將一個包含 `presigned_url_str` 的 JSON 負載作為郵件內容發送。

6. 配置狀態機器
   - 選擇 Config（配置）按鈕返回配置模式。
   - 設置狀態機器名稱為 MyStateMachine。
   - 在「Execution role」部分，選擇 Choose an existing role（選擇現有角色）。
   - 在「Existing roles」中，選擇 RoleForStepToCreateAReport 角色。
   - 將 Log level 設置為 ALL（全部）。

> 注意：這個日誌組將捕獲每次運行狀態機器時的資訊，用於檢查和調試狀態機器。

7. 創建狀態機器
   - 保留其他設置的默認值，選擇 Create（創建）。

## 測試 State Machine
1. 啟動狀態機器執行
   - 選擇 Start execution（開始執行），並配置以下選項：
     - 在代碼編輯器中，替換現有的 JSON 代碼為：
     ```json
     {
       "presigned_url_str": "Testing that my email message works"
     }
     ```
   - 選擇 Start execution。

2. 查看執行結果
   - 開啟「Execution Details」頁面，檢視執行細節。

3. 檢查電子郵件通知
   - 幾分鐘內應收到一封通知，該通知包含訊息內容：「Testing that my email message works」。

> 恭喜！ 您已成功創建一個基本的狀態機器，該狀態機器調用了 SNS 主題並發送了一封電子郵件。