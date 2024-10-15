# Task 9：測試應用程式與身份池的整合

_此任務將測試更新後的 Birds 應用程式，以確保能夠獲取臨時 AWS 憑證。通過這些臨時憑證，使用者可以根據身份池配置的角色訪問 AWS 服務。你的身份池已配置為將已驗證使用者與具有訪問 DynamoDB 表格權限的 IAM 角色關聯。_

## 測試身份池整合

1. 返回 Birds 應用程式的瀏覽器分頁。

2. 選擇 "HOME" 標籤，並刷新頁面，確保瀏覽器載入的是更新後的代碼。

3. 選擇 "REPORT" 標籤。

4. 選擇 "LOGIN"，並使用先前在user pool中創建的 `teststudent` 帳戶登入。

5. 登入後，再次選擇 "REPORT" 標籤。

6. 驗證臨時 AWS 憑證：
   - 選擇 `VALIDATE MY TEMPORARY AWS CREDENTIALS`。
   - 系統會短暫顯示一則訊息："We are verifying that your temporary AWS credentials can access dynamoDB. One moment...."。
   - 接著訊息會更新為："Your temporary AWS credentials have been configured."

這個測試確認了應用程式與 Amazon Cognito 身份池已正確配置。經過身份驗證的使用者將能夠獲取臨時 AWS 憑證，並藉此與 DynamoDB 資料庫進行交互。

## 任務總結

恭喜！成功完成了身份池與應用程式的整合測試。使用者現已能夠通過臨時 AWS 憑證訪問 DynamoDB。在接下來的 Lab 中，將學習更多關於 DynamoDB 的內容，包括如何查看和添加資料至資料庫。