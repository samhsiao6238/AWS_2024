# 場景介紹

<br>

## 說明

1. 這個 Lab 的場景是已經開發了一個使用 `Amazon Cognito` 驗證並整合 `Amazon DynamoDB` 的網頁應用程式，該應用允許登入的學生查看資料表中的觀察記錄並新增新的鳥類觀察記錄。Ms. Garcia 和她的學生對這個應用感到非常滿意，但她現在需要新增一個功能：生成所有學生觀察記錄的報告。

<br>

2. 這份報告的需求是以更適合列印的格式顯示所有學生的觀察記錄（不包含圖片）。且報告需要高度安全，只有老師（Ms. Garcia）可以訪問。

<br>

## 實作

_在此 Lab 中將使用 AWS Step Functions 配置一個狀態機（State Machine）來自動執行以下操作；最後還將更新現有的 Bird Sightings 網頁應用，讓應用可以調用這個狀態機來生成報告。_

<br>

1. 從 DynamoDB 中檢索所有學生的觀察記錄。

<br>

2. 將這些記錄格式化為 HTML 報告。

<br>

3. 生成一個安全的鏈接來訪問報告。

<br>

4. 通過 Amazon SNS 將報告鏈接發送給 Ms. Garcia。

<br>

___

_END_