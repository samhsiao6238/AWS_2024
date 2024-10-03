#### 任務 8: 確認使用者可以在 Redshift 資料庫上運行查詢
最後，確認 Mary 能夠透過 Redshift 查詢數據。使用 AWS CLI 指令模擬 Mary 的權限，並測試其能否檢索查詢結果。

步驟包括：
- 透過 Mary 的憑證運行 `execute-statement` 指令進行數據查詢。
- 使用 `get-statement-result` 指令檢索查詢結果。

---

這個教程展示了如何建立 Redshift 數據倉庫、加載數據以及進行查詢分析，並且提供了如何使用 IAM 角色和 AWS CLI 進行操作的完整指引。