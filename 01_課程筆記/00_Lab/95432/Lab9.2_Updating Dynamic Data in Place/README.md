# Updating Dynamic Data in Place




### 任務 3：配置 AWS Glue 作業腳本
此任務中，你將檢索並配置 AWS Glue 作業所需的文件。

#### 步驟：
1. 透過 Cloud9 終端下載兩個文件 `glue_job_script.py` 和 `glue_job.template`。
2. 將這些文件上傳到 S3 Bucket，為後續 AWS Glue 作業配置所用。

### 任務 4：配置並運行 AWS Glue 作業
AWS Glue 提供運行 ETL 作業的能力，用於在各數據源之間進行數據複製。

#### 步驟：
1. 使用 CloudFormation 創建 Glue 作業堆疊。
2. 開啟 AWS Glue 控制台，運行名為 `Hudi_Streaming_Job` 的作業，並檢查其運行狀態。

### 任務 5：使用 KDG 向 Kinesis 發送數據
你將使用 Kinesis Data Generator（KDG）工具生成並模擬 IoT 設備的隨機數據，並發送至 Kinesis。

#### 步驟：
1. 打開 KDG 工具，使用指定憑證登錄。
2. 配置數據發送到 Kinesis，並保持 KDG 運行以模擬數據流。

### 任務 6：使用 Athena 檢查架構並查詢數據
你將使用 Athena 檢查表架構，並運行查詢來分析數據。

#### 步驟：
1. 在 AWS Glue 控制台檢查 `hudi_demo_table` 表的架構。
2. 在 Athena 中運行查詢，檢查數據的變化。

### 任務 7：動態更改架構
在此任務中，你將修改來自 KDG 的數據結構，然後在 Athena 中運行查詢，無需更改 AWS Glue 作業或表結構。

#### 步驟：
1. 更改 KDG 工具中的架構，並向 Kinesis 發送數據。
2. 在 Athena 中查詢數據，檢查新列 `new_column` 的值變化。

### 任務 8：恢復架構變更
你將恢復原始架構，並驗證是否能夠繼續進行數據分析。

#### 步驟：
1. 在 KDG 工具中恢復為原始架構，並向 Kinesis 發送數據。
2. 在 Athena 中查詢，確認新列 `new_column` 的數據被處理為空值。

### 總結：
你已成功創建 Hudi 連接，並使用自定義 Python 腳本讀取 Kinesis 數據流數據，並使用 Athena 查詢數據變化。