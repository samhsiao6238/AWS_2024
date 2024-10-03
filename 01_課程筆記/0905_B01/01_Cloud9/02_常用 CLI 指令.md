# 其他常用指令 

<br>

## IAM 相關

1. 查詢所有 IAM 角色。

    ```bash
    aws iam list-roles
    ```

<br>

2. 查詢特定角色的詳細信息，這裡使用 `LabRole`。

    ```bash
    aws iam get-role --role-name LabRole
    ```

<br>

3. 查詢已建立的所有 Instance Profile。

    ```bash
    aws iam list-instance-profiles
    ```

<br>

## S3 相關

1. 列出所有 S3 Bucket。

    ```bash
    aws s3 ls
    ```

<br>

2. 查詢特定 Bucket 中的文件。

    ```bash
    aws s3 ls s3://<bucket-name>
    ```

<br>

3. 上傳文件到 S3。

    ```bash
    aws s3 cp <local-file> s3://<bucket-name>/path/to/file
    ```

<br>

## CloudFormation 相關

1. 列出所有 CloudFormation Stacks。

    ```bash
    aws cloudformation list-stacks
    ```

<br>

2. 查詢特定堆疊的詳細信息。

    ```bash
    aws cloudformation describe-stacks --stack-name <stack-name>
    ```

<br>

## 當前用戶相關

1. 查看當前使用中的用戶信息。

    ```bash
    aws sts get-caller-identity
    ```

<br>

## CloudWatch 相關

1. 查詢所有 CloudWatch Alarms。

    ```bash
    aws cloudwatch describe-alarms
    ```

<br>

2. 查詢特定 EC2 實例的 CloudWatch Metrics。

    ```bash
    aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization --dimensions Name=InstanceId,Value=<instance-id> --start-time 2023-09-01T00:00:00Z --end-time 2023-09-05T23:59:59Z --period 300 --statistics Average
    ```

<br>

## Lambda 相關

1. 列出所有 Lambda 函數。

    ```bash
    aws lambda list-functions
    ```

<br>

2. 調用特定 Lambda 函數。

    ```bash
    aws lambda invoke --function-name <function-name> output.txt
    ```

<br>

## EC2 Auto Scaling 相關

1. 查詢所有 Auto Scaling 群組。

    ```bash
    aws autoscaling describe-auto-scaling-groups
    ```

<br>

2. 查詢 Auto Scaling 計畫。

    ```bash
    aws autoscaling describe-scaling-plans
    ```

<br>

## 當前區域信息

1. 列出可用的所有區域（Regions）。

    ```bash
    aws ec2 describe-regions
    ```

<br>

2. 查看當前區域內的可用區（Availability Zones）。

    ```bash
    aws ec2 describe-availability-zones
    ```

<br>

## AWS Systems Manager，SSM 指令

1. 列出可用的 SSM 指令文檔。

    ```bash
    aws ssm list-documents
    ```

<br>

2. 執行 SSM 指令以管理 EC2 實例。

    ```bash
    aws ssm send-command --instance-ids <instance-id> --document-name "AWS-RunShellScript" --parameters commands="uptime"
    ```

<br>

___

_END_
