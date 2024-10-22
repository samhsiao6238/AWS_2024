# User Data 進階

_詳細解說_

<br>

## 概述

1. AWS EC2 的 User Data 允許在實例啟動時自動執行配置任務或腳本，常用於軟體安裝、服務啟動等；支援 `Shell Scripts（Linux）` 和 `PowerShell Scripts（Windows）`；在較為複雜的自動化需求情境，AWS 建議使用 `AWS CloudFormation` 或 `AWS OpsWorks` 來完成任務。

<br>

2. `User Data` 可以通過明文、文件或 Base64 編碼傳遞，並且 _在首次啟動時_，若要確保每次重啟都執行，必須添加 `<persist>true</persist>`；在實例停止後可以進行更新，但如果最初未包含 <persist>true</persist>，後續即使添加此標籤，仍無法讓腳本在每次重啟時自動執行。

<br>

3. User Data 有時間限制，默認腳本運行時間約 20 秒，過長可能中斷；另外，因為是非交互式運行，腳本應避免包含用戶輸入，如需自動確認，需加上 `-y` 標籤。

<br>

4. 在 `Windows` 和 `Linux` 的使用略有不同，`Linux` 實例使用 `Shell Scripts`` 或 Cloud-Init`；`Windows` 實例則通過 `EC2Launch` 或 `EC2Config` 處理，支援 `批次` 和 `PowerShell` 腳本。

<br>

5. 默認情況下，User Data 腳本僅在實例首次啟動時運行，希望每次重新啟動時運行，需要在腳本中加上 `<persist>true</persist>`。 

<br>

## 查看和更新

1. 可通過 AWS 控制台、AWS CLI、PowerShell 更新與查看。

<br>

2. 若要查看日誌，`Linux` 文件在 `/var/log/cloud-init-output.log`，`Windows` 則在 `C:\ProgramData\Amazon\EC2-Windows\Launch\Log\UserdataExecution.log`。

<br>

## 使用 AWS CLI 管理

1. 使用 `run-instances` 設置 User Data。

<br>

2. 使用 `modify-instance-attribute` 更新已停止實例的 User Data。

<br>

3. 使用 `describe-instance-attribute` 檢視實例 User Data。

<br>

## Cloud-Init 的使用

1. 常見指令有 `runcmd` 和 `write_files` 用於配置實例。

<br>

2. 用途：Cloud-Init 自動配置 SSH 密鑰與系統參數。

<br>

## 結合 Shell Scripts 和 Cloud-Init Directives

1. 可通過 MIME 支援多部分內容，將 Shell Scripts 和 Cloud-Init 結合使用。

<br>

## 持續運行腳本

1. 使用 `<persist>true</persist>` 或 EC2Launch v2 的 `frequency: always` 確保每次啟動時運行腳本。

<br>

##  關於超時的解決方案

_以 XAMPP 安裝為例_

<br>

1. 通過 EC2Launch v2 設置持續運行腳本以避免中斷。

<br>

## Windows 手動配置自動運行機制

_實例使用 EC2Launch 或 EC2Launch v2_

<br>

1. 連線 Windows 實例，打開 PowerShell，運行以下命令，以啟用 User Data 腳本在下次啟動時運行；特別注意，這只會在 `下一次啟動` 時運行腳本，如果希望每次啟動都執行，則需要調整 `EC2Launch` 的設定或使用 `計畫任務（Task Scheduler）`。

    ```powershell
    C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule
    ```

<br>

2. 建立一個 `計畫任務（Task Scheduler）`，設定為每次系統啟動時執行您的腳本。

<br>

## Linux 手動配置自動運行機制

_使用 `rc.local`、`cron` 或 `cloud-init`；以下每種方式都是獨立的方法，並且可以單獨使用。_

<br>

1. 將腳本添加到 `/etc/rc.local`，並確保該文件具有可執行權限，這樣腳本就會在每次系統啟動時運行。

<br>

2. 使用 `cron` 的 `@reboot` 參數，在系統重啟時執行腳本。

    ```bash
    @reboot /path/to/your-script.sh
    ```

<br>

3. 通過編輯 `cloud-init` 配置文件 `（/etc/cloud/cloud.cfg）`，並運行相關命令來強制 `cloud-init` 每次啟動時執行 User Data 腳本。

    ```yaml
    cloud_final_modules:
        - [scripts-user, always]
    ```

<br>

4. 然後運行以下命令，這樣將強制 `cloud-init` 在每次啟動時執行 User Data 腳本。

    ```bash
    sudo cloud-init clean
    sudo cloud-init init
    sudo cloud-init modules --mode=config
    sudo cloud-init modules --mode=final
    ```

<br>

## 使用啟動服務或守護程序：

1. Windows 實例可編寫一個 Windows 服務，設置為在系統啟動時自動執行腳本。

<br>

2. Linux 實例使用 `systemd` 建立一個服務，設定為在系統啟動時執行腳本。

<br>

___

_END_