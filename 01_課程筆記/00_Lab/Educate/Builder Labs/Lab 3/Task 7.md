# Task 7：審查 Amazon Cognito 群組配置

_在這個任務中，將審查 Amazon Cognito 使用者池中的群組配置，並瞭解如何通過 IAM 角色來控制應用程式訪問 Step Functions 狀態機。接著，您將更新應用程式代碼以調用狀態機。_

## 審查 Amazon Cognito 使用者池群組配置

1. 打開 Cognito：
   - 在 AWS 管理控制台中，搜尋並選擇 Cognito 服務。
   - 如果頁面上有 "Try out the new interface" 的鏈接，請選擇它。
   - 在 User pools 頁面中，選擇 `bird_app` 鏈接。
   - 選擇 Groups 標籤，然後選擇 teachers 群組。

2. 審查與 teachers 群組相關聯的 IAM 角色：
   - 在群組資訊面板中，您會看到分配給 teachers 群組的 IAM 角色為 `bird-app-teacher-role`。

#### 2. 分析 `bird-app-teacher-role` IAM 角色

1. 檢查 `bird-app-teacher-role` IAM 角色：
   - 在 AWS 管理控制台中，搜尋並選擇 IAM。
   - 選擇 Roles，並在搜尋框中搜尋 `bird-app-teacher-role`。
   - 選擇該角色，然後進入 Permissions 標籤，展開 bird-app-teacher-policy。
   - 該策略允許對 Amazon DynamoDB 中的 BirdSightings 表，以及 Amazon Step Functions (`states`) 中的 MyStateMachine 狀態機進行操作。
   
2. 審查信任關係：
   - 選擇 Trust relationships 標籤。
   - 注意到該角色允許 Amazon Cognito Identity 服務在經過身份驗證後，通過 Web 身份來假設這個角色。

   當使用者以 `teacher` 身份登錄應用程式時，他們的應用程式會話將使用 `bird-app-teacher-role` IAM 角色來調用 AWS 服務。

#### 3. 更新代碼以調用狀態機

1. 更新 `mw.js` 文件：
   - 返回 AWS Cloud9 IDE。
   - 展開 node_server 資料夾，然後展開 libs 資料夾。
   - 打開名為 `mw.js` 的文件。
   - 找到用於配置登錄使用者 IAM 憑證的代碼片段：
     ```javascript
     AWS.config.credentials = new AWS.CognitoIdentityCredentials({
         IdentityPoolId: process.env.COGNITO_IDENTITY_POOL_ID,
         Logins: {
             "cognito-idp.us-east-1.amazonaws.com/<cognito-user-pool-id>": bearer_str
         }
     });
     ```
   - 確認 `<cognito-user-pool-id>` 已被替換為真實的 Cognito 使用者池 ID，這是在實驗環境中已自動設置的。

2. 配置 Step Functions 客戶端：
   - 下一段代碼配置了 Step Functions AWS SDK 客戶端：
     ```javascript
     var stepFunction = new AWS.StepFunctions({apiVersion: '2016-11-23'});
     ```

3. 設置調用參數：
   - 定義調用參數，包括 `stateMachineArn`、`input` 和 `name`：
     ```javascript
     var params = {
       stateMachineArn: 'arn:aws:states:us-east-1:<aws-account>:stateMachine:MyStateMachine',
       input: '{}',
       name: 'CreateReport' + id
     };
     ```
   - 使用 `AWS Account ID` 替換 `<aws-account>` 占位符。

4. 啟動狀態機調用：
   - `callStateMachine` 函數用於調用狀態機：
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

5. 更新 `stateMachineArn`：
   - 在 `mw.js` 中找到 `<aws-account>` 占位符，並使用真實的 AWS 帳戶 ID 進行替換。

   更新後的代碼應類似於：
   ```javascript
   stateMachineArn: 'arn:aws:states:us-east-1:1234567890:stateMachine:MyStateMachine',
   ```

6. 保存修改：
   - 保存您的更改，並關閉文件。

#### 4. 啟動 Node Server

1. 啟動 Node 服務器：
   - 在 AWS Cloud9 終端中運行以下指令：
     ```bash
     cd /home/ec2-user/environment/node_server
     npm start
     ```

2. 檢查輸出：
   - 成功啟動服務後，終端應顯示類似於以下的輸出：
     ```bash
     > start
     > REGION_STR=us-east-1 node index.js
     Live on port: 8080
     ```

至此，您已經成功更新了代碼以調用狀態機，並啟動了 Node 服務器以支持應用程式的運行。