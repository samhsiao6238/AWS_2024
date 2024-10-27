# 建立 Lambda Layer 和 Lambda Function

<br>

## 設置記錄文件

1. 設置變數並建立記錄文件。

    ```bash
    API_NAME="MyAPI-Bot"
    LAMBDA_FUNCTION_NAME="MyFunction-Bot"
    REGION="us-east-1"
    ROLE_NAME="LabRole"
    LOG_FILE="api_setup_log.txt"
    ```

<br>

2. 建立記錄文件。

    ```bash
    touch $LOG_FILE && open -e api_setup_log.txt
    ```

<br>

3. 使用文字編輯並不會自動刷新，要重啟才會看到文件，若想即時更新可使用 VSCode。

    ```bash
    code api_setup_log.txt
    ```

<br>

4. 寫入初始內容。

    ```bash
    LOG_FILE="api_setup_log.txt"
    echo "# 設置已知變數" > $LOG_FILE
    echo "API_NAME=\"$API_NAME\"" >> $LOG_FILE
    echo "LAMBDA_FUNCTION_NAME=\"$LAMBDA_FUNCTION_NAME\"" >> $LOG_FILE
    echo "REGION=\"$REGION\"" >> $LOG_FILE
    echo "ROLE_NAME=\"$ROLE_NAME\"" >> $LOG_FILE
    echo "LOG_FILE=\"$LOG_FILE\"" >> $LOG_FILE
    ```

5. 取得 ACCOUNT_ID。

    ```bash
    ACCOUNT_ID=$(\
    aws sts get-caller-identity \
        --query 'Account' \
        --output text)
    echo "ACCOUNT_ID=$ACCOUNT_ID" | tee -a $LOG_FILE
    ```

<br>

6. 這裡補充說明一下，假如原本已經寫在記錄文檔內，只是沒有值的變數，可使用以下語法進行更新，而不是直接寫入。

    ```bash
    sed -i '' "s/^ACCOUNT_ID=.*/ACCOUNT_ID=\"$ACCOUNT_ID\"/" $LOG_FILE
    ```

<br>

## 建立 Lambda Layer

1. 建立名為 `MyLayer-Bot` 的 `Lambda Layer`，並將本地文件 `python.zip` 上傳。

    ```bash
    aws lambda publish-layer-version \
        --layer-name MyLayer-Bot \
        --zip-file fileb://python.zip \
        --compatible-runtimes python3.12 \
        --compatible-architectures x86_64
    ```

<br>

## 建立 Lambda Function

_使用前一步驟建立的 Layer_

<br>

1. 建立名為 `MyFunction-Bot` 的 Lambda Function，使用 `Python 3.12` 運行環境、`x86_64` 架構和指定的 IAM 角色（`LabRole`），並將之前建立的 Layer 附加到該 Function 中。

    ```bash
    aws lambda create-function \
        --function-name MyFunction-Bot \
        --runtime python3.12 \
        --role arn:aws:iam::114726445145:role/LabRole \
        --handler lambda_function.lambda_handler \
        --zip-file fileb://python.zip \
        --architectures x86_64 \
        --layers $(aws lambda list-layer-versions --layer-name MyLayer-Bot --query 'LayerVersions[0].LayerVersionArn' --output text)
    ```

<br>

## 建立 API Gateway

1. 建立 REST API。

_將 `API_ID` 寫入變數_

<br>

    ```bash
    API_ID=$(\
    aws apigateway create-rest-api \
        --name $API_NAME \
        --endpoint-configuration types=REGIONAL \
        --region $REGION \
        --query 'id' \
        --output text)

    echo "API_ID=$API_ID" | tee -a $LOG_FILE
    ```

<br>

2. 取得根資源 ID 並寫入變數。

    ```bash
    RESOURCE_ID=$(\
    aws apigateway get-resources \
        --rest-api-id $API_ID \
        --region $REGION \
        --query 'items[?path==`/`].id' \
        --output text)

    echo "RESOURCE_ID=$RESOURCE_ID" | tee -a $LOG_FILE
    ```

<br>

3. 建立 POST 方法。

    ```bash
    aws apigateway put-method \
        --rest-api-id $API_ID \
        --resource-id $RESOURCE_ID \
        --http-method POST \
        --authorization-type NONE \
        --region $REGION
    ```

<br>

4. 將 POST 方法連接至 Lambda 函數。

    ```bash
    aws apigateway put-integration \
        --rest-api-id $API_ID \
        --resource-id $RESOURCE_ID \
        --http-method POST \
        --type AWS_PROXY \
        --integration-http-method POST \
        --uri arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$LAMBDA_FUNCTION_NAME/invocations \
        --region $REGION
    ```

<br>

## 賦予權限

1. 賦予 API Gateway 調用 Lambda 函數的權限

    ```bash
    aws lambda add-permission \
        --function-name $LAMBDA_FUNCTION_NAME \
        --statement-id apigateway-access \
        --action lambda:InvokeFunction \
        --principal apigateway.amazonaws.com \
        --source-arn arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/*/POST/ \
        --region $REGION
    ```

<br>

## 部署 API 並

1. 將階段名稱設定為 `prod`。

    ```bash
    DEPLOYMENT_ID=$(aws apigateway create-deployment \
        --rest-api-id $API_ID \
        --stage-name prod \
        --region $REGION \
        --query 'id' \
        --output text)

    echo "DEPLOYMENT_ID=$DEPLOYMENT_ID" | tee -a $LOG_FILE
    ```

<br>

2. 取得 Invoke URL 並記錄到文件。

    ```bash
    INVOKE_URL="https://$API_ID.execute-api.$REGION.amazonaws.com/prod"
    echo "INVOKE_URL=$INVOKE_URL" | tee -a $LOG_FILE

    echo "API Gateway setup complete. Invoke URL: $INVOKE_URL"
    ```

<br>

