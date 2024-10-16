# 本地環境設定

<br>

## 步驟說明

1. 當運行 Lab 的 `boto3`，必須設置 `AWS Configure`。

<br>

2. 進入 Lab 首頁點擊 `Details` > `Show` 查看。

    ![](images/img_01.png)

<br>

3. 點擊 `Show`。

    ![](images/img_02.png)

<br>

4. 複製。

    ![](images/img_03.png)

<br>

5. 開啟終端機運行指令。

    ```bash
    aws configure
    ```

<br>

6. 輸入 `ID`。

    ![](images/img_04.png)

<br>

7. 輸入 `Key`。

    ![](images/img_05.png)

<br>

8. 手動設定 Token；特別注意，即便運行過 `AWS configure` 設置 `id` 及 `key`，一樣要運行以下三行指令才能順利完城。

    ```bash
    export AWS_ACCESS_KEY_ID=<複製-ID-貼上>
    export AWS_SECRET_ACCESS_KEY=<複製-KEY-貼上>
    export AWS_SESSION_TOKEN=<複製-TOKEN-貼上>
    ```

    ![](images/img_06.png)

<br>

9. 透過指令查詢當前登入的使用者。

    ```bash
    aws sts get-caller-identity
    ```

    ![](images/img_07.png)

<br>

___

_END_