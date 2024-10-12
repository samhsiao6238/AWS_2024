## 建立其他子網

_當前有公共、私有子網各有一個_

<br>

1. 在左側欄選擇 `Subnets`。

    ![](images/img_08.png)

<br>

2. 建立第二個公共子網 `Cretae subnet`。

    ![](images/img_09.png)

<br>

3. 選擇剛剛建立的 `lab-vpc`。

    ![](images/img_10.png)

<br>

4. 子網名稱 `lab-subnet-public2`、AZ 選 `us-east-1b`；`IPv4 subnet CIDR block` 需要手動輸入為 `10.0.2.0/24`。

    ![](images/img_11.png)

<br>

5. 完成後點擊右下角 `Create subnet`。

    ![](images/img_23.png)

<br>

6. 接著，建立第二個私有子網，名稱 `lab-subnet-private2`、可用區 `us-east-1b`、IPv4 CIDR：`10.0.3.0/24`；完成同樣點擊 `Create subnet`，會顯示在清單的最下方。

    ![](images/img_24.png)

<br>

## 更新路由表

1. 點擊左側的 `Route tables`，然後點擊 `刷新`，就會看到新增的路由表。

    ![](images/img_25.png)

<br>

2. 勾選 `lab-rtb-private1-us-east-1a` 路由表，展開 `Actions`，點擊其中的 `Edit subnet associations`。

    ![](images/img_26.png)

<br>

3. 或在下方切換頁籤到 `Subnet associations` 然後分別點擊 `Edit subnet associations`。

    ![](images/img_44.png)

<br>

4. 勾選新建的私有子網 (`lab-subnet-private2`) ，點擊右下角 `Save associations` 便可建立與此路由表的關聯。

    ![](images/img_27.png)

<br>

5. 完成後會顯示 `2 subnets`。

    ![](images/img_28.png)

<br>

6. 比照之前步驟，接著對 `lab-rtb-public` 路由表編輯子網關聯，將新建的公共子網 (`lab-subnet-public2`) 與此路由表關聯。

    ![](images/img_29.png)

<br>

## 建立安全群組

1. 在左側欄選擇 `Security groups`。

    ![](images/img_30.png)

<br>

2. 建立新的安全群組。

    ![](images/img_31.png)

<br>

3. 名稱為 `Web Security Group`、描述 `Enable HTTP access`、VPC `lab-vpc`。

    ![](images/img_32.png)

<br>

4. 添加入站規則 `Inbound rules`。

    ![](images/img_33.png)

<br>

5. 類型 `HTTP`、來源 `Anywhere-IPv4`、描述 `Permit web requests`。

    ![](images/img_34.png)

<br>

6. 點擊右下角 `Create secyrity group`。

    ![](images/img_35.png)

<br>

## 啟動 Web 伺服器

1. 搜尋並進入 EC2 主控台，點擊 `Launch instance`；命名 `Web Server 1`，密鑰對選擇 `vockey`；接著點擊網路設置 `Network settings` 右側的 `Edit`。

    ![](images/img_36.png)

<br>

2. 選擇 `lab-vpc`、子網選擇 `lab-subnet-public2`、自動分配公共 IP `Auto-assign public IP` 設定為 `Enable`。

    ![](images/img_37.png)

<br>

3. 防火牆 `Firewall` 選擇 `Web Security Group`。

    ![](images/img_38.png)

<br>

4. 展開最下方的 `Advanced details`，將以下代碼貼到 `User data` 欄位中。

    ```bash
    #!/bin/bash
    dnf install -y httpd wget php mariadb105-server
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
    unzip lab-app.zip -d /var/www/html/
    chkconfig httpd on
    service httpd start
    ```

<br>

5. 以上是個一般的 Bash 腳本，所以不需要勾選 `User data has already been base64 encoded`，AWS 會自動將該腳本進行 Base64 編碼並傳遞給 EC2 實例；點擊 `Launch instance` 啟動。

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