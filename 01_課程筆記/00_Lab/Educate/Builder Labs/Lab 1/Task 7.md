# Task 7: 檢視 Amazon Cognito 群組設定

_在此任務中，將檢視 Amazon Cognito 使用者池群組配置及其關聯的 IAM 角色，以了解應用程式如何控制訪問 Step Functions 狀態機器的權限。_

<br>

## 進入 Cognito 使用者池

1. 進入 `Cognito`。

<br>

2. 在使用者池面板中，選擇 `bird_app` 連結。

<br>

3. 選擇 `Groups` 標籤，並點擊 `teachers` 群組。

<br>

4. 在群組資訊窗格中，檢視分配給該群組的 IAM 角色。該角色名為 `bird-app-teacher-role`。

<br>

## 分析 `bird-app-teacher-role` IAM 角色詳細信息

1. 進入 IAM 服務。

<br>

2. 在左側欄選擇 Roles。

<br>

3. 在角色搜尋框中，輸入並選擇 `bird-app-teacher-role`。

<br>

4. 在 `Permissions` 標籤下，展開 `bird-app-teacher-policy` 策略。

<br>

5. 該策略允許對 Amazon DynamoDB 中的 BirdSightings 資料表以及 `MyStateMachine` 狀態機器執行相關操作。

<br>

6. 選擇 `Trust relationships` 標籤，確認該角色允許 Amazon Cognito 身份服務通過 Web 身份驗證來假設此角色。

<br>

7. 當使用者以 `teacher` 身分登入應用程式時，應用程式會使用 `bird-app-teacher-role IAM` 角色來調用 AWS 服務。

<br>

## 更新程式碼以調用 StateMachine

_在以下步驟中，將更新 `mw.js` 檔案，將其中的 `<account-id>` 佔位符替換為實驗環境中的 AWS 帳戶 ID。_

<br>

## 定位 AWS 帳戶 ID

1. 在 AWS 管理控制台右上角，點擊帳戶名稱。

<br>

2. 從下拉選單中複製 `Account ID`，並將其貼到文字編輯器中，供後續步驟使用。

<br>

## 更新 `mw.js` 檔案

_返回 AWS Cloud9 IDE_

<br>

1. 在左側欄展開 `node_server` 資料夾，接著展開 `libs` 資料夾。

<br>

2. 因為應用程式的前端使用了 `AWS JavaScript SDK v2`，所以無法從瀏覽器直接調用 `Step Functions`，必須由 `node 伺服器` 來處理這個請求。

<br>

3. 開啟名為 `mw.js` 的檔案。

<br>

## 配置 IAM 認證

1. 在 `mw.js` 檔案中，找到以下代碼，這部分設定了登入用戶的 IAM 認證。

    ```javascript
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId : process.env.COGNITO_IDENTITY_POOL_ID,
        Logins : {
            "cognito-idp.us-east-1.amazonaws.com/<cognito-user-pool-id>": bearer_str
        }
    });
    ```

<br>

2. 特別注意，在此並不會在代碼中看到 `<cognito-user-pool-id>` 佔位符，因為 Lab 環境中的設置腳本已經將該佔位符更新為 `Amazon Cognito` 使用者池 ID。

<br>

## 配置 Step Functions AWS SDK 客戶端

1. 下方代碼用於配置 Step Functions SDK 客戶端。

    ```javascript
    var stepFunction = new AWS.StepFunctions({apiVersion: '2016-11-23'});
    ```

<br>

2. 設定調用參數，在 `stateMachineArn` 狀態機器的 ARN，是所配置狀態機器的唯一識別符。

<br>

3. `input` 應用程式要傳遞給狀態機器的數據；在這裡，傳遞的是一個空的 JSON 對象。

<br>

4. `name` 調用狀態機器的唯一標識符，該值必須唯一，因此代碼會將一個唯一的 ID 追加至名稱。

<br>

5. 設置如下。

    ```javascript
    var params = {
        stateMachineArn: 'arn:aws:states:us-east-1:<aws-account>:stateMachine:MyStateMachine',
        input: '{}',
        name: 'CreateReport' + id
    };
    ```

<br>

## 調用狀態機器

1. 最後，這段代碼將調用狀態機器，並使用已定義的參數發起 `startExecution` 操作。

    ```javascript
    async function callStateMachine(){
        console.log('runReport');
        try {
        const data = await stepFunction.startExecution(params).promise();
        return data;
        } catch (err) {
        return err;
        }
    }
    ```

<br>

## 更新 ARN 並啟動 node 伺服器

1. 在 `mw.js` 檔案中，找到 `<aws-account>` 佔位符，並將其替換為 AWS 帳戶 ID，更改後要進行保存。

    ```javascript
    stateMachineArn: 'arn:aws:states:us-east-1:1234567890:stateMachine:MyStateMachine',
    ```

<br>

2. 返回 AWS Cloud9 終端，運行以下指令來啟動 node 伺服器。

    ```bash
    cd /home/ec2-user/environment/node_server
    npm start
    ```

<br>

3. 當 node 伺服器啟動後，會看到如下輸出。

    ```bash
    > start
    > REGION_STR=us-east-1 node index.js

    Live on port: 8080
    ```

<br>

4. 此任務的主要目標是通過檢視 Amazon Cognito 使用者群組配置，確保授予特定 IAM 角色的權限允許應用程式訪問所需的 AWS 服務。隨後，更新應用程式代碼以配置對 Step Functions 狀態機器的調用，並運行 node 伺服器來完成應用程式的執行。

<br>

___

_END_