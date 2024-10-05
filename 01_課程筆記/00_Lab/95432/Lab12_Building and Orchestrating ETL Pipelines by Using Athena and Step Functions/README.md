# 主題：使用 Athena 和 Step Functions 架構與編排 ETL 管道

_Building and Orchestrating ETL Pipelines by Using Athena and Step Functions_

<br>

## 說明

1. 在這個 Lab 中將使用 `AWS Step Functions` 建立一個包含 `S3`、`Glue Data Catalog` 和 `Athena` 的 `ETL(Extract、Transform、Load)` 管道來處理大規模數據集。  

<br>


2. `Step Functions` 能幫助自動化業務流程，這些流程被稱為 `狀態機`，這個 Lab 將使用 `Step Functions` 來建立工作流程，讓 `Athena` 執行一系列操作，例如執行查詢來檢查 AWS Glue 表是否存在。

<br>


3. `AWS Glue Data Catalog` 提供持久的元數據存儲，包括表定義、架構和其他控制信息，這些信息將幫助建立 ETL 管道。`Athena` 是一個無伺服器的互動式查詢服務，通過標準 SQL 簡化了對 Amazon S3 中數據的分析。

<br>


4. 過程中將設計一個工作流程，如果 AWS Glue 表不存在，工作流程將調用其他 Athena 查詢來創建它們。如果表已經存在，則會執行其他 AWS Glue 查詢，來在 Athena 中創建一個從兩個表合併數據的視圖。隨後可以查詢該視圖，以在大規模數據集中發現基於時間和位置的有趣信息。

    ![](images/img_01.png)

<br>


## Scenario

1. 先前曾建立了一個 `概念驗證（POC）` 來展示如何使用 AWS Glue 推斷數據架構並手動調整列名，隨後使用 Athena 查詢數據。每次開始新項目時，必須執行許多手動步驟，所以創建一個可重複使用的數據管道，以幫助快速啟動新的數據處理項目。

<br>


2. 這個 Lab 項目是研究紐約市的出租車數據，已經知道表數據的列名，並且已為創建了視圖和數據導入的 SQL 命令，接下來想研究 2020 年初的紐約市出租車使用模式。希望按月份將表數據分區並以 Parquet 格式存儲，並使用 Snappy 壓縮以提高效率和降低成本，由於這是 `概念驗證`，所以可使用硬編碼的值來處理列名、分區、視圖和 S3 桶資訊。

<br>


3. Lab 已提供以下資源：訪問出租車數據的鏈接、要創建的分區（pickup_year 和 pickup_month）、SQL 導入腳本、用於此項目的 SQL 視圖創建腳本。

    ![](images/img_02.png)

<br>


4. 完成時將創建出第二張圖示所示的架構。

<br>

___

_END_