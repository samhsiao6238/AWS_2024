# Task 1：準備實驗環境

_開始之前，先將一些文件匯入 Cloud9，並安裝所需的包，以便正確配置實驗環境。_

<br>

## 連接到 Cloud9 IDE

1. 進入 `Cloud9`，在 Lab 預設的實例 `Cloud9 Instance` 右側點擊 `Open` 進入 `IDE`。

<br>

2. 進入後先新增一個 `File` 並貼上以下內容，在之後的步驟中用於記錄重要資訊備用，然後使用組合鍵將文件儲存為 `MyDoc.txt`。

    ```bash
    CloudFront Domain:
    AWS Account ID:
    ```

<br>

3. 在終端機中運行以下指令，這會下載 Lab 所需的設置腳本到當前資料夾，也就是 `home/ec2-user/environment`；下載後會增加一個壓縮檔 `code.zip`。

    ```bash
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-EDBLDR-1-107430/03-lab-step/code.zip -P /home/ec2-user/environment
    ```

<br>

4. 運行以下指令解壓文件並啟動設置腳本 `setup.sh`，如此便完成 Lab 環境設置。

    ```bash
    unzip code.zip
    cd /home/ec2-user/environment/resources
    . ./setup.sh
    ```

<br>

5. 設置腳本完成後，在終端中會顯示 CloudFront 分發域名，將此域名記錄在 `MyDoc.txt`。

    ![](images/img_23.png)

<br>

___

_END_