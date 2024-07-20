# 在 VSCode 使用 AWS

<br>

## 步驟

1. 下載 AWS Access Key 文件；參考前面小節 _建立密鑰_ 說明。

<br>

2. 使用組合鍵 `SHIFT+command+P` 開啟 _命令選擇區_，輸入 `Connect to AWS`。

    ![](images/img_17.png)

<br>

3. 會看到幾個選項，可使用現有的連線 `profile`，或是編輯現有的憑證 `Edit Credentials`，或是建立新的連線 `Add New Connection`。

    ![](images/img_28.png)

<br>

## 編輯憑證

1. 點擊 `Edit Credentials`。

    ![](images/img_18.png)

<br>

2. 會開啟兩個視窗，分別是 `config`、`credentials`，手動將下載的 `.csv` 密鑰文件內容填入；特別注意，這組設定的 `default` 就是設定值的 `Profile Name`，可以修改，但必須一致。

    ![](images/img_19.png)

<br>

3. 這兩個文件在本機的位置是 `~/.aws`，可透過指令 `ls -l ~/.aws` 進行觀察。

    ![](images/img_29.png)

<br>

## 使用插件

1. 點擊左側插件圖標 `AWS`。

    ![](images/img_21.png)

<br>

2. 假如還沒連線，點擊 `Select a connection`。

    ![](images/img_20.png)

<br>

3. 點擊 `Add new connection`。

    ![](images/img_22.png)

<br>

4. 選取 `IAM Credentials` 並點擊 `Continue`。

    ![](images/img_23.png)

<br>

5. 任意命名如 `sam6239`，`Axxess Key` 就是 `Access key ID`，`Secret Key` 就是 `Secret access key`。

    ![](images/img_26.png)

<br>

6. 完成後再查看 `credentials` 就會看到新增這個密鑰設定。

    ![](images/img_24.png)

<br>

7. 假如要登出。

    ![](images/img_25.png)

<br>

8. 假如要選取已經存在的連線 `profile`。

    ![](images/img_27.png)

<br>

## 使用插件

1. 在桌面建立一個資料夾 `00_Lambda_Local` 備用。

    ```bash
    cd ~/Desktop && mkdir 00_Lambda_Local && cd 00_Lambda_Local && code .
    ```

<br>

2. 舉例來說，展開 `Lambda` 後，在 `myFirebase_01` 點擊右鍵，可點擊 `Download`。

    ![](images/img_30.png)

<br>

3. 上方會展開選單，可使用當前預設的路徑，或是選擇任一路徑；這裡使用前面步驟建立的 `00_Lambda_Local `。

    ![](images/img_31.png)

<br>

## 編輯之後

1. 若是測試寫入 Firebase Realtime Database，可修改腳本來觀察。

    ![](images/img_38.png)

<br>

2. 編輯完成，在插件視窗中，選擇所編輯的 Lambda 並點擊右鍵，選擇 `Upload`。

    ![](images/img_33.png)

<br>

3. 在第一個彈出選單中選擇 `Directory`。

    ![](images/img_34.png)

<br>

4. 選擇 `No`。

    ![](images/img_32.png)

<br>

5. 選擇資料夾後點擊 `打開`。

    ![](images/img_35.png)

<br>

6. 彈出視窗中表示 `將立即對所選程式碼發佈為 Lambda 的 $LATEST 版本：myFirebase_01。`，點擊 `YES`。

    ![](images/img_36.png)

<br>

7. 完成時右下角顯示 `uploaded`。

    ![](images/img_37.png)

<br>

8. 近入 AWS 控制台，這裡是看不到壓縮的文件內容，切換到 `Test` 進行測試，完成時會顯示成功，資料庫也會更新。

    ![](images/img_39.png)

<br>

___

_END_