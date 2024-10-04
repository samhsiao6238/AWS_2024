# Task 5：Joining tables by using Hive

_通過將展示給用戶的廣告資料 `impressions 表` 與用戶選擇廣告的點擊資料 `clicks 表` 結合，可深入了解用戶行為並針對廣告進行更有效的服務和貨幣化。_

<br>

## 步驟

1. 執行以下指令來建立外部表 `joined_impressions`；表 `joined_impressions` 定義了與 `impressions` 表相同的七個欄位，並增加了第八個欄位 `clicked`；特別注意，這個表還沒有任何數據，當數據被添加時，會存儲在 S3 的 `hive-output` 資料夾中。

    ```sql
    CREATE EXTERNAL TABLE joined_impressions (
        requestBeginTime string,
        adId string,
        impressionId string,
        referrer string,
        userAgent string,
        userCookie string,
        ip string,
        clicked Boolean
    )
    PARTITIONED BY (day string, hour string)
    STORED AS SEQUENCEFILE
    LOCATION '${OUTPUT}/tables/joined_impressions';
    ```

<br>

2. 執行以下指令來建立並插入資料。

    ```sql
    CREATE TABLE tmp_impressions (
        requestBeginTime string,
        adId string,
        impressionId string,
        referrer string,
        userAgent string,
        userCookie string,
        ip string
    ) STORED AS SEQUENCEFILE;

    INSERT OVERWRITE TABLE tmp_impressions
    SELECT from_unixtime(cast((cast(i.requestBeginTime as bigint) / 1000) as int)) requestBeginTime,
        i.adId,
        i.impressionId,
        i.referrer,
        i.userAgent,
        i.userCookie,
        i.ip
    FROM impressions i
    WHERE i.dt >= '${DAY}-${HOUR}-00'
    AND i.dt < '${NEXT_DAY}-${NEXT_HOUR}-00';
    ```

<br>

3. 建立並插入臨時表 `tmp_clicks`。

    ```sql
    CREATE TABLE tmp_clicks (
        impressionId string,
        adId string
    ) STORED AS SEQUENCEFILE;

    INSERT OVERWRITE TABLE tmp_clicks
    SELECT impressionId, adId
    FROM clicks c
    WHERE c.dt >= '${DAY}-${HOUR}-00'
    AND c.dt < '${NEXT_DAY}-${NEXT_HOUR}-20';
    ```

<br>

4. 執行以下指令來將結果集寫入 `joined_impressions` 表。
    ```sql
    INSERT OVERWRITE TABLE joined_impressions
    PARTITION (day='${DAY}', hour='${HOUR}')
    SELECT i.requestBeginTime,
        i.adId,
        i.impressionId,
        i.referrer,
        i.userAgent,
        i.userCookie,
        i.ip,
        (c.impressionId is not null) clicked
    FROM tmp_impressions i
    LEFT OUTER JOIN tmp_clicks c ON i.impressionId=c.impressionId;
    ```

<br>

___

_END_

