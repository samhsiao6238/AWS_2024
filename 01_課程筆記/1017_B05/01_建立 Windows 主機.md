# 建立 Windows Server

_使用 Learner Lab 資源建立一個 Windows Server 的 EC2 實例，將在後續步驟中用於作為網站伺服器_

<br>

## 建立 EC2 實例

_進入 AWS 主控台_

<br>

1. 進入 EC2。

    ![](images/img_18.png)

<br>

2. 點擊 `Launch instance`，任意命名如 `MyInstance1018`。

    ![](images/img_19.png)

<br>

3. OS 選擇 `Windows`，`Amazon Machine Image` 選用 `Microsoft Windows Server 2022 Base`。

    ![](images/img_01.png)

<br>

4. 在 Instance type 部分，選擇 `t2.micro` 即可，這裡為了提升效能，所以選擇 `t3.large`。

    ![](images/img_20.png)

<br>

5. 點擊 `Create new key pair` 建立新的 Key pair；命名 `MyKey1018`，其餘採用預設；點擊右下角 `Create key pair` 完成建立，此時會自動下載同名密鑰文件到本地電腦。

    ![](images/img_02.png)

<br>

6. `Firewall (security groups)` 的設定全部點選，也就是開啟 HTTPS 及 HTTP 的進站規則。

    ![](images/img_03.png)

<br>

## 關於 Advanced details

1. 展開 `Advanced details` 並滑動到該區塊最下方會看到 `User data`，可用於自動化伺服器配置，節省手動安裝和設定的時間；特別注意，`User data` 預設有 `16KB` 的大小限制，並且只會在實例第一次啟動時執行，如果想讓指令每次重啟時都執行，需要將腳本放入 `C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\.`。

    ![](images/img_10.png)

<br>

2. 透過 `PowerShell` 指令在實例啟動時自動安裝 `Python`，並將 Python 加入環境變數路徑，最後刪除安裝檔。

    ```bash
    <powershell>
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe" -OutFile "C:\python-installer.exe"
    Start-Process -FilePath "C:\python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item -Path "C:\python-installer.exe"
    </powershell>
    ```

<br>

3. 安裝 XAMPP，完成後同樣刪除安裝檔。

    ```bash
    <powershell>
    Invoke-WebRequest -Uri "https://downloadsapachefriends.global.ssl.fastly.net/xampp-files/8.1.10/xampp-windows-x64-8.1.10-0-VS16-installer.exe" -OutFile "C:\xampp-installer.exe"
    Start-Process -FilePath "C:\xampp-installer.exe" -ArgumentList "/S" -Wait
    Remove-Item -Path "C:\xampp-installer.exe"
    </powershell>
    ```

<br>

4. 安裝 Google Chrome。 

    ```bash
    <powershell>
    Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile "C:\chrome_installer.exe"
    Start-Process -FilePath "C:\chrome_installer.exe" -ArgumentList "/silent /install" -Wait
    Remove-Item -Path "C:\chrome_installer.exe"
    </powershell>
    ```

<br>

5. 其他更新與安裝。

    ```bash
    <powershell>
    # 更新系統
    Install-WindowsUpdate -AcceptAll -AutoReboot

    # 安裝 IIS (網頁伺服器)
    Install-WindowsFeature -name Web-Server -IncludeManagementTools

    </powershell>
    ```

<br>

6. 只需要添加一次 Section 語句，如下安裝。

    ```bash
    <powershell>
    # 更新系統
    Install-WindowsUpdate -AcceptAll -AutoReboot

    # 安裝 Python
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe" -OutFile "C:\python-installer.exe"
    Start-Process -FilePath "C:\python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item -Path "C:\python-installer.exe"

    # 安裝 XAMPP
    Invoke-WebRequest -Uri "https://downloadsapachefriends.global.ssl.fastly.net/xampp-files/8.1.10/xampp-windows-x64-8.1.10-0-VS16-installer.exe" -OutFile "C:\xampp-installer.exe"
    Start-Process -FilePath "C:\xampp-installer.exe" -ArgumentList "/S" -Wait
    Remove-Item -Path "C:\xampp-installer.exe"

    # 安裝 Google Chrome
    Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile "C:\chrome_installer.exe"
    Start-Process -FilePath "C:\chrome_installer.exe" -ArgumentList "/silent /install" -Wait
    Remove-Item -Path "C:\chrome_installer.exe"
    
    </powershell>
    ```

<br>

## 建立並預覽指令

1. 點擊 `Launch instance` 之前，下方有個 `Prevuew code`，先點擊查看；右側會顯示指令預覽，這裡先做紀錄，之後再來透過指令重新建立一次。

    ![](images/img_21.png)

<br>

2. 包含了三個部分，分別是 `CreateSecurityGroup`、`AuthorizeSecurityGroupIngress`、`RunInstances`。

    ![](images/img_09.png)

<br>

3. CreateSecurityGroup：建立名為 `launch-wizard-1` 的安全群組，並附加到指定的 `VPC`。

    ```bash
    aws ec2 create-security-group --group-name "launch-wizard-1" --description "launch-wizard-1 created 2024-10-17T16:52:15.514Z" --vpc-id "vpc-0c46350047f5fa6e4"
    ```

<br>

4. AuthorizeSecurityGroupIngress：為 `sg-preview-1` 安全群組設置 `入口規則（Ingress Rules）`，也可稱為 `進站規則（Inbound Rules）`。

    ```bash
    aws ec2 authorize-security-group-ingress --group-id "sg-preview-1" --ip-permissions '{"IpProtocol":"tcp","FromPort":3389,"ToPort":3389,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}' '{"IpProtocol":"tcp","FromPort":443,"ToPort":443,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}' '{"IpProtocol":"tcp","FromPort":80,"ToPort":80,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}' 
    ```

<br>

5. RunInstances：啟動 EC2 實例。

    ```bash
    aws ec2 run-instances --image-id "ami-0324a83b82023f0b3" --instance-type "t3.large" --key-name "Mykey1018" --network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-preview-1"]}' --credit-specification '{"CpuCredits":"unlimited"}' --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"MyInstance1018"}]}' --metadata-options '{"HttpEndpoint":"enabled","HttpPutResponseHopLimit":2,"HttpTokens":"required"}' --private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' --count "1"
    ```

<br>

5. 點擊 `Launch instance`。

    ![](images/img_22.png)

<br>

## 使用 AWS CLI 連線

_接下來會交叉使用 CLI 與面板，所以先進行 CLI 環境設置_

<br>

1. 回到 Lab 主頁面，點擊 `! AWS Details`。

    ![](images/img_23.png)

<br>

2. 紀錄 AWS CLI 所需資訊，包含 ID、Key、Token。

    ![](images/img_24.png)

<br>

3. 在本機開啟終端機進行設置。

    ```bash
    aws configure
    ```

    ![](images/img_25.png)

<br>

4. 還要進行環境參數設置。

    ```bash
    export AWS_ACCESS_KEY_ID=<複製-ID-貼上>
    export AWS_SECRET_ACCESS_KEY=<複製-KEY-貼上>
    export AWS_SESSION_TOKEN=<複製-TOKEN-貼上>
    ```

<br>

## 運行指令確認設置完成

1. 確認當前用戶。

    ```bash
    aws sts get-caller-identity
    ```

    ![](images/img_26.png)

<br>

2. 返回的結果中會顯示角色 ARN，角色名稱就是 `voclabs`；特別注意，其中 `user2069478` 是當前 AWS 會話中的一個具體用戶身份，附加在 `voclabs` 角色之下，用來追蹤和標識用戶的操作。

    ```json
    {
        "UserId": "AROARVNR2UBM6YZZVY4SF:user2069478=_________",
        "Account": "114726445145",
        "Arn": "arn:aws:sts::114726445145:assumed-role/voclabs/user2069478=_________"
    }
    ```

<br>

3. 列出角色的附加權限。

    ```bash
    aws iam list-attached-role-policies --role-name voclabs
    ```

    ![](images/img_27.png)

<br>

4. 檢查該角色的內嵌策略。

    ```bash
    aws iam list-role-policies --role-name voclabs
    ```

    ![](images/img_28.png)

<br>

## 取得帳號密碼

_回到 EC2 實例，這時應該已經完成 `Running`_

<br>

1. 選取後，可在下方的 `Details` 及 `Security` 頁籤中紀錄幾項資訊。

    ```bash
    [default]
    aws_access_key_id=
    aws_secret_access_key=
    aws_session_token=

    Instance ID=
    Public IPv4 address=
    Security groups=
    Username=Administrator
    Password=
    ```

<br>

2. 接著點擊上方 `Connect`。

    ![](images/img_05.png)

<br>

3. 切換到 `RDP client` 頁籤，點擊下方 `Get password`。

    ![](images/img_06.png)

<br>

4. 點擊 `Upload private key file` 上傳密鑰，選取前面步驟下載到本地的密鑰文件 `*.pem`，選取後點擊右下角 `Decrypt password` 將 `Private Key` 解密成密碼。

    ![](images/img_07.png)

<br>

5. 解密後可看到這組密碼是可讀的；紀錄其中 `Username`、`Password`。

    ![](images/img_04.png)

<br>

6. 點擊 `Download remote desktop file` 下載連線遠端桌面所需連結。

    ![](images/img_11.png)

<br>

## 連線

1. 點擊下載的 `*.rdp` 文件進行連線。

    ![](images/img_29.png)

<br>

2. 輸入密碼，點擊 `Continue`。

    ![](images/img_30.png)

<br>

3. 依據使用不同的連線工具會有不同的連線過程，這裡使用 MacOS 的 `Remote Desktop`，然後進入桌面完成連線。

    ![](images/img_12.png)

<br>

4. 點擊 `Yes` 後會顯示相關資訊。

    ![](images/img_13.png)

<br>

___

_END_