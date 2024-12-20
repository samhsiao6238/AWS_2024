# Task 04：根據 AWS Glue 表是否存在向工作流程新增路由邏輯

_在工作流中添加 _判斷 Glue 中是否存在資料庫表的邏輯_，並依此決定工作流的路徑；這個 Task 會使用到前一個步驟中 `Run Table Lookup` 返回的 ID，並基於結果進行不同的流程選擇。_

<br>

## 更新工作流以查詢結果

1. 在 `Step Functions` 主控台中選擇 `WorkflowPOC` 狀態機，點擊 `Edit` 進行編輯。

    ![](images/img_52.png)

<br>

2. 在 `Actions` 面板中，搜尋 `Athena`，將 `GetQueryResults` 任務拖到 `Run Table Lookup` 和 `End` 兩個任務之間；特別注意，不要使用 `GetQueryExecution` 任務。

    ![](images/img_53.png)

<br>

## 配置 GetQueryResults 任務

1. 選擇剛加入的任務 `GetQueryResults`，在右側 `Inspector` 面板中，將 `State name` 改為 `Get lookup query results`。

    ![](images/img_54.png)

<br>

2. 將 API Parameters 替換為以下代碼，這會傳遞前一個任務的查詢執行 ID 作為輸入。

    ```json
    {
        "QueryExecutionId.$": "$.QueryExecution.QueryExecutionId"
    }
    ```

<br>

3. 特別注意，這次無需勾選 `Wait for task to complete`，因為這個任務不需要內部輪詢結果，可先進行 `Save`；然後點擊上方頁籤切換到 `{ } Code`。

    ![](images/img_55.png)

<br>

4. 確認 JSON 定義如下，並檢查其中 `<替換-S3-Bucket-名稱>` 是否自動填入正確的名稱；確認無誤點擊右上角 `Save`。

    ```json
    {
        "Comment": "A description of my state machine",
        "StartAt": "Create Glue DB",
        "States": {
            "Create Glue DB": {
                "Type": "Task",
                "Resource": "arn:aws:states:::athena:startQueryExecution.sync",
                "Parameters": {
                    "QueryString": "CREATE DATABASE if not exists nyctaxidb",
                    "WorkGroup": "primary",
                        "ResultConfiguration": {
                            "OutputLocation": "s3://<替換-S3-Bucket-名稱>/athena/"
                        }
                },
                "Next": "Run Table Lookup"
            },
            "Run Table Lookup": {
                "Type": "Task",
                "Resource": "arn:aws:states:::athena:startQueryExecution.sync",
                "Parameters": {
                    "QueryString": "show tables in nyctaxidb",
                    "WorkGroup": "primary",
                    "ResultConfiguration": {
                        "OutputLocation": "s3://<替換-S3-Bucket-名稱>/athena/"
                    }
                },
                "Next": "Get lookup query results"
            },
            "Get lookup query results": {
                "Type": "Task",
                "Resource": "arn:aws:states:::athena:getQueryResults",
                "Parameters": {
                    "QueryExecutionId.$": "$.QueryExecution.QueryExecutionId"
                },
                "End": true
            }
        }
    }
    ```

<br>

## 添加選擇狀態

1. 切換回到 `Design`。

    ![](images/img_56.png)

<br>

2. 將 `Actions` 頁籤切換到 `Flow`。

    ![](images/img_57.png)

<br>

3. 將 `Choice` 狀態拖到 `Get lookup query results` 與 `End` 任務之間。

    ![](images/img_58.png)

<br>

4. 選中 `Choice`，將 `State name` 更改為 `ChoiceStateFirstRun`。

    ![](images/img_59.png)

<br>

5. 在右側的 `Choice Rules` 區塊中，點擊 `Rule #1` 右側的 `edit` 圖標。

    ![](images/img_60.png)

<br>

6. 接著點擊 `Add conditions`。

    ![](images/img_61.png)

<br>

7. 在彈窗中，保持預設的 `Simple`。

    ![](images/img_69.png)

<br>

8. 在下方的 `Not` 下拉選單中，設為 `NOT`。

    ![](images/img_62.png)

<br>

9. 在 `Variable` 欄位中輸入以下語句。

    ```bash
    $.ResultSet.Rows[0].Data[0].VarCharValue
    ```

<br>

10. `Operator` 選擇 `is present`。

    ![](images/img_63.png)

<br>

## 特別注意接下來的步驟

1. 教程中，特別提示了要確認是否與下面截圖顯示相同，這裡注意到了 `Value` 的部分並不相同。

    ![](images/img_86.png)

<br>

2. 在 Step Functions 中，操作至此會提示要 `Select Value`。

    ![](images/img_82.png)

<br>

3. 若不選取任何值，並且直接點擊 `Save conditions`，系統在這個 Lab 環境中會自動帶入 `false`；這裡先嘗試進行儲存然後再回來查看；先點擊右下角 `Save conditions`。

    ![](images/img_81.png)

<br>

4. 再次點擊 `Edit` 進入查看。

    ![](images/img_84.png)

<br>

5. 可發現自動帶入 `false`；這樣的設置在運行工作流之後，不會運行正確的邏輯設計。

    ![](images/img_85.png)

<br>

6. 這裡硬編碼將其設定為 `true`，點擊 `Save conditions` 進行儲存；可在儲存後重複登入查看，確認 `Value` 不會變為 `false`。

    ![](images/img_87.png)

<br>

## 添加兩個 Pass 狀態

_回到工作流_

<br>

1. 左側面板同樣保持在 `Flow`，在中央的視圖編輯中，前步驟加入的 `ChoiceStateFirstRun` 狀態的左側是一個標記為 `not...` 的方塊，在沿著箭頭下的方塊中，拖曳並加入一個 `Pass` 狀態。

    ![](images/img_64.png)

<br>

2. 在右側將 `State name` 設為 `REPLACE ME TRUE STATE`；特別注意，這是一個臨時名稱，稍後會再操作中被自動更換。

    ![](images/img_65.png)

<br>

3. 在 `ChoiceStateFirstRun` 狀態的右側是一個標記為 `Default` 的方塊，與前一個步驟相同，在沿著箭頭下的方塊中拖曳並加入另一個 `Pass` 狀態，然後將 `State name` 設為 `REPLACE ME FALSE STATE`。

    ![](images/img_66.png)

<br>

4. 稍作檢查目前的工作流畫布是否如下，確認無誤即可點擊右上角 `Save`。

    ![](images/img_67.png)

<br>

## 邏輯解釋

1. 當工作流執行並且 `Get lookup query results` 任務完成後，`ChoiceStateFirstRun` 狀態將根據最後一次查詢的結果進行評估；如果查詢未找到表（根據 `$.ResultSet.Rows[0].Data[0].VarCharValue` 邏輯判斷），則工作流將沿 `REPLACE ME TRUE STATE` 路徑進行，在後續任務中會替換此狀態來建立表。

<br>

2. 如果查詢找到了表，則工作流將沿 `REPLACE ME FALSE STATE` 路徑進行，稍後將此狀態替換為檢查新數據（如 2 月的出租車數據）並將其插入到現有的表中。

<br>

3. 至此，這個任務完成在工作流中加入了一個選擇狀態，用來評估查詢結果並根據表的存在性決定下一步的工作流路徑，後續將會替換這些臨時狀態以執行具體操作。

<br>

___

_END_