#!/bin/bash

# 讀取 .env 文件
export $(grep -v '^#' .env | xargs)

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
                "s3:PutBucketPublicAccessBlock",
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

# 使用根用戶附加政策到 s3user
aws iam put-user-policy --user-name s3user --policy-name S3AccessPolicy --policy-document file://s3_policy.json --profile default