#!/bin/bash

# 設定用戶配置
aws configure set aws_access_key_id YOUR_ACCESS_KEY_ID --profile s3user
aws configure set aws_secret_access_key YOUR_SECRET_ACCESS_KEY --profile s3user
aws configure set region us-east-1 --profile s3user
aws configure set output json --profile s3user

# 建立政策文件
cat <<EOL > s3_policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutBucketPolicy",
                "s3:GetBucketPolicy",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:DeletePublicAccessBlock",
                "s3:GetPublicAccessBlock",
                "s3:PutEncryptionConfiguration",
                "s3:GetEncryptionConfiguration",
                "s3:DeleteBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-bucket-623801",
                "arn:aws:s3:::my-bucket-623801/*"
            ]
        }
    ]
}
EOL

# 建立使用者並附加政策
aws iam create-user --user-name s3user
aws iam create-access-key --user-name s3user
aws iam put-user-policy --user-name s3user --policy-name S3AccessPolicy --policy-document file://s3_policy.json

# 建立 S3 Bucket
aws s3api create-bucket --bucket my-bucket-623801 --region us-east-1 --profile s3user

# 建立測試文件
echo "這是測試文件 localfile.txt" > localfile.txt

# 上傳文件到 S3
aws s3 cp localfile.txt s3://my-bucket-623801/localfile.txt --profile s3user