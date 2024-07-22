#!/bin/bash

# 檢查 .env 文件是否存在，如果不存在則創建它
if [ ! -f .env ]; then
    touch .env
fi

# 確保 AWS CLI 配置已設置根用戶憑證
aws sts get-caller-identity --profile default

# 檢查上一步是否成功
if [ $? -ne 0 ]; then
    echo "AWS CLI 配置的根用戶憑證無效。請檢查您的 AWS CLI 配置。"
    exit 1
fi

# 從現有 AWS 配置文件中獲取根用戶憑證並寫入 .env 文件
ROOT_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile default)
ROOT_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile default)

echo "ROOT_ACCESS_KEY_ID=$ROOT_ACCESS_KEY_ID" > .env
echo "ROOT_SECRET_ACCESS_KEY=$ROOT_SECRET_ACCESS_KEY" >> .env

echo "Root user keys have been stored in .env file."