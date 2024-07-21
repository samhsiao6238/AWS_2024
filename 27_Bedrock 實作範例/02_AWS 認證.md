# AWS 認證

_需要認證才能使用 AWS 服務_

<br>

## 說明

1. 在使用 AWS 的 Boto3 客戶端與 Bedrock 服務時，需要配置 AWS 認證來確保腳本能夠正確地訪問 AWS 服務，這些認證包含 `Access Key` 和 `Secret Access Key`。

<br>

2. 這些認證有多種方法設置，以下是詳細步驟。

<br>

## 使用環境變數設置 AWS 認證

1. 可以將 AWS 認證設置為環境變數，並使用 `boto3` 自動加載這些變數，在 `.env` 文件中，設置以下內容。

    ```json
    AWS_ACCESS_KEY_ID=你的AWSAccessKey
    AWS_SECRET_ACCESS_KEY=你的AWSSecretKey
    AWS_DEFAULT_REGION=你的AWSRegion
    ```

<br>

2. 然後在腳本中加載這些變數。

    ```python
    from dotenv import load_dotenv
    load_dotenv()
    ```

<br>

## 使用 AWS 配置文件

_有兩個設定文件，`boto3` 會自動加載這些配置_

<br>

1. 第一個文件 `~/.aws/credentials` 是設定憑證，文件內容如下。

    ```bash
    [default]
    aws_access_key_id = <AWS Access Key>
    aws_secret_access_key = <AWS Secret Key>
    ```

<br>

2. 第二個文件是 `~/.aws/config` 是設定區域及文件輸出格式。

    ```bash
    [default]
    region = <AWS Region>
    ```

<br>

## 直接在腳本中設置認證

1. 在腳本中直接設置 AWS 認證，但這樣的設置安全性較低，不建議使用。

    ```python
    import boto3

    bedrock_client = boto3.client(
        service_name='bedrock-agent-runtime',
        aws_access_key_id='<AWS Access Key>',
        aws_secret_access_key='<AWS Secret Key>',
        region_name='<AWS Region>'
    )
    ```

<br>

___

_END_