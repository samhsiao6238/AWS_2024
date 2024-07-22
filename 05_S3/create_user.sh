#!/bin/bash

# 檢查 .env 文件是否存在，如果不存在則創建它
if [ ! -f .env ]; then
    echo ".env 文件不存在，請先運行根用戶密鑰腳本。"
    exit 1
fi

# 讀取 .env 文件
export $(grep -v '^#' .env | xargs)

# 創建一個新的 IAM 用戶，命名為 s3user
aws iam create-user --user-name s3user --profile default

# 創建訪問密鑰，並將結果輸出到 .env 文件
aws iam create-access-key --user-name s3user --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text --profile default | while read access_key secret_key; do
    echo "AWS_ACCESS_KEY_ID=$access_key" >> .env
    echo "AWS_SECRET_ACCESS_KEY=$secret_key" >> .env
done