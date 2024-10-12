# Lab 2: Adding Dynamic Data to Your Application with DynamoDB

## 場景說明

1. 在這個 Lab 中，假設已建立一個名為 `Birds` 的網頁應用程式，供學生學習有關鳥類的知識，並透過 `Amazon Cognito` 配置了安全機制。

2. 使用 `Cognito` 使用者池，要求用戶登入才能訪問 `Sightings` 和 `Report` 頁面，並驗證 Cognito 身份池能為登入的用戶提供應用程式所需的 AWS 服務憑證（如與 DynamoDB 互動）。

3. 目前應用程式透過 JSON 格式的靜態檔案提供鳥類觀察資料，接下來將創建 DynamoDB 資料表來儲存觀察記錄，並載入歷史資料，最後更新網站程式碼以讀取和新增資料，並撰寫腳本每週生成報告供 Ms. García 使用。