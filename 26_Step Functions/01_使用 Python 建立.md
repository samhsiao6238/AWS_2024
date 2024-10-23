# 使用 Python 建立 Step Function

##  安裝和配置 `boto3`

1. 先在 Cloud9 或 Jupyter Notebook 環境中安裝。

    ```bash
    pip install boto3
    ```

2. 設定憑證。

    ```bash
    aws configure
    ```

3. 使用 Python 代碼來運行 Step Functions。

    ```python
    import boto3
    import json

    # 建立 Step Functions 客戶端
    client = boto3.client('stepfunctions')

    # 定義 State Machine ARN，這是你在 Step Functions 中建立的狀態機 ARN
    state_machine_arn = 'arn:aws:states:<region>:<account-id>:stateMachine:<state-machine-name>'

    # 定義輸入數據（根據你的狀態機輸入需求定義）
    input_data = {
        "key1": "value1",
        "key2": "value2"
    }

    # 啟動 Step Functions 執行
    response = client.start_execution(
        stateMachineArn=state_machine_arn,
        input=json.dumps(input_data)
    )

    # 輸出結果
    print("Execution ARN:", response['executionArn'])
    ```

4. 檢查 Step Functions 執行狀態。

    ```python
    # 之前執行返回的 ARN
    execution_arn = response['executionArn']
    # 檢查執行狀態
    response = client.describe_execution(
        executionArn=execution_arn
    )
    print("Execution Status:", response['status'])
    print("Execution Output:", response['output'])
    ```

## 管理其他 Step Functions 操作

1. 停止執行。
    ```python
    client.stop_execution(
        executionArn=execution_arn
    )
    ```

2. 列出所有執行。

    ```python
    response = client.list_executions(
        stateMachineArn=state_machine_arn,
        # 可以過濾狀態，例如：RUNNING、SUCCEEDED、FAILED
        statusFilter='RUNNING'
    )
    print(response)
    ```

<br>

___

_END_