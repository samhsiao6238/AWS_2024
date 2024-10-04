# Task 2：訂閱並啟動 Hudi 連接器

_配置 Hudi 連接器，用於 AWS Glue 與 S3 進行交互，實現動態數據更新。_

<br>

## 步驟

1. 進入 `AWS Glue Studio`，注意，這與 `AWS Glue` 不同。

    ![](images/img_03.png)

<br>

2. 點擊左下角的 `AWS Marketplace`。

    ![](images/img_04.png)

<br>

3. 在 `Search AWS Glue Studio products` 下的搜尋框內輸入 `Hudi`，點擊 `Apache Hudi Connector for AWS Glue`。

    ![](images/img_05.png)

<br>

4. 會自動開啟新的瀏覽頁籤，點擊右上角 `Continue to Subscribe`。

    ![](images/img_06.png)

<br>

5. 點擊 `Accept Terms`。

    ![](images/img_07.png)

<br>

6. 畫面下方的 `Effective date` 會顯示 `Pending`，而且右上角的 `Continue to Configuration` 按鈕會呈現反白不可點擊，稍作等待。

    ![](images/img_08.png)

<br>

7. 點擊 `Continue to Configuration`。

    ![](images/img_09.png)

<br>

8. `Fulfillment option` 選擇 `Glue 3.0`，`Software version` 選擇 `0.10.1 (Jun 13, 2022)`，然後點擊右上角 `Continue to Launch`。

    ![](images/img_10.png)

<br>

9. 點擊畫面中央的 `Usage instructions`。

    ![](images/img_11.png)

<br>

10. 在彈窗中點擊首行中的連結。

    ![](images/img_12.png)

<br>

11. 會開啟新的頁面，畫面上方有個藍色彈窗，右側有個 `Activate connector only` 按鈕，不予理會。

    ![](images/img_13.png)

<br>

12. 在 `Connector` 命名為 `hudi-connection`，然後點擊右下角的 `Create connection and activate connector`。

    ![](images/img_14.png)

<br>

13. 點擊連結可查看詳情。

    ![](images/img_15.png)

<br>

___

_END_