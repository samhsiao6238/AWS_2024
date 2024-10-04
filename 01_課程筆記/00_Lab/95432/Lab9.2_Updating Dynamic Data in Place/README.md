# Updating Dynamic Data in Place


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