#!/bin/bash

# 檢查 .env 文件是否存在，如果不存在則創建它
if [ ! -f .env ]; then
    touch .env
fi

# 讀取現有的根用戶訪問密鑰並寫入 .env 文件
read -p "Enter your existing ROOT_ACCESS_KEY_ID: " root_access_key_id
read -p "Enter your existing ROOT_SECRET_ACCESS_KEY: " root_secret_access_key

echo "ROOT_ACCESS_KEY_ID=$root_access_key_id" > .env
echo "ROOT_SECRET_ACCESS_KEY=$root_secret_access_key" >> .env

echo "Root user keys have been stored in .env file."
