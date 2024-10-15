# Task 7：配置 Amazon Cognito 身份池

_此任務中，將會配置已經在 Lab 環境中預先建立的 Amazon Cognito 身份池，並使其與 Birds 應用程式整合。_

## 進入身份池配置頁面

1. 返回 AWS 管理控制台的瀏覽器分頁。

2. 從頁面左側選單中選擇 "Federated identities"。

3. 選擇 "bird_app_id_pool"，這是預先建立的身份池。

4. 點擊右上角的 "Edit identity pool" 進行編輯。

5. 記錄身份池 ID 到文本編輯器中，稍後在更新網站配置時需要使用。

## 配置身份池角色

1. 在 "Edit identity pool" 頁面上，檢查以下角色配置：
   - Unauthenticated role (未認證角色)：`bird-app-id-poolUnauth_Role`
     - 此角色會分配給尚未通過身份驗證的使用者，這些使用者在 Birds 應用程式中的訪問權限有限。
   
   - Authenticated role (已認證角色)：`bird-app-student-role`
     - 當使用者通過身份驗證後，會自動被分配此角色。對於 Birds 應用程式，該角色已配置為允許學生添加和選擇 DynamoDB 表中的記錄。

## 更新身份池配置

1. 展開 "Authentication providers" 區域，選擇 "Cognito" 標籤。

2. 配置以下內容：
   - User Pool ID：輸入 `bird_app` user pool ID。
   - App client ID：輸入 `bird_app_client` ID。

3. 保存變更：
   - 點擊 `Save Changes` 保存配置。
   - 若出現提示 "Some edits will not be saved due to warnings. Are you sure you want to continue?"，選擇 `Continue`。

   - 注意：若出現錯誤訊息 "There was a problem modifying this identity pool. Please try again."，可以忽略該錯誤訊息。

## 檢查身份池角色配置

1. 再次檢查 "Authentication providers" 區域：
   - 確認已認證角色 (`Authenticated role`) 配置為預設角色，該角色會在使用者成功登入後自動分配。
   - 雖然可以設置額外的規則來為不同使用者分配不同的 AWS 身份與存取管理 (IAM) 角色，但在此階段，將保持簡單配置。

至此，身份池已成功配置，Birds 應用程式現在可以使用 Cognito 的身份驗證和授權功能來管理不同使用者的訪問權限。