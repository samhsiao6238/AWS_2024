# PostgreSQL

_PostgreSQL 是一個開源的 `關聯式資料庫管理系統（RDBMS）`，AWS 提供了多種方式在 AWS 平台上運行和管理 PostgreSQL_

## Amazon RDS for PostgreSQL

1. Amazon RDS (Relational Database Service) 是 AWS 提供的一個完全托管的資料庫服務，支持多種資料庫引擎，包括 PostgreSQL。


## Amazon Aurora PostgreSQL-Compatible Edition

1. Amazon Aurora 是 AWS 提供的高性能關聯式資料庫引擎，與 PostgreSQL 兼容。

## 在 EC2 部署 PostgreSQL

_如果想要更大的控制權，可以在 Amazon EC2 上手動部署 PostgreSQL_

1. 在 EC2 上啟動一個 Linux 實例（如 Amazon Linux 或 Ubuntu）。

2. 使用標準的包管理工具安裝 PostgreSQL。

    ```bash
    sudo yum install postgresql-server  # 對於 Amazon Linux
    sudo apt-get install postgresql     # 對於 Ubuntu
    ```

3. 配置資料庫，並通過安全組允許外部訪問（例如開放 5432 端口）。

4. 使用標準的 PostgreSQL 管理工具來管理和維護資料庫。

## Amazon Lightsail

_Lightsail 是一個簡化的雲端服務，適合於快速部署應用和資料庫，這也包含 PostgreSQL 的應用_

1. 在 Lightsail 中建立一個資料庫實例，選擇 PostgreSQL 作為資料庫引擎。

2. Lightsail 提供簡單的定價模型和自動化工具，適合小型應用和快速開發。
