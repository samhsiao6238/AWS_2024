# PostgreSQL 實作

_以下說明在 RDS 上建立 PostgreSQL 引擎，以及進行必要的互動操作，並使用 Python 腳本模擬數據生成_

<br>

## 建立 PostgreSQL 引擎

1. 在主控台搜尋並進入 `RDS`。

    ![](images/img_51.png)

<br>

2. 建立資料庫，點擊 Create database。

    ![](images/img_52.png)

<br>

3. Engine type 選擇 PostgreSQL。

    ![](images/img_53.png)

<br>

4. Version 選擇最新的 `PostgreSQL 16.4-R1`。

    ![](images/img_54.png)

<br>

5. 在下方的 `Enable RDS Extended Support` 部分不要勾選，這是一個付費服務，勾選後表示當使用的資料庫主版本已經超過了 RDS 標準支援的終止日期，同意在使用這個過期版本時支付額外的費用，具體的支援終止日期可在 AWS 文件中查閱。

    ![](images/img_55.png)

<br>

6. Templates 選擇 Free tier，也就是免費的樣板。

    ![](images/img_56.png)

<br>

7. Settings 部分，首先任意命名如 `my_postgres_db`。

    ![](images/img_57.png)

<br>

8. Master username 輸入管理員名稱，預設是 `postgres`，這裡使用自己慣用的名稱如 `sam6238`。

    ![](images/img_58.png)

<br>

9. 密碼設定要輸入兩次，並記住這個密碼。

    ![](images/img_59.png)

<br>

## 配置資料庫實例

1. 在 DB instance class 中，選擇 `db.t3.micro`，這是免費的。

    ![](images/img_60.png)

<br>

2. Storage 部分，type 選擇標準存儲類型（`General Purpose SSD(gp2)`），Allocated storage 使用預設值 `20` GiB。

    ![](images/img_61.png)

<br>

3. 在 `autoscalling` 部分，這裡只是簡單示範，可取消勾選以節省資源。

    ![](images/img_62.png)

<br>

## 配置連接

1. 在計算資源部分，若有存在的 EC2 實例，可選擇 `Connect to an EC2 compute resource`；這裡選擇 `Don't connect to an EC2 compute resource`，之後再進行手動設置。

    ![](images/img_63.png)

<br>

2. VPC 選擇預設即可。

    ![](images/img_64.png)

<br>

3. Public access 要選擇 `Yes`，這樣便會允許來自外部的訪問。

    ![](images/img_65.png)

<br>

4. 在 VPC 安全群組部分選擇現有的群組即可，但要特別注意，該群組必須允許 PostgreSQL 的預設端口 `5432` 入站規則，這在後續會進行檢查。

    ![](images/img_66.png)

<br>

5. 可另外開啟一個瀏覽器頁籤並進入 EC2 主控台，在左側點擊 `Security Groups` 進入，並點擊 `default` 安全群組的 ID 進入設定畫面，

    ![](images/img_67.png)

<br>

6. 添加進站規則，記得點擊右下角 `Save relus`。

    ![](images/img_68.png)

<br>

7. Availability zone 選擇 `No preference`，也就是讓 AWS 自動選擇一個可用區來部署資料庫實例。

    ![](images/img_69.png)

<br>

## 配置資料庫選項

1. Database authentication 選擇使用密碼驗證 `Password authentication`。

    ![](images/img_70.png)

<br>

2. 在其他設置使用預設即可中，點擊 Create database 進行建立資料庫。

    ![](images/img_71.png)

<br>

#### 6. 監控資料庫創建
資料庫的創建可能需要幾分鐘。創建完成後，您可以在 Databases 頁面查看到資料庫實例。點擊資料庫名稱來查看連接信息，包括 Endpoint 和 Port。

---

### 第二部分：使用 Python 腳本模擬數據並與 PostgreSQL 進行互動

#### 1. 安裝所需的 Python 套件
在本地開發環境或 EC2 實例上，確保安裝了 `psycopg2`（Python 的 PostgreSQL 客戶端庫），使用以下指令安裝：

```bash
pip install psycopg2-binary
```

#### 2. 連接到 PostgreSQL 的 Python 腳本範例

```python
import psycopg2
from psycopg2 import sql
import random

# 使用您的資料庫連接信息
db_host = 'your-db-endpoint.amazonaws.com'  # 從 RDS 控制台獲取 Endpoint
db_name = 'postgres'
db_user = 'postgres'
db_password = 'your-password'
db_port = 5432

# 連接到 PostgreSQL 資料庫
try:
    conn = psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_password,
        port=db_port
    )
    print("成功連接到 PostgreSQL 資料庫")
except Exception as e:
    print(f"連接失敗: {e}")

# 創建游標來執行 SQL 命令
cursor = conn.cursor()

# 創建一個表格
cursor.execute('''
    CREATE TABLE IF NOT EXISTS employees (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        age INT,
        department VARCHAR(50)
    );
''')
conn.commit()

# 使用隨機數據插入模擬數據
names = ["Alice", "Bob", "Charlie", "David", "Eve"]
departments = ["HR", "IT", "Finance", "Marketing", "Sales"]

for _ in range(10):
    name = random.choice(names)
    age = random.randint(22, 60)
    department = random.choice(departments)
    cursor.execute('''
        INSERT INTO employees (name, age, department)
        VALUES (%s, %s, %s);
    ''', (name, age, department))

conn.commit()

# 查詢並打印表中的數據
cursor.execute('SELECT * FROM employees;')
rows = cursor.fetchall()
for row in rows:
    print(row)

# 關閉游標和連接
cursor.close()
conn.close()
```

#### 3. 確認 Python 腳本生成數據並成功互動
1. 執行上述 Python 腳本，它將創建一個 employees 表，並向表中隨機插入數據。
2. 腳本成功運行後，您將看到插入到資料庫的數據，並且能夠通過查詢顯示出來。

---

### 總結：
在這個部分中，我們已經在 AWS 的 RDS 服務中成功建立了 PostgreSQL 資料庫，並使用 Python 腳本與資料庫進行了互動，模擬了數據的生成和插入。這個過程涵蓋了從 AWS RDS 的控制台設置到 Python 程式碼編寫的具體操作步驟。

接下來的部分可以進一步介紹更多 PostgreSQL 的進階功能，如索引、查詢優化、備份與還原等。