# Task 8：更新應用程式以使用身份池進行授權

_為了使 Birds 應用程式能夠與 Amazon Cognito 身份池進行互動，必須進行一些必要的更新。這些更新將使應用程式能夠正確處理授權並確保使用者擁有適當的 AWS 憑證來訪問受保護的資源。_

<br>

## 更新 Birds Web 應用程式

_返回 AWS Cloud9 IDE_

<br>

1. 展開 `website/scripts` 資料夾，點擊打開 `config.js` 文件。

<br>

2. 取消最後一行代碼的註解，並將 `<cognito-identity-pool-id>` 佔位符替換為之前記錄的身份池 ID；保存變更。

    ```javascript
    //CONFIG.COGNITO_IDENTITY_POOL_ID_STR = "<cognito-identity-pool-id>";
    CONFIG.COGNITO_IDENTITY_POOL_ID_STR = "us-east-1:example-identity-pool-id";
    ```

<br>

3. 在 `website/scripts` 資料夾中打開 `auth.js` 文件。

<br>

4. 將 `<cognito-user-pool-id>` 佔位符替換為 `user pool ID`，注意這裡要使用user pool ID，而不是身份池 ID。

    ```javascript
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId : CONFIG.COGNITO_IDENTITY_POOL_ID_STR,
        Logins : {
            "cognito-idp.us-east-1.amazonaws.com/<cognito-user-pool-id>": token_str_or_null
        }
    });
    ```

<br>

5. 更新後的代碼應類似如下，保存變更。

    ```javascript
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId : CONFIG.COGNITO_IDENTITY_POOL_ID_STR,
        Logins : {
            "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAAA1111": token_str_or_null
        }
    });
    ```

<br>

6. 此代碼片段使用 `COGNITO_IDENTITY_POOL_ID_STR` 變數來請求身份池中的 AWS 憑證。該代碼還傳遞了user pool ID 和 `token_str_or_null`（保存身份驗證憑證）。身份池會使用這些資訊來驗證使用者，如果驗證通過，身份池會向應用程式返回 AWS 憑證。

<br>

## 推送更新至 S3 Bucket

1. 運行以下指令將網站代碼上傳到 S3，將 `<s3-bucket>` 替換為記錄的 S3 Bucket 名稱。

    ```bash
    cd /home/ec2-user/environment
    aws s3 cp website s3://<s3-bucket>/ --recursive --cache-control "max-age=0"
    ```

<br>

## 確認 Node 伺服器是否正在運行

1. 如果伺服器未在運行，運行以下指令重新啟動伺服器：

    ```bash
    cd /home/ec2-user/environment/node_server
    npm start
    ```

<br>

2. 經過這些更新，Birds 應用程式現在可以正確與 Cognito 身份池進行整合，確保使用者在身份驗證後能夠獲得 AWS 憑證並進行授權。

<br>

___

_END_