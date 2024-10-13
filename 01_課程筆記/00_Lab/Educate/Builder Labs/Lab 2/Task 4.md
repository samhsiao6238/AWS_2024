# Task 4：使用 Scan 方法以程式化方式檢索資料

_在此任務中，將更新網站程式碼，使其從 `BirdSightings` 資料表中動態顯示鳥類觀察數據。這樣，當學生將來新增記錄時，這些新記錄將自動顯示在應用程式的 `Sightings` 頁面上。_

<br>

## 檢視程式碼

_返回 Cloud9 IDE_

<br>

1. 在左側的視窗中，依序展開 `website` 資料夾、`scripts` 資料夾，然後找到並點擊開啟 `db_scan.js` 檔案。

    ![](images/img_34.png)

<br>

2. 在第 42 行左右，找到下列代碼，這是用於定義文件客戶端的代碼。這與之前在批次載入腳本中看到的代碼相同。

    ```javascript
    var docClient = new AWS.DynamoDB.DocumentClient(
        {region: "us-east-1"}
    );
    ```

<br>

3. 參數 `params` 定義了傳遞給 Scan 方法的參數，在此例中，該變數指定了要掃描的資料表名稱。

    ```javascript
    var params = {
        TableName: "<table-name>"
    };
    ```

<br>

4. 在第 46 行附近，找到 `getDdbData` 函數。該代碼使用 AWS SDK 的 `scan` 方法向 DynamoDB 傳送掃描請求。參數 `params` 被傳遞給該方法。

    ```javascript
    const data = await docClient.scan(params).promise();
    ```

<br>

## 更新 `db_scan.js` 文件

1. 將 `<table-name>` 替換為 `BirdSightings`。

    ```javascript
    var params = {
        TableName: "BirdSightings"
    };
    ```

<br>

## 更新網站程式碼並上傳到 S3

_在 AWS Cloud9 終端機中運行_

<br>

1. 更新網站程式碼。

    ```bash
    cd /home/ec2-user/environment/website
    cp index_db_scan.html index.html
    cp scripts/templates_sightings_from_db.js scripts/templates.js
    ```

<br>

2. 將更新的網站程式碼上傳至 S3。

    ```bash
    cd /home/ec2-user/environment/resources
    python upload_website_code.py
    ```

<br>

## 測試網站更新

1. 在新的瀏覽器標籤頁中，輸入之前記錄的 CloudFront 分發網域。

<br>

2. 開啟瀏覽器的開發者工具。

<br>

3. 進入 Birds 應用程式並進行登入，選擇 SIGHTINGS 頁籤，選擇 LOGIN，並輸入以下憑證 Username 為 `teststudent`、Password 為 `Welcome1!`；當系統提示選擇新密碼時，輸入記得的密碼（例如 `Welcome123!`），並在記錄檔中記下新密碼。

<br>

4. 返回 SIGHTINGS 頁面，應顯示所有 25 筆鳥類觀察記錄。

<br>

## 更新程式碼以只顯示已登入學生的數據

1. 返回 AWS Cloud9 IDE，在 `website/scripts` 資料夾中找到並打開 `db_scan_filter.js` 檔案。

<br>

2. 將 `<attribute-name>` 替換為 `student_name_str`，儲存更改並關閉檔案。

    ```javascript
    var params = {
        TableName: "BirdSightings",
        FilterExpression: "student_name_str = :student_name_str",
        ExpressionAttributeValues: { ":student_name_str": student }
    };
    ```

<br>

3. 更新網站程式碼並上傳至 S3。

    ```bash
    cd /home/ec2-user/environment/website
    cp index_db_scan_filter.html index.html
    ```

<br>

4. 切換至 `resources` 資料夾並運行命令上傳程式碼。

    ```bash
    cd /home/ec2-user/environment/resources
    python upload_website_code.py
    ```

<br>

5. 返回 Birds 應用程式的瀏覽器標籤頁並刷新頁面，現在應只顯示 `teststudent` 的鳥類觀察記錄。整體來說，這個部分是透過更新網站程式碼以動態檢索並過濾資料，成功將 `BirdSightings` 資料表中的數據顯示在應用程式的 `Sightings` 頁面上；學生可查看自己提交的觀察數據，並確保只有自己的數據被顯示。

<br>

___

_END_