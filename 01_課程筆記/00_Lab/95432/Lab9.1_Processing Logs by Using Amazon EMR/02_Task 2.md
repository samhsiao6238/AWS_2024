# Task 2：透過SSH連接Hadoop主節點

<br>

## 在 EMR 複製 DNS

1. 複製公共 DNS `ec2-3-95-6-4.compute-1.amazonaws.com`。

    ![](images/img_27.png)

<br>

## 前往 Cloud9

1. 進入 Cloud9，開啟預設的 IDE。

    ![](images/img_28.png)

<br>

2. 添加文件。

    ![](images/img_29.png)

<br>

3. 把前面複製的 DNS 貼在文件中。

    ![](images/img_30.png)

<br>

4. 在 Lab 簡介頁面中，點擊 `AWS Details`。

    ![](images/img_31.png)

<br>

5. 點擊其中的 `Download PEM` 下載文件。

    ![](images/img_32.png)

<br>

6. 會下載文件到本地。

    ![](images/img_33.png)

<br>

## 回到 Cloud9

1. 上傳文件。

    ![](images/img_34.png)

<br>

2. 上傳前一個步驟下載的 `labsuser.pem`；完成後點擊 `X` 關閉彈窗。

    ![](images/img_35.png)

<br>

3. 完成後，在 Cloud9 的左側會看到。

    ![](images/img_36.png)

<br>

4. 在終端機中使用 `ls` 指令確認文件在當前路徑中。

    ![](images/img_37.png)

<br>

5. 依照 AWS 規範，要對密鑰文件降低權限。

    ```bash
    chmod 400 labsuser.pem
    ```

<br>

6. 透過指令 `ls -l` 可查看當前路徑中文件的權限設定。

    ![](images/img_38.png)

<br>

## 連線

1. 運行以下指令進行連線，要替換其中的 `<公共DNS>`，這部分已經暫時貼在上方文件中。

    ```bash
    ssh -i labsuser.pem hadoop@<公共DNS>
    ```

<br>

2. 輸入 `yes` 完成連線。

    ![](images/img_39.png)

<br>

___

_END_