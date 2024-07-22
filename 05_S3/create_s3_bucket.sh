#!/bin/bash

# 讀取 .env 文件
export $(grep -v '^#' .env | xargs)

# 設定用戶配置
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile s3user
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile s3user
aws configure set region us-east-1 --profile s3user
aws configure set output json --profile s3user

# 建立 S3 Bucket
aws s3api create-bucket --bucket my-bucket-623801 --region us-east-1 --profile s3user

# 建立測試文件
echo "這是測試文件 localfile.txt" > localfile.txt

# 上傳文件到 S3
aws s3 cp localfile.txt s3://my-bucket-623801/localfile.txt --profile s3user