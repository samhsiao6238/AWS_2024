# Task 7: 檢視 Amazon Cognito 群組設定

在此任務中，將檢視 Amazon Cognito 使用者池群組配置及其關聯的 IAM 角色，以了解應用程式如何控制訪問 Step Functions 狀態機器的權限。

## 檢視 Cognito 使用者池群組配置

### 步驟 1：進入 Cognito 使用者池

1. 登入 AWS 管理控制台，從服務選單中搜索並選擇 Cognito。
2. 在使用者池面板中，選擇 `bird_app` 連結。
3. 選擇 Groups（群組）標籤，並點擊 teachers 群組。
4. 在群組資訊窗格中，檢視分配給該群組的 IAM 角色。該角色名為 bird-app-teacher-role。

### 步驟 2：分析 `bird-app-teacher-role` IAM 角色詳細信息

1. 返回 AWS 管理控制台，搜索並選擇 IAM 服務。
2. 在左側導航窗格中，選擇 Roles（角色）。
3. 在角色搜索框中，輸入並選擇 bird-app-teacher-role 角色。
4. 在 Permissions（權限）標籤下，展開 bird-app-teacher-policy 策略。
   - 該策略允許對 Amazon DynamoDB 中的 BirdSightings 資料表以及 MyStateMachine 狀態機器執行相關操作。
5. 選擇 Trust relationships（信任關係）標籤，確認該角色允許 Amazon Cognito 身份服務通過 Web 身份驗證來假設此角色。
   - 當使用者以 `teacher` 身分登入應用程式時，應用程式會使用 bird-app-teacher-role IAM 角色來調用 AWS 服務。

---

## 更新程式碼以調用 StateMachine

在此步驟中，將更新 `mw.js` 檔案，將其中的 `<account-id>` 佔位符替換為實驗環境中的 AWS 帳戶 ID。

### 步驟 1：定位 AWS 帳戶 ID

1. 在 AWS 管理控制台右上角，點擊帳戶名稱。
2. 從下拉選單中複製 Account ID（帳戶 ID）號碼，並將其粘貼到文字編輯器中，供後續步驟使用。

### 步驟 2：更新 `mw.js` 檔案

1. 返回 AWS Cloud9 IDE。
2. 在環境窗格中，展開 `node_server` 資料夾，接著展開 libs 資料夾。
   - 注意：因為應用程式的前端使用了 AWS JavaScript SDK v2，所以無法從瀏覽器直接調用 Step Functions，必須由 node 伺服器來處理這個請求。
3. 開啟名為 `mw.js` 的檔案。

### 步驟 3：配置 IAM 認證

1. 在 `mw.js` 檔案中，找到以下代碼，這部分設定了登入用戶的 IAM 認證：
   ```javascript
   AWS.config.credentials = new AWS.CognitoIdentityCredentials({
       IdentityPoolId : process.env.COGNITO_IDENTITY_POOL_ID,
       Logins : {
           "cognito-idp.us-east-1.amazonaws.com/<cognito-user-pool-id>": bearer_str
       }
   });
   ```
   - 注意：您不會在代碼中看到 `<cognito-user-pool-id>` 佔位符，因為實驗環境中的設置腳本已經將該佔位符更新為 Amazon Cognito 使用者池 ID。

### 步驟 4：配置 Step Functions AWS SDK 客戶端

1. 下方代碼用於配置 Step Functions SDK 客戶端：
   ```javascript
   var stepFunction = new AWS.StepFunctions({apiVersion: '2016-11-23'});
   ```

2. 接下來設定調用參數：
   - stateMachineArn：狀態機器的 ARN，是所配置狀態機器的唯一識別符。
   - input：應用程式要傳遞給狀態機器的數據。在這裡，傳遞的是一個空的 JSON 對象。
   - name：調用狀態機器的唯一標識符，該值必須唯一，因此代碼會將一個唯一的 ID 追加至名稱。
   ```javascript
   var params = {
     stateMachineArn: 'arn:aws:states:us-east-1:<aws-account>:stateMachine:MyStateMachine',
     input: '{}',
     name: 'CreateReport' + id
   };
   ```

### 步驟 5：調用狀態機器

1. 最後，這段代碼將調用狀態機器，並使用已定義的參數發起 `startExecution` 操作：
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

### 步驟 6：更新 ARN 並啟動 node 伺服器

1. 在 `mw.js` 檔案中，找到 `<aws-account>` 佔位符，並將其替換為 AWS 帳戶 ID。例如：
   ```javascript
   stateMachineArn: 'arn:aws:states:us-east-1:1234567890:stateMachine:MyStateMachine',
   ```
2. 保存修改後的檔案。
3. 返回 AWS Cloud9 終端，運行以下指令來啟動 node 伺服器：
   ```bash
   cd /home/ec2-user/environment/node_server
   npm start
   ```
4. 當 node 伺服器啟動後，應在終端看到如下輸出：
   ```
   > start
   > REGION_STR=us-east-1 node index.js

   Live on port: 8080
   ```

## 結論

此任務的主要目標是通過檢視 Amazon Cognito 使用者群組配置，確保授予特定 IAM 角色的權限允許應用程式訪問所需的 AWS 服務。隨後，更新應用程式代碼以配置對 Step Functions 狀態機器的調用，並運行 node 伺服器來完成應用程式的執行。