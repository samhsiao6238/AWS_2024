# Elastic IPs

<br>

## Auto Scaling




## 建立一個 EC2

1. 準備一個記錄用的文檔。

```bash
# 第一部分：複製 AWS CLI 貼上，格式不重要，稍後會直接覆蓋
[default]
aws_access_key_id=
aws_secret_access_key=
aws_session_token=

# 第二部分：建立環境變數
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_SESSION_TOKEN=$aws_session_token

# 第三部分：設定變數
My_AMI=
INSTANCE_TYPE="t3.micro"
KEY_NAME=vockey
SECURITY_GROUP_ID=
INSTANCE_NAME="MyEC2_1025"
INSTANCE_COUNT=1
```

1. 複製 AWS Details 中的 `AWS CLI` 設定。

2. 使用命令建立安全群組，並將回傳的 `GroupId` 存入變數 `SECURITY_GROUP_ID` 中。

```bash
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name MySecurityGroup_1025 \
    --description "Security group for MyEC2_1025 instance" \
    --query 'GroupId' \
    --output text)
```

1. 輸出 `SECURITY_GROUP_ID` 來檢查是否正確儲存了安全群組 ID。

```bash
echo $SECURITY_GROUP_ID
```



1. 使用變數來配置安全群組的入站規則，允許 HTTP 和 HTTPS 流量。

```bash
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp --port 443 --cidr 0.0.0.0/0
```

## 查詢 AMI

1. 使用 AWS Systems Manager 查詢最新的 AMI，並將結果寫入變數 `My_AMI`。

```bash
My_AMI=$(aws ssm get-parameters \
    --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
    --query 'Parameters[*].{Name:Name, Value:Value}' \
    --outut table)
```


1. 使用儲存在變數中的安全群組 ID 來建立 EC2 實例；特別注意，JSON 格式必須以雙引號包圍變數的值，其中若有變數，則將前後引號 `"` 改為 `\"` 反斜線作為插補符號。

```bash
aws ec2 run-instances \
--image-id $My_AMI \
--instance-type $INSTANCE_TYPE \
--key-name "vockey" \
--network-interfaces "[{\"AssociatePublicIpAddress\":true,\"DeviceIndex\":0,\"Groups\":[\"$SECURITY_GROUP_ID\"]}]" \
--credit-specification '{"CpuCredits":"standard"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"MyEC2_1025"}]}' \
--metadata-options '{"HttpEndpoint":"enabled","HttpPutResponseHopLimit":2,"HttpTokens":"required"}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count $INSTANCE_COUNT
```
