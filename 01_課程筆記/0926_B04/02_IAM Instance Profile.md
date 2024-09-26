# IAM Instance Profile

_IAM Instance Profile 是 EC2 與 IAM 角色之間的橋樑_

## 說明

1. `IAM Instance Profile` 可將一個 IAM 角色附加到 EC2 實例上，使實例能夠繼承這個 IAM 角色的權限，從而可以執行受權的 AWS API 操作，例如存取 S3 資源、使用 DynamoDB 等。

2. `IAM Instance Profile` 是一個 IAM 角色的容器，實際上允許 EC2 實例與 IAM 角色之間建立橋樑。每個 EC2 實例都可以擁有一個 IAM Instance Profile，它通過內部的機制，讓應用程式可以取得 IAM 角色所授權的臨時安全憑證來執行操作。

3. 特別注意，無法直接在 IAM 主控台的特定頁面中對 `IAM Instance Profile` 進行管理，但可通過 `IAM Role` 頁面間接地查看哪些角色附加到了實例配置文件。

4. 登入 AWS 管理控制台並進入 IAM 控制台，在左側導航欄中，選擇 Roles（角色），當某個角色被分配給一個 EC2 實例，這個角色便會與 Instance Profile 相關聯，點擊這個具體的角色，可在角色詳細頁面中看到這個角色的使用情況，包括與實例配置文件，這個文件就是 `Instance Profile` 的關聯。

5. 特別注意，在 EC2 控制台中啟動或修改 EC2 實例時，可選擇一個 IAM 角色，它會自動創建或關聯到一個 `Instance Profile`。

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


## 使用 AWS CLI

1. 使用指令列出所有的 IAM Instance Profiles，並顯示每個配置文件的詳細信息。

```bash
aws iam list-instance-profiles
```

2. 可加入參數 `--instance-profile-name` 查詢特定的 Instance Profile。

```bash
aws iam get-instance-profile --instance-profile-name <InstanceProfileName>
```


要查詢具體的「Instance Profile 名稱」，可以有以下幾種方式，具體步驟包括在 AWS 主控台、使用 AWS CLI 或 `boto3`。

## 在 EC2 主控台查詢 Instance Profile 名稱

1. 通過 EC2 主控台查看
1. 登入 AWS 管理控制台，導航到 EC2 控制台。
2. 點擊左側選單中的 Instances（實例）查看 EC2 實例列表。
3. 選擇你感興趣的 EC2 實例，進入實例詳細頁面。
4. 在 Description（描述）部分，你會看到與該實例相關聯的 IAM Role（IAM 角色）。點擊該角色的名稱。
5. 點擊後進入 IAM 角色頁面，在該角色的「Trusted entities」（信任實體）中，你可以看到與此角色關聯的 Instance Profile 名稱。

#### 方法二：在 IAM 控制台查看
1. 登入 AWS 管理控制台，導航到 IAM 控制台。
2. 點擊左側選單中的 Roles（角色）。
3. 選擇一個與 EC2 實例關聯的 IAM 角色，進入角色詳細頁面。
4. 在該角色的詳細信息中，可以看到與之關聯的 Instance Profile 名稱。

### 2. 使用 AWS CLI 查詢 Instance Profile 名稱

你可以使用 AWS CLI 指令來查詢所有的 Instance Profiles，然後查看具體名稱。以下是查詢所有 Instance Profiles 的指令：

```bash
aws iam list-instance-profiles
```

這條指令會返回所有 IAM Instance Profiles 的清單，其中包括具體的 InstanceProfileName、ARN 以及其他詳細信息。

### 3. 使用 boto3 查詢 Instance Profile 名稱

你也可以使用 `boto3` 程式來查詢所有的 Instance Profiles。這段 Python 程式碼會列出所有的 Instance Profile 及其相關資訊：

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

### 總結
- 你可以在 EC2 控制台 或 IAM 控制台 中找到具體的 Instance Profile 名稱。
- 也可以使用 AWS CLI 或 boto3 查詢並列出所有的 Instance Profiles。

這些方法能幫助你快速找到 EC2 實例所關聯的具體 Instance Profile 名稱。
