# Task 4：新增測試使用者

## 說明

1. 在使用 `Amazon Cognito user pool` 訪問應用程式之前，必須先在 `user pool` 中建立使用者帳戶。

2. 此任務會建立一個使用者 `teststudent`，並使用該帳戶來測試應用程式與 `Amazon Cognito user pool` 的整合。

## 建立測試使用者

1. 進入 `Users` 頁籤，在 `Cognito user pool` 的管理介面中，點擊上方的 `Users` 頁籤。

2. 在 `Users` 面板中選擇 `Create user`；`Username` 輸入 `teststudent`、`Temporary password` 選擇 `Set a password`、`Password` 輸入 `Welcome1!`。

3. 點擊 `Create user` 完成建立。

## 測試 `teststudent` 使用者登入

1. 返回 App integration 標籤，滾動至 `App clients and analytics` 區域。

2. 點擊 `bird_app_client` 連結，在 `Hosted UI` 區域中，選擇 `View Hosted UI`。

3. 在新打開的瀏覽器分頁中，輸入剛剛建立的使用者名稱 `teststudent` 及密碼 `Welcome1!`，點擊登入。

4. 登入後系統會要求更改密碼，在 `New Password` 輸入 `Welcome123!`，`Email` 輸入自己的電子郵件地址，點擊 `Send`。

5. 成功登入後，會自動進入網頁應用程式的主頁。

## 獲取 Cognito 發送的憑證 (Token)

1. 開啟瀏覽器的開發者工具：
   - 在 Birds 應用程式頁面中，打開瀏覽器的開發者工具。
     - Google Chrome 或 Microsoft Edge：選擇右上角的菜單圖示，點擊 `更多工具 (More tools)`，選擇 `開發者工具 (Developer tools)`。
     - Firefox：選擇右上角的菜單圖示，點擊 `更多工具 (More tools)`，選擇 `Web Developer Tools`。

2. 模擬行動裝置顯示：
   - 在開發者工具中，選擇設備圖示，模擬應用程式在行動裝置上的顯示效果。

3. 檢視 Local Storage：
   - Chrome 或 Edge：進入 `Application` 標籤。
   - Firefox：進入 `Storage` 標籤。
   - 注意：如需檢視更多標籤，點擊右側的箭頭圖示 (>>)。

4. 找到 Token：
   - 在左側導覽欄中，展開 `Local Storage`。
   - 找到 CloudFront 網域，點擊該網域。
   - 在右側區域，找到名為 `bearer_str` 的鍵。
   - `bearer_str` 的值即是 Amazon Cognito user pool產生的憑證 (Token)。

在下一個任務中，將更新應用程式以使用此憑證來驗證使用者是否已登入。應用程式的代碼會檢查此憑證是否有效以及是否過期。