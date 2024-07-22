#!/bin/bash

# 檢查 .env 文件是否存在，如果不存在則創建它
if [ ! -f .env ]; then
    touch .env
fi

# 請確保您的 AWS CLI 配置已設置根用戶憑證
# 使用 AWS CLI 確認當前配置的用戶
aws sts get-caller-identity --profile default

# 檢查上一步是否成功
if [ $? -ne 0 ]; then
    echo "AWS CLI 配置的根用戶憑證無效。請檢查您的 AWS CLI 配置。"
    exit 1
fi

# 旋轉根用戶訪問密鑰
aws iam create-access-key --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text --profile default | while read access_key secret_key; do
    echo "ROOT_ACCESS_KEY_ID=$access_key" > .env
    echo "ROOT_SECRET_ACCESS_KEY=$secret_key" >> .env
done

echo "Root user keys have been rotated and stored in .env file."
