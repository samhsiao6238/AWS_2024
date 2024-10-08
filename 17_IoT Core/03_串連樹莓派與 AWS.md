# 串連硬體與服務

<br>

## 進入 AWS

1. 在 `Thing properties` 區塊中，選取 `Choose an existing thing`，並在下方選單中選擇前面步驟建立好的 Thing `Raspi5_AWS_1`；點擊 `Next`。

    ![](images/img_30.png)

<br>

2. 在 `Platform and SDK` 部分，分別選取 `Linux / MacOS` 及 `Python`，然後點擊 `Next`。

    ![](images/img_31.png)

<br>

3. 點擊 `Download connection kit` 下載 Kit，下載後點擊 `Next`。

    ![](images/img_32.png)

<br>

## 回到本機電腦

1. 在下載資料夾中點擊壓縮文件會自動解壓縮，解壓縮後有以下這些檔案，可將解壓縮後的資料夾重新命名，如 `connect_01`。

    ![](images/img_33.png)

<br>

2. 可將這個資料夾透過 VSCode 拖曳到樹梅派專案目錄中，或是透過指令複製；特別注意，複製資料夾時要加上參數 `-r` 遞迴處理。

    ```bash
    scp -r ~/Downloads/connect_01 ssd:~/Documents/exAWS_01/
    ```

<br>

## 在 `connect_01` 資料夾開啟終端機

1. 以下操作在 AWS 主控台皆有指引，可自行查看。

    ![](images/img_34.png)

<br>

2. 修改腳本權限。

    ```bash
    chmod +x start.sh
    ```

<br>

3. 啟動腳本。

    ```bash
    sudo ./start.sh
    ```

<br>

4. 會先開始一些安裝。

    ![](images/img_35.png)

<br>

5. 安裝完成後會啟動。

    ![](images/img_36.png)

<br>

6. 透過 AWS 網頁可看到執行狀況

    ![](images/img_37.png)

<br>

7. 點擊右下角的 `Continue`。

    ![](images/img_38.png)

<br>

8. 會顯示設備已經連線。

    ![](images/img_39.png)

<br>

9. 點擊右下角 `View thing`，會回到 `Raspi5_AWS_1`。

    ![](images/img_40.png)

<br>

___

_END_

