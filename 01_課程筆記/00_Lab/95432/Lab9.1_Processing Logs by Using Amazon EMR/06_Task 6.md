# Task 6：Querying the resulting dataset

_使用 Hive 來查詢 `joined_impressions` 表中的數據，以分析哪些展示轉化成了廣告點擊。_

<br>

## 步驟

1. 在結果集中顯示列名。

    ```sql
    set hive.cli.print.header=true;
    ```

<br>

2. 查詢 `joined_impressions` 表中的前 10 行數據。

    ```sql
    SELECT * FROM joined_impressions LIMIT 10;
    ```

<br>

3. 查詢點擊最多的 10 個廣告。

    ```sql
    SELECT adid, count(*) AS hits 
    FROM joined_impressions 
    WHERE clicked = true 
    GROUP BY adid 
    ORDER BY hits DESC 
    LIMIT 10;
    ```

<br>

4. 退出 Hive CLI 並執行以下指令查詢來自哪個網站的用戶點擊了最多的廣告。

    ```bash
    hive -e "SELECT referrer, count(*) as hits FROM joined_impressions WHERE clicked = true GROUP BY referrer ORDER BY hits DESC LIMIT 10;" > /home/hadoop/result.txt
    ```

    使用 `cat` 指令查看結果：
    ```bash
    cat /home/hadoop/result.txt
    ```

<br>

## 補充

1. 通過這些查詢可深入了解哪些廣告最受歡迎，哪些網站帶來了最多的用戶點擊。

<br>

2. 數據被存儲在 S3 中，未來可再次建立集群來連接到這些數據進行進一步分析。

<br>

___

_END_