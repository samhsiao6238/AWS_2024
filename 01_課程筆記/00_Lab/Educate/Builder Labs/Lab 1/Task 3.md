# Task 3：建立user pool

<br>

## 說明

1. 這個任務會建立 `Amazon Cognito user pool` 作為身份提供者，用於建立使用者及管理其密碼。

<br>

2. `user pool` 還會產生 `憑證 (tokens)`，網頁應用程式將使用這些憑證來確保使用者在訪問受保護頁面或執行受保護操作之前，已經通過身份驗證並擁有有效的工作階段。

<br>

## 建立 Cognito user pool

1. 進入 `Cognito`。

<br>

2. 在頁面頂部選擇 `User Pools`。

<br>

3. 點擊 `Create user pool` 建立新的 `user pool`。

<br>

## 配置登入體驗

_在 `Configure sign-in experience=` 頁面中配置以下設定_

<br>

1. `Authentication providers` 選擇 `Cognito user pool`。

<br>

2. `Cognito user pool sign-in options` 選擇 `User name`。

<br>

3. `User name requirements` 勾選 `Make user name case sensitive`。

<br>

4. 點擊 `Next`。

<br>

## 配置安全性要求

_在 "Configure security requirements" 頁面中配置以下設定_

<br>

1. `Password policy mode`  使用 `Cognito defaults`。

<br>

2. `Multi-factor authentication` 選擇 `No MFA`。

<br>

3. `User account recovery` 取消選擇 `Enable self-service account recovery - Recommended`。

<br>

4. 點擊 `Next`。

<br>

## 配置註冊體驗

_在 "Configure sign-up experience" 頁面中配置以下設定_

<br>

1. 取消選擇 `Enable self-registration`。

<br>

2. 取消選擇 `Allow Cognito to automatically send messages to verify and confirm - Recommended`。

<br>

3. 點擊 `Next`。

<br>

## 配置訊息傳遞

_在 "Configure message delivery" 頁面中配置以下設定_

<br>

1. 選擇 `Send email with Cognito`。

<br>

2. 點擊 `Next`。

<br>

## 應用程式整合

_在 "Integrate your app" 頁面中配置以下設定_

<br>

1. `User pool name` 輸入 `bird_app`

<br>

2. 勾選 `Use the Cognito Hosted UI`

<br>

3. 在 `Domain` 區域中，選擇 `Use a Cognito domain`

<br>

4. 在 `Cognito domain` 欄位中輸入唯一的域名如 `MyDomain2024`；可將此紀錄在 `MyDoc.txt`。

<br>

## 配置應用程式客戶端

1. 在 `Initial app client` 區域中，選擇 `Public client`。

<br>

2. 在 `App client name` 欄位中輸入 `bird_app_client`。

<br>

3. 在 `Allowed callback URLs` 欄位中，輸入 `https://<cloudfront-domain>/callback.html`，將其中 `<cloudfront-domain>` 替換為記錄在 `MyDoc.txt` 中的 CloudFront 網域名。

<br>

4. 在 `Advanced app client settings` 區域中已選取確保以下選項，`ALLOW_USER_PASSWORD_AUTH`、`ALLOW_REFRESH_TOKEN_AUTH`。

<br>

5. 在 `OAuth 2.0 Grant Types` 區域中，取消選取 `Authorization code grant`，然後選取 `Implicit grant`。

<br>

6. 點擊 `Next`。

<br>

## 檢查設定並建立user pool

1. 檢查所有設定是否正確，然後點擊 `Create user pool`。

<br>

2. 在 `MyDoc.txt` 記錄 `User Pool ID`。

<br>

## 配置應用整合

1. 在 `user pool` 建立後，選擇 `bird-app` 連結。

<br>

2. 進入 `App integration` 頁籤，滾動至頁面底部找到 `App clients and analytics` 區域。

<br>

3. 找到 `bird_app_client`，記錄 `Client ID`；至此成功設置 `Cognito user pool` 與應用程式客戶端，接下來將會建立測試用戶。

<br>

___

_END_