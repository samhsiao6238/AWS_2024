# Task 8：更新應用程式以使用身份池進行授權

_為了使 Birds 應用程式能夠與 Amazon Cognito 身份池進行互動，必須進行一些必要的更新。這些更新將使應用程式能夠正確處理授權並確保使用者擁有適當的 AWS 憑證來訪問受保護的資源。_

## 更新 Birds Web 應用程式

1. 返回 AWS Cloud9 IDE 的瀏覽器分頁。

### 更新 `config.js` 文件

1. 展開 `website/scripts` 資料夾。

2. 打開 `config.js` 文件。

3. 取消最後一行代碼的註解，並將 `<cognito-identity-pool-id>` 佔位符替換為之前記錄的身份池 ID。

    ```javascript
    //CONFIG.COGNITO_IDENTITY_POOL_ID_STR = "<cognito-identity-pool-id>";
    CONFIG.COGNITO_IDENTITY_POOL_ID_STR = "us-east-1:example-identity-pool-id";
    ```

4. 保存變更。

### 更新 `auth.js` 文件

1. 在 `website/scripts` 資料夾中打開 `auth.js` 文件。

2. 找到大約第 91 行的代碼，並將 `<cognito-user-pool-id>` 佔位符替換為user pool ID（注意：這裡要使用user pool ID，而不是身份池 ID）。

    ```javascript
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId : CONFIG.COGNITO_IDENTITY_POOL_ID_STR,
        Logins : {
            "cognito-idp.us-east-1.amazonaws.com/<cognito-user-pool-id>": token_str_or_null
        }
    });
    ```

   更新後的代碼應類似如下：

    ```javascript
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId : CONFIG.COGNITO_IDENTITY_POOL_ID_STR,
        Logins : {
            "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAAA1111": token_str_or_null
        }
    });
    ```

3. 保存變更。

   - 此代碼片段使用 `COGNITO_IDENTITY_POOL_ID_STR` 變數來請求身份池中的 AWS 憑證。該代碼還傳遞了user pool ID 和 `token_str_or_null`（保存身份驗證憑證）。身份池會使用這些資訊來驗證使用者，如果驗證通過，身份池會向應用程式返回 AWS 憑證。

## 將更新後的網站代碼推送至 S3 Bucket

1. 替換 S3 Bucket 的佔位符：
   - 在以下指令中，將 `<s3-bucket>` 替換為記錄的 S3 Bucket 名稱。

2. 運行以下指令將網站代碼上傳到 S3：

    ```bash
    cd /home/ec2-user/environment
    aws s3 cp website s3://<s3-bucket>/ --recursive --cache-control "max-age=0"
    ```

## 確認 Node 伺服器是否正在運行

1. 確認 Node 伺服器是否仍在運行：
   - 如果伺服器未在運行，運行以下指令重新啟動伺服器：

    ```bash
    cd /home/ec2-user/environment/node_server
    npm start
    ```

經過這些更新，Birds 應用程式現在可以正確與 Cognito 身份池進行整合，確保使用者在身份驗證後能夠獲得 AWS 憑證並進行授權。