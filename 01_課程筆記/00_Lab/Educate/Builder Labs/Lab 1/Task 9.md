# Task 9：測試應用程式與身份池的整合

_此任務將測試更新後的 Birds 應用程式，以確保能夠獲取臨時 AWS 憑證。通過這些臨時憑證，使用者可以根據身份池配置的角色訪問 AWS 服務。你的身份池已配置為將已驗證使用者與具有訪問 DynamoDB 表格權限的 IAM 角色關聯。_

<br>

## 測試身份池整合

_返回 Birds 應用程式的瀏覽器分頁_

<br>

1. 選擇 `HOME` 頁籤，並刷新頁面，確保瀏覽器載入的是更新後的代碼。

<br>

2. 選擇 `REPORT` 頁籤。

<br>

3. 選擇 `LOGIN`，並使用先前在user pool中建立的 `teststudent` 帳戶登入。

<br>

4. 登入後，再次選擇 `REPORT` 頁籤。

<br>

## 驗證臨時 AWS 憑證

1. 選擇 `VALIDATE MY TEMPORARY AWS CREDENTIALS`。

<br>

2. 系統會短暫顯示一則訊息：`We are verifying that your temporary AWS credentials can access dynamoDB. One moment....`。

<br>

3. 接著訊息會更新為：`Your temporary AWS credentials have been configured.`

<br>

4. 這個測試確認了應用程式與 Amazon Cognito 身份池已正確配置。經過身份驗證的使用者將能夠獲取臨時 AWS 憑證，並藉此與 DynamoDB 資料庫進行交互。

<br>

## 任務總結

1. 以上成功完成身份池與應用程式的整合測試。

<br>

2. 使用者現已能夠通過臨時 AWS 憑證訪問 DynamoDB。

<br>

3. 在接下來的 Lab 中，將對 DynamoDB 進行操作，包括如何查看和添加資料至資料庫。

<br>

___

_END_