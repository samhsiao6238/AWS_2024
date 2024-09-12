AWS 提供了一種簡便的方式來運行 Hadoop 框架，主要通過 Amazon EMR（Elastic MapReduce）來實現。Amazon EMR 是一個完全托管的服務，讓用戶可以在 AWS 上快速部署 Hadoop 集群，並使用 Hadoop 生態系統中的工具（如 Spark、HBase、Hive、Pig 等）來處理大數據工作負載。

### AWS 上的 Hadoop 簡介

Hadoop 是一個開源的框架，主要用來處理和存儲大量數據，具有分佈式處理能力。AWS 通過 EMR 服務簡化了 Hadoop 的管理和部署，用戶可以輕鬆地擴展或縮減資源。

#### Amazon EMR 的主要功能：
1. 分佈式數據處理：自動配置和管理 Hadoop 群集，進行大規模的分佈式處理。
2. 整合其他工具：支援 Apache Spark、HBase、Hive 等。
3. 彈性擴展：根據負載自動擴展叢集。
4. S3 整合：可以將 S3 用作 Hadoop 分散式文件系統（HDFS）的替代品，用來存儲和讀取數據。

### 具體操作示例

我們將展示如何使用 AWS SDK 在 Python 中操作 Amazon EMR 來建立一個簡單的 Hadoop 集群並執行 MapReduce 任務。這裡假設你已經安裝了 AWS SDK for Python (`boto3`) 並配置了 AWS 憑證。

#### 1. 安裝依賴
```bash
pip install boto3
```

#### 2. 使用 Python 代碼建立 EMR 叢集
以下代碼將建立一個 Amazon EMR 叢集來運行 Hadoop：

```python
import boto3

# 建立 EMR 客戶端
emr_client = boto3.client('emr', region_name='us-west-2')

# 建立 EMR 叢集
response = emr_client.run_job_flow(
    Name="MyHadoopCluster",  # 叢集名稱
    ReleaseLabel='emr-6.3.0',  # EMR 版本（包含 Hadoop 版本）
    Instances={
        'InstanceGroups': [
            {
                'Name': "Master node",  # 主節點
                'Market': 'ON_DEMAND',
                'InstanceRole': 'MASTER',
                'InstanceType': 'm5.xlarge',  # EC2 instance 類型
                'InstanceCount': 1
            },
            {
                'Name': "Core - 2 nodes",  # 工作節點
                'Market': 'ON_DEMAND',
                'InstanceRole': 'CORE',
                'InstanceType': 'm5.xlarge',
                'InstanceCount': 2
            }
        ],
        'Ec2KeyName': 'my-key-pair',  # EC2 SSH Key，用於連接主節點
    },
    Applications=[
        {'Name': 'Hadoop'},  # 安裝 Hadoop
        {'Name': 'Hive'},    # 可選，安裝 Hive
        {'Name': 'Pig'}      # 可選，安裝 Pig
    ],
    Configurations=[
        {
            'Classification': 'hadoop-env',  # Hadoop 環境配置
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
    JobFlowRole='EMR_EC2_DefaultRole',  # 叢集中的 EC2 角色
    ServiceRole='EMR_DefaultRole',  # EMR 服務角色
    VisibleToAllUsers=True,
    LogUri='s3://my-emr-logs/',  # 日誌存放於 S3
    AutoScalingRole='EMR_AutoScaling_DefaultRole',
)

# 輸出 EMR 叢集 ID
print(f"Created cluster with ID: {response['JobFlowId']}")
```

#### 3. 在叢集上運行 Hadoop 任務
建立 Hadoop 叢集後，可以提交任務來運行 MapReduce 作業。這裡假設你要運行一個 MapReduce 任務來處理 S3 上的數據。

```python
# 提交一個 Hadoop 任務到 EMR 叢集
response = emr_client.add_job_flow_steps(
    JobFlowId='j-xxxxxxxxxxxxx',  # 替換為你建立的叢集 ID
    Steps=[
        {
            'Name': 'Word count',  # 任務名稱
            'ActionOnFailure': 'CONTINUE',
            'HadoopJarStep': {
                'Jar': 'command-runner.jar',
                'Args': [
                    'hadoop-streaming',
                    '-input', 's3://my-input-bucket/input/',  # 輸入文件
                    '-output', 's3://my-output-bucket/output/',  # 輸出結果
                    '-mapper', 's3://my-script-bucket/mapper.py',  # Mapper 腳本
                    '-reducer', 's3://my-script-bucket/reducer.py'  # Reducer 腳本
                ]
            }
        }
    ]
)

# 輸出 Step ID
print(f"Submitted step with ID: {response['StepIds'][0]}")
```

### 4. 停止叢集
當任務完成後，可以手動終止叢集以避免額外費用：

```python
# 停止 EMR 叢集
emr_client.terminate_job_flows(
    JobFlowIds=['j-xxxxxxxxxxxxx']  # 替換為你的叢集 ID
)
```

### 小結
- 建立 EMR 叢集：透過 `run_job_flow` 來建立一個帶有 Hadoop 的叢集。
- 提交 MapReduce 任務：使用 `add_job_flow_steps` 將 MapReduce 任務提交到叢集。
- 管理叢集：運行完畢後，記得終止叢集以節省費用。

這個流程展示了如何使用 AWS 的 Hadoop 服務來簡化大數據處理，並且可以透過 Python 程式碼與 AWS 互動來自動化這個過程。