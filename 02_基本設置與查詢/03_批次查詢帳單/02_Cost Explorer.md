# AWS Cost Explorer API

_根據 [官網說明](https://aws.amazon.com/tw/aws-cost-management/aws-cost-explorer/pricing/)，透過 `AWS Cost Explorer API` 查詢，每項請求會產生 0.01 USD 的費用_

<br>

## 說明

_以下指令都直接與 `AWS Cost Explorer API` 進行互動，每次查詢產生 0.01 美金的費用。如果只是操作其他服務如 EC2、S3 等，不涉及 `Cost Explorer`，則不會產生這類費用。_

<br>

1. 查詢指定日期範圍內的成本和使用情況。

    ```bash
    aws ce get-cost-and-usage --time-period Start=YYYY-MM-DD,End=YYYY-MM-DD --granularity DAILY --metrics "UnblendedCost"
    ```

<br>

2. 查詢未來的成本預測。

    ```bash
    aws ce get-cost-forecast --time-period Start=YYYY-MM-DD,End=YYYY-MM-DD --metric "UNBLENDED_COST" --granularity DAILY
    ```

<br>

3. 查詢資源預算利用率。

    ```bash
    aws ce get-reservation-utilization --time-period Start=YYYY-MM-DD,End=YYYY-MM-DD --granularity DAILY
    ```

<br>

4. 查詢 Savings Plans 的使用情況。

    ```bash
    aws ce get-savings-plans-utilization --time-period Start=YYYY-MM-DD,End=YYYY-MM-DD --granularity DAILY
    ```

<br>

5. 查詢 Savings Plans 的覆蓋範圍。

    ```bash
    aws ce get-savings-plans-coverage --time-period Start=YYYY-MM-DD,End=YYYY-MM-DD --granularity DAILY
    ```

<br>

___

_END_