# Task 1：配置開發環境


## 觀察 CapstoneGlueRole 角色

1. 檢查預先建立的角色 `CapstoneGlueRole`，查看奇 AWS 身份與 `IAM` 角色的詳細信息。



## 建立 AWS Cloud9 環境

1. 設置環境名稱為 `CapstoneIDE`。

2. 選擇建立新的 EC2 實例，使用 t2.micro 型號實例。

3. 部署實例以支持通過 SSH 連接到 Capstone VPC，使用 Capstone 公共子網。

4. 其他設置保持預設值。

## 建立兩個 S3 Bucket

1. 在 `us-east-1` 區域中建立兩個 S3 Bucket 。

2. 命名 Bucket，第一個 Bucket 命名為 `data-source-#####`；第二個Bucket 命名為 `query-results-#####`；`#####` 是隨機數字。

3. 其他設置保持預設值。



## 下載三個 .csv 源數據文件

1. 在 Cloud9 IDE 的終端中運行以下命令，下載所需的 CSV 檔案。

```bash
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-capstone/s3/SAU-GLOBAL-1-v48-0.csv
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-capstone/s3/SAU-HighSeas-71-v48-0.csv
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-capstone/s3/SAU-EEZ-242-v48-0.csv
```


2. 使用以下命令查看 `SAU-GLOBAL-1-v48-0.csv` 文件的列標題和前五行數據。

```bash
head -6 SAU-GLOBAL-1-v48-0.csv
```

## 數據分析

1. 每行數據包括捕魚年份、捕魚國家（fishing_entity）、捕魚噸數和魚的價值（以 2010 年美元計算）；這些數據涵蓋了1950年至2018年之間全球高海域的捕魚數據，不包括任何國家專屬經濟區（EEZ）內的捕魚活動。

2. 數據集包含 561,675 行。

3. 可以使用以下命令確認行數。
```bash
wc -l SAU-GLOBAL-1-v48-0.csv
```

## 將 CSV 文件轉換為 Parquet 格式

1. 安裝所需工具。

```bash
sudo pip3 install pandas pyarrow fastparquet
```

2. 使用以下 Python 代碼將 CSV 文件轉換為 Parquet 格式。

```bash
# 開啟 Python 交互式終端
python3

# 使用 pandas 將 CSV 轉換為 Parquet
import pandas as pd
df = pd.read_csv('SAU-GLOBAL-1-v48-0.csv')
df.to_parquet('SAU-GLOBAL-1-v48-0.parquet')

# 退出交互式終端
exit()
```



## 將 Parquet 文件上傳到 S3 Bucket 

1. 使用 AWS CLI 在 Cloud9 終端上傳 SAU-GLOBAL-1-v48-0.parquet 文件至 data-source Bucket。

```bash
aws s3 cp SAU-GLOBAL-1-v48-0.parquet s3://data-source-#####
```