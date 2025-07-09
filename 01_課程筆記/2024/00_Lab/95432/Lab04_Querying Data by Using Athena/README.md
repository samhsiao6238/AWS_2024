# Querying Data by Using Athena

_此 Lab 是使用 AWS Athena 和 AWS Glue 來查詢儲存在 Amazon S3 中的數據，包含建立 Glue 資料庫與表格、查詢並優化 Athena 的查詢，以及使用 Athena 視圖來簡化數據分析。_

<br>

## 目標

1. 使用 Athena 查詢編輯器建立 AWS Glue 資料庫與表格。

<br>

2. 使用 Athena 查詢 S3 中的數據集，並進行優化。

<br>

3. 建立 Athena 視圖來簡化數據查詢。

<br>

## 關於 AWS Athena

_這是一個互動式查詢服務，允許使用標準的 SQL 語法直接查詢儲存在 Amazon S3 中的資料；這是無伺服器（serverless）的解決方案，這代表不需要設定或管理伺服器，且只需為實際執行的查詢付費。_

<br>

## 主要特點

_Athena 適合進行大數據分析、快速資料查詢，並且可以與 BI 工具整合來進行可視化分析。_

<br>

1. 無伺服器：不需要配置基礎設施，所有資源由 AWS 自動管理。

<br>

2. SQL 查詢：使用標準的 SQL 查詢來分析儲存在 S3 中的結構化、半結構化（如 JSON、CSV、Parquet 等）資料。

<br>

3. 即時查詢：查詢結果幾乎即時返回，適合進行數據探索與分析。

<br>

4. 與 S3 整合：直接對 S3 上的資料執行查詢，無需移動或複製資料。

<br>

___

_END_