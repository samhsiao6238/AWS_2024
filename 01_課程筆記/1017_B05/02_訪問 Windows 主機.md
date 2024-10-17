# 訪問 Windows Server 磁區

<br>

## 設定磁區共享

_先分享 Windows 主機的磁區 C_

<br>

1. 在 `C` 槽點擊 `屬性`。

    ![](images/img_31.png)

<br>

2. 切換到 `Sharing` 點擊 `Advanced Sharing`。

    ![](images/img_32.png)

<br>

3. 勾選並點擊 `OK`。

    ![](images/img_33.png)

<br>

4. 設置 EC2 安全組以允許 SMB 流量，端口是 `445`。

    ```bash
    aws ec2 authorize-security-group-ingress --group-id <EC2-安全群組-ID> --protocol tcp --port 445 --cidr <EC2-公共-IP>/32
    ```

    ![](images/img_34.png)

<br>

5. 可進入安全群組查看入站規則。

    ![](images/img_35.png)

<br>

6. 修改為 `0.0.0.0`，然後點擊 `Save rules`。

    ![](images/img_37.png)

<br>

7. 通過以下 AWS CLI 指令獲取 EC2 公共 IP

    ```bash
    aws ec2 describe-instances --instance-ids <EC2-實例-ID> --query "Reservations[*].Instances[*].PublicIpAddress"
    ```

    ![](images/img_36.png)

<br>

## 通過 SMB 連接到 C 盤

_示範環境是 macOS 系統，Linux 相同_

<br>

1. 先使安裝 smbclient；特別注意，這個安裝步驟很久，可先去忙別的。

    ```bash
    brew install samba
    ```

<br>

2. 使用指令連線。

    ```bash
    smbclient //<EC2-公共-IP>/C$ -U Administrator
    ```

<br>

3. 輸入密碼；特別注意，這個密碼是看不到的。

    ![](images/img_38.png)

<br>

## 檢查 smb.conf 文件是否存在

1. 檢查該文件是否存在於指定路徑；如果文件不存在會導致 `testparm` 錯誤。

    ```bash
    ls /opt/homebrew/etc/smb.conf
    ```

<br>

2. 手動建立 `smb.conf`。

    ```bash
    sudo nano /opt/homebrew/etc/smb.conf
    ```

<br>

3. 添加以下內容到文件中；這是一個基本的 SMB 設置，它將 `/tmp` 目錄作為共享目錄並允許訪客訪問。。

    ```bash
    [global]
        workgroup = WORKGROUP
        security = user
        map to guest = Bad User

    [shared]
        path = /tmp
        read only = no
        guest ok = yes
    ```

<br>

4. 再次運行 `testparm` 測試配置；如果配置文件正確，應該會顯示 `Loaded services file OK.` 的相關訊息。

    ```bash
    testparm
    ```

<br>

## Windows Server 防火牆設置

1. 搜尋進入 `Check firewall status`。

    ![](images/img_39.png)

<br>

2. 點擊 `Advanced Settings`。

    ![](images/img_40.png)

<br>

3. 點擊 `Action Properties`。

    ![](images/img_41.png)

<br>

4. 把三個 Profile 的 Inbound connections 都設定為 `Allow`，然後點擊 `OK`。

    ![](images/img_42.png)

<br>

5. 設定完成如下。

    ![](images/img_43.png)

<br>

## 在 Windows 安裝 OpenSSH Server

1. 在 Windows CMD 中運行以下指令安裝 OpenSSH Server。

    ```bash
    powershell -Command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'"
    powershell -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"
    ```

<br>

2. 啟動並設置 SSH 服務自動啟動。

    ```bash
    powershell -Command "Start-Service sshd"
    powershell -Command "Set-Service -Name sshd -StartupType 'Automatic'"
    ```

<br>

3. 假如需要手動開放防火牆上的 22 端口。

    ```bash
    powershell -Command "New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22"
    ```

<br>

## 透過 SCP 傳送文件

1. 在 主控台中編輯 Inbound Rule 添加 SSH。

    ![](images/img_44.png)

<br>

2. 傳送本機建立任意文件到 Windows，這裡示範使用 `~/Downloads` 中的 `test.txt`，傳送到 Windows C 槽的 `test` 目錄。

    ```bash
    scp test.txt Administrator@<EC2-公共-IP>:C:/test
    ```

<br>

3. 第一次連線會詢問是否確定，輸入密碼後會立即傳送文件。

    ![](images/img_45.png)

<br>

4. 透過 smb 連線並查看。

    ![](images/img_46.png)

<br>

## MacOS 使用 Finder 連線

1. `Finder` > `前往` > `連接到伺服器`。

    ![](images/img_47.png)

<br>

2. 輸入並連線。

    ```bash
    smb://<EC2-公共-IP>
    ```

    ![](images/img_48.png)

<br>

3. 再次點擊連線。

    ![](images/img_49.png)

<br>

4. 輸入帳戶 `Administrator` 及密碼。

    ![](images/img_50.png)

<br>

5. 加載卷宗。

    ![](images/img_51.png)

<br>

6. 完成時可在 Finder 中查看。

    ![](images/img_52.png)

<br>

___

_END_