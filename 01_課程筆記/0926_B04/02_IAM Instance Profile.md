# IAM Instance Profile

_IAM Instance Profile 是 EC2 與 IAM 角色之間的橋樑；以下若使用 `90629` 操作可能會遇到 IAM 權限問題，所以使用 `90630`_

<br>

## 說明

1. `IAM Instance Profile` 可將一個 IAM 角色附加到 EC2 實例上，使實例能夠繼承這個 IAM 角色的權限，從而可以執行受權的 AWS API 操作，例如存取 S3 資源、使用 DynamoDB 等。

<br>

2. `IAM Instance Profile` 是一個 IAM 角色的容器，實際上允許 EC2 實例與 IAM 角色之間建立橋樑。每個 EC2 實例都可以擁有一個 IAM Instance Profile，它通過內部的機制，讓應用程式可以取得 IAM 角色所授權的臨時安全憑證來執行操作。

<br>

3. 特別注意，無法直接在 IAM 主控台的特定頁面中對 `IAM Instance Profile` 進行管理，但可通過 `IAM Role` 頁面間接地查看哪些角色附加到了實例配置文件。

<br>

4. 登入 AWS 管理控制台並進入 IAM 控制台，在左側導航欄中，選擇 Roles（角色），當某個角色被分配給一個 EC2 實例，這個角色便會與 Instance Profile 相關聯，點擊這個具體的角色，可在角色詳細頁面中看到這個角色的使用情況，包括與實例配置文件，這個文件就是 `Instance Profile` 的關聯。

<br>

5. 特別注意，在 EC2 控制台中啟動或修改 EC2 實例時，可選擇一個 IAM 角色，它會自動創建或關聯到一個 `Instance Profile`。

<br>

## 啟動環境

1. 使用 `90630` 的 `Learner Lab`；搜尋並進入 `SageMaker`。

    ![](images/img_41.png)

<br>

2. 點擊左側 `Notebooks`。

    ![](images/img_42.png)

<br>

3. 點擊 `Create notebook instance`。

    ![](images/img_43.png)

<br>

4. 命名 `Mynotebook`，其餘使用預設。

    ![](images/img_44.png)

<br>

5. 保持其他設置為預設值，點擊 `Create notebook instance`。

    ![](images/img_46.png)

<br>

6. 建立後，Notebook 實例的狀態會先顯示為灰色的 `Pending`，當狀態變為綠色的 `InService` 時，便可繼續進行下一步，這個過程需要一點時間。

    ![](images/img_47.png)

<br>

7. 當 Notebook 實例變為 `InService` 後可點擊 `Open JupyterLab`；其中 Jupyter 就是指傳統的 Jupyter Notebook，而 JupyterLab 則是進階版，提供更多功能，適用於複雜的工作流程。

    ![](images/img_48.png)

<br>

8. 點擊開啟一個腳本。

    ![](images/img_49.png)

<br>

## 使用 boto3

1. 查詢 IAM Instance Profile，以下程式碼會列出所有 IAM Instance Profiles 及其關聯的角色。

    ```python
    import boto3

    # 創建 IAM 客戶端
    iam = boto3.client('iam')

    # 查詢所有的 Instance Profiles
    response = iam.list_instance_profiles()

    # 列出所有的 Instance Profiles
    for profile in response['InstanceProfiles']:
        print(f"Profile Name: {profile['InstanceProfileName']}")
        print(f"Role(s): {[role['RoleName'] for role in profile['Roles']]}")
        print(f"Instance Profile ARN: {profile['Arn']}")
        print('---')
    ```

<br>

2. 輸出結果如下，顯示了兩個 `Profile` 的內容；第一個 `EMR_EC2_DefaultRole`  Profile 綁定了一個同名角色 `EMR_EC2_DefaultRole`，為 EMR 提供 EC2 所需的權限來操作 S3、CloudWatch 和其他 AWS 服務，而 `ARN` 就是 Profile 的唯一識別符，可將 IAM 角色與 EC2 實例關聯起來，讓這些實例可以使用角色中的權限；另一個 Profile 是 `LabInstanceProfile`，綁定的角色為 `LabRole`， 其具體權限取決於與它關聯的策略，這些策略可能允許 EC2 實例或其他資源訪問特定的 AWS 服務，如 S3、DynamoDB、SageMaker 等；透過觀察可知 Instance Profile 使 AWS 實例可獲取需要的權限來執行特定操作，而無需硬編碼 AWS 憑證，這提高了安全性和靈活性。

    ![](images/img_50.png)

<br>

## 使用 AWS CLI

_查看具體內容_

<br>

1. 使用指令列出所有的 IAM Instance Profiles，並顯示每個配置文件的詳細信息。

    ```bash
    aws iam list-instance-profiles
    ```

<br>

2. 可加入參數 `--instance-profile-name` 查詢特定的 Instance Profile。

    ```bash
    aws iam get-instance-profile --instance-profile-name <InstanceProfileName>
    ```

<br>

___

_END_