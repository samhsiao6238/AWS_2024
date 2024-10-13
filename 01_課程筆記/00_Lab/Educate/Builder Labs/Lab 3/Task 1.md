# Task 1：準備實驗環境

_開始之前，先將一些文件匯入 Cloud9，並安裝所需的包，以便正確配置實驗環境。_

<br>

## 連接到 Cloud9 IDE

1. 進入 Cloud9，點擊預設 Instance 右側的 `Open` 進入 `IDE`。

<br>

2. 為了便於稍後步驟中的資料存儲，在選擇的文字編輯器中貼上以下信息，並在進行實驗時更新這些資訊。

    ```bash
    CloudFront Domain:
    AWS Account ID:
    ```

<br>

3. 在終端機中運行以下指令，這會下載 Lab 所需的設置腳本到 `home/ec2-user/environment` 目錄中。

    ```bash
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-EDBLDR-1-107430/03-lab-step/code.zip -P /home/ec2-user/environment
    ```

<br>

4. 運行以下指令解壓文件並啟動設置腳本，以完成實驗環境的設置。

    ```bash
    unzip code.zip
    cd /home/ec2-user/environment/resources
    . ./setup.sh
    ```

<br>

5. 設置腳本完成後，在終端中會顯示 CloudFront 分發域名，將此域名記錄在之前的文字編輯器中，因為後續任務中會需要使用此資訊。

<br>

___

_END_