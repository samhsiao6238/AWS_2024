# Task 2：訂閱 SNS 主題

在這個任務中，將會訂閱一個 SNS 主題，當應用程式用戶請求報告時，該主題將會發送通知給訂閱者。

#### 步驟 1：進入 Simple Notification Service（SNS）主題頁面
1. 在 AWS Management Console 中，從 Services 菜單中搜尋並選擇 Simple Notification Service。
2. 在左側的導航欄中，選擇 Topics（主題）。
3. 在 Name（名稱）欄位中，找到名為 EmailReport 的 SNS 主題並點擊進入。

#### 步驟 2：創建一個電子郵件訂閱
1. 在 Subscription（訂閱）部分中，選擇 Create subscription（創建訂閱）。
2. 在配置頁面上，完成以下選項：
   - Topic ARN：主題的 Amazon Resource Number（ARN）會自動填寫，無需更改。
   - Protocol：選擇 Email。
   - Endpoint：輸入一個有效的電子郵件地址，這將是在實驗期間接收通知的地址。
3. 選擇 Create subscription（創建訂閱）。

#### 步驟 3：確認電子郵件訂閱
1. 檢查提供的電子郵件信箱，應收到來自 AWS 通知服務的電子郵件。
2. 打開郵件，並在郵件內容中點擊 Confirm subscription（確認訂閱）鏈接。
3. 此時瀏覽器將打開一個網頁，顯示訂閱成功的訊息。
4. 關閉顯示成功消息的網頁。

#### 步驟 4：發佈測試訊息以確認訂閱
1. 返回瀏覽器中 SNS 主題 EmailReport 的頁面。
2. 在頁面頂部，選擇 EmailReport 主題名稱，回到該主題的詳細頁面。
3. 選擇 Publish message（發佈訊息），然後進行以下配置：
   - Subject - optional（主題 - 可選）：輸入 `Test`。
   - Message body（訊息內容）：輸入 `Hello! This is a test.`。
4. 在頁面底部，選擇 Publish message（發佈訊息）。

#### 步驟 5：確認收到測試訊息
1. 檢查提供的電子郵件信箱，確認已收到主題為 `Test` 的測試訊息。
2. 驗證郵件的主題與訊息內容是否與先前配置的內容一致。

此步驟的目的是確認 SNS 訂閱功能是否正常運作，並確保未來的報告通知能夠正確傳送給 Ms. Garcia。