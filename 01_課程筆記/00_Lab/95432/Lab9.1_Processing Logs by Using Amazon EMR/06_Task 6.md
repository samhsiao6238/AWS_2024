### Task 6: Querying the resulting dataset

此任務中，你將使用 Hive 來查詢 `joined_impressions` 表中的數據，以分析哪些展示轉化成了廣告點擊。

#### 步驟
1. 顯示列名  
   為了在結果集中顯示列名，執行以下命令：
   ```sql
   set hive.cli.print.header=true;
   ```

2. 查詢前 10 行數據  
   執行以下命令查詢 `joined_impressions` 表中的前 10 行數據：
   ```sql
   SELECT * FROM joined_impressions LIMIT 10;
   ```

3. 查詢點擊最多的廣告  
   執行以下命令查詢點擊最多的 10 個廣告：
   ```sql
   SELECT adid, count(*) AS hits 
   FROM joined_impressions 
   WHERE clicked = true 
   GROUP BY adid 
   ORDER BY hits DESC 
   LIMIT 10;
   ```

4. 查詢帶來最多點擊的 referrers  
   退出 Hive CLI 並執行以下命令查詢來自哪個網站的用戶點擊了最多的廣告：
   ```bash
   hive -e "SELECT referrer, count(*) as hits FROM joined_impressions WHERE clicked = true GROUP BY referrer ORDER BY hits DESC LIMIT 10;" > /home/hadoop/result.txt
   ```

   使用 `cat` 命令查看結果：
   ```bash
   cat /home/hadoop/result.txt
   ```

總結  
通過這些查詢，你可以深入了解哪些廣告最受歡迎，哪些網站為你帶來了最多的用戶點擊。數據被存儲在 S3 中，未來你可以再次建立集群來連接到這些數據進行進一步分析。

---

這兩個任務旨在展示如何使用 Hive 對數據進行聯合查詢和數據分析。你學會了如何通過 MapReduce 運行分佈式查詢，並將查詢結果存儲到 Amazon S3 中，隨時可供未來的分析。