# Sandbox

_在 `90628`中實作這個 Lab 時遇到一些挑戰，因為依據教程似乎暗示著我們從外部連線跳板進入 Cloud9，但 Lab IAM 的 SSM 權限並未開啟，而跳板進入目標時限制必須使用 SSM，不知道算不算是打關卡的概念，最終雖是成功了，但總覺得像是腦筋急轉彎，不像是教程。_

<br>

## 特別提醒事項

1. [官方宣佈](https://aws.amazon.com/tw/blogs/devops/how-to-migrate-from-aws-cloud9-to-aws-ide-toolkits-or-aws-cloudshell/) 自 `2024年07月25日` 起將關閉新用戶訪問 Cloud9，其實包含既有用戶當前（09/07）也無法訪問，所謂的現有用戶可能是指服務使用中的用戶才可繼續使用。

<br>

2. DevOps 團隊推薦兩個替代方案 `AWS IDE Toolkits` 和 `AWS CloudShell` 進行遷移。

<br>

3. `AWS IDE Toolkits` 是一套插件，允許開發者在 VSCode 等 IDE 中直接管理 AWS 資源，也就是 `Boto3`。

<br>

4. `AWS CloudShell` 是 AWS 管理控制台中的瀏覽器終端，預配置了 AWS CLI，方便隨時操作 AWS 資源。

<br>

## 說明

1. 從 `Modules` 點擊進入 `Sandbox Environment`。

    ![](images/img_01.png)

<br>

2. 參考左側欄中的說明步驟進行操作；完成 `Start Lab` 之後，點擊 `AWS` 進入主控台。

    ![](images/img_02.png)

<br>

## 開始操作

1. 搜尋並進入 `Cloud9`。

    ![](images/img_03.png)

<br>

2. 點擊 `Create enviroment`，建立新的 Cloud9 環境。

    ![](images/img_04.png)

<br>

3. 任意命名如 `_MyEnv-0906_`。

    ![](images/img_05.png)

<br>

4. 切換 `Network settings` 為 `SSH`。

    ![](images/img_07.png)

    _因為當前帳號不夠權限選擇預設的 `SSM`_

    ![](images/img_31.png)

<br>

5. 在 VPC 部分，設定為 `Work VPC` 及 `Work Public Subnet`。

    ![](images/img_48.png)

<br>

6. 其餘先使用預設，點擊右下角建立 `Create`。

    ![](images/img_06.png)

<br>

7. 瀏覽器會自動跳回清單頁面，等待建立完成。

    ![](images/img_08.png)

<br>

8. 點擊 `Open` 進入 Cloud9 的 IDE。

    ![](images/img_09.png)

<br>

9. 若要關閉歡迎頁面，點擊 `X` 即可。

    ![](images/img_10.png)

<br>

## 在 Cloud9 中使用 AWS CLI

_已經內建 CLI，無需額外安裝_

<br>

1. 可在 Cloud9 下方的終端機中執行 AWS CLI 指令；以下指令是查詢當前用戶身份，可比對這個 `Account`，這就是自己的 `Academy` 帳號；等號後面的空白通常表示該角色名中的某些部分被隱藏或省略。

    ```bash
    aws sts get-caller-identity
    ```

    ![](images/img_11.png)

<br>

2. 列出當前運行的 EC2 實例。

    ```bash
    aws ec2 describe-instances
    ```

<br>

3. 可優化指令，僅顯示 EC2 實例的 ID 及名稱。

    ```bash
    aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0]]" --output text
    ```

    ![](images/img_32.png)

<br>

4. 特別注意，這個 `Bastion Host` 會比較慢完成，可等待狀態變成 `Running` 再進行後續操作。

    ![](images/img_49.png)

<br>

## 使用 AWS SDK for Python

_Boto3_

<br>

1. 若要開啟新的終端，點擊 `+` 符號，然後點擊 `New Terminal`。

    ![](images/img_12.png)

<br>

2. 與一般使用 Python 開發的程序相同，先建立虛擬環境。

    ```bash
    python3 -m venv envSandBox
    ```

    ![](images/img_50.png)

<br>

3. 啟動虛擬環境。

    ```bash
    source envSandBox/bin/activate
    ```

    ![](images/img_51.png)

<br>

4. 先更新 pip。

    ```bash
    python3 -m pip install --upgrade pip
    ```

<br>

5. 雖然官方說明文件在語義上似乎說已經內建了 `boto3`，但實際上還是需要安裝才能使用；以下是安裝套件指令。

    ```bash
    python3 -m pip install boto3
    ```

<br>

## 啟動互動環境

1. 安裝後可先進入 Python 環境中測試看看。

    ```bash
    python3
    ```

<br>

2. 使用 Boto3 操作 EC2。

    ```python
    import boto3
    ec2 = boto3.client('ec2', region_name='us-east-1')
    ec2.describe_regions()
    ```

<br>

3. 列出了 AWS 支持的區域以及 API 請求的相關元數據。

    ![](images/img_14.png)

<br>

4. 退出 Python。

    ```bash
    exit()
    ```

<br>

## 連接 EC2 實例

_使用密鑰從本機連線 EC2_

<br>

1. 首先進行密鑰的下載；回到 `Academy` 的入口網頁，展開上方 `Details` 下拉選單，點擊其中的 `Show`。

    ![](images/img_15.png)

<br>


2. 彈窗中會顯示連線所需的各種資訊，可依據使用的系統以及連線方式進行下載或複製。

    ![](images/img_16.png)

<br>

3. 接下來要使用 `PEM 密鑰文件` 進行連線，所以點擊 `PEM 密鑰文件` 進行下載。

    ![](images/img_17.png)

<br>

4. 特別注意，下方顯示了 `SecretKey` 與 `AccessKey`，這裡的鍵名與 CLI 設定文件略有不同；其中 `SecretKey` 就是 `Secret Access Key`，`AccessKey` 就是 `AWS Access Key ID`；這兩個密鑰資料可在本機的 `~/.aws/credentials` 中查看，或透過終端機指令 `aws configure` 進行設定。

    ![](images/img_33.png)

<br>

5. 這個下載的 `labsuser.*` 文件的權限設定初始值是 `644`。

    ![](images/img_18.png)

<br>

6. 比照 EC2 教程中的說明，先修改密鑰文件的權限為 `400`；注意指令的執行路徑。

    ```bash
    chmod 400 labsuser.pem
    ```

    ![](images/img_19.png)

<br>

## EC2

_進入主控台查看當前的 EC2_

<br>

1. 先進入 EC2 查看，可看到建立 Cloud9 的過程中添加了兩個實例。

    ![](images/img_20.png)

<br>

2. 其中 `Bastion Host` 就是 `堡壘主機`，以下稱為 `跳板主機`；可通過 `Bastion Host` 來訪問其他位於私有子網中的 EC2 實例，而另一個就是子網中的 EC2 實例，也就是開啟 Cloud9 終端機時所進入的實例。

    ![](images/img_21.png)

<br>

3. 在 `Bastion Host` 中，切換下方的頁籤到 `Security`，然後點擊 `Security groups` 下方的鏈接進入安全群組設定。

    ![](images/img_23.png)

<br>

4. 進入安全群組設定後，在 `Inbound rules` 頁籤中點擊右下方的 `Edit Inbound rules`。

    ![](images/img_24.png)

<br>

5. 確認預設已經開啟 `SSH` 的 22 Port，並允許來自所有 IP 的連線 `0.0.0.0`。

    ![](images/img_22.png)

<br>

## 回到本機終端機

_或是在 EC2 主控台中連線堡壘主機_

<br>

1. 找到之前下載的密鑰文件，並在密鑰所在路徑中開啟終端，這樣可在不指定路徑下，直接運行以下指令進行 SSH 連線堡壘主機；若不在路徑中，則要添加密鑰文件的路徑。

    ```bash
    ssh -i labsuser.pem ec2-user@<Bastion Host 公共 IP>
    ```

<br>

2. 只要是 SSH 連線，第一次都會詢問是否確認要建立連線，輸入 `yes`。

    ![](images/img_25.png)

<br>

3. 成功連入會顯示如下畫面。

    ![](images/img_26.png)

<br>

## 結束 Learner Lab

_依據官方的指引到此就結束_

<br>

1. 完成以上操作後可點擊 `End Lab` 關閉 Lab，關閉後會自動清理環境、刪除所有前面步驟建立的資源。

    ![](images/img_27.png)

<br>

## 關於 Lab 操作的各種限制

_在 Lab 中的操作是有侷限性的，官方對此也加以提示_

<br>

1. 首先，Lab 的所有操作在區域選擇上僅限於 `us-east-1`。

<br>

2. `EC2` 同時運行的實例數量最多為 `9` 個，超過限制的實例將自動終止。

<br>

3. 在建立 AWS 資源時，使用預設的 `LabRole` 角色

    ![](images/img_28.png)

<br>

4. 這個角色有預設的 `LabInstanceProfile` 進行訪問和權限控制；`Instance Profile` 是一個容器，用於將 `IAM Role` 連接到 EC2 實例，這樣該實例可以通過角色獲得 AWS 服務的訪問權限。

    ![](images/img_29.png)

<br>

5. 可查看其中的 `Trust relationships`，這也是 `IAM Role` 的一部分，用於定義哪些實體可以假設這個 Role。

    ![](images/img_30.png)

<br>

## 與 EC2 相關的終端指令

_接著將示範在 Cloud9 終端中進行相關查詢指令，若嘗試在遠端連線的終端中運行將會出錯，因為 `EC2InstanceRole` 預設不具備相關權限，這裡先嘗試在 Cloud9 中執行，並體驗遠端並無權限後，將在後面步驟進行各種限制的排除與說明。_

<br>

1. 查詢 Instance Profile 的詳細信息。

    ```bash
    aws iam get-instance-profile --instance-profile-name LabInstanceProfile
    ```

<br>

2. 查詢 IAM 角色 的 Trust Relationships。

    ```bash
    aws iam get-role --role-name LabRole
    ```

<br>

3. 列出當前區域內的所有 EC2 實例。

    ```bash
    aws ec2 describe-instances
    ```

<br>

4. 查看特定 EC2 實例的狀態，這裡以這個 `Bastion Host` 為例。 

    ```bash
    aws ec2 describe-instance-status --instance-ids i-0c3135f2500a4443e
    ```

<br>

5. 查看 EC2 配額。

    ```bash
    aws ec2 describe-account-attributes
    ```

<br>

## 添加權限

_為了排除相關限制，嘗試在允許範圍內對預設的 IAM 進行設定_

<br>

1. 進入 IAM 服務。

    ![](images/img_34.png)

<br>

2. 進入 Roles，搜尋並點擊進入與 EC2 實例關聯的 IAM 角色 `EC2InstanceRole`。

    ![](images/img_35.png)

<br>

3. 為角色添加政策。

    ![](images/img_36.png)

<br>

4. 搜尋並勾選 `AmazonEC2ReadOnlyAccess`，點擊 `Add permissions`。

    ![](images/img_37.png)

<br>

## 查詢

_完成以上步驟後，可在本機連線跳板主機後的終端機中進行以下查詢_

<br>

1. 查詢跳板與目標 EC2 實例的資訊；得到正確訊息代表設定皆正確，然後繼續以下步驟。

    ```bash
    aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].[InstanceId, PublicIpAddress, PrivateIpAddress, Tags[?Key==`Name`].Value | [0]]' \
    --output table

    ```

    ![](images/img_38.png)

<br>

## 本地連線目標 EC2

_從本地經由跳板 EC2 輾轉進入目標 EC2，特別注意，外部是無法直接進入目標主機的。_

<br>

1. 先在主控台中點擊 `目標 EC2` 的 ID 進入實例頁面。

    ![](images/img_52.png)

<br>

2. 接著切換到頁籤 `Security`，並點擊進入 `安全群組`。 

    ![](images/img_53.png)

<br>

3. 在 `Inbound rules` 頁籤點擊 `Edit inbound rules`。

    ![](images/img_54.png)

<br>

4. 點擊 `Add rule` 添加規則。

    ![](images/img_55.png)

<br>

5. 在 `安全群組` 設定 `白名單`；這步驟與前面相同不再贅述，惟先前做查詢時，跳板中已預設開啟 `0.0.0.0`；完成時點擊右下角的 `Save rules`。

    ![](images/img_39.png)

<br>

## 連線

1. 在 EC2 主控台中進入 `目標 EC2`，點擊連線 `Connect` 以確認可連入目標 EC2。

    ![](images/img_40.png)

<br>

2. 特別注意，預設是 `root`，這裡要修改使用者名稱為 `ec2-user` 連線；不要使用預設的 `root`。

    ![](images/img_41.png)

<br>

3. 完成連線時顯示如下。

    ![](images/img_56.png)

<br>

## 建立密鑰對

_將跳板主機的公鑰複製到 `目標主機`；特別注意，這時候本機電腦開啟的終端機是連線在 `跳板主機`。_

<br>

1. 先在 `跳板主機` 的終端機中運型以下指令以建立密鑰對，所有提示後都按下 `ENTER` 即可；這就是在後面步驟要複製到目標實例的公鑰，如此便可免除輸入密碼並通過驗證。

    ```bash
    ssh-keygen
    ```

    ![](images/img_57.png)

<br>

2. 建立完成後，使用以下指令進入密鑰路徑，並透過 `cat` 指令將指定的公鑰內容輸出在畫面上。

    ```bash
    cd ~/.ssh && cat id_rsa.pub
    ```

<br>

3. 先將畫面保留在此，之後需要複製這個公鑰的內容；特別注意，假如有多組公鑰，可任意複製一組到遠端作為驗證，但務必確保本地存在私鑰。

    ![](images/img_42.png)

<br>

## 金鑰驗證

_回到 Cloud9 的目標 EC2 的終端機中_

<br>

1. 使用 nano 編輯授權文件 `authorized_keys`。

    ```bash
    sudo nano ~/.ssh/authorized_keys
    ```

<br>

2. 複製前面步驟在 `堡壘 EC2` 建立的公鑰，並貼在 `目標 EC2` 的授權文件上；特別注意，文件中的每一列就是一組公鑰，每一列末端無需斷行符號；編輯完成後，使用 NANO 的組合鍵進行 `儲存（control+O）`、`退出（control+X）`。

    ![](images/img_43.png)

<br>

3. 在 `目標 EC2` 終端機畫面下方會顯示 `目標 EC2` 的 `公共 IP` 與 `私有 IP`，複製其中的 `PublicIPs`。

    ![](images/img_44.png)

<br>

4. 回到 `堡壘 EC2` 的終端機中，輸入以下指令進行連線；因為已經複製了公鑰，無需使用參數指定密鑰文件。

    ```bash
    ssh ec2-user@<目標-EC2-PublicIPs>
    ```

    ![](images/img_58.png)

<br>

5. 輸入 `yes` 之後會進行連線，若成功會顯示如下畫面。

    ![](images/img_45.png)

<br>

## 驗證連線成功

1. 進入 `目標 EC2` 的目錄 `~/environment`，這就是在 `Cloud9` 終端機所顯示的資料夾，接著使用 `cat` 指令輸出 `README.md` 文件內容。

    ```bash
    cd ~/environment && cat README.md
    ```

    ![](images/img_46.png)

<br>

13. 可在 Cloud9 IDE 中使用相同指令，並比對兩者的畫面是否一致。

    ![](images/img_47.png)

<br>

___

_END_