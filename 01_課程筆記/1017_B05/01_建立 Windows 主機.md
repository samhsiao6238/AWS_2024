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

_實作 User data；進階操作_

<br>

1. 展開 `Advanced details` 並滑動到該區塊最下方會看到 `User data`，可用於自動化伺服器配置，節省手動安裝和設定的時間；特別注意，`User data` 預設有 `16KB` 的大小限制，並且只會在實例第一次啟動時執行，如果想讓指令每次重啟時都執行，需要將腳本放入 `C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\.`。

    ![](images/img_10.png)

<br>

2. 透過 `PowerShell` 指令在實例啟動時自動更新。

    ```bash
    <powershell>
    Install-WindowsUpdate -AcceptAll -AutoReboot
    </powershell>
    ```

<br>

3. 安裝 `Python`，並將 Python 加入環境變數路徑，最後刪除安裝檔。

    ```bash
    <powershell>
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe" -OutFile "C:\python-installer.exe"
    Start-Process -FilePath "C:\python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item -Path "C:\python-installer.exe"
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

5. 安裝 XAMPP。

    ```bash
    <powershell>
    # 使用 Invoke-WebRequest 代替 curl 來下載 XAMPP，適合 PowerShell 環境
    Invoke-WebRequest -Uri "https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe/download" -OutFile "C:\xampp-installer.exe"

    # 靜默安裝 XAMPP
    Start-Process -FilePath "C:\xampp-installer.exe" -ArgumentList "--mode unattended --unattendedmodeui none --prefix C:\xampp" -Wait

    # 刪除安裝檔案
    Remove-Item -Path "C:\xampp-installer.exe"

    # 啟動 Apache 和 MySQL 服務，使用 Start-Process 啟動批處理文件
    Start-Process -FilePath "C:\xampp\apache_start.bat" -Wait
    Start-Process -FilePath "C:\xampp\mysql_start.bat" -Wait
    </powershell>
    ```

<br>


6. 其他安裝；暫時不用加入 `user data`，持續補充。

    ```bash
    <powershell>
    # 安裝 IIS (網頁伺服器)
    Install-WindowsFeature -name Web-Server -IncludeManagementTools

    </powershell>
    ```

<br>

7. 更新防火牆，暫時不用加入 `user data`。

    ```bash
    <persist>
    rem 啟動 Apache 和 MySQL
    cd C:\xampp
    apache_start.bat
    mysql_start.bat

    rem 設定防火牆規則，允許 HTTP (80), HTTPS (443) 和 MySQL (3306) 的入站連接
    netsh advfirewall firewall add rule name="Allow HTTP" dir=in action=allow protocol=TCP localport=80
    netsh advfirewall firewall add rule name="Allow HTTPS" dir=in action=allow protocol=TCP localport=443
    netsh advfirewall firewall add rule name="Allow MySQL" dir=in action=allow protocol=TCP localport=3306

    </persist>
    ```

<br>

8. 若運行多項功能，只需要添加一次 Section 語句；以下將預設進行系統更新，並安裝 Python、Chrome 及 XAMPP；另外，在此先不進行啟動應用，也不要設置防火牆。

    ```bash
    <powershell>
    # 更新系統並自動重啟
    Install-WindowsUpdate -AcceptAll -AutoReboot

    # 下載並安裝 Python
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe" -OutFile "C:\python-installer.exe"
    Start-Process -FilePath "C:\python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item -Path "C:\python-installer.exe"

    # 下載並安裝 Google Chrome
    Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile "C:\chrome_installer.exe"
    Start-Process -FilePath "C:\chrome_installer.exe" -ArgumentList "/silent /install" -Wait
    Remove-Item -Path "C:\chrome_installer.exe"

    </powershell>
    ```

<br>

9. 特別說明，`EC2 User Data` 腳本有預設的執行時間限制，通常是 `20 秒`，如果腳本過長或過於複雜，某些命令可能無法完全執行。

<br>

## 建立並預覽指令

1. 點擊 `Launch instance` 之前，下方有個 `Preview code`，先點擊查看；右側會顯示指令預覽，這裡先做紀錄，之後再來透過指令重新建立一次。

    ![](images/img_21.png)

<br>

2. 包含了三個部分，分別是 `CreateSecurityGroup`、`AuthorizeSecurityGroupIngress`、`RunInstances`。

    ![](images/img_09.png)

<br>

3. `CreateSecurityGroup` 區塊預設會建立名為 `launch-wizard-1` 的安全群組，並附加到指定的 `VPC`。

    ![](images/img_71.png)

<br>

4. `AuthorizeSecurityGroupIngress` 會自動依據安全群組為 `ID` 為 `sg-preview-1` 的安全群組設置 `入口規則（Ingress Rules）`，也可稱為 `進站規則（Inbound Rules）`。

    ![](images/img_70.png)

<br>

5. `RunInstances` 進行啟動 EC2 實例；這段指令很長，會依據各項設定自動生成。

    ![](images/img_72.png)

<br>

6. 點擊 `Download` 下載語法備用。

    ![](images/img_58.png)

<br>

7. 點擊 `Launch instance`。

    ![](images/img_22.png)

<br>

8. 沒特殊狀況就會顯示 `Success`，但這僅是完成設定，實例尚未完成啟動，回到 EC2 清單查看。

    ![](images/img_59.png)

<br>

## 準備紀錄用文檔

_接下來會有一些資訊需要記錄備用，在一般正式的 Lab 中會建議使用 Cloud9 做紀錄，但這個 Lab 並未授權，請自行使用任意文件編輯器做紀錄。_

<br>

1. 建立文檔後，先貼上以下內容；這裡特別使用全形的引號 `【】`，僅是基於有利於區別字串資訊內容與引號，無其他用意，`Username` 部分已填入預設的內容 `Administrator`，共享名稱部分如為變動則是設定為 `C_Drive`。

    ```bash
    # 複製 AWS CLI 貼上
    [default]
    aws_access_key_id=【】
    aws_secret_access_key=【】
    aws_session_token=【】

    # 複製以上 Value 貼上
    export AWS_ACCESS_KEY_ID=<複製-ID-貼上>
    export AWS_SECRET_ACCESS_KEY=<複製-KEY-貼上>
    export AWS_SESSION_TOKEN=<複製-TOKEN-貼上>

    # 在操作步驟中複製
    Instance ID=【】
    Public IPv4 address=【】
    Security groups=【】
    Username=【Administrator】
    Password=【】
    Shared Name of Drive C=【C_Drive】
    ```

<br>

## 使用 AWS CLI 連線

_在等待實例初始化同時，可先進行 CLI 環境設置_

<br>

1. 回到 Lab 主頁面，點擊右上角的文字圖標 `! AWS Details`。

    ![](images/img_23.png)

<br>

2. 在 `AWS CL` 尾端點擊 `Show` 展開內容。

    ![](images/img_60.png)

<br>

3. 複製展開後的內容，這是 AWS CLI 所需資訊，包含 ID、Key、Token；貼到前面步驟所建立的文檔中。

    ![](images/img_24.png)

<br>

4. 複製貼上過程中要特別注意尾端不要添加多餘的空格或換行符號。

    ![](images/img_61.png)

<br>

5. 將值貼到下方準備好的字串中。

    ![](images/img_89.png)

<br>

6. 開啟終端機進行環境參數設置；可以逐行輸入以下指令。

    ```bash
    export AWS_ACCESS_KEY_ID=<複製-ID-貼上>
    export AWS_SECRET_ACCESS_KEY=<複製-KEY-貼上>
    export AWS_SESSION_TOKEN=<複製-TOKEN-貼上>
    ```

<br>

7. 或是將紀錄中的整段一次性貼上運行；特別說明，在終端機中設定環境變數時，其生命週期僅限於當前視窗，假如另外開啟新的視窗，必須再次重複這個步驟。

    ![](images/img_90.png)

<br>

8. 設定 AWS 內建文檔；特別說明，在 Lab 環境中其實可不用執行 `aws configure`，因為環境變數的優先權是在設定檔之前，而 Token 必須透過環境變數設定，如果只設置 `TOKEN` 但沒有設置相應的 `ID` 和 `KEY` 到環境變數，AWS CLI 會無法進行身份驗證。

    ```bash
    aws configure
    ```

    ![](images/img_25.png)

<br>

## 運行指令確認設置完成

1. 確認當前用戶。

    ```bash
    aws sts get-caller-identity
    ```

    ![](images/img_26.png)

<br>

2. 返回的結果中會顯示角色 ARN，角色名稱就是 `voclabs`；特別注意，其中 `user2069478` 是當前 AWS 會話中的一個具體用戶身份，附加在 `voclabs` 角色之下，用來追蹤和標識用戶的操作。

    ![](images/img_62.png)

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

_回到 EC2 實例，這時應該已經完成 `Status check`，特別注意，並非以 `Instance state` 的 `Running` 作為確認資訊，而是要確認實例已經功過檢查。_

<br>

1. 務必確認所有狀態都已完成。

    ![](images/img_63.png)

<br>

2. 勾選實例，先複製下方 `ID` 及 `IP` 到紀錄中；特別注意，`ID` 並不包含尾端括號及括號內字串，點擊複製圖標時，也不會將其複製，此後不再贅述。

    ![](images/img_64.png)

<br>

3. 接著切換到 `Security` 頁籤，複製 `Security groups` 的 `ID` 到紀錄中。

    ![](images/img_65.png)

<br>

4. 接著點擊上方頁籤中的 `Connect`。

    ![](images/img_05.png)

<br>

5. 切換到 `RDP client` 頁籤，點擊下方 `Get password`。

    ![](images/img_06.png)

<br>

6. 點擊 `Upload private key file` 上傳密鑰，選取前面步驟下載到本地的密鑰文件 `*.pem`，選取後點擊右下角 `Decrypt password` 將 `Private Key` 解密成密碼。

    ![](images/img_07.png)

<br>

7. 解密後可看到這組密碼是可讀的；紀錄其中 `Username`、`Password`。

    ![](images/img_04.png)

<br>

8. 點擊 `Download remote desktop file` 下載連線遠端桌面所需連結。

    ![](images/img_11.png)

<br>

## 連線

1. 點擊下載的 `*.rdp` 文件進行連線；這是一個與實例同名的文件。

    ![](images/img_29.png)

<br>

2. 輸入密碼，點擊 `Continue`。

    ![](images/img_30.png)

<br>

3. 依據使用不同的連線工具會有不同的連線過程，這裡使用 MacOS 的 `Remote Desktop`，然後進入桌面完成連線。

    ![](images/img_12.png)

<br>

4. 點擊 `Yes` 後完成啟動；可以看到桌面已經安裝了 Google Chrome。

    ![](images/img_16.png)

<br>

5. 畫面右側會有詳細連線資訊。

    ![](images/img_13.png)

<br>

6. 透過在終端機中查詢 Python 版本以確定完成安裝。

    ![](images/img_17.png)

<br>

## 重新編輯 User Data

_對於實例來說，User Data 只會在首次啟動時自動執行；以下先說明如何修改 User Data，至於如何讓編輯過的文件生肖，將另作說明。_

<br>

1. 假如是已經啟動的實例，先停止實例。

    ![](images/img_73.png)

<br>

2. 點擊 `Edit user data`。

    ![](images/img_66.png)

<br>

3. 預設以編輯方式進行修正 `Modify user data text`，完成後點擊 `Save`。

    ![](images/img_67.png)

<br>

4. 重新啟動實例。

    ![](images/img_68.png)

<br>

5. 下載新的 `remote desktop file`。

    ![](images/img_69.png)

<br>

## 使用例外捕捉

1. 在 `PowerShell`  中可加入簡單的錯誤處理，確保過程中出現問題使腳本中斷。

    ```bash
    try {
        # 安裝 Python
        Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe" -OutFile "C:\python-installer.exe"
        Start-Process -FilePath "C:\python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
        Remove-Item -Path "C:\python-installer.exe"
    } catch {
        Write-Host "Python 安裝失敗: $_"
    }
    ```

<br>

## 查看實例運行

1. 查看實例運行中的日誌。

    ![](images/img_74.png)

<br>

## 完成 XAMPP 安裝

1. 下載 XAMPP 安裝程式。

    ```bash
    curl -L -o C:\xampp-installer.exe https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe/download
    ```

<br>

2. 使用無人值守模式自動化部署、安裝 `XAMPP` 到 `C:\xampp` 目錄；`unattended` 模式下安裝過程不會提示用戶進行任何輸入或確認。這對於自動化部署來說非常有用。
無人值守安裝會自動使用默認選項進行安裝，並不需要用戶手動介入。

    ```bash
    C:\xampp-installer.exe --mode unattended --unattendedmodeui none --prefix C:\xampp
    ```

<br>

3. 查詢安裝進度，透過 `進程是否消失` 來確定安裝是否完成；這個過程約略需要五分鐘，甚至更多。

    ```bash
    tasklist | findstr /I "xampp-installer"
    ```

<br>

4. 直到確認進程已經結束。

    ![](images/img_75.png)

<br>

5. 刪除安裝檔案。

    ```bash
    del C:\xampp-installer.exe
    ```

<br>

6. 啟動 Apache 和 MySQL 服務；使用 `start` 指令載不阻塞終端的情況下同時啟動以下兩個服務，`""` 是提供給 `start` 指令的終端機空標題；`/min` 參數來最小化批次運行，這樣第二個指令視窗不會等待使用者按下 `ENTER`。

    ```bash
    start /min "" C:\xampp\apache_start.bat
    start /min "" C:\xampp\mysql_start.bat
    ```

<br>

7. 啟動 XAMPP 應用。

    ```bash
    start "" C:\xampp\xampp-control.exe
    ```

<br>

8. 應用程式視窗。

    ![](images/img_76.png)

<br>

___

_END_