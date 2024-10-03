# Amazon Redshift

_Storing and Analyzing Data by Using Amazon Redshift_

<br>

## 任務 1：檢視 IAM Role

_觀察預設 Role 是否具備適當權限訪問 Redshift_

<br>

1. 進入 `IAM`。

    ![](images/img_02.png)

<br>

2. IAM 中有以下成員。

    ![](images/img_25.png)

<br>

3. Lab 有預設角色 `MyRedshiftRole`，點擊進入。

    ![](images/img_03.png)

<br>

4. 該角色預設附加了 `AmazonS3ReadOnlyAccess` 和 `RedshiftIAMLabPolicy` 策略。

    ![](images/img_04.png)

<br>

5. 可對 Policy 進性展開觀察，例如 `AmazonS3ReadOnlyAccess`；該 IAM 策略主要用於授權用戶對 `Amazon S3` 和 `S3 Object Lambda` 資源進行讀取和列出操作，適用於需要查看和檢索 S3 中存儲的數據但不需要修改權限的場景。

    ![](images/img_26.png)

<br>

6. 另外，`RedshiftIAMLabPolicy` 部分允許用戶描述、建立、修改和刪除與 EC2 網路相關的資源，適用於管理 EC2 網路環境的場景。

    ![](images/img_27.png)

<br>

___

_END_