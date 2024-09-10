# Lightsail

_Academy 帳號似乎無權限使用，切換到個人帳號_

<br>

## 說明

1. Lightsail 是一個簡化的雲端平台，服務提供簡單的界面快速設置和管理虛擬私人伺服器（VPS）、數據庫、儲存空間等，適合中小型應用程式的部署。

<br>

## 典型的應用

1. 網站託管：Lightsail 支持安裝和管理流行的 CMS（如 WordPress、Magento）或自訂網站。

<br>

2. 簡單的開發環境：適合用來快速設置測試環境或小型應用。

<br>

3. 應用程式：包括 LAMP 堆疊、Node.js、GitLab 等應用程式，適合快速部署。

<br>

## 設置指引

_以下示範使用 Lightsail 設置虛擬私人伺服器_

<br>

1. 搜尋並進入。

    ![](images/img_37.png)

<br>

2. 點擊 `Create instance`。

    ![](images/img_38.png)

<br>

3. 選擇區域。

    ![](images/img_39.png)

<br>

4. 選擇伺服器的映像系統。

    ![](images/img_40.png)

<br>

5. 選擇 OS。

    ![](images/img_41.png)

<br>

6. 選擇伺服器方案。

    ![](images/img_42.png)

<br>

7. 任意命名如 `SamHsiao-202409`，這個命名也必須是唯一識別。

    ![](images/img_43.png)

<br>

8. 點擊下方 `Create instance`。

    ![](images/img_44.png)

<br>

9. 完成；顯示為 `Pending`。

    ![](images/img_45.png)

<br>

10. 等待一下，直到顯示 `Running`。

    ![](images/img_46.png)

<br>

## 連接實例

1. 建立實例後，點擊終端機圖標可自動透過 SSH 連接實例。

    ![](images/img_47.png)

<br>

2. 點擊實例的 `Manage` 可進入細節畫面。

    ![](images/img_48.png)

<br>

3. 點擊下方 `Download default key` 可下載 `*.pem` 文件。

    ![](images/img_49.png)

<br>

4. 預設的使用者名稱依舊是 `ec2-user`。

    ![](images/img_50.png)

<br>

5. 與 EC2 操作相同，編輯遠端的 `authorized_keys` 文件。

    ```bash
    sudo ~/.ssh/authorized_keys
    ```

<br>

6. 查詢本機的 `*.pub` 文件。

    ```bash
    cat ~/.ssh/id_rsa.pub
    ```

<br>

7. 貼到遠端後，使用本機終端進行連線。

    ```bash
    ssh ec2-user@18.233.225.144
    ``` 

<br>

8. 完成連線；其餘操作如設置靜態 IP 或寫入密鑰等，與之前前面 EC2 相同，此處不再贅述。

    ![](images/img_51.png)

<br>

## 使用 Python 控制 Lightsail

_Lightsail 支援 boto3 進行自動化操作，以下示範簡單的查詢程序_

<br>

1. 安裝 `boto3`。

    ```bash
    pip install boto3
    ```

<br>

2. 建立 Python 腳本，對當前 `Lightsail` 實例進行查詢。

    ```python
    import boto3

    # 初始化 Lightsail 客戶端
    client = boto3.client('lightsail')

    # 列出所有 Lightsail 實例並回傳其狀態資訊
    def list_instances():
        try:
            # 調用 Lightsail API 來獲取實例資訊
            response = client.get_instances()
            instances = response.get('instances', [])
            
            if not instances:
                print("目前沒有任何 Lightsail 實例。")
            else:
                for instance in instances:
                    # 使用 .get() 方法來避免 KeyError
                    instance_name = instance.get('name', '無')
                    instance_state = instance.get('state', {}).get('name', '無')
                    instance_id = instance.get('instanceId', '無')
                    blueprint_id = instance.get('blueprintId', '無')
                    bundle_id = instance.get('bundleId', '無')
                    public_ip = instance.get('publicIpAddress', '無')

                    # 顯示每個實例的名稱、狀態和其他相關資訊
                    print(f"實例名稱: {instance_name}")
                    print(f"狀態: {instance_state}")
                    print(f"實例ID: {instance_id}")
                    print(f"藍圖ID（系統映像）: {blueprint_id}")
                    print(f"伺服器配置: {bundle_id}")
                    print(f"公有IP地址: {public_ip}")
                    print("-" * 40)
        except Exception as e:
            print(f"列出實例時出現錯誤: {e}")

    if __name__ == "__main__":
        # 查詢並列出所有實例
        list_instances()
    ```

    _輸出_

    ```bash
    實例名稱: SamHsiao-202409
    狀態: running
    實例ID: 無
    藍圖ID（系統映像）: amazon_linux_2023
    伺服器配置: nano_3_0
    公有IP地址: 18.233.225.144
    ```

<br>

3. 刪除實例。

    ```python
    import boto3

    # 初始化 Lightsail 客戶端
    client = boto3.client('lightsail')

    # 列出所有 Lightsail 實例並回傳其狀態資訊
    def list_instances():
        try:
            # 調用 Lightsail API 來獲取實例資訊
            response = client.get_instances()
            instances = response.get('instances', [])
            
            if not instances:
                print("目前沒有任何 Lightsail 實例。")
            else:
                for instance in instances:
                    # 使用 .get() 方法來避免 KeyError
                    instance_name = instance.get('name', '無')
                    instance_state = instance.get('state', {}).get('name', '無')
                    instance_id = instance.get('instanceId', '無')
                    blueprint_id = instance.get('blueprintId', '無')
                    bundle_id = instance.get('bundleId', '無')
                    public_ip = instance.get('publicIpAddress', '無')

                    # 顯示每個實例的名稱、狀態和其他相關資訊
                    print(f"實例名稱: {instance_name}")
                    print(f"狀態: {instance_state}")
                    print(f"實例ID: {instance_id}")
                    print(f"藍圖ID（系統映像）: {blueprint_id}")
                    print(f"伺服器配置: {bundle_id}")
                    print(f"公有IP地址: {public_ip}")
                    print("-" * 40)
        except Exception as e:
            print(f"列出實例時出現錯誤: {e}")

    # 刪除指定的 Lightsail 實例
    def delete_instance(instance_name):
        try:
            # 調用 Lightsail API 來刪除實例
            response = client.delete_instance(
                instanceName=instance_name
            )
            print(f"實例 {instance_name} 刪除成功。")
        except Exception as e:
            print(f"刪除實例 {instance_name} 時出現錯誤: {e}")

    if __name__ == "__main__":
        # 列出所有實例
        list_instances()

        # 刪除實例
        instance_to_delete = input("請輸入要刪除的實例名稱: ")
        delete_instance(instance_to_delete)
    ```

<br>

2. 會先顯示。

    ```bash
    實例名稱: SamHsiao-202409
    狀態: running
    實例ID: 無
    藍圖ID（系統映像）: amazon_linux_2023
    伺服器配置: nano_3_0
    公有IP地址: 18.233.225.144
    ```

<br>

3. 上方會顯示對話窗，可複製 `實例名稱` 然後按下 `ENTER` 進行刪除。

    ![](images/img_52.png)

<br>

4. 刪除後顯示。

    ```bash
    實例 SamHsiao-202409 刪除成功。
    ```

<br>

5. 再次查詢。

    ![](images/img_53.png)

<br>

___

_END_
