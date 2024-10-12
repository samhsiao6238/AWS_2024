# Task 03：建立安全群組

<br>

## 步驟

1. 在左側欄點擊進入 `Security groups`。

    ![](images/img_30.png)

<br>

2. 點擊右上方 `Create security group` 建立新的安全群組。

    ![](images/img_31.png)

<br>

3. 命名為 `Web Security Group`、描述填入 `Enable HTTP access`、VPC 選擇 `lab-vpc`。

    ![](images/img_32.png)

<br>

4. 點擊 `Add rule` 添加入站規則 `Inbound rules`。

    ![](images/img_33.png)

<br>

5. 類型選 `HTTP`、來源選 `Anywhere-IPv4`、描述填入 `Permit web requests`。

    ![](images/img_34.png)

<br>

6. 點擊右下角 `Create secyrity group`。

    ![](images/img_35.png)

<br>

___

_END_