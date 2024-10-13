_特別注意，這個 Lab 錯誤將 Task 5 標注為 Task 6，所以有兩個 Task 6_

### Task 5: 使用 put 方法將單筆記錄新增至資料表

在此任務中，將更新 Birds 應用程式，讓學生可以透過「Report」頁面新增觀察記錄。

#### 步驟 1：檢視並更新 `templates_with_add_sighting.js` 檔案

1. 返回 AWS Cloud9 IDE 的瀏覽器標籤。

2. 檢視 `templates_with_add_sighting.js` 檔案：
   - 在終端機左側的 Environment 視窗中，展開 `website` 資料夾，然後展開 `scripts` 資料夾。
   - 找到並打開 `templates_with_add_sighting.js` 檔案。

3. 檢視 `addSighting` 函數（大約在第 19 行）：
   - 該函數包含參數變數 `params`，該變數指定了 `put` 方法將接收新記錄的資料表名稱。此函數還將學生在網頁上輸入的數據對應到資料表的屬性：
     ```javascript
     var params = {
       TableName: '<table_name>',
       Item: {
         '<table-partition-key>': id,
         '<table-sort-key>': username,
         'bird_name_str': bird_name,
         'location_str': location,
         'count_int': parseInt(count),
         'date_int': date_int,
         'class_level_str': grade_level
       }
     };
     ```

4. 檢視 `addItem` 函數（大約在第 67 行）：
   - 該函數通過 `params` 變數將參數傳遞給 `put` 方法，並將單筆記錄新增至資料表：
     ```javascript
     async function addItem(){
     try {
       const data = await docClient.put(params).promise();
       return data;
     } catch (err) {
       return err;
     }
     }
     ```

5. 更新 `templates_with_add_sighting.js` 文件：
   - 將以下佔位符替換為適當的值：
     - `<table_name>`：`BirdSightings`
     - `<table-partition-key>`：`id`
     - `<table-sort-key>`：`student_name_str`
   
   更新後的程式碼如下：
   ```javascript
   var params = {
     TableName: 'BirdSightings',
     Item: {
       'id': id,
       'student_name_str': username,
       'bird_name_str': bird_name,
       'location_str': location,
       'count_int': parseInt(count),
       'date_int': date_int,
       'class_level_str': grade_level
     }
   };
   ```

6. 儲存更改並關閉檔案。

#### 步驟 2：更新網站程式碼並上傳至 S3

1. 在 AWS Cloud9 終端機中運行命令更新網站程式碼：
   - 執行以下命令來替換舊版腳本：
     ```bash
     cp /home/ec2-user/environment/website/scripts/templates_with_add_sightings.js /home/ec2-user/environment/website/scripts/templates.js
     ```

2. 將更新的網站程式碼上傳至 S3：
   - 切換至 `resources` 資料夾並運行以下命令：
     ```bash
     python /home/ec2-user/environment/resources/upload_website_code.py
     ```

#### 步驟 3：測試 Report 頁面

1. 返回 Birds 應用程式的瀏覽器標籤，並選擇「REPORT」頁面。
   
2. 刷新瀏覽器頁面：
   - 頁面現在應顯示一個表單，允許用戶報告新的鳥類觀察數據。
   - 如果表單未顯示，可能需要多次刷新頁面。

3. 使用表單新增鳥類觀察記錄：
   - 使用表單新增兩到三筆新的觀察記錄。確保每個欄位都正確填寫。
   - 注意：在年級欄位中，選擇「3rd Grade」。

4. 檢視新增的觀察記錄：
   - 選擇「SIGHTINGS」頁面。
   - 除了前一任務中已經找到的鳥類觀察記錄外，現在還應能看到剛剛輸入的新記錄。

#### 總結

透過完成這項任務，學生現在可以直接在鳥類觀察發生的同時通過「Report」頁面新增記錄。這項功能允許 Ms. García 和學生即時訪問觀察記錄，無需再等待批次上傳。