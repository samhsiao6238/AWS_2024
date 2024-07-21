# 建立 S3 Bucket

_透過 AWS CLI 指令_


## 步驟

1. 確保現在是使用 `s3user` 配置文件。

```sh
aws configure --profile s3user
```

2. 使用以下指令來建立 S3 Bucket。

```sh
aws s3api create-bucket --bucket my-bucket-623801 --region us-east-1 --profile s3user
```

