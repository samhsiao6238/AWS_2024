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

## 啟動 Web 伺服器

1. 搜尋並進入 EC2 主控台，點擊 `Launch instance`。

    ![](images/img_54.png)

<br>

2. 命名為 `Web Server 1`。

    ![](images/img_55.png)

<br>

3. 密鑰對選擇 `vockey`。

    ![](images/img_56.png)

<br>

4. 接著在 `Network settings` 區塊，點擊標題右側的 `Edit`。

    ![](images/img_36.png)

<br>

## 進入 `Network settings`

1. VPC 選擇 `lab-vpc`、子網選擇 `lab-subnet-public2`、`Auto-assign public IP` 設定為 `Enable`。

    ![](images/img_37.png)

<br>

2. 防火牆 `Firewall` 切換到 `Select existing security group`，然後在選單中選擇 `Web Security Group`。

    ![](images/img_38.png)

<br>

3. 展開最下方的 `Advanced details`，將以下代碼貼到 `User data` 欄位中。

    ```bash
    #!/bin/bash
    dnf install -y httpd wget php mariadb105-server
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
    unzip lab-app.zip -d /var/www/html/
    chkconfig httpd on
    service httpd start
    ```

<br>

4. 以上是個一般的 Bash 腳本，所以不需要勾選 `User data has already been base64 encoded`，AWS 會自動將該腳本進行 Base64 編碼並傳遞給 EC2 實例；點擊 `Launch instance` 啟動。

    ![](images/img_39.png)

<br>

## 連接 Web 伺服器

1. 實例狀態顯示 `Success` 之後，複製 `Public IPv4 address` 在瀏覽器查看網頁。

    ![](images/img_40.png)

<br>

## 完成

_`Submit` & `End Lab`_

<br>

___

_END：完成 Lab2 之後，可接著做 Lab5_