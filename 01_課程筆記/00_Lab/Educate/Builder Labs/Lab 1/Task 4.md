# Task 4：新增測試使用者

<br>

## 說明

1. 在使用 `Amazon Cognito user pool` 訪問應用程式之前，必須先在 `user pool` 中建立使用者帳戶。

<br>

2. 此任務會建立一個使用者 `teststudent`，並使用該帳戶來測試應用程式與 `Amazon Cognito user pool` 的整合。

<br>

## 建立測試使用者

_繼續在 `User pools` 的 `bird_app` 詳細頁面中操作_

<br>

1. 進入 `Users` 頁籤，在 `Cognito user pool` 的管理介面中，點擊上方的 `Users` 頁籤。

<br>

2. 在 `Users` 面板中選擇 `Create user`；`Username` 輸入 `teststudent`、`Temporary password` 選擇 `Set a password`、`Password` 輸入 `Welcome1!`。

<br>

3. 點擊 `Create user` 完成建立。

<br>

## 測試 `teststudent` 使用者登入

1. 返回 App integration 標籤，滾動至 `App clients and analytics` 區域。

<br>

2. 點擊 `bird_app_client` 連結，在 `Hosted UI` 區域中，選擇 `View Hosted UI`。

<br>

3. 在新打開的瀏覽器分頁中，輸入剛剛建立的使用者名稱 `teststudent` 及密碼 `Welcome1!`，點擊登入。

<br>

4. 登入後系統會要求更改密碼，在 `New Password` 輸入 `Welcome123!`，`Email` 輸入自己的電子郵件地址，點擊 `Send`。

<br>

5. 成功登入後，會自動進入網頁應用程式的主頁。

<br>

## 獲取 Cognito 發送的憑證 (Token)

1. 在網頁應用程式頁面中，打開瀏覽器的開發者工具，並選擇模擬在行動裝置上的顯示效果。

<br>

2. 在左側導覽欄中，展開 `Local Storage`，找到 `CloudFront` 網域，點擊該網域。

<br>

3. 在右側區域，找到名為 `bearer_str` 的鍵，這個 `bearer_str` 的值即是 `Amazon Cognito user pool` 產生的 `憑證 (Token)`。

<br>

___

_END_