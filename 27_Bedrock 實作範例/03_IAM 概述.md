# IAM

<br>

## 說明

1. 根據 AWS 的設計，root 帳戶擁有所有 AWS 服務的完全權限，所以使用 root 帳戶時是不需要額外設置政策來訪問特定服務；然而基於安全性考量，AWS 官方不建議在生產環境中使用 root 帳戶進行日常操作；最佳的實踐方式是為每個需要訪問服務的使用者建立獨立的 IAM 用戶。

<br>

2. 在授權的原則上，根據每個使用者的實際需求而授予必要的最小權限。

<br>

## 指令介紹

1. 建立 IAM 用戶並設置權限。

    ```bash
    # 建立一個新的 IAM 用戶
    aws iam create-user --user-name <使用者名稱>
    # 為該用戶附加一個策略
    aws iam attach-user-policy --user-name <使用者名稱> --policy-arn arn:aws:iam::aws:policy/<policy_name>
    ```

<br>

2. 建立 IAM 角色並附加策略。

    ```bash
    # 建立一個新的 IAM 角色，指定信任政策文件
    aws iam create-role --role-name <role_name> --assume-role-policy-document file://trust-policy.json

    # 為該角色附加一個策略
    aws iam attach-role-policy --role-name <role_name> --policy-arn arn:aws:iam::aws:policy/<policy_name>
    ```

<br>

3. 列出所有 IAM 用戶。

    ```bash
    # 列出當前帳戶中的所有 IAM 用戶
    aws iam list-users
    ```

4. 列出指定用戶附加的所有策略。

    ```bash
    # 列出指定用戶附加的所有管理策略
    aws iam list-attached-user-policies --user-name <使用者名稱>
    ```

5. 列出所有 IAM 角色。

    ```bash
    # 列出當前帳戶中的所有 IAM 角色
    aws iam list-roles
    ```

6. 列出角色附加的所有策略。

    ```bash
    # 列出指定角色附加的所有管理策略
    aws iam list-attached-role-policies --role-name <role_name>
    ```

7. 刪除 IAM 用戶。

    ```bash
    # 刪除一個 IAM 用戶
    aws iam delete-user --user-name <使用者名稱>
    ```

8. 刪除 IAM 角色。

    ```bash
    # 刪除一個 IAM 角色
    aws iam delete-role --role-name <role_name>
    ```

<br>

___

_END_


___

_END_