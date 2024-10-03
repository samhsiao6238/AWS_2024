# ETL

_使用 AWS Glue 對數據集進行 ETL 操作_

<br>

## 任務 3，使用 CloudFormation 建立並部署 Glue 爬網程式

_在 `Task 1` 中，使用 Glue 控制台創建爬網程式以檢查數據源並推斷其結構。當爬網程式多次運行時，會自動查找數據存儲中的新增或已修改文件，並輸出自上次運行以來發現的新表和分區。_

## 搜尋 `gluelab` IAM 角色的 ARN

1. 進入 IAM 控制台。

    ![](images/img_51.png)

2. 在左側欄中選擇 Roles，接著點擊清單中的 `gluelab`。

    ![](images/img_52.png)

3. 複製 `Summary` 中的 ARN 備用。

    ![](images/img_53.png)

## 建立 CloudFormation 模板

1. 進入 `Cloud9` 控制台。

![](images/img_54.png)

2. 在預設的實體 `Cloud9 Instance` 點擊 `Open` 打開 IDE；這會開啟新的瀏覽夜面。

![](images/img_55.png)

3. 在 Cloud9 IDE 中，展開上方功能選單的 `File`，點及 `New File` 新建文件。

![](images/img_56.png)

4. 在編輯前，直接先將空文件保存為 `gluecrawler.cf.yml`；這些操作的快速鍵與本地常用編輯器都相同。

![](images/img_57.png)

5. 將以下代碼複製並粘貼到文件中：

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Parameters:
        CFNCrawlerName:
            Type: String
            Default: cfn-crawler-weather
        CFNDatabaseName:
            Type: String
            Default: cfn-database-weather
        CFNTablePrefixName:
            Type: String
            Default: cfn_sample_1-weather
    Resources:
        CFNDatabaseWeather:
            Type: AWS::Glue::Database
            Properties:
                CatalogId: !Ref AWS::AccountId
                DatabaseInput:
                    Name: !Ref CFNDatabaseName
                    Description: "AWS Glue container to hold metadata tables for the weather crawler"
        CFNCrawlerWeather:
            Type: AWS::Glue::Crawler
            Properties:
                Name: !Ref CFNCrawlerName
                Role: <GLUELAB-ROLE-ARN>
                Description: AWS Glue crawler to crawl weather data
                DatabaseName: !Ref CFNDatabaseName
                Targets:
                    S3Targets:
                        - Path: "s3://noaa-ghcn-pds/csv/by_year/"
                TablePrefix: !Ref CFNTablePrefixName
                SchemaChangePolicy:
                    UpdateBehavior: "UPDATE_IN_DATABASE"
                    DeleteBehavior: "LOG"
                Configuration: "{\"Version\":1.0,\"CrawlerOutput\":{\"Partitions\":{\"AddOrUpdateBehavior\":\"InheritFromTable\"},\"Tables\":{\"AddOrUpdateBehavior\":\"MergeNewColumns\"}}}"
    ```

6. 在文件中，將 `<GLUELAB-ROLE-ARN>` 替換為你之前複製的 `gluelab` 角色的 ARN。
7. 保存模板文件。

#### 驗證並部署模板

1. 在 AWS Cloud9 終端中，運行以下命令來驗證 CloudFormation 模板：

   ```bash
   aws cloudformation validate-template --template-body file://gluecrawler.cf.yml
   ```

   - 如果模板格式正確，應該會顯示驗證成功的消息。
   - 注意：如果收到「YAML not well-formed」的錯誤，請檢查 `gluelab` 角色名稱的值，並檢查每行的縮進和間距，確保 YAML 格式正確。

2. 運行以下命令來建立 CloudFormation 堆疊：

   ```bash
   aws cloudformation create-stack --stack-name gluecrawler --template-body file://gluecrawler.cf.yml --capabilities CAPABILITY_NAMED_IAM
   ```

   - 注意：命令中包含 `--capabilities` 參數，因為你正在建立具有自定義名稱的資源，這會影響權限。

3. 如需驗證 AWS Glue 數據庫是否已建立，運行以下命令：

   ```bash
   aws glue get-databases
   ```

   - 輸出應該顯示與堆疊相關的數據庫。

4. 如需驗證爬網程式是否已建立，運行以下命令：

   ```bash
   aws glue list-crawlers
   ```

5. 如需檢索爬網程式的詳細信息，運行以下命令：

   ```bash
   aws glue get-crawler --name cfn-crawler-weather
   ```

#### 任務 3 總結

在這個任務中，你學會了如何將 AWS Glue 爬網程式集成到 CloudFormation 模板中。你還學會了如何在 AWS Cloud9 終端中使用 AWS CLI 來驗證並部署模板，建立爬網程式。透過使用模板，你可以在其他 AWS 帳戶中重複使用爬網程式，並根據需要更改參數。

---

### 任務 4: 審查 Athena 和 AWS Glue 訪問的 IAM 策略

現在你已經使用 CloudFormation 建立了爬網程式，接下來需要審查爬網程式的 IAM 策略，以確保其他人可以在生產環境中使用它。

1. 在 AWS 管理控制台中的搜索框旁搜尋 IAM，打開 IAM 控制台。
2. 在左側導航窗格中，選擇 Users（使用者）。
3. 注意，`mary` 是列出的 IAM 使用者之一。該使用者屬於 DataScienceGroup IAM 群組。
4. 選擇 DataScienceGroup 群組的鏈接。
5. 在群組詳細信息頁面，選擇 Permissions（權限）標籤。
6. 在附加到群組的策略列表中，選擇 Policy-For-Data-Scientists 策略的鏈接。
7. 在策略詳細信息頁面，審查與該策略相關的權限。

   - 提示：如需更仔細地查看 IAM 策略的詳細信息，選擇 {} JSON，可以查看允許和拒絕的操作及其相關資源。

#### 任務 4 總結

在這個任務中，你審查了 DataScienceGroup 群組的 IAM 策略。該策略包含對 Amazon S3、AWS Glue 和 Athena 的有限訪問權限。此策略可以作為用於重用操作團隊構建的爬網程式的示例策略。

---

### 任務 5: 確認 Mary 能夠訪問並使用 AWS Glue 爬網程式

現在你已經審查了 IAM 策略，接下來你將測試另一個使用者（`mary`）是否能夠訪問 AWS Glue 爬網程式並使用它來提取、轉換和加載存儲在 Amazon S3 中的數據。

1. 在 AWS 管理控制台中，打開 CloudFormation，找到建立實驗環境的堆疊。
2. 選擇該堆疊的鏈接，並在 Outputs（輸出）標籤中複製 `MarysAccessKey` 和 `MarysSecretAccessKey`。
3. 返回到 AWS Cloud9 終端，將這些值分別存儲為變數：

   ```bash
   AK=<ACCESS-KEY>
   SAK=<SECRET-ACCESS-KEY>
   ```

4. 使用 `mary` 的憑證測試 `list-crawlers` 命令：

   ```bash
   AWS_ACCESS_KEY_ID=$AK AWS_SECRET_ACCESS_KEY=$SAK aws glue list-crawlers
   ```

5. 如需檢索爬網程式的詳細信息，運行以下命令：

   ```bash
   AWS_ACCESS_KEY_ID=$AK AWS_SECRET_ACCESS_KEY=$SAK aws glue get-crawler --name cfn-crawler-weather
   ```

6. 如需測試 `mary` 是否能夠運行爬網程式，運行

以下命令：

   ```bash
   AWS_ACCESS_KEY_ID=$AK AWS_SECRET_ACCESS_KEY=$SAK aws glue start-crawler --name cfn-crawler-weather
   ```

   - 當爬網程式運行成功時，終端不會顯示任何輸出。

7. 你可以在 AWS Glue 控制台中查看爬網程式的運行情況，並等待狀態更改為 Ready（就緒），這可能需要幾分鐘。

#### 任務 5 總結

這一結果確認了 `mary` 有權訪問並運行你使用 CloudFormation 建立和部署的 AWS Glue 爬網程式。她能夠列出、檢索爬網程式並運行它來提取數據。

---

至此，所有任務的翻譯已完成。如果你有進一步的問題或需要更多協助，請隨時告訴我！