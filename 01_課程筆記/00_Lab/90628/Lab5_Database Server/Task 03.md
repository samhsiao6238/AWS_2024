# Task 03：建立 Amazon RDS DB 實例

_同樣在 RDS_

<br>

## 步驟

1. 在左側欄中選擇 `Databases`，並選擇 `Create database`。

    ![](images/img_36.png)

<br>

2. 選擇 `MySQL` 作為引擎。

    ![](images/img_37.png)

<br>

3. 在 `Templates` 下選擇 `Dev/Test`。

    ![](images/img_06.png)

<br>

4. 在 `Availability and durability` 選擇 `Multi-AZ DB instance`。

    ![](images/img_07.png)

<br>

5. 接著滑動到設置 `Settings` 區塊，在 `DB instance identifier` 更名為 `lab-db`；展開 `Credentials Settings`，在 `Master username` 更名為 `main`。

    ![](images/img_08.png)

<br>

6. 設定密碼，選取 `Self managed`，然後 Master password、Confirm password 都輸入 `lab-password`。

    ![](images/img_09.png)

<br>

7. 在 DB instance class 區塊，切換到 `Burstable classes`，並使用預設的  `db.t3.micro`。

    ![](images/img_10.png)

<br>

8. 在 `Storage` 區塊，因為教程並未明確指出要設定 `gp2` 或 `gp3`，這裡設置 Storage type 為預設的 `General Purpose SSD(gp3)`，Allocated storage 設置為 `20` GB；另外，在 AWS 的最新建議中，gp3 通常是更具成本效益且靈活的選擇。

    ![](images/img_11.png)

<br>

9. 在 Virtual Private Cloud (VPC) 選取 `Lab VPC`。

    ![](images/img_12.png)

<br>

10. Existing VPC security groups 下拉選單中勾選 `DB Security Group`，並取消勾選 `default`。

    ![](images/img_13.png)

<br>

11. 在 `Monitoring` 區塊取消勾選 `Enable Enhanced monitoring`。

    ![](images/img_14.png)

<br>

12. 展開 `Additional configuration`，在 `Backup` 區塊取消勾選 `Enable automatic backups` 及 `Enable encryption` 兩個 Check Box。

    ![](images/img_15.png)

<br>

13. 點擊右下角的 `Create database`，等待約三四分鐘，直到資料庫狀態顯示為 `Available`，會先經過 initialing、modifying。

    ![](images/img_16.png)


<br>
14. 完成後點擊進入資料庫實例中，預設會在 `Connectivity & security` 頁籤中，複製 `Endpoint` 並儲存；尚未完成時會顯示空白。

    ![](images/img_17.png)

<br>

## 與資料庫互動

1. 從 Lab 說明頁右上角處，點擊 `! AWS Details` 展開詳細資訊。

    ![](images/img_18.png)

<br>

2. 中取得 Web 伺服器的 IP 地址。

    ![](images/img_19.png)

<br>

3. 在新的瀏覽器標籤中貼上該 IP 地址，並按下 Enter。

    ![](images/img_20.png)

<br>

4. 在網頁應用程式中選擇 `RDS`，並配置以下設定；Endpoint 貼上之前複製的 `Endpoint`，Database 命名為 `lab`、Username `main`、Password `lab-password`；然後點擊下方的 `Submit`。

    ![](images/img_21.png)

<br>

5. 應用程式會顯示資料庫正在儲存數據。

    ![](images/img_23.png)

<br>

6. 然後顯示一個通訊錄應用程式。

    ![](images/img_24.png)

<br>

7. 點擊 `Load Test` 可查看當前 CPU 負載率。

    ![](images/img_22.png)

<br>

## 完成

_`Submit` & `Yes`_

<br>

___

_END_