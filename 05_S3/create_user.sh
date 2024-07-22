#!/bin/bash

# 創建一個新的 IAM 用戶，命名為 s3user
aws iam create-user --user-name s3user

# 創建訪問密鑰，並將結果輸出到 .env 文件
aws iam create-access-key --user-name s3user --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text | while read access_key secret_key; do
echo "AWS_ACCESS_KEY_ID=$access_key" > .env
echo "AWS_SECRET_ACCESS_KEY=$secret_key" >> .env
done