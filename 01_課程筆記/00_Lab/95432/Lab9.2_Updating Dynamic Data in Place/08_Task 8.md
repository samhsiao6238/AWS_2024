# Task 8：恢復架構變更

_恢復原始架構，並驗證是否能夠繼續進行數據分析_

## 步驟

1. 回到運行 `KDG` 的頁面中，點擊 `Stop Sending Data to Kinesis`。

![](images/img_60.png)

2. 在 `Record template` 中選取 `Schema 1` 並點擊 `Send data`；同樣保持運行，不要關必夜面。

![](images/img_61.png)

3. 回到 `Athena` 中，展開 `Tables` 並選取 `hudi_demo_table`，然後 _重複多次運行_ 以下查詢。

```sql
SELECT _hoodie_commit_seqno, _hoodie_record_key, column_to_update_string, new_column FROM "hudi_demo_table"
```

4. 查詢結果中仍然包含 new_column；但是，該列不包含任何值。

![](images/img_62.png)

5. 