# Task 2: 訂閱 SNS 主題

_在這個任務中，將訂閱一個 SNS 主題，當應用程式用戶請求的報告可用時，系統會發送通知。_

<br>

## 訂閱 SNS 主題

1. 搜尋並進入 `Simple Notification Service`。

<br>

2. 在左側欄中選擇 `Topics`。

<br>

3. 在 `Name` 下找到並點擊 `EmailReport`。

<br>

## 建立電子郵件訂閱

1. 在 `Subscription` 選擇 `Create subscription`。

<br>

2. 進行配置，在 Topic ARN 部分已自動填入前面步驟建立主題的 `ARN`。

<br>

3. `Protocol` 選擇 `Email`。

<br>

4. `Endpoint` 輸入一個電子郵件的地址，這將在本 Lab 後續步驟中接收通知。

<br>

5. 點擊 `Create subscription`。

<br>

## 確認電子郵件訂閱

1. 檢查電子郵件收件箱，會收到來自 AWS Notifications 的郵件，並在郵件正文中點擊 `Confirm subscription`。

<br>

2. 打開的網頁會顯示 `訂閱確認成功`；關閉該網頁。

<br>

## 發佈測試消息以驗證 SNS 訂閱

1. 返回 Amazon SNS 控制台中 `EmailReport` 主題頁面。

<br>

2. 點擊 `Publish message` 後進行配置。

<br>

3. 在 `Subject` 輸入 `Test`。

<br>

4. 在 `Message body` 輸入 `Hello! This is a test.`。

<br>

5. 在頁面底部點擊 `Publish message`。

<br>

6. 檢查電子郵件，確認已收到來自 SNS 的測試消息；以上已成功訂閱 SNS 主題，並驗證 SNS 通知功能能夠正常運作。

<br>

___

_END_