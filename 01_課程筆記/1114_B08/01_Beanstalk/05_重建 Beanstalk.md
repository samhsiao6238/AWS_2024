# 重新建立環境

_以下部分尚未成功，暫且做個紀錄_

<br>

## 說明

1. 在之前的步驟中所建立的 `Beanstalk` 環境是 `Single Instance` 模式，而不是 `Load Balancing, Auto Scaling` 模式，在這種情況下，`Beanstalk` 不會自動啟用負載均衡器，也就無法在 `Configuration` 配置 `Load Balancer`。

    ![](images/img_66.png)

<br>

2. 因為要使用 `ALB` 以支持 `HTTPS`，必須建立新的環境類型使用 `Load Balancing, Auto Scaling`。

<br>

## 建立 Beanstalk 環境

_使用 `Learner Lab` 建立支持負載均衡的環境，步驟大致與之前相同，以下僅簡單條列_

<br>

1. 進入服務 `Beanstalk`，左側切換到頁籤 `Environments`，接著點擊 `Create environment` 建立新的環境。

<br>

2. 選擇 `Web Server Environment`。

    ![](images/img_67.png)

<br>

3. 任意命名如 `MyWSEnb1118`；主機名稱可命名 `mylinebot1118`。

<br>

4. Platform 一樣使用 `Python 3.9`。

<br>

5. 在 `Presets ` 選擇 `High availability` 模式，這樣可以直接啟用 `Application Load Balancer`；若使用個人帳號，可選用 Single instance 來避免不必要的費用。

    ![](images/img_68.png)

<br>

6. 在 `Configure service access` 與之前相同。

    ![](images/img_69.png)

<br>

7. 在 `Set up networking, database, and tags`，特別注意開啟 `Public IP address`。

<br>

8. 因為使用 ALB，在 `Instance subnets` 需要綁定到至少兩個子網。

    ![](images/img_72.png)

<br>

9. 在 `Configure instance traffic and scaling` 頁面中，`EC2 security groups` 選擇 `default`。

    ![](images/img_73.png)

<br>

10. `Capacity` 的 `Environment type` 已自動設置為 `load balanced`；預設最小最大實例數為 1、4，如果只需要 1 個實例，可以將最小和最大值都設置為 1。

    ![](images/img_70.png)

<br>

11. `Load Balancer Type` 部分使用預設值，其中 `Application load balancer` 適合處理 `HTTP/HTTPS` 流量，支持基於路徑或主機名的流量路由，是 `Linebot Webhook HTTPS` 要求的最佳選擇；`Dedicated` 則為這個環境專門創建一個負載均衡器。

    ![](images/img_74.png)

<br>

12. 特別注意，在 `Listeners` 及 `Processes` 部分預設都是 `80`，這僅支持 HTTP，但是添加監聽需綁定在有效的 SSL 憑證上，而 SSL 憑證域名必須與當前的域名相同；由上可知，這個步驟必須在 beanstalk 建立完成並取得域名後再回來處理。

    ![](images/img_75.png)

<br>

13. 提交。

    ![](images/img_71.png)

<br>

14. 完成後紀錄域名備用。

    ![](images/img_79.png)

<br>

15. `Domain` 跟 `Domain name` 是一樣的，這在設定監聽時會選擇。

    ![](images/img_83.png)

<br>

## 設定第三方域名

_使用 GoDaddy 的 Edit DNS_

<br>

1. 已經有一個 `www CNAME` 紀錄。

    ![](images/img_86.png)

<br>

2. 添加新的紀錄。

    ![](images/img_87.png)

<br>

3. 使用新的子域名如 `linebot`，Value 寫入 Beanstalk 的網域 `mylinebot1118.us-east-1.elasticbeanstalk.com`；點擊 `Save` 儲存。

    ![](images/img_88.png)

<br>

## 申請 SSL 憑證

1. 搜尋並進入 `Certificate Manager`。

    ![](images/img_76.png)

<br>

2. 點擊 `Request a certificate`。

    ![](images/img_77.png)

<br>

3. 選取 `Request a public certificate`，點擊 `Next`。

    ![](images/img_78.png)

<br>

4. 貼上自己的第三方域名，這裡使用 GoDaddy 申請的 `linebot.SAMHSIAO6238.ONLINE`；如果需要覆蓋所有子域名，可輸入 `*.SAMHSIAO6238.ONLINE`。

    ![](images/img_80.png)

<br>

5. `Validation method` 使用預設的 `DNS validation`，AWS 會生成一條 `CNAME` 記錄，需要將這條記錄添加到 `GoDaddy` 的 `DNS` 配置中。

<br>

6. 點擊 `Request`。

    ![](images/img_81.png)

<br>

## 設置 GoDaddy

1. 目前的狀態 `Pending validation` 表示憑證的申請已經提交，但尚未完成驗證，需要完成以下操作，才能讓狀態變為 `Issued`。

    ![](images/img_89.png)

<br>

2. 在 `Domains` 區塊會顯示 `CNAME name` 及 `CNAME value`。

    ![](images/img_90.png)

<br>

3. 回到 GoDaddy，添加一條紀錄，貼上 `CNAME name` 及 `CNAME value`；完成後點擊 `Save`。

    ![](images/img_91.png)

<br>

4. 返回 ACM 中等待驗證，通常需要幾分鐘甚至幾小時，取決於 DNS 的生效速度。

<br>

5. 使用指令查詢。

    ```bash
    dig <CNAME-的-NAME>.linebot.samhsiao6238.online CNAME
    ```

<br>

## 回到 Beanstalk 環境

1. 點擊 `Configuration`，在 `Instance traffic and scaling` 點擊 `Edit`。

    ![](images/img_82.png)

<br>

2. 在 `Listeners` 點擊 `Add listener`，設置完成點擊 `Save`。

    ![](images/img_84.png)

<br>

3. 最重要的，不要忘記點擊右下角的 `Apply`。

    ![](images/img_85.png)

<br>

___

_未完_