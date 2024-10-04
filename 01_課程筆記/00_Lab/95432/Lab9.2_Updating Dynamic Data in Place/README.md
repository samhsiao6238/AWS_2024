# Updating Dynamic Data in Place


### 任務 8：恢復架構變更
你將恢復原始架構，並驗證是否能夠繼續進行數據分析。

#### 步驟：
1. 在 KDG 工具中恢復為原始架構，並向 Kinesis 發送數據。
2. 在 Athena 中查詢，確認新列 `new_column` 的數據被處理為空值。

### 總結：
你已成功創建 Hudi 連接，並使用自定義 Python 腳本讀取 Kinesis 數據流數據，並使用 Athena 查詢數據變化。