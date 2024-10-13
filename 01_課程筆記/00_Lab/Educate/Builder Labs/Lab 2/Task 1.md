# Task 1：Preparing the lab

<br>

## 連接到 AWS Cloud9 IDE

1. 搜尋並進入 `Cloud9`。

    ![](images/img_13.png)

<br>

2. 點擊現有 `Cloud9 Instance` 右側 `Open` 進入 IDE；保持這個頁面在開啟中。

    ![](images/img_14.png)

<br>

3. 上方會出現紅色警告，可不予理會；在下方終端機中可輸入指令。

    ![](images/img_15.png)

<br>

## 記錄實驗環境的重要信息

3. 使用任何可建立文檔的方式建立一個文檔，編輯內容如下。

    ```bash
    CloudFront distribution domain: 
    Table name: 
    Table partition key: 
    Table sort key:  
    Password:
    Index name:
    Index partition key: 
    Index sort key: 
    ```

<br>

4. 暫時儲存為 `MyDoc.txt`

    ![](images/img_01.png)

<br>

## 下載並設置應用程式代碼

1. 在 Cloud9 終端機中執行以下命令，這是下載並設置實驗所需的應用程式代碼；最後一行指令需要再按一次 `ENTER`。

    ```bash
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-EDBLDR-1-107430/02-lab-ddb/code.zip
    unzip code.zip
    cd resources
    . ./setup.sh
    ```

<br>

2. 當 `setup.sh` 腳本執行完成後，輸出的最後幾行會顯示類似以下的信息。

    ![](images/img_02.png)

<br>

3. 將輸出中的 `CloudFront distribution domain` 紀錄在前面步驟建立的文件中。

    ![](images/img_03.png)

<br>

## 啟動 Node.js 伺服器

1. 運行以下命令啟動 Node.js 伺服器。

    ```bash
    cd /home/ec2-user/environment/node_server
    npm start
    ```

<br>

2. 結果如下。

    ![](images/img_04.png)

<br>

## 監控 CloudFront 分發部署

1. 搜尋並進入 `CloudFront`。

<br>

2. 確認 `Distributions` 的狀態為 `Enabled`，至此確保 Lab 環境正確。

    ![](images/img_05.png)

<br>

___

_END_