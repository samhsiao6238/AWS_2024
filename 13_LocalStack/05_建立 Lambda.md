# 建立和部署 Lambda

_延續之前的操作_

<br>

## 說明

1. 在工作目錄下建立一個名為 `lambda_function.py` 的文件。

    ```bash
    touch lambda_function.py && sudo nano lambda_function.py
    ```

<br>

2. 編輯 `lambda_function.py` 內容；儲存後退出。

    ```python
    def lambda_handler(event, context):
        return {
            'statusCode': 200,
            'body': 'Hello from Lambda!'
        }
    ```

<br>

3. 壓縮 `lambda_function.py` 文件，這就是 Lambda 的函數代碼。

    ```bash
    zip function.zip lambda_function.py
    ```

<br>

4. 在專案資料夾內使用 `awslocal` 命令建立和部署 Lambda 函數；結果成功建立並顯示詳細配置。

    ```bash
    awslocal lambda create-function --function-name my-function --runtime python3.8 --role arn:aws:iam::000000000000:role/lambda-role --handler lambda_function.lambda_handler --zip-file fileb://function.zip
    ```

<br>

5. 會顯示 `Pending`，稍等一陣子。

    ![](images/img_02.png)

<br>

6. 檢查 Lambda 函數狀態。

    ```bash
    awslocal lambda get-function --function-name my-function
    ```

<br>

7. 成功建立後會顯示。

    ```bash
    "State": "Active",
    "LastUpdateStatus": "Successful",
    ```

<br>

8. 輸出中包含配置訊息。

    ```bash
    FunctionName: my-function
    Runtime: python3.10
    Role: arn:aws:iam::000000000000:role/lambda-role
    Handler: lambda_function.lambda_handler
    State: Pending - 函數正在建立中
    CodeSize: 284 bytes
    Timeout: 3 seconds
    MemorySize: 128 MB
    ```

<br>

9. 使用 `awslocal` 來測試 Lambda 函數，調用（invoke）在 LocalStack 中建立的 Lambda 函數 my-function，並將其執行結果寫入 output.txt 文件。

    ```bash
    awslocal lambda invoke --function-name my-function output.txt
    ```

<br>

10. 顯示 output.txt 文件的內容，從而查看 Lambda 函數的執行結果；特別注意，若有錯誤發生時不會有輸出文件。

    ```bash
    cat output.txt
    ```

<br>

## 關於錯誤

_使用 `awslocal lambda invoke` 測試時發生錯誤_

<br>

1. 錯誤訊息表示 Lambda 函數處於 Failed 狀態，這表示在建立或更新函數時發生了某些問題，導致函數無法正確執行；特別注意，錯誤發生時，不會建立 `output.txt` 文件。

    ![](images/img_01.png)

<br>

2. 錯誤訊息。

    ```bash
    An error occurred (ServiceException) when calling the Invoke operation (reached max retries: 4): Internal error while executing lambda
    ```

<br>

3. 若出現函數已經存在的錯誤，可刪除衝突的 Lambda 函數。

    ```bash
    awslocal lambda delete-function --function-name my-function
    ```

<br>

## 各種檢查

1. 檢查 Docker 是否正在運行。

    ```bash
    docker ps
    ```

<br>

2. 查詢日誌。

    ```bash
    docker logs <容器 ID>
    ```

<br>

3. 檢查 Lambda 函數狀態。

    ```bash
    awslocal lambda get-function --function-name my-function
    ```

<br>

4. 檢查 Lambda 函數列表，確認是否確實存在名為 my-function 的 Lambda 函數。

    ```bash
    awslocal lambda list-functions
    ```

<br>

## 容器操作

1. 停用當前 LocalStack 容器。

    ```bash
    docker stop <localstack-container-id>
    ```

<br>

2. 刪除當前容器。

    ```bash
    docker rm <localstack-container-id>
    ```

<br>

3. 重新啟動 LocalStack 並確保 Docker 正確掛載。

    ```bash
    docker run -d -p 4566:4566 -p 4571:4571 -v /var/run/docker.sock:/var/run/docker.sock localstack/localstack
    ```

<br>

## 成功時查看

1. 當 Lambda 函數狀態顯示為 Active 並且 LastUpdateStatus 為 Successful 時，調用函數建立輸出；這似乎需要一點時間。

    ```bash
    awslocal lambda invoke --function-name my-function output.txt
    ```

<br>

2. 然後查看輸出。

    ```bash
    cat output.txt
    ```

<br>

___

_END_