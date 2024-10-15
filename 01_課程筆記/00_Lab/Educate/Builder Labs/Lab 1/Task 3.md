# Task 3：建立user pool

_在這個任務中，將會建立一個 Amazon Cognito user pool，該池將作為身份提供者，用於建立使用者及管理其密碼。此user pool還會產生憑證 (tokens)，Birds Web 應用程式將使用這些憑證來確保使用者在訪問受保護頁面或執行受保護操作之前已經通過身份驗證並擁有有效的工作階段。_

## 建立 Cognito user pool

1. 返回已開啟 CloudFront 控制台的瀏覽器分頁。

2. 從 AWS 服務選單中選擇 Cognito。

3. 在頁面頂部選擇 "User Pools"。

4. 點擊 "Create user pool" 來建立新的user pool。

## 配置登入體驗

1. 在 "Configure sign-in experience" 頁面中配置以下設定：
   - 身份驗證提供者 (Authentication providers)：選擇 "Cognito user pool"
   - Cognito user pool登入選項 (Cognito user pool sign-in options)：選擇 "User name"
   - 使用者名稱要求 (User name requirements)：勾選 "Make user name case sensitive"

2. 點擊 "Next" 繼續。

## 配置安全性要求

1. 在 "Configure security requirements" 頁面中配置以下設定：
   - 密碼政策模式 (Password policy mode)：使用 "Cognito defaults"
   - 多因素驗證 (Multi-factor authentication)：選擇 "No MFA"
   - 使用者帳戶恢復 (User account recovery)：取消選擇 "Enable self-service account recovery - Recommended"

2. 點擊 "Next" 繼續。

## 配置註冊體驗

1. 在 "Configure sign-up experience" 頁面中配置以下設定：
   - 取消選擇 "Enable self-registration"
   - 取消選擇 "Allow Cognito to automatically send messages to verify and confirm - Recommended"

2. 點擊 "Next" 繼續。

## 配置訊息傳遞

1. 在 "Configure message delivery" 頁面中配置以下設定：
   - 選擇 "Send email with Cognito"

2. 點擊 "Next" 繼續。

## 應用程式整合

1. 在 "Integrate your app" 頁面中配置以下設定：
   - user pool名稱 (User pool name)：輸入 "bird_app"
   - 勾選 "Use the Cognito Hosted UI"

2. 在 "Domain" 區域中配置以下設定：
   - 選擇 "Use a Cognito domain"
   - 在 Cognito domain 欄位中輸入唯一的域名，例如：`abc-10-12-2021` (可使用個人首字母加日期)，如果出現紅字提示該域名不可用，請嘗試另一個名稱。

3. 記錄 Amazon Cognito domain prefix（例如 `abc-10-12-2021`）於文本編輯器中，以備後續使用。

## 配置應用程式客戶端

1. 在 "Initial app client" 區域中配置以下設定：
   - 選擇 "Public client"
   - 在 App client name 欄位中輸入 `bird_app_client`
   - 在 Allowed callback URLs 欄位中，輸入 `https://<cloudfront-domain>/callback.html`，將 `<cloudfront-domain>` 替換為 Task 1 中記錄的 CloudFront 網域名。

   例如：`https://d123456acbdef.cloudfront.net/callback.html`

2. 在 "Advanced app client settings" 區域中確保以下選項已選取：
   - `ALLOW_USER_PASSWORD_AUTH`
   - `ALLOW_REFRESH_TOKEN_AUTH`

3. 在 "OAuth 2.0 Grant Types" 區域中配置以下設定：
   - 取消選取 "Authorization code grant"
   - 選取 "Implicit grant"

4. 點擊 "Next" 繼續。

## 檢查設定並建立user pool

1. 檢查所有設定是否正確，然後點擊 "Create user pool"。

2. 記錄 User Pool ID 於文本編輯器中，將在後續配置 Web 應用程式時使用。

## 配置應用整合

1. 在user pool建立後，選擇 "bird-app" 連結。

2. 進入 "App integration" 標籤，滾動至頁面底部，找到 "App clients and analytics" 區域。

3. 找到 `bird_app_client` 並記錄其 Client ID，此 Client ID 將在更新 Web 應用程式時使用。

至此，已成功設置 Cognito user pool與應用程式客戶端，接下來將會建立測試用戶。