# Task 3：配置 AWS Glue 作業腳本

_檢索並配置 AWS Glue 作業所需的文件_

<br>

## 進入 `Cloud9`

_特別注意，這裡不是搜尋服務進入 `Cloud9` 主控台，請依以下說明操作_

<br>

1. 之前進入 `CloudFormation` 的 `Stacks` 時查看了 `Outputs`，可使用記錄下的內文或展開未關閉的網頁；其中有一組 Key 是 `Cloud9URL`，點擊 Value 中的連結就會進入 Cloud9 中預設的 IDE。

    ![](images/img_17.png)

<br>

2. 若是複製並保存的網址 `https://us-east-1.console.aws.amazon.com/cloud9/ide/6a8832e56f854979896d413542c3d99e`，可貼到瀏覽器開啟，同樣這會啟動 Cloud9 中預設的 IDE。

<br>

## 下載文件

1. 依據官網指示，要下載兩個文件 `glue_job_script.py`、`glue_job_script.py`，網址如下。

    ```html
    # glue_job_script.py
    https://
    aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-06-hudi/s3/glue_job_script.py

    # glue_job_script.py
    https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-06-hudi/s3/glue_job.template
    ```

<br>

2. 方法一，使用 `curl -O` 下載。

    ```bash
    curl -O https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-06-hudi/s3/glue_job_script.py
    ```

    ![](images/img_16.png)

<br>

3. 方法二，使用 `wget` 指令下載。

    ```bash
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACDENG-1-91570/lab-06-hudi/s3/glue_job.template
    ```

    ![](images/img_18.png)

<br>

## 複製文件到 S3

1. 在 Outputs 中記錄了 Bucket name 如 `ade-dsc-bucket-094adf30`。

    ![](images/img_19.png)

<br>

2. 運行以下指令，替換其中的 `<Bucket name>` 為 `ade-dsc-bucket-094adf30`。

    ```bash
    aws s3 cp glue_job_script.py s3://<Bucket name>/artifacts/
    aws s3 cp glue_job.template s3://<Bucket name>/templates/
    ```

    _實際指令如下_

    ```bash
    aws s3 cp glue_job_script.py s3://ade-dsc-bucket-094adf30/artifacts/
    aws s3 cp glue_job.template s3://ade-dsc-bucket-094adf30/templates/
    ```

    ![](images/img_20.png)
