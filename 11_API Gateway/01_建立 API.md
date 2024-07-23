# 建立 API

_結合 API Gateway 和 Lambda 的簡單範例_

## 說明

1. 在 AWS 中，可使用 API Gateway 和 Lambda 來創建一個簡單的 API 並建立接口給使用者使用。

2. 以下範例展示如何創建一個簡單的 API，這個 API 將調用一個 Lambda 函數來處理請求；其中 `Lambda 函數` 負責處理 API 請求並返回響應，`API Gateway` 提供一個 `RESTful API` 接口，將請求路由到 Lambda 函數。


## 創建 Lambda 函數

1. 進入 Lambda 服務點擊 `Create function`。

2. 選擇 `Author from scratch`，並為函數命名，如 `MyFunction`。

3. 選擇運行環境，如 `Python 3.8`。

4. 建立角色或選擇現有角色。

5. 點擊 `Create function`。

6. 在 Lambda 函數頁面，編輯函數代碼。

```python
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!'
    }
```

## 創建 API Gateway

1. 進入 API Gateway 服務，點擊 `Create API`。

2. 選擇 `HTTP API`。

3. 點擊 `Build`。

4. 為 API 命名，如 `MyAPI`。

5. 在 `Routes` 頁面，點擊 `Create`。

## 添加路由

1. 設置路由方法，例如 `GET`。

2. 設置路由路徑，例如 `/hello`。

3. 點擊 `Create`。

## 配置 Lambda 集成

1. 在路由設置頁面，選擇 `Add integration`。

2. 選擇 `Lambda function`。

3. 選擇之前創建的 Lambda 函數 `MyFunction`。

4. 點擊 `Create and attach`。

## 部署 API

1. 在 API 配置頁面，點擊 `Deployments`。

2. 點擊 `Create` 來創建部署，部署後，將生成一個 API 端點 URL。

## 測試 API

1. 使用瀏覽器或工具（如 curl 或 Postman）訪問 API 端點。

    ```bash
    curl https://<api-id>.execute-api.<region>.amazonaws.com/hello
    ```

2. 若正確運行會看到 Lambda 函數的返回結果。

    ```json
    {"statusCode":200,"body":"Hello from Lambda!"}
    ```


