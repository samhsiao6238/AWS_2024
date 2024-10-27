# 簡單範例

_這裡直接實作，使用 AWS CLI 查詢 EC2 實例的相關資訊並設定 CloudWatch 警報_

<br>

## 準備工作

1. 記錄用文檔。

    ```bash
    LAST_VERSION=
    SECURITY_GROUP_ID=
    INSTANCE_ID=
    ```

<br>

## 查詢鏡像

_Amazon Machine Image，AMI_

<br>

1. 查詢最新的 `Amazon Linux 2 AMI`，並將查詢結果存入變數 `LAST_VERSION`。

    ```bash
    LAST_VERSION=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1 --query "Parameters[*].Value" --output text) && echo $LAST_VERSION
    ```

    ![](images/img_11.png)

<br>

2. 透過取得的 `AMI ID` 查詢有關此 AMI 的更多詳細資訊。

    ```bash
    aws ec2 describe-images --image-ids $LAST_VERSION --region us-east-1
    ```

    ![](images/img_22.png)

<br>

3. _這是補充說明_，可透過以下指令查詢所有可用的 AMI。

    ```bash
    aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[*].[ImageId,Name]" --output table
    ```

    ![](images/img_23.png)

<br>

## 建立 EC2 實例

1. 先建立密鑰對，命名為 `MyKeyPair`，並將結果輸出到文件 `MyKeyPair.pem`，這是用於 SSH 連線 EC2；建立完成顯示內容如下。

    ```bash
    aws ec2 create-key-pair \
        --key-name MyKeyPair \
        --query "KeyMaterial" \
        --output text > MyKeyPair.pem \
    && cat MyKeyPair.pem
    ```

    _可在主控台 EC2 或 VPC 查看 `MyKeyPair`_

    ![](images/img_01.png)

<br>

2. 會自動下載密鑰到執行指令的當前路徑，直接運行以下指令變更這個密鑰文件權限為 `400`，就是 **_只有擁有者可讀_**。

    ```bash
    chmod 400 MyKeyPair.pem
    ```

<br>

3. 第二步，建立一個安全群組並命名為 `MySecurityGroup`；完成後同樣可在主控台 EC2 或 VPC 查看 `Security Groups`。

    ```bash
    SECURITY_GROUP_ID=$(\
    aws ec2 create-security-group \
        --group-name MySecurityGroup \
        --description "My security group" \
        --query 'GroupId' \
        --output text) \
    && echo $SECURITY_GROUP_ID
    ```

    ![](images/img_02.png)

<br>

4. 根據前一個步驟儲存的 `SECURITY_GROUP_ID` 建立群組規則，對以下兩個端口進行設置，無需指定 Type 是 SSH 或是 HTTP，系統會自動判斷。

    ```bash
    aws ec2 authorize-security-group-ingress \
        --group-id $SECURITY_GROUP_ID \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0 && \
    aws ec2 authorize-security-group-ingress \
        --group-id $SECURITY_GROUP_ID \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0
    ```

    <img src="images/img_12.png" width="450px">

<br>

5. 也可以在主控台中查看安全群組。

    ![](images/img_24.png)

<br>

6. 建立並啟動 EC2 實例：以上完成建立密鑰、安全群組、啟動端口後，這裡進行建立並啟動，可在主控台中觀察其狀態。

    ```bash
    INSTANCE_ID=$(\
    aws ec2 run-instances \
        --image-id $LAST_VERSION \
        --count 1 \
        --instance-type t2.micro \
        --key-name MyKeyPair \
        --security-group-ids $SECURITY_GROUP_ID \
        --query 'Instances[0].InstanceId' \
        --output text) \
    && echo $INSTANCE_ID
    ```

    ![](images/img_03.png)

<br>

7. 查詢特定實例的完整詳細資訊；剛建立完成時會一段時間進行 `initializing`。

    ```bash
    aws ec2 describe-instances --instance-ids $INSTANCE_ID
    ```

<br>

## 設置 CloudWatch 監控和警報

1. 建立 CloudWatch 警報，自訂名稱為 `HighCPUUtilization`，對 EC2 的 CPU 使用率進行監控；以下將自動對前面建立的 ID 設置警報；以下指令建立完成不會有任何輸出。

    ```bash
    aws cloudwatch put-metric-alarm \
        --alarm-name "HighCPUUtilization" \
        --alarm-description "Alarm when CPU exceeds 80%" \
        --metric-name "CPUUtilization" \
        --namespace "AWS/EC2" \
        --statistic "Average" \
        --period 300 \
        --threshold 80 \
        --comparison-operator "GreaterThanThreshold" \
        --evaluation-periods 1 \
        --alarm-actions "arn:aws:sns:us-east-1:account-id:sns-topic" \
        --dimensions "Name=InstanceId,Value=$INSTANCE_ID"
    ```

<br>

2. 進入 CloudWatch 主控台。

    ![](images/img_25.png)

<br>

3. 還沒完成時要點擊顯示更多的 `...` 會自動展開 `All alarms`，可看到自定義的警告 `HighCPUUtilization`。

    ![](images/img_04.png)

<br>

4. 完成時會顯示在運行中的選項中，狀態為 `OK`。

    ![](images/img_05.png)

<br>

5. 查詢特定 EC2 實例相關的所有警報，當前僅有一個警報 `HighCPUUtilization`；輸出的詳盡說明在講義最下方，可前往查看說明。

    ```bash
    aws cloudwatch describe-alarms-for-metric \
        --metric-name CPUUtilization \
        --namespace AWS/EC2 \
        --dimensions Name=InstanceId,Value=$INSTANCE_ID
    ```

<br>

6. 列出指定警報 `HighCPUUtilization` 的詳細資訊。

    ```bash
    aws cloudwatch describe-alarms --alarm-names "HighCPUUtilization"
    ```

<br>

7. 檢查 CloudWatch 中的相關度量標準，就是列出指定命名空間 `AWS/EC2` 中的所有 `度量標準（metrics）`。

    ```bash
    aws cloudwatch list-metrics --namespace "AWS/EC2"
    ```

<br>

## 設置 CloudWatch Logs

_捕獲 EC2 實例的系統日誌，並設定 CloudWatch 警報來監控這些日誌_

<br>

1. 先取得 EC2 實例的公共 IP。

    ```bash
    MyPublicIP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].PublicIpAddress" --output text) && echo $MyPublicIP
    ```

<br>

2. 連接到 EC2 實例：要設置 CloudWatch Logs Agent，先在 EC2 實例上安裝和配置 CloudWatch Logs Agent 以捕獲系統日誌。

    ```bash
    ssh -i "MyKeyPair.pem" ec2-user@$MyPublicIP
    ```

<br>

2. 在 EC2 下載和安裝 CloudWatch Logs Agent；在測試時可直接安裝，無需更新。

    ```bash
    sudo yum update -y && sudo yum install -y awslogs
    ```

<br>

3. 配置 CloudWatch Logs Agent，編輯配置文件 `/etc/awslogs/awslogs.conf`。

    ```bash
    sudo nano /etc/awslogs/awslogs.conf
    ```

<br>

4. 添加或修改如下內容。

    ```bash
    # 修改
    [/var/log/messages]
    log_group_name = EC2InstanceLogs
    log_stream_name = {instance_id}/messages

    # 添加
    [/var/log/cloud-init.log]
    file = /var/log/cloud-init.log
    log_group_name = EC2InstanceLogs
    log_stream_name = {instance_id}/cloud-init.log
    datetime_format = %Y-%m-%d %H:%M:%S
    ```

<br>

5. 具體修正後的完整內容如下。

    ```bash
    [general]
    state_file = /var/lib/awslogs/agent-state

    [/var/log/messages]
    datetime_format = %b %d %H:%M:%S
    file = /var/log/messages
    buffer_duration = 5000
    log_stream_name = {instance_id}/messages
    initial_position = start_of_file
    log_group_name = EC2InstanceLogs

    [/var/log/cloud-init.log]
    file = /var/log/cloud-init.log
    log_group_name = EC2InstanceLogs
    log_stream_name = {instance_id}/cloud-init.log
    datetime_format = %Y-%m-%d %H:%M:%S
    ```

<br>

6. 啟動和設置 CloudWatch Logs Agent。

    ```bash
    sudo systemctl start awslogsd && sudo systemctl enable awslogsd
    ```

<br>

7. 確認 CloudWatch Logs Agent 已啟動。

    ```bash
    sudo systemctl status awslogsd
    ```

    ![](images/img_13.png)

<br>

## 設置 AWS CLI

1. 先在本機另外開啟一個終端，透過以下指令查看設置內容。

    ```bash
    cat ~/.aws/credentials
    ```

<br>

2. 在 EC2 上運行設置指令；從本機複製查詢到的密鑰來設定 EC2。

    ```bash
    aws configure
    ```

<br>

## 建立並附加 IAM 角色

_不能使用 default IAM 角色，需要建立一個專門的 IAM 角色並配置相應的權限，然後將該角色附加到 EC2 實例。_

<br>

1. 建立角色 `MyCloudWatchLogsRole` 並信任政策，使其能夠被 EC2 使用。

    ```bash
    aws iam create-role --role-name MyCloudWatchLogsRole --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }'
    ```

    _可在主控台查看_

    ![](images/img_14.png)

<br>

2. 建立一個新的附加政策 `CloudWatchLogsPolicy`，允許 CloudWatch Logs 的必要權限。

    ```bash
    aws iam create-policy --policy-name CloudWatchLogsPolicy --policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:DescribeLogGroups",
                    "logs:DescribeLogStreams"
                ],
                "Resource": "*"
            }
        ]
    }'
    ```

    ![](images/img_15.png)

<br>

3. 觀察當前角色 `MyCloudWatchLogsRole` 尚無任何權限政策。

    ![](images/img_18.png)

<br>

4. 將政策 `CloudWatchLogsPolicy` 附加到角色 `MyCloudWatchLogsRole`。

    ```bash
    aws iam attach-role-policy --role-name MyCloudWatchLogsRole --policy-arn arn:aws:iam::$(aws sts get-caller-identity --query "Account" --output text):policy/CloudWatchLogsPolicy
    ```

    _刷新觀察_

    ![](images/img_16.png)

<br>

5. 使用指令 [create-instance-profile](https://docs.aws.amazon.com/cli/latest/reference/iam/create-instance-profile.html) 建立一個 EC2 實例配置文件 `CloudWatchLogsProfile`。

    ```bash
    aws iam create-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

    _輸出_

    ```json
    {
        "InstanceProfile": {
            "InstanceProfileId": "AIPA47CR2L2QUYX52KF7A", 
            "Roles": [], 
            "CreateDate": "2024-07-23T23:46:36Z", 
            "InstanceProfileName": "CloudWatchLogsProfile", 
            "Path": "/", 
            "Arn": "arn:aws:iam::891377311393:instance-profile/CloudWatchLogsProfile"
        }
    }
    ```


<br>

6. 將前面步驟建立的角色附加到該配置文件。

    ```bash
    aws iam add-role-to-instance-profile --instance-profile-name CloudWatchLogsProfile --role-name MyCloudWatchLogsRole
    ```

<br>

7. 確認實例配置文件和角色的關聯；也就是顯示實例配置文件 `CloudWatchLogsProfile` 包含角色 `MyCloudWatchLogsRole。`

    ```bash
    aws iam get-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

    _確認關聯無誤_

    ![](images/img_17.png)

<br>

8. 在主控台查看角色的信任關係時，它顯示的是該角色的信任政策，而不是實例配置文件的詳細信息；而前面使用 CLI 指令 `aws iam get-instance-profile` 查詢實例配置文件時，它返回的是該實例配置文件的詳細信息，包括關聯的角色及其詳細信息，所以兩者查詢的結果並不相同。

    ![](images/img_20.png)

<br>

## 關於實例配置文件

1. 列出所有實例配置文件。

    ```bash
    aws iam list-instance-profiles
    ```

<br>

2. 查看特定實例配置文件的詳細信息。

    ```bash
    aws iam get-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

    ![](images/img_19.png)

<br>

3. 查看特定實例配置文件的詳細信息。

    ```bash
    aws iam get-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

<br>

4. 確保 CloudWatchLogsProfile 已經關聯到正確的角色。

    ```bash
    aws iam get-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

<br>

5. 使用以下指令刪除 CloudWatchLogsProfile。

    ```bash
    aws iam delete-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

<br>

## 附加配置並重啟 EC2

1. 取得 EC2 的 ID。

    ```bash
    INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text) && echo $INSTANCE_ID
    ```

<br>

2. 將 IAM 實例配置文件 `CloudWatchLogsProfile` 與指定的 EC2 實例關聯，從而使該實例能夠使用該實例配置文件中的 IAM 角色及其權限，通常用於允許 EC2 實例訪問其他 AWS 服務，如 CloudWatch 日誌、S3 儲存等，而不需要在實例上配置明文的 AWS 憑證。

    ```bash
    aws ec2 associate-iam-instance-profile --instance-id $INSTANCE_ID --iam-instance-profile Name=CloudWatchLogsProfile
    ```

    _輸出_

    ```json
    {
        "IamInstanceProfileAssociation": {
            "InstanceId": "i-02f28ac860c5dc163", 
            "State": "associating", 
            "AssociationId": "iip-assoc-026f4da2f5dac50d2", 
            "IamInstanceProfile": {
                "Id": "AIPA47CR2L2QVUJHXFWWX", 
                "Arn": "arn:aws:iam::891377311393:instance-profile/CloudWatchLogsProfile"
            }
        }
    }
    ```

<br>

3. 重啟 CloudWatch Logs Agent。

    ```bash
    sudo systemctl restart awslogsd
    ```

<br>

4. 從指定的 CloudWatch `Log Group` 和 `Log Stream` 中查看特定 EC2 實例的日誌信息；添加參數 `--limit 5` 可僅顯示最新五筆日誌訊息。

    ```bash
    aws logs get-log-events --log-group-name EC2InstanceLogs --log-stream-name ${INSTANCE_ID}/messages --region us-east-1 --limit 5
    ```

<br>

## 設置 CloudWatch Logs Log Group 和 Log Stream

_使用 AWS CLI 建立 Log Group 和 Log Stream_

<br>

1. 建立 Log Group `EC2InstanceLogs`。

    ```bash
    aws logs create-log-group --log-group-name EC2InstanceLogs --region us-east-1
    ```

<br>

2. 進入主控台可以看到。

    ![](images/img_06.png)

<br>

3. 通常情況下，CloudWatch Logs Agent 會自動建立 Log Stream。

    ![](images/img_21.png)

<br>

4. 如果沒有自動建立，可手動建立 Log Stream。

    ![](images/img_09.png)

<br>

## 手動建立 Log Stream

1. 建立 Log Stream。

    ```bash
    aws logs create-log-stream --log-group-name EC2InstanceLogs --log-stream-name ${INSTANCE_ID}/messages --region us-east-1
    ```

    ![](images/img_10.png)

<br>

2. 列出日誌組中的所有 Log Stream。

    ```bash
    aws logs describe-log-streams --log-group-name EC2InstanceLogs --region us-east-1
    ```

    _輸出_

    ```json
    {
        "logStreams": [
            {
                "creationTime": 1721776001190, 
                "arn": "arn:aws:logs:us-east-1:891377311393:log-group:EC2InstanceLogs:log-stream:i-042e134bfd8c90fa2/messages", 
                "logStreamName": "i-042e134bfd8c90fa2/messages", 
                "storedBytes": 0
            }
        ]
    }
    ```

<br>

3. 查看 `CloudWatch Logs Agent` 產生的日誌內容文件 `/var/log/awslogs.log` 可確保 Agent 正在運行並且沒有錯誤；按下組合鍵 `comtrol + C` 可退出。

    ```bash
    cat /var/log/awslogs.log
    ```

<br>

## 設置 CloudWatch 警報來監控日誌

_監控 `/var/log/messages` 中的關鍵字 `ERROR`；_

<br>

1. 以下指令用於在 CloudWatch Logs 中建立一個 `度量過濾器（Metric Filter）`，將日誌中的特定模式轉換為 CloudWatch 度量標準。

    ```bash
    aws logs put-metric-filter \
        --log-group-name EC2InstanceLogs \
        --filter-name ErrorFilter \
        --filter-pattern "ERROR" \
        --metric-transformations \
        metricName=ErrorCount,metricNamespace=EC2InstanceLogs,metricValue=1
    ```

    _可在主控台中觀察_

    ![](images/img_07.png)

<br>

2. 以下指令用於在 CloudWatch 中建立一個警報，當特定度量標準超過設定的閾值時觸發警報。

    ```bash
    aws cloudwatch put-metric-alarm \
        --alarm-name "EC2InstanceErrorAlarm" \
        --alarm-description "Alarm when there are errors in EC2 instance logs" \
        --metric-name "ErrorCount" \
        --namespace "EC2InstanceLogs" \
        --statistic "Sum" \
        --period 300 \
        --threshold 1 \
        --comparison-operator "GreaterThanOrEqualToThreshold" \
        --evaluation-periods 1 \
        --alarm-actions "arn:aws:sns:us-east-1:account-id:sns-topic"
    ```

    _可在主控台中觀察多了一個警告，前面步驟建立的警告也已經 `OK`_

    ![](images/img_08.png)

<br>

3. 取得 EC2 實例的 ID。

    ```bash
    INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text) && echo $INSTANCE_ID
    ```

<br>

4. 查詢 CloudWatch 日誌。

    ```bash
    aws logs get-log-events --log-group-name EC2InstanceLogs --log-stream-name ${INSTANCE_ID}/messages --limit 5
    ```

<br>

3. 查詢警報狀態。

    ```bash
    aws cloudwatch describe-alarms --alarm-names "EC2InstanceErrorAlarm"
    ```

<br>

## 涉及收費項目

_AWS 的多數服務如 EC2、CloudWatch 和 IAM 都可能產生費用，運行中的 EC2 實例會按使用時間收費，建立和儲存的日誌和指標也會產生費用，尤其是超出免費使用配額時，另外，雖然 IAM 本身不收費，但與其他服務結合使用可能會導致相關服務的費用增加。_

<br>

1. 刪除 EC2 實例。

    ```bash
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID
    ```

<br>

2. 刪除密鑰對。

    ```bash
    aws ec2 delete-key-pair --key-name MyKeyPair
    ```

<br>

3. 刪除安全群組。

    ```bash
    aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID
    ```

<br>

4. 刪除 CloudWatch 警報。

    ```bash
    aws cloudwatch delete-alarms --alarm-names "HighCPUUtilization" "EC2InstanceErrorAlarm"
    ```

<br>

5. 刪除 CloudWatch 日誌組和日誌流。

    ```bash
    aws logs delete-log-group --log-group-name EC2InstanceLogs
    ```

<br>

6. 刪除 IAM 角色和實例配置文件，先將角色從實例配置文件中移除。

    ```bash
    aws iam remove-role-from-instance-profile --instance-profile-name CloudWatchLogsProfile --role-name MyCloudWatchLogsRole
    ```

<br>

7. 然後刪除實例配置文件。

    ```bash
    aws iam delete-instance-profile --instance-profile-name CloudWatchLogsProfile
    ```

<br>

8. 刪除角色政策。

    ```bash
    POLICY_ARN=$(aws iam list-attached-role-policies --role-name MyCloudWatchLogsRole --query "AttachedPolicies[?PolicyName=='CloudWatchLogsPolicy'].PolicyArn" --output text)
    aws iam detach-role-policy --role-name MyCloudWatchLogsRole --policy-arn $POLICY_ARN
    aws iam delete-policy --policy-arn $POLICY_ARN
    ```

<br>

9. 刪除角色。

    ```bash
    aws iam delete-role --role-name MyCloudWatchLogsRole
    ```

<br>

## 警報內容的詳盡說明

_說明警報內容的重要參數_

<br>

1. 警告所顯示的完整內容。

    ```json
    {
        "MetricAlarms": [
            {
                "AlarmName": "HighCPUUtilization",
                "AlarmArn": "arn:aws:cloudwatch:us-east-1:891377311393:alarm:HighCPUUtilization",
                "AlarmDescription": "Alarm when CPU exceeds 80%",
                "AlarmConfigurationUpdatedTimestamp": "2024-07-23T20:29:33.725000+00:00",
                "ActionsEnabled": true,
                "OKActions": [],
                "AlarmActions": [
                    "arn:aws:sns:us-east-1:account-id:sns-topic"
                ],
                "InsufficientDataActions": [],
                "StateValue": "OK",
                "StateReason": "Threshold Crossed: 1 datapoint [7.122636236757979 (23/07/24 20:20:00)] was not greater than the threshold (80.0).",
                "StateReasonData": "{\"version\":\"1.0\",\"queryDate\":\"2024-07-23T20:30:30.531+0000\",\"startDate\":\"2024-07-23T20:20:00.000+0000\",\"statistic\":\"Average\",\"period\":300,\"recentDatapoints\":[7.122636236757979],\"threshold\":80.0,\"evaluatedDatapoints\":[{\"timestamp\":\"2024-07-23T20:20:00.000+0000\",\"sampleCount\":3.0,\"value\":7.122636236757979}]}",
                "StateUpdatedTimestamp": "2024-07-23T20:30:30.533000+00:00",
                "MetricName": "CPUUtilization",
                "Namespace": "AWS/EC2",
                "Statistic": "Average",
                "Dimensions": [
                    {
                        "Name": "InstanceId",
                        "Value": "i-0e5332b7abb70366a"
                    }
                ],
                "Period": 300,
                "EvaluationPeriods": 1,
                "Threshold": 80.0,
                "ComparisonOperator": "GreaterThanThreshold",
                "StateTransitionedTimestamp": "2024-07-23T20:30:30.533000+00:00"
            }
        ]
    }
    ```

<br>

2. ActionsEnabled：`true` 表示啟用警報動作。

<br>

3. OKActions：`[]`，當警報狀態為 OK 時執行的動作，此處空列表表示無指定動作。

<br>

4. AlarmActions：當警報狀態變為 Alarm 時執行的動作，這裡是發送到指定的 SNS 主題。

<br>

5. InsufficientDataActions：`[]`，當數據不足時執行的動作。

<br>

6. StateValue：警報的當前狀態，`OK` 表示當前 CPU 使用率未超過設定的閾值。

<br>

7. StateReason：當前狀態的原因，此處表示最近一次數據點的值（7.12%）未超過閾值（80%）。

<br>

8. StateReasonData：這是一個 JSON 字串，包含更詳細的狀態數據，包含 `queryDate` 請求的日期時間、`startDate` 評估開始的日期時間、`statistic` 使用的統計方法，此處為 "Average"、`period` 度量標準的周期（秒）、 `recentDatapoints` 最近一次數據點的值、`threshold` 設定的閾值、 `evaluatedDatapoints` 評估期間內的數據點。

<br>

9. MetricName：`"CPUUtilization"`，監控的度量標準名稱。

<br>

10. Namespace：`"AWS/EC2"`，度量標準的命名空間。

<br>

11. Statistic：使用的統計方法，此處為 `Average`。

<br>

12. Dimensions：包含的 EC2 實例 ID。

<br>

13. Period：`300`，度量標準的評估周期（秒）。

<br>

14. EvaluationPeriods：`1`，評估周期的數量。

<br>

15. Threshold：`80.0`，警報觸發的閾值。

<br>

16.  ComparisonOperator：`"GreaterThanThreshold"`，這是比較運算符，此處為 `大於閾值`。

<br>

___

_END_