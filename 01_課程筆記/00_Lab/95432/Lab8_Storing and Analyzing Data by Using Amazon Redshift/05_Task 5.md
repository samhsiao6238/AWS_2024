
#### 任務 5: 查詢數據
加載數據後，你可以撰寫 SQL 查詢來生成 Mary 所需的報告。Mary 提供了查詢來統計特定日期銷售的商品數量，以及查詢購買量最多的前 10 名客戶。

步驟包括：
- 使用 SQL 查詢來查詢 `sales` 和 `date` 表格，並找出特定日期的總銷量。
- 使用 SQL 查詢找出購買量最多的 10 位客戶。

#### 任務 6: 使用 AWS CLI 運行查詢
除了通過控制台運行查詢，你還可以使用 Amazon Redshift API、AWS SDK 庫和 AWS CLI 來執行操作。在這個任務中，你將通過 AWS Cloud9 終端執行 AWS CLI 指令，來查詢 Redshift 集群中的數據。

步驟包括：
- 使用 AWS CLI 在 Cloud9 中查詢 Redshift 資料庫。
- 使用 `get-statement-result` 指令檢索查詢結果。

#### 任務 7: 審查對 Redshift 的 IAM 訪問策略
你將審查附加到 DataScienceGroup 群組的 `Policy-For-Data-Scientists` IAM 策略，該策略允許使用 Redshift Data API 進行有限的資料庫操作。

步驟包括：
- 審查策略的 JSON，了解授權的動作和資源。

#### 任務 8: 確認使用者可以在 Redshift 資料庫上運行查詢
最後，確認 Mary 能夠透過 Redshift 查詢數據。使用 AWS CLI 指令模擬 Mary 的權限，並測試其能否檢索查詢結果。

步驟包括：
- 透過 Mary 的憑證運行 `execute-statement` 指令進行數據查詢。
- 使用 `get-statement-result` 指令檢索查詢結果。

---

這個教程展示了如何建立 Redshift 數據倉庫、加載數據以及進行查詢分析，並且提供了如何使用 IAM 角色和 AWS CLI 進行操作的完整指引。