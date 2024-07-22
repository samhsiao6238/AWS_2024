# 堆疊

<br>

## 說明

1. 錯誤訊息 `Service:AmazonCloudFormation, Message:Resource AWSEBAutoScalingGroup does not exist for stack awseb-e-ivs4rzg5pe-stack` 表示在 AWS EB 環境建立過程中，CloudFormation 堆疊 (stack) 中的一個資源（AWSEBAutoScalingGroup）無法找到或未成功建立。這個問題通常與 CloudFormation 堆疊的配置或 Elastic Beanstalk 環境的設置有關。

<br>

2. 登入到 CloudFormation，找到相關的堆疊並查看堆疊事件，在 `Events` 檢查是否有錯誤或失敗事件。

<br>

3. 查看 `Resources ` 確認 `AWSEBAutoScalingGroup` 是否存在以及其狀態。

<br>

4. 檢查 VPC 和子網配置，確認 RDS 子網組包含至少兩個不同可用區域的子網。

<br>

5. 確認服務角色擁有 `rds:CreateDBSubnetGroup` 和其他相關 RDS 許可權用以建立和管理 RDS 子網組。

<br>

___

_END_