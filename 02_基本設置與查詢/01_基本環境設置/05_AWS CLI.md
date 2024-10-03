# AWS CLI

_快速設定 AWS CLI 的本地工作環境_

<br>

## 安裝

1. 開啟 [官方說明](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#cliv2-linux-install)，根據操作系統選擇安裝方式。macOS 使用者可下載 `.pkg` 文件安裝，或使用 CLI 安裝。

    ```bash
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    ```

<br>

2. 驗證安裝；特別說明，因為 AWS CLI 是用 Python 開發的，因此它需要 Python 執行環境。

    ```bash
    aws --version
    ```

    ![](images/img_41.png)

<br>

## 配置 AWS CLI

1. 執行以下指令配置 AWS CLI，系統會提示輸入 AWS Access Key ID、Secret Access Key、預設區域以及輸出格式；特別說明，這需要依據下載的密鑰文件進行設置，而不是在這裡建立一個帳號。

    ```bash
    aws configure
    ```

<br>

## AWS 本地配置說明

1. AWS 在本地的配置文件位置存放在 `~/.aws`，包含兩個文件及一個資料夾 `sso`；

    ![](images/img_42.png)

<br>

2. `credentials` 文件包含多組 Access Key 和 Secret Key。

    ![](images/img_43.png)

<br>

3. `config` 文件包含各帳號設定的區域和輸出格式。

    ![](images/img_44.png)

<br>

4. `sso` 文件夾用於儲存 AWS SSO（Single Sign-On）配置參數，用戶可通過這些 SSO 驗證訪問 AWS 資源；其中 `clientId` 和 `clientSecret` 是應用程式的客戶端 ID 和密鑰，用於身份驗證；`scopes` 則列出 `CodeWhisperer` 提供的不同服務範圍。

    ![](images/img_45.png)

<br>

5. 補充說明 `AWS CodeWhisperer`，這是整合在 VSCode 中的服務，主要功能是幫助開發者在編寫代碼時提供智能的代碼建議和補全，從而提高編程效率並減少錯誤。

<br>

6. 查詢當前 AWS CLI 或 SDK 的使用者的 ID 和 ARN，確保成功配置了 AWS CLI。

    ```bash
    aws sts get-caller-identity
    ```

<br>

## 其他指令

1. 查詢當前 AWS CLI 配置，也就是名為 `default` 的配置。

    ```bash
    aws configure list
    ```

<br>

2. 配置指定的文件，例如，要對名為 `dev` 的文件進行配置使用以下指令，若存在則可進行變更，不存在則進行建立；執行後會在 `~/.aws/credentials` 和 `~/.aws/config` 文件中建立或更新名為 `dev` 的配置。

    ```bash
    aws configure --profile dev
    ```

<br>

3. 使用配置名稱進行操作：在運行 AWS CLI 指令時，可使用參數 `--profile` 指定要使用的配置名稱。例如，使用 `dev` 配置文件運行 `aws s3 ls`。

    ```bash
    aws s3 ls --profile dev
    ```

<br>

4. 列出所有配置名稱，僅顯示所有已配置的 profile 名稱。

    ```bash
    aws configure list-profiles
    ```

<br>

5. 檢查特定配置名稱的詳細信息。

    ```bash
    aws configure list --profile dev
    ```

<br>

6. 切換配置文件，也就是設置一次性的環境變數 `AWS_PROFILE`，只在當前運作的終端機中有效，並不會修改設定的 `default`。

    ```bash
    export AWS_PROFILE=dev
    ```

<br>

7. 若要刪除配置，可手動編輯 `~/.aws/credentials` 和 `~/.aws/config` 文件；若使用以下指令並在提示下留空並按 Enter 只會維持原有設定值。

    ```bash
    aws configure --profile dev
    ```

<br>

8. 若要使用 CLI 將指定用戶如 `s3user` 指定為 `default`，必須透過以下指令完成；透過編輯文件會是更有效率的方式。

    ```bash
    aws configure set region $(aws configure get region --profile s3user)
    aws configure set output $(aws configure get output --profile s3user)
    aws configure set aws_access_key_id $(aws configure get aws_access_key_id --profile s3user)
    aws configure set aws_secret_access_key $(aws configure get aws_secret_access_key --profile s3user)
    ```

<br>

___

_END_