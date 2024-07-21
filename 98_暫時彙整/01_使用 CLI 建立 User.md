# 建立 IAM User

_使用 CLI 建立一個具有 S3 完整權限的 IAM User_

<br>

1. 建立一個新的 IAM 用戶，命名為 `s3user`。

    ```bash
    aws iam create-user --user-name s3user
    ```

<br>

2. 為新用戶建立訪問密鑰，包含 Access Key 和 Secret Key。

    ```bash
    aws iam create-access-key --user-name s3user
    ```

<br>

3. 建立一個 JSON 文件 `s3_policy.json` 用來定義用戶的 S3 訪問權限，允許該用戶對 S3 進行完全控制。

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:ListAllMyBuckets",
                    "s3:ListBucket",
                    "s3:GetBucketLocation",
                    "s3:CreateBucket",
                    "s3:DeleteBucket",
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:DeleteObject"
                ],
                "Resource": "*"
            }
        ]
    }
    ```

<br>

4. 將指定策略附加到 `s3user`。

    ```bash
    aws iam put-user-policy --user-name s3user --policy-name S3FullAccess --policy-document file://s3_policy.json
    ```

<br>

5. 確認設置。

    ```bash
    aws iam list-user-policies --user-name s3user
    ```

<br>

6. 使用指定用戶 `s3user` 的憑證配置 AWS CLI。

    ```bash
    aws configure --profile s3user
    ```

<br>

7. 查詢指定用戶的區域。

    ```bash
    aws configure get region --profile s3user
    ```

<br>

8. 查詢指定用戶的所有設定。

    ```bash
    aws configure list --profile s3user
    ```

<br>

9. 查詢全部 IAM 使用者資訊。

    ```bash
    aws iam list-users
    ```

<br>

## 錯誤排除

1. 使用指令 `aws iam list-users` 查詢時出錯，這是由於當前使用的 IAM 使用者 `s3user` 沒有執行 `iam:ListUsers` 操作的權限。

    ```bash
    An error occurred (AccessDenied) when calling the ListUsers operation: User: arn:aws:iam::891377311393:user/s3user is not authorized to perform: iam:ListUsers on resource: arn:aws:iam::891377311393:user/ because no identity-based policy allows the iam:ListUsers action
    ```

<br>

2. 創建一個策略文件 `policy.json`，內容如下。

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "iam:ListUsers",
                "Resource": "*"
            }
        ]
    }
    ```

<br>

3. 切換使用者為 `root`。

    ```bash
    aws configure --profile root
    ```

<br>

4. 使用 `root` 為 `s3user` 附加這個策略。

    ```bash
    aws iam put-user-policy --user-name s3user --policy-name ListUsersPolicy --policy-document file://policy.json --profile root
    ```

<br>

5. 切換到指定使用者 `s3user` 的配置檔案。

    ```bash
    export AWS_PROFILE=s3user
    ```

<br>

6. 確認當前使用者。

    ```bash
    aws configure list
    ```

    ![](images/img_01.png)

<br>

___

_END_