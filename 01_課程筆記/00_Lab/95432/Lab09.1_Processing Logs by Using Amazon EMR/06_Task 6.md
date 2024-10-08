# Task 6：Querying the resulting dataset

_使用 Hive 來查詢 `joined_impressions` 表中的數據，以分析哪些展示轉化成了廣告點擊。_

<br>

## 步驟

1. 指示 Hive CLI 在查詢結果中顯示欄位名稱，執行這個指令後，運行查詢並返回結果時，Hive 會在結果的頂部顯示每個欄位的名稱；這個指令無回傳值。

    ```sql
    set hive.cli.print.header=true;
    ```

<br>

2. 查詢 `joined_impressions` 表中的前 10 行數據。

    ```sql
    SELECT * FROM joined_impressions LIMIT 10;
    ```

    ![](images/img_54.png)

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

    ![](images/img_55.png)

<br>

4. 退出 Hive CLI。

    ```sql
    exit;
    ```

<br>

5. 查詢來自哪個網站的用戶點擊了最多的廣告。

    ```bash
    hive -e "SELECT referrer, count(*) as hits FROM joined_impressions WHERE clicked = true GROUP BY referrer ORDER BY hits DESC LIMIT 10;" > /home/hadoop/result.txt
    ```

    ![](images/img_56.png)

<br>

6. 使用 `cat` 指令查看結果。

    ```bash
    cat /home/hadoop/result.txt
    ```

    ![](images/img_57.png)

<br>

## 總結

1. 通過這些查詢可深入了解哪些廣告最受歡迎，哪些網站帶來了最多的用戶點擊。

<br>

2. 數據被儲存在 S3 中，未來可再次建立集群來連接到這些數據進行進一步分析。

<br>

___

_END_