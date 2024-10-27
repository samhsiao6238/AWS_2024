# 自動化操作 RSD

_建立 MySQL 資料庫_

<br>

## 準備工作

1. 在終端機輸入 AWS CLI，並輸出為環境變數。

    ```bash
    export AWS_ACCESS_KEY_ID=$aws_access_key_id
    export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
    export AWS_SESSION_TOKEN=$aws_session_token
    ```

<br>

2. 設置環境變數到記錄文件。

    ```bash
    LOG_FILE="$HOME/Desktop/rds_setup_log.txt"
    DB_NAME="mydatabase-01"
    DB_ENDPOINT="mydatabase-01.cacwqxy1xikj.us-east-1.rds.amazonaws.com"
    DB_USERNAME="sam6238"
    DB_PASSWORD="<自行輸入>"
    DB_SCHEMA="db20240718"
    DB_PORT="3306"
    REGION="us-east-1"
    SG_NAME="MyRDSGroupRule"
    ENGINE="mysql"
    DB_INSTANCE_CLASS="db.t4g.micro"
    STORAGE_TYPE="gp3"
    ENGINE_VERSION="8.0.39"
    ```

<br>

3. 請務必記得自行輸入密碼。

    ```bash
    DB_PASSWORD=""
    ```

<br>


4. 在桌面建立一個記錄文件，並寫入環境變數。

    ```bash
    touch "$LOG_FILE" && code -n "$LOG_FILE"
    ```

<br>

5. 將環境變數寫入 LOG_FILE。

    ```bash
    echo "DB_NAME=\"$DB_NAME\"" | tee -a "$LOG_FILE"
    echo "DB_ENDPOINT=\"$DB_ENDPOINT\"" | tee -a "$LOG_FILE"
    echo "DB_USERNAME=\"$DB_USERNAME\"" | tee -a "$LOG_FILE"
    echo "DB_PASSWORD=\"$DB_PASSWORD\"" | tee -a "$LOG_FILE"
    echo "DB_SCHEMA=\"$DB_SCHEMA\"" | tee -a "$LOG_FILE"
    echo "DB_PORT=\"$DB_PORT\"" | tee -a "$LOG_FILE"
    echo "REGION=\"$REGION\"" | tee -a "$LOG_FILE"
    echo "SG_NAME=\"$SG_NAME\"" | tee -a "$LOG_FILE"
    ```

<br>

## 建立安全群組並配置規則

1. 建立安全群組並添加 `MySQL/Aurora` 的允許訪問規則，並記錄 `GroupId` 為 `SG_ID`。

    ```bash
    SG_ID=$(aws ec2 create-security-group \
        --group-name "$SG_NAME" \
        --description "Security group for RDS with MySQL access" \
        --region "$REGION" \
        --query 'GroupId' \
        --output text)

    echo "SG_ID=\"$SG_ID\"" | tee -a "$LOG_FILE"
    ```

<br>

2. 添加規則，允許所有 IP 訪問。

    ```bash
    aws ec2 authorize-security-group-ingress \
        --group-id "$SG_ID" \
        --protocol tcp \
        --port "$DB_PORT" \
        --cidr 0.0.0.0/0 \
        --region "$REGION"
    ```

    ![](images/img_56.png)

<br>

## 建立 RDS MySQL

1. 建立 RDS 資料庫，並將其設置為可公開訪問。

    ```bash
    aws rds create-db-instance \
        --db-instance-identifier "$DB_NAME" \
        --db-instance-class "$DB_INSTANCE_CLASS" \
        --engine "$ENGINE" \
        --allocated-storage 20 \
        --master-username "$DB_USERNAME" \
        --master-user-password "$DB_PASSWORD" \
        --backup-retention-period 7 \
        --vpc-security-group-ids "$SG_ID" \
        --availability-zone "$REGION"a \
        --no-multi-az \
        --publicly-accessible \
        --no-auto-minor-version-upgrade \
        --storage-type "$STORAGE_TYPE" \
        --engine-version "$ENGINE_VERSION" \
        --db-name "$DB_SCHEMA" \
        --region "$REGION" | tee -a "$LOG_FILE"
    ```

<br>

## 檢查 RDS 狀態並記錄終端點

1. 建立 RDS 後，狀態需要一段時間才能變為 `available`。可以通過以下指令定期檢查。

    ```bash
    aws rds describe-db-instances \
        --db-instance-identifier "$DB_NAME" \
        --region "$REGION" \
        --query 'DBInstances[0].DBInstanceStatus' \
        --output text
    ```

<br>

## 更新 RDS 終端點到記錄文件

1. 一旦 RDS 可用，取得並記錄其終端點 `DB_ENDPOINT`。

    ```bash
    DB_ENDPOINT=$(aws rds describe-db-instances \
        --db-instance-identifier "$DB_NAME" \
        --region "$REGION" \
        --query 'DBInstances[0].Endpoint.Address' \
        --output text)

    echo "DB_ENDPOINT=\"$DB_ENDPOINT\"" | tee -a "$LOG_FILE"
    ```

<br>

