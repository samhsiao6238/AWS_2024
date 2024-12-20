# Task 9：測試應用程式與 Identity Pool 的整合

_此任務將測試更新後的 `Birds 應用程式`，以確保能夠取得 `臨時 AWS 憑證`，通過這些臨時憑證，使用者可以根據 `Identity Pool` 配置的角色訪問 AWS 服務。_

<br>

## 測試 Identity Pool 整合

_返回 Birds 應用程式的瀏覽器分頁_

<br>

1. 選擇 `HOME` 頁籤，並刷新頁面，確保瀏覽器載入的是更新後的代碼。

<br>

2. 選擇 `REPORT` 頁籤。

<br>

3. 選擇 `LOGIN`，並使用先前在 `user pool` 中建立的 `teststudent` 帳戶登入。

<br>

4. 登入後，再次選擇 `REPORT` 頁籤。

<br>

## 驗證臨時 AWS 憑證

1. 選擇 `VALIDATE MY TEMPORARY AWS CREDENTIALS`。

<br>

2. 系統會短暫顯示一則訊息：`We are verifying that your temporary AWS credentials can access dynamoDB. One moment....`。

<br>

3. 接著訊息會更新為：`Your temporary AWS credentials have been configured.`

    ![](images/img_86.png)

<br>

4. 至此確認應用程式與 `Amazon Cognito Identity Pool` 已正確配置；經過身份驗證的使用者將能夠取得臨時 AWS 憑證，並藉此與 DynamoDB 資料庫進行交互。

<br>

5. 可透過開發者工具進行觀察。

    ![](images/img_87.png)

<br>

## 任務總結

_以上成功完成 `Identity Pool` 與應用程式的整合測試，使用者現已能夠通過臨時 AWS 憑證訪問 DynamoDB；在接下來的 Lab 中，將對 DynamoDB 進行操作，包括如何查看和添加資料至資料庫。_

<br>

___

_END_