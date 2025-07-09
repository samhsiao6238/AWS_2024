# Task 1：啟動 EMR cluster

_使用 Amazon EMR 處理日誌_

<br>

## 開始

1. 搜尋並進入 `EMR`。

    ![](images/img_01.png)

<br>

2. 點擊右上角 `Create cluster`。

    ![](images/img_02.png)

<br>

3. 命名為 `Hive EMR cluster`。

    ![](images/img_03.png)

<br>

4. `Amazon EMR release` 選擇 `emr-5.29.0`。

    ![](images/img_04.png)

<br>

5. 在 `Application bundle` 區塊勾選 `Hadoop 2.8.5` 及 `Hive 2.3.6`。

    ![](images/img_05.png)

<br>

## 設定硬體

1. `Primary` 選擇 `m4.large`。

    ![](images/img_06.png)

<br>

2. `Core` 也選擇相同規格。

    ![](images/img_07.png)

<br>

3. 展開 `Cluster scaling and provisioning`，其中 Core 的 Instance size 必須設置為 `2`。

    ![](images/img_8.png)

<br>

4. 展開 `Networking`，先點擊 `Browse` 設定 `VPC`。

    ![](images/img_09.png)

<br>

5. 選取 `Lab VPC`，然後點擊 `Choose`。

    ![](images/img_10.png)

<br>

6. `Subnet` 預設已經是 `Lab subnet`。

    ![](images/img_11.png)

<br>

7. 展開 `Cluster termination and node replacement`，確認 `Use termination protection` 未被勾選。

    ![](images/img_12.png)

<br>

8. 展開 `Cluster logs`，點擊 `Browse S3`。

    ![](images/img_13.png)

<br>

9. 勾選前綴為 `hive-output-xxxxxx` 的 Bucket，然後點擊 `Choose`。

    ![](images/img_14.png)

<br>

10. 展開 `Security configuration and EC2 key pair Info`，在 `Amazon EC2 key pair for SSH to the cluster` 部分，從下拉選單中選取預設的 `vockey`；稍後會下載這個密鑰對文件 `labsuser.pem`。

    ![](images/img_15.png)

<br>

11. 展開 `Identity and Access Management (IAM) roles`，在 `Amazon EMR service role` 部分，使用預設的 `Choose an existing service role` 選項，然後在 `Service role` 中從下拉選單中選取 `EMR_DefaultRole`。

    ![](images/img_16.png)

<br>

12. 在下方的 `EC2 instance profile for Amazon EMR` 中，則選取 `EMR_EC2_DefaultRole`。

    ![](images/img_17.png)

<br>

13. 完成以上設置，點擊右下角的 `Create cluster`。

    ![](images/img_18.png)

<br>

## 確認安全群組

1. 滑動到最下方並展開 `EC2 security groups (firewall)`，點擊 `Primary node` 中的安全群組；這會開啟新的瀏覽頁籤並進入 `EC2` 主控台。

    ![](images/img_19.png)

<br>

2. 在 `Inbound rules` 頁籤中點擊右側的 `Edit inbound rules`。

    ![](images/img_20.png)

<br>

3. 點擊最下方的 `Add rule` 添加入站規則。

    ![](images/img_21.png)

<br>

4. `Type` 選取 `SSH`，`Source` 選取 `Anywhere-IPv4`，這會自動帶入 `0.0.0.0/0`；然後點擊 `Save rules`。

    ![](images/img_22.png)

<br>

## 返回 EMR

1. 在 `Clusters` 中，確認實體狀態是 `Waiting`。

    ![](images/img_23.png)

<br>

2. 勾選後點擊 `View details`。 

    ![](images/img_24.png)

<br>

3. 切換到 `Instances` 頁籤，確認狀態都是 `Running`。

    ![](images/img_25.png)

<br>

___

_END_
