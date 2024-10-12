# Task 01：建立 VPC

<br>

## 步驟

1. 搜尋並進入服務 VPC；進入後確認所在區域為 `N. Virginia (us-east-1)`；在 Lab 環境中應該都被侷限在這個區域。

    ![](images/img_12.png)

<br>

2. 點擊進入 `VPCs` 觀察一下當前的 VPCs，有兩個。

    ![](images/img_17.png)

<br>

3. 點擊右上角 `Create VPC`，建立新的 VPC。

    ![](images/img_16.png)

<br>

## 建立設定

1. 選擇 `VPC and more`。

    ![](images/img_01.png)

<br>

2. 畫面的右側有 `Preview` 視圖，可預覽網路設施的樹狀圖。

    ![](images/img_13.png)

<br>

3. 可觀察名稱都帶有前綴 `project`，這是預設的網路名稱，稍後將進行修改。

    ![](images/img_46.png)

<br>

4. 勾選名稱自動生成 `Auto-generate`，並將預設的命名改為 `lab`；注意，右側預覽畫面中的名稱 `project-vpc` 也會更改為 `lab-vpc`，所有的前綴也會改為 `lab`。

    ![](images/img_02.png)

<br>

## 設定網路

1. 選擇 `1` 個可用區 `AZs`。

    ![](images/img_03.png)

<br>

2. 展開 `Customize subnets CIDR blocks` 區塊，公共子網 CIDR 設置為 `10.0.0.0/24`，私有子網 CIDR 設置為 `10.0.1.0/24`；使用滑鼠點擊正確位置後，以鍵盤輸入即可。

    ![](images/img_04.png)

<br>

3. NAT 閘道設為 `1` 個可用區。

    ![](images/img_05.png)

<br>

4. `VPC endpoints` 設置為 `None`。

    ![](images/img_14.png)

<br>

## 預覽並檢查

_名稱如前說明已自動變更為 `lab-vpc`_

<br>

1. Subnets (2)。

    ![](images/img_18.png)

<br>

2. Route tables (2)。

    ![](images/img_19.png)

<br>

3. Network connections (2)。

    ![](images/img_20.png)

<br>

4.  確認設定並點擊下方的 `Create VPC`。

    ![](images/img_06.png)

<br>

5. 過程還蠻耗時的。

    ![](images/img_07.png)

<br>

6. 完成後點擊 `View VPC` 進行檢視。

    ![](images/img_15.png)

<br>

## 說明 IPv4 CIDR

1. 從 Details 視窗中可以看到建立的 `IPv4 CIDR` 是 `10.0.0.0/16`；這是 VPC 的 CIDR，代表 VPC 可以擁有從 `10.0.0.0` 到 `10.0.255.255` 的 IP 地址範圍。

    ![](images/img_21.png)

<br>

2. 而子網是在 VPC 內劃分的小網路範圍，前面設定了 `10.0.0.0/24` 和 `10.0.1.0/24` 兩個子網的範圍，它們分別位於 VPC 的 `10.0.0.0/16` 之下，子網共享 VPC 的大範圍，但自身有各自的更小的 IP 範圍；可分別點擊並展開預覽圖中的子網來觀察這個範圍。

    ![](images/img_22.png)

<br>


## 官網提供圖示

1. 教程中講解建立的 VPC 結構，包含一個公有子網和一個私有子網，並且每個子網都有相應的路由表，控制流量如何進出；Internet Gateway 允許公有子網連接到互聯網，而 NAT Gateway 則允許私有子網連接到互聯網但保持隱私性；這些設置通常用於需要高安全性的架構，例如 Web 應用和內部資料庫的部署。

    ![](images/img_47.png)

___

_END_
