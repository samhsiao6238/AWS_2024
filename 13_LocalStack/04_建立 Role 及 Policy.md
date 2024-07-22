# 建立 Lambda

<br>

## 確認 Lambda 函數和 Role 設置

1. 建立並進入專案資料夾。

    ```bash
    cd ~/Documents && mkdir exAWS && cd exAWS
    ```

<br>

2. 建立角色時的 AssumeRole 政策 `assume-role-policy.json`。

    ```bash
    touch assume-role-policy.json && sudo nano assume-role-policy.json
    ```

<br>

3. 定義 Lambda 的 IAM 角色政策。

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```

<br>

4. 建立並編輯執行政策 `execution-policy.json`。

    ```bash
    touch execution-policy.json && sudo nano execution-policy.json
    ```

<br>

5. 編輯。

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "logs:*",
                "Resource": "arn:aws:logs:*:*:*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "lambda:InvokeFunction",
                    "lambda:GetFunction"
                ],
                "Resource": "*"
            }
        ]
    }
    ```

<br>

6. 建立角色。

    ```bash
    awslocal iam create-role --role-name lambda-role --assume-role-policy-document file://assume-role-policy.json
    ```

    _輸出_

    ```bash
    (envOpenCV) sam6238@raspi-2024-ssd:~/Documents/exAWS $ awslocal iam create-role --role-name lambda-role --assume-role-policy-document file://role-policy.json
    {
        "Role": {
            "Path": "/",
            "RoleName": "lambda-role",
            "RoleId": "AROAQAAAAAAAO7FVHRKXV",
            "Arn": "arn:aws:iam::000000000000:role/lambda-role",
            "CreateDate": "2024-07-19T15:17:41.136000Z",
            "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Principal": {
                            "Service": "lambda.amazonaws.com"
                        },
                        "Action": "sts:AssumeRole"
                    }
                ]
            }
        }
    }
    ```

<br>

5. 附加執行政策。

    ```bash
    awslocal iam put-role-policy --role-name lambda-role --policy-name lambda-basic-execution --policy-document file://execution-policy.json
    ```

<br>

## 錯誤與檢查

_這裡示範的錯誤訊息類型是 `EntityAlreadyExists`，表示名為 `lambda-role` 的角色已經存在_

<br>

1. 列出所有 IAM 角色，結果包括每個角色的基本資訊，如角色名稱、ARN（Amazon Resource Name）等。

    ```bash
    awslocal iam list-roles
    ```

<br>

2. 取得特定 IAM 角色的詳細資訊，這裡會返回模擬環境中指定角色 `lambda-role` 的詳細資訊。

    ```bash
    awslocal iam get-role --role-name lambda-role
    ```

<br>

3. 如果確定要重新建立角色 `lambda-role`，可以先刪除已存在的同名角色。

    ```bash
    awslocal iam delete-role --role-name lambda-role
    ```

<br>

4. 重新建立角色並附加政策。

    ```bash
    awslocal iam create-role --role-name lambda-role --assume-role-policy-document file://assume-role-policy.json
    ```

<br>

5. 檢查指定角色 `lambda-role` 的特定內嵌政策 `lambda-basic-execution` 的詳細資訊。

    ```bash
    awslocal iam get-role-policy --role-name lambda-role --policy-name lambda-basic-execution
    ```

    <br>

___

_END_