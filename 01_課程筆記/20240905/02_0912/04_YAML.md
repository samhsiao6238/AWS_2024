# YAML

_任務：使用 `.yaml` 一鍵式建立雲計算環境；這裡以 `EC2` 為例_

## 說明

1. 在 AWS 中可用 `AWS CloudFormation` 完成一鍵式建立雲計算環境。

2. `CloudFormation` 使用 `.yaml` 或 `.json` 格式的模板來自動化基礎架構的部署和管理。


## 步驟規劃

1. 建立 CloudFormation 模板：使用 YAML 語法來定義 AWS 資源。

2. 部署 CloudFormation Stack：通過 AWS 控制台或 AWS CLI 部署 YAML 模板，並自動建立所有相關資源。

3. 驗證資源：確認 EC2 實例已正確啟動並運作。

## 實作 

1. 建立 CloudFormation 模板 (`cloudformation-template.yaml`)，這個模板會自動建立一個 VPC、子網路、網際網路閘道、路由表、安全群組，並在此網路架構中啟動一個 EC2 實例。

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: '使用 CloudFormation 一鍵式部署 EC2 實例的雲端環境'

Resources:
  MyVPC:
    Type: 'AWS::EC2::VPC'
    Properties: 
      CidrBlock: '10.0.0.0/16'
      EnableDnsSupport: 'true'
      EnableDnsHostnames: 'true'
      Tags: 
        - Key: Name
          Value: MyVPC

  MySubnet:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: '10.0.1.0/24'
      MapPublicIpOnLaunch: 'true'
      AvailabilityZone: 'us-west-2a'
      Tags:
        - Key: Name
          Value: MySubnet

  MyInternetGateway:
    Type: 'AWS::EC2::InternetGateway'
    Properties: 
      Tags:
        - Key: Name
          Value: MyInternetGateway

  AttachGateway:
    Type: 'AWS::EC2::VPCGatewayAttachment'
    Properties: 
      VpcId: !Ref MyVPC
      InternetGatewayId: !Ref MyInternetGateway

  MyRouteTable:
    Type: 'AWS::EC2::RouteTable'
    Properties: 
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: MyRouteTable

  MyRoute:
    Type: 'AWS::EC2::Route'
    DependsOn: AttachGateway
    Properties: 
      RouteTableId: !Ref MyRouteTable
      DestinationCidrBlock: '0.0.0.0/0'
      GatewayId: !Ref MyInternetGateway

  MySubnetRouteTableAssociation:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties: 
      SubnetId: !Ref MySubnet
      RouteTableId: !Ref MyRouteTable

  MySecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties: 
      GroupDescription: '允許 HTTP 和 SSH 流量的安全群組'
      VpcId: !Ref MyVPC
      SecurityGroupIngress: 
        - IpProtocol: tcp
          FromPort: '22'
          ToPort: '22'
          CidrIp: '0.0.0.0/0'
        - IpProtocol: tcp
          FromPort: '80'
          ToPort: '80'
          CidrIp: '0.0.0.0/0'
      Tags:
        - Key: Name
          Value: MySecurityGroup

  MyEC2Instance:
    Type: 'AWS::EC2::Instance'
    Properties: 
      InstanceType: 't2.micro'
      KeyName: 'my-key-pair' # 替換為你自己的 Key Pair 名稱
      ImageId: 'ami-0c55b159cbfafe1f0'  # 替換為你想使用的 AMI ID
      NetworkInterfaces: 
        - AssociatePublicIpAddress: 'true'
          DeviceIndex: '0'
          SubnetId: !Ref MySubnet
          GroupSet: 
            - !Ref MySecurityGroup
      Tags:
        - Key: Name
          Value: MyEC2Instance
          
Outputs:
  InstanceId:
    Description: "EC2 實例的 ID"
    Value: !Ref MyEC2Instance

  PublicIP:
    Description: "EC2 實例的公有 IP"
    Value: !GetAtt MyEC2Instance.PublicIp
```

2. 使用 AWS CLI 部署 CloudFormation Stack；確保已安裝並配置好 AWS CLI；以下建立一個 CloudFormation Stack 並命名為 `my-ec2-stack`，並根據模板建立 EC2 實例及其相關的網路資源。

```bash
aws cloudformation create-stack \
  --stack-name my-ec2-stack \
  --template-body file://cloudformation-template.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```



3. 驗證資源

部署完成後，可以通過 AWS CLI 或 AWS 控制台驗證資源是否正確建立。

#### 使用 AWS CLI 獲取 EC2 實例信息

```bash
aws cloudformation describe-stacks --stack-name my-ec2-stack
```

這將返回有關 Stack 的詳細信息，包括 EC2 實例的公有 IP 地址和實例 ID。你可以使用返回的公有 IP 來連接到 EC2 實例。

#### 使用 SSH 連接到 EC2 實例

```bash
ssh -i my-key-pair.pem ec2-user@<PublicIP>
```

記得將 `<PublicIP>` 替換為前面取得的公有 IP 地址，並確保使用正確的 `Key Pair` 文件。

### 4. 刪除 Stack（清理資源）

當你不再需要這些資源時，通過刪除 CloudFormation Stack 可以自動清理所有資源。

```bash
aws cloudformation delete-stack --stack-name my-ec2-stack
```

### 小結

這個指南展示了如何使用 AWS CloudFormation 和 YAML 模板一鍵式地建立雲計算環境。在這個例子中，我們建立了一個 VPC、子網路、網際網路閘道、安全群組，並啟動了一個 EC2 實例。你可以根據需求修改這個模板，添加其他 AWS 資源如 S3、RDS 等。