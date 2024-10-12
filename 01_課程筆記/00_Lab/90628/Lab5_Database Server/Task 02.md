# Task 02：建立 DB 子網路群組

<br>

## 步驟

1. 在控制台中搜尋並進入 `RDS`。

    ![](images/img_31.png)

<br>

2. 在左側欄中，點擊進入 `Subnet groups`；目前尚無任何設置。

    ![](images/img_32.png)

<br>

3. 點擊畫面中的 `Create DB Subnet Group`。

    ![](images/img_33.png)

<br>

4. 配置以下設定，Name 設定為 `DB-Subnet-Group`、描述 Description 部分填入 `DB Subnet Group`；展開 VPC ，然後在下拉選單中選取 `Lab VPC`

    ![](images/img_34.png)

<br>

5. 向下捲動至 `Add subnets` 區塊，下拉 Availability Zones 選單勾選 `us-east-1a` 和 `us-east-1b` 兩個區域。

    ![](images/img_04.png)

<br>

6. 緊接著在 `Subnets` 區塊中設置 `CIDR 範圍`，從下拉選單選取 `10.0.1.0/24` 和 `10.0.3.0/24` 的子網路；特別注意，畫面中看到的順序不是固定的，務必確實查看後勾選。

    ![](images/img_05.png)

<br>

7. 務必再次檢查是否正確如下。

    ![](images/img_45.png)

<br>

8. 點擊右下角 `Create` 完成設置。

    ![](images/img_35.png)

<br>

___

_END_