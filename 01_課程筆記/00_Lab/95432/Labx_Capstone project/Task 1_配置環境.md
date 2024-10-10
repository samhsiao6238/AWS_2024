# Task 1：配置開發環境

_從配置環境開始_

<br>

## 觀察 CapstoneGlueRole 角色

1. 進入 IAM，在 Roles 中搜尋預先建立好提供 Lab 使用的角色 `CapstoneGlueRole`，並點擊查看詳細信息。

    ![](images/img_01.png)

<br>

2. 在 Permissions 頁籤中可看到三個 Policy，這三個都是 AWS 預設的；其中 `AmazonAthenaFullAccess` 允許對 Athena 的完全存取權限，`AmazonS3FullAccess` 允許對 Amazon S3 Bucket 的完全存取權限，`AWSGlueServiceRole` 則是提供 AWS Glue 服務進行爬網、ETL 操作時所需的執行角色和權限。

    ![](images/img_02.png)

<br>

3. `Trust relationship` 是定義哪些實體被授權扮演特定的 IAM 角色，被授權的信任實體能夠以該角色的身份執行操作，這個實體可以是服務、使用者或另一個角色；以下的信任關係設定允許 `AWS Glue` 服務根據需求來假設該角色的權限，進而執行諸如資料爬網、ETL 等任務。

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "glue.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```

<br>

## 補充說明

_針對前項 IAM 的補充_

<br>

1. AWS 的 Policy 分為 `預設（Managed Policies）` 和 `自訂（Custom Policies）` 兩類，預設的 Policy 由 AWS 提供和管理，自訂的 Policy 由使用者自行建立和管理。

<br>

2. 在 AWS 中，`假設（Assume）角色` 指的是一個實體 _暫時獲得_ 該角色的權限，這個實體並不長久持有該角色的權限，而是透過 _**假設**_ 這個角色來臨時擁有其權限；這種機制是透過 AWS 的 `STS（Security Token Service）` 完成的，它會向實體提供一個臨時的安全憑證，使其能夠以該角色的身份執行操作。因此，在信任關係中，`AWS Glue` 等服務是 _**假設**_ 這個角色來獲得必要的權限進行操作，也就是說 Glue 服務並不永久擁有該角色的權限，而是根據需求在指定的操作期間臨時使用該角色的權限。

<br>

## 進入 Cloud9

_建立開發環境_

<br>

1. 建立新環境。

    ![](images/img_03.png)

<br>

2. 設置環境名稱為 `CapstoneIDE`，其餘使用預設，包含選擇建立新的 EC2 實例、使用 t2.micro 型號實例。

    ![](images/img_04.png)

<br>

3. 在 Network settings 中，選擇 `Secure Shell(SSH)`。

    ![](images/img_07.png)

<br>

4. 展開 VPC settings，在下拉選單中分別選取 `Capstone VPC`、`Capstone public subnet`；這是 Lab 預先準備好的設定。

    ![](images/img_05.png)

<br>

5. 然後點擊右下角的 `Create`。

    ![](images/img_06.png)

<br>

## 進入 S3

_在 `us-east-1` 區域中建立兩個 S3 Bucket，這是 Lab 預設的區域_

<br>

1. 確認當前所在區域為 `N.Virginia`，也就是 `us-east-1`。

    ![](images/img_49.png)

<br>

2. 點擊 `Create bucket` 並命名為 `data-source-99991`；`99991` 可以是隨機數字，其餘使用預設，然後點擊右下角 `Create bucket`；這裡依據教程的指引使用 _五碼_ 自訂數字，實務上只要名稱可唯一識別即可。

    ![](images/img_08.png)

<br>

3. 比照前一步驟模式建立第二個 Bucket，命名使用相同尾綴 `99991`，完整命名為 `query-results-99991`；其餘不贅述。

    ![](images/img_09.png)

<br>

4. 完成時可在清單中再次確認兩個 Bucket 的命名與區域正確無誤。

    ![](images/img_10.png)

<br>

## 返回 Cloud9

_下載三個 .csv 源數據文件_

<br>

1. 進入 Cloud9 後，在前面步驟建立的 `CapstoneIDE` 環境對象中點擊 `Open` 開啟 IDE。

    ![](images/img_50.png)

<br>

2. 在終端中運行以下命令，這會下載所需的三個 CSV 檔案；這裡加上 `&&` 只是懶得再逐一按 `ENTER`，不是必須的。

    ```bash
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-capstone/s3/SAU-GLOBAL-1-v48-0.csv && \
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-capstone/s3/SAU-HighSeas-71-v48-0.csv && \
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-capstone/s3/SAU-EEZ-242-v48-0.csv
    ```

    ![](images/img_11.png)

<br>

3. 使用以下命令查看 `SAU-GLOBAL-1-v48-0.csv` 文件的欄位標題和前五行數據。

    ```bash
    head -6 SAU-GLOBAL-1-v48-0.csv
    ```

    ![](images/img_12.png)

<br>

## 數據集簡介

_僅說明結構，詳細內容請參考 `README`_

<br>

1. 數據集包含 `561,675` 行，欄位有 `捕撈年份`、`捕撈國家（fishing_entity）`、`捕撈噸數` 和 `捕撈價值`，其中價值是以 `2010 年美元` 計算；這些數據涵蓋了 `1950` 年至 `2018` 年之間全球高海域的捕撈數據，不包括任何國家 `專屬經濟區（EEZ）內` 的捕撈活動。

<br>

2. 可以使用以下命令確認行數。

    ```bash
    wc -l SAU-GLOBAL-1-v48-0.csv
    ```

    ![](images/img_13.png)

<br>

## 轉換數據格式

_將 `CSV` 文件轉換為 `Parquet` 格式；該格式具備空間效率、查詢性能、高效壓縮、高度兼容等特性_

<br>

1. 安裝所需工具；依據官方說明是使用以下指令。

    ```bash
    sudo pip3 install pandas pyarrow fastparquet
    ```

<br>

2. 依照官方指引安裝會出現以下錯誤。

    ![](images/img_14.png)

<br>

## 修正教程指引

_排除以上錯誤並完成安裝與後續操作；以下操作同樣在 Cloud9 的終端進行。_

<br>

1. 先建立虛擬環境；自訂名稱為 `envCapstone`。

    ```bash
    python3 -m venv envCapstone
    ```

<br>

2. 啟用虛擬環境。

    ```bash
    source envCapstone/bin/activate
    ```

<br>

3. 重新安裝套件。

    ```bash
    pip install pandas pyarrow fastparquet
    ```

<br>

4. 開啟 Python 交互式環境。

    ```bash
    python3
    ```

<br>

5. 使用以下 Python 代碼將 `CSV` 文件轉換為 `Parquet` 格式。

    ```bash
    import pandas as pd
    df = pd.read_csv('SAU-GLOBAL-1-v48-0.csv')
    df.to_parquet('SAU-GLOBAL-1-v48-0.parquet')
    ```

<br>

6. 退出交互式環境。

    ```bash
    exit()
    ```

<br>

7. 關閉虛擬環境。

    ```bash
    deactivate
    ```

<br>

## 上傳文件到 S3 Bucket 

1. 上傳 `SAU-GLOBAL-1-v48-0.parquet` 文件至 `data-source` Bucket。

    ```bash
    aws s3 cp SAU-GLOBAL-1-v48-0.parquet s3://data-source-99991
    ```

<br>

2. 可前往 S3 查看。

    ![](images/img_15.png)

<br>

___

_END_