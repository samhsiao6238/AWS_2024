# 申請憑證

_申請 `Let's Encrypt` 憑證導入 ACM_

<br>

## 安裝 Certbot

_這是 `Let's Encrypt` 提供的 CLI 工具，以下是在 MacOS 中操作，若在 Windows 操作則安裝適配的系統工具，程序大同小異。_

<br>

1. 如果尚未安裝 Homebrew，執行安裝命令。

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

<br>

2. 使用 Homebrew 安裝 Certbot。

    ```bash
    brew install certbot
    ```

<br>

3. 確認 Certbot 已安裝成功。

    ```bash
    certbot --version
    ```

    ![](images/img_119.png)

<br>

## 生成憑證

1. 接著 Certbot 申請憑證，參數 `certonly` 表示只申請憑證，不會自動安裝到伺服器；`--manual` 是手動模式，Certbot 會要求用戶自行進行 DNS 設定來完成域名所有權的驗證；`--preferred-challenges=dns` 指定使用 DNS TXT 記錄驗證域名所有權；`-d` 指定要申請憑證的域名，這裡涵蓋主域名與子域名，憑證將同時覆蓋這兩個域名。

    ```bash
    sudo certbot certonly --manual --preferred-challenges=dns -d linebot.samhsiao6238.online -d www.linebot.samhsiao6238.online
    ```

    ![](images/img_102.png)

<br>

2. 提示輸入一個有效的電子郵件信箱。

    ![](images/img_103.png)

<br>

3. 先點擊兩次 `Y`。

<br>

4. 按照提示進行 DNS 驗證，登入 DNS 管理平台，這裡使用 `GoDaddy`，添加 `TXT` 記錄，`Name` 為 `_acme-XXXXXXX.XXXXXXX.samhsiao6238.online.`，`Value` 為 `ziVuXXXXXXXXXXXXXXXXXxNwyKdIPsvIhfUQT43o`。

    ![](images/img_104.png)

<br>

5. 完成配置顯示如下。

    ![](images/img_105.png)

<br>

6. 假如連續提示兩次，就依照指示添加兩筆紀錄。

    ![](images/img_126.png)

<br>

7. 完成時檢查 `Name`，假如尾綴的點 `.` 未被保存，請點擊編輯重新輸入，正確完成時會發現 `Name` 會自動轉換。

    ![](images/img_127.png)

<br>

## 進行檢查

1. 使用 `nslookup` 指令檢查是否正確配置。

    ```bash
    nslookup -type=TXT _acme-challenge.linebot.samhsiao6238.online
    ```

<br>

2. 顯示結果如下，表示 TXT 記錄已正確配置、DNS 記錄已生效。

    ![](images/img_106.png)

<br>

3. 根據 Certbot 的提示需要為 `_acme-challenge.www.linebot.samhsiao6238.online` 新增另一個 DNS TXT 記錄；Name `_acme-challenge.www.linebot.samhsiao6238.online.`、Value `GlYPnrhuXxd-VW54f_EXFTF3nTt-Oshwx7SwDgU72IQ`，
保留上一個記錄勿刪除。

<br>

4. 按下 ENTER 之後會收到以下訊息，會顯示憑證路徑 `/etc/letsencrypt/live/linebot.samhsiao6238.online/fullchain.pem`，私鑰路徑 `/etc/letsencrypt/live/linebot.samhsiao6238.online/privkey.pem`。

    ![](images/img_107.png)

<br>

5. 使用以下命令檢查生成的憑證。

    ```bash
    sudo ls /etc/letsencrypt/live/
    ```

<br>

6. 依據結果進一步查看。

    ```bash
    sudo ls -l /etc/letsencrypt/live/linebot.samhsiao6238.online
    ```

<br>

7. 文件包含主憑證`cert.pem`、中間憑證 `chain.pem`、完整憑證鏈 `fullchain.pem`、私鑰 `privkey.pem`。

    ![](images/img_108.png)

<br>

## 導入憑證到 ACM

_使用主控台_

<br>

1. 點擊右上角的 `Import a certificate` 按鈕，進入後有三個欄位 `Certificate body`、`Certificate private key`、`Certificate chain`。

    ![](images/img_109.png)

<br>

2. 查詢 `fullchain.pem`，並將第一個區塊貼在 `Certificate body`，著要要包含 `-----BEGIN CERTIFICATE-----` 及 `-----END CERTIFICATE-----`。

    ```bash
    sudo cat /etc/letsencrypt/live/linebot.samhsiao6238.online/fullchain.pem
    ```

<br>

3. 查詢 `privkey.pem` 並貼在 `Certificate private key`。

    ```bash
    sudo cat /etc/letsencrypt/live/linebot.samhsiao6238.online/privkey.pem
    ```

<br>

4. 查詢 `chain.pem` 並貼在 `Certificate chain`

    ```bash
    sudo cat /etc/letsencrypt/live/linebot.samhsiao6238.online/chain.pem
    ```

<br>

5. 點擊 `Import`。

<br>

6. 完成。

    ![](images/img_110.png)

<br>

## 補充說明

_使用 CLI 導入憑證到 ACM_

<br>

1. 如果憑證存放在 MacOS 系統中，可直接使用終端中的路徑傳遞給 AWS CLI，使用 `fileb://` 指定二進位文件路徑。

    ```bash
    aws acm import-certificate \
        --certificate fileb:///etc/letsencrypt/live/linebot.samhsiao6238.online/fullchain.pem \
        --private-key fileb:///etc/letsencrypt/live/linebot.samhsiao6238.online/privkey.pem \
        --region us-east-1
    ```

<br>

2. 返回 AWS Console，前往 ACM，確認導入的憑證顯示狀態為 `ISSUED`。

<br>

## 憑證效期

_特別注意 `Let's Encrypt` 憑證有效期為 `90` 天_

<br>

1. 設置自動更新。

    ```bash
    sudo certbot renew --dry-run
    ```

<br>

2. 添加以下命令到 `cron`，如此將每週執行並更新憑證。

    ```bash
    0 3 * * 1 sudo certbot renew --deploy-hook "aws acm import-certificate --certificate fileb:///etc/letsencrypt/live/<網域名稱>/fullchain.pem --private-key fileb:///etc/letsencrypt/live/<網域名稱>/privkey.pem --region us-east-1"
    ```

<br>

##

___

_END_