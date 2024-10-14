# Task 2: 訂閱 SNS 主題

在這個任務中，將訂閱一個 SNS 主題，當應用程式用戶請求的報告可用時，系統會發送通知。

## 訂閱 SNS 主題
1. 進入 AWS SNS 控制台
   - 在 AWS 管理控制台，打開「服務」菜單，搜索並選擇 Simple Notification Service。
   - 在左側導航窗格中，選擇 Topics（主題）。

2. 選擇主題
   - 在「名稱」欄位下，找到並選擇 EmailReport 主題。

3. 創建電子郵件訂閱
   - 在 Subscription（訂閱）部分，選擇 Create subscription（創建訂閱），並配置以下選項：
     - Topic ARN（主題 ARN）：注意該欄位已自動填入您剛創建的主題的 Amazon 資源編號（ARN）。
     - Protocol（協議）：選擇 Email。
     - Endpoint（端點）：輸入一個您能夠接收電子郵件的地址，以便在本實驗過程中接收通知。
   - 選擇 Create subscription（創建訂閱）。

## 確認電子郵件訂閱
1. 檢查您輸入的電子郵件收件箱。
2. 收到來自 AWS Notifications 的郵件，並在郵件正文中選擇 Confirm subscription（確認訂閱）鏈接。
3. 打開的網頁會顯示「訂閱確認成功」的消息。
4. 關閉顯示確認消息的網頁。

## 發佈測試消息以驗證 SNS 訂閱
1. 返回到您瀏覽器中的 Amazon SNS 控制台標籤，回到 EmailReport 主題頁面。
   - 提示：可以選擇頁面頂部的 EmailReport 返回主題頁面。

2. 發佈測試消息
   - 選擇 Publish message（發佈消息），並配置以下選項：
     - Subject - optional（主題 - 可選）：輸入 `Test`。
     - Message body（消息正文）：輸入 `Hello! This is a test.`。
   - 在頁面底部，選擇 Publish message（發佈消息）。

3. 確認收到測試消息
   - 檢查您的電子郵件，確認已收到來自 SNS 的測試消息。
   - 電子郵件的主題和正文應與您配置的內容相符。

完成此任務後，您已成功訂閱 SNS 主題，並驗證 SNS 通知功能能夠正常運作。