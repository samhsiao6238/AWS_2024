# 中，Hadoop

_用於大規模數據處理和分析_

<br>

## 說明

1. AWS 提供了 `EMR (Elastic MapReduce)`，這是一個基於 `Hadoop` 的雲端服務，可快速部署和運行 Hadoop 集群。

<br>

2. Amazon EMR 結合 Hadoop 提供了大規模數據處理的高效解決方案，並具有按需擴展、成本效益和高可用性等優勢。

<br>

3. AWS 提供了一種簡便的方式來運行 Hadoop 框架，主要通過 Amazon EMR（Elastic MapReduce）來實現。Amazon EMR 是一個完全托管的服務，讓用戶可以在 AWS 上快速部署 Hadoop 集群，並使用 Hadoop 生態系統中的工具（如 Spark、HBase、Hive、Pig 等）來處理大數據工作負載。

<br>

4. Hadoop 是一個開源的框架，主要用來處理和存儲大量數據，具有分佈式處理能力。AWS 通過 EMR 服務簡化了 Hadoop 的管理和部署，用戶可以輕鬆地擴展或縮減資源。

<br>

## Amazon EMR 的主要功能

1. 分佈式數據處理：自動配置和管理 Hadoop 群集，進行大規模的分佈式處理。

<br>

2. 整合其他工具：支援 Apache Spark、HBase、Hive 等。

<br>

3. 彈性擴展：根據負載自動擴展叢集。

<br>

4. S3 整合：可以將 S3 用作 Hadoop 分散式文件系統（HDFS）的替代品，用來存儲和讀取數據。

<br>

## 操作

_使用 AWS SDK 在 Python 中操作 Amazon EMR 來建立一個簡單的 Hadoop 集群並執行 MapReduce 任務。_

<br>

1. 安裝庫。

    ```bash
    pip install boto3
    ```

<br>

2. 使用 Python 代碼建立 EMR 叢集運行 Hadoop。

    ```python
    import boto3

    # 建立 EMR 客戶端
    emr_client = boto3.client(
        'emr', region_name='us-east-1'
    )

    # 建立一個帶有 Hadoop 的 EMR 叢集
    response = emr_client.run_job_flow(
        # 叢集名稱
        Name="MyHadoopCluster",
        # EMR 版本（包含 Hadoop 版本）
        ReleaseLabel='emr-6.3.0',
        Instances={
            'InstanceGroups': [
                {
                    # 主節點
                    'Name': "Master node",  
                    'Market': 'ON_DEMAND',
                    'InstanceRole': 'MASTER',
                    # EC2 instance 類型
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1
                },
                {
                    # 工作節點
                    'Name': "Core - 2 nodes",
                    'Market': 'ON_DEMAND',
                    'InstanceRole': 'CORE',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 2
                }
            ],
            # EC2 SSH Key，用於連接主節點
            'Ec2KeyName': 'my-key-pair',
        },
        Applications=[
            # 安裝 Hadoop
            {'Name': 'Hadoop'},
            # 可選，安裝 Hive
            {'Name': 'Hive'},
            # 可選，安裝 Pig
            {'Name': 'Pig'}
        ],
        Configurations=[
            {
                # Hadoop 環境配置
                'Classification': 'hadoop-env',
                'Configurations': [
                    {
                        'Classification': 'export',
                        'Properties': {
                            'JAVA_HOME': '/usr/lib/jvm/java-1.8.0'
                        }
                    }
                ]
            }
        ],
        # 叢集中的 EC2 角色
        JobFlowRole='EMR_EC2_DefaultRole',
        # EMR 服務角色
        ServiceRole='EMR_DefaultRole',
        VisibleToAllUsers=True,
        # 日誌存放於 S3
        LogUri='s3://my-emr-logs/',
        AutoScalingRole='EMR_AutoScaling_DefaultRole',
    )

    # 輸出 EMR 叢集 ID
    print(f"Created cluster with ID: {response['JobFlowId']}")
    ```

<br>

3. 建立 Hadoop 叢集後，可提交任務來運行 MapReduce 作業。這裡假設要運行一個 MapReduce 任務來處理 S3 上的數據。

    ```python
    # 提交一個 Hadoop 任務到 EMR 叢集
    response = emr_client.add_job_flow_steps(
        # 使用自己建立的叢集 ID
        JobFlowId='j-xxxxxxxxxxxxx',
        Steps=[
            {
                # 任務名稱
                'Name': 'Word count',
                'ActionOnFailure': 'CONTINUE',
                'HadoopJarStep': {
                    'Jar': 'command-runner.jar',
                    'Args': [
                        'hadoop-streaming',
                        # 輸入文件
                        '-input', 's3://my-input-bucket/input/',
                        # 輸出結果
                        '-output', 's3://my-output-bucket/output/',
                        # Mapper 腳本
                        '-mapper', 's3://my-script-bucket/mapper.py',
                        # Reducer 腳本
                        '-reducer', 's3://my-script-bucket/reducer.py'
                    ]
                }
            }
        ]
    )

    # 輸出 Step ID
    print(f"Submitted step with ID: {response['StepIds'][0]}")
    ```

<br>

4. 當任務完成後，可以手動終止叢集以避免額外費用。

    ```python
    # 停止 EMR 叢集
    emr_client.terminate_job_flows(
        # 替換自己的叢集 ID
        JobFlowIds=['j-xxxxxxxxxxxxx']
    )
    ```

<br>

___

_END_