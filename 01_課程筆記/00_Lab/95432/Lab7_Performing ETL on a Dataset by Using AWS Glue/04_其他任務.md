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