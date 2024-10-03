# 新增 IAM 用戶

<br>

## 操作步驟

1. 搜尋 `IAM` 並加入快捷鍵，接著點擊進入。

    ![](images/img_15.png)

<br>

2. 點擊左側的使用者 `Users`。

    ![](images/img_16.png)

<br>

3. 點擊建立使用者 `Create user`。

    ![](images/img_17.png)

<br>

4. 自訂使用者名稱如 `sam6239`，並勾選 `提供使用者對 AWS 管理主控台的存取權` 後勾選 `我想要建立 IAM 使用者`。

    ![](images/img_18.png)

<br>

5. 使用自訂產生的密碼，另外取消預設的更新密碼選項，接著進入下一步 `Next`。

    ![](images/img_19.png)

<br>

6. 這裡無論選哪個項目都無妨，預設是 `Add user to group`，點擊下一步 `Next`。

    ![](images/img_20.png)

<br>

7. 檢視設定後，點擊右下角的建立使用者 `Create user`。

    ![](images/img_21.png)

<br>

8. 完成建立 IAM 用戶，先點擊 `下載 .csv 檔案`，這會將帳號密碼下載到本地，然後再點擊返回使用者清單 `Return to users list`；這裡若為下載文件，會跳出視窗再次提醒，務必確認保存了必要資訊。

    ![](images/img_22.png)

<br>

9. 接著會看到添加的個 IAM 用戶在 Users 清單中。

    ![](images/img_23.png)

<br>

10. 進入本機下載資料夾，查看前面步驟下載的密鑰文件，這個文件會以 `使用者名稱` 作為前綴命名。

    ![](images/img_24.png)

<br>

11. 文件內容是使用者名稱 `User name`、密碼 `Password` 與 URL；這些資訊是用於讓新的 IAM 使用者首次登入 AWS 管理控制台使用。

    ![](images/img_25.png)

<br>

## 新 IAM 用戶登入

1. 可以點擊 `*credentials.csv` 文件中的 `Console sign-in URL` 開啟主控台登入頁面，會自訂填入 `Account ID`。

    ![](images/img_14.png)

<br>

2. 或是使用官方登入畫面，選擇 `IAM user` 進行登入。

    ![](images/img_56.png)

<br>

3. 在 `Account ID` 部分，參考 `*credentials.csv` 文件中的這 12 碼數字就是帳號的 ID。

    ![](images/img_53.png)

<br>

4. 自動或手動填入 ID後，接著依照文件內的名稱與密碼進行登入。

    ![](images/img_54.png)

<br>

5. 第一次登入會提示修改密碼；特別注意，修改之後若為自動進入主控台，就代表所修改的密碼不合規範，一但合乎規範就會自動進入主控台，截至目前（2024/07/21）這裡還有 Bug，不會提示更新失敗。

    ![](images/img_55.png)

<br>

## 建立使用者密鑰

1. 在 IAM 服務中，點擊進入使用者 `Users` 後，先點擊指定的用戶帳如 `sam6239` 中。

    ![](images/img_57.png)

<br>

2. 滑動到下方，切換頁籤 `Security credentials`，點擊建立存取金鑰 `Create access key`。

    ![](images/img_26.png)

<br>

3. 選取 `指令列介面` 後勾選下方的 `確認`，緊接著進入 `下一步`。

    ![](images/img_27.png)

<br>

4. 任意描述後，點擊右下角的 `Create access key`。

    ![](images/img_28.png)

<br>

5. 與前面步驟相同，先點擊 `下載 .csv 檔案`，然後完成 `Done`。

    ![](images/img_29.png)

<br>

6. 這個檔案與前面的 `*credentials.csv` 不同，這時下載的文件名稱是 `*accessKeys.csv`。

    ![](images/img_30.png)

<br>

7. 文件內容如下，這是在程式碼或應用程序中以程式化的方式訪問 AWS 服務時使用。

    ![](images/img_58.png)

<br>

___

_END_