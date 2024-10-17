### 彙整官方說明：如何使用 Amazon SageMaker 創建 Jupyter Notebook

#### Task 1: 創建 Amazon SageMaker 的 Jupyter Notebook

在此任務中，您將透過 AWS 管理控制台進入 Amazon SageMaker，並創建一個 Jupyter Notebook。

#### 創建 Jupyter Notebook 的步驟：

1. 進入 AWS 管理控制台  
   在 AWS 管理控制台中，從「Services（服務）」選單中選擇「Amazon SageMaker」。

2. 進入 Notebook 節點  
   從左側導航欄選擇「Notebook instances（Notebook 實例）」。

3. 創建 Notebook 實例  
   點選「Create notebook instance（創建 Notebook 實例）」。

4. 命名 Notebook 實例  
   在「Notebook instance name（Notebook 實例名稱）」框中輸入：`my-flight-notebook`

5. 選擇實例類型  
   從「Notebook instance type（Notebook 實例類型）」的下拉選單中選擇：`ml.m4.xlarge`

6. 設置儲存卷大小  
   在「Additional configuration（其他配置）」下，找到「Volume size in GB - optional（可選的卷大小）」框，輸入：`25` GB

7. 配置生命週期  
   在「Additional configuration（其他配置）」下，打開「Lifecycle configuration（生命週期配置）」的下拉選單，並選擇包含 `ml-pipeline` 的生命週期配置。

8. 創建 Notebook 實例  
   點擊「Create notebook instance（創建 Notebook 實例）」按鈕。

9. 查看 Notebook 實例狀態  
   創建的 Notebook 實例會出現在「Notebook instances（Notebook 實例）」列表中，狀態顯示為「Pending（待定）」。當狀態變更為「InService」時，您就可以進行下一步操作。

---

#### 進一步閱讀：
在等待 Notebook 實例變為「InService」狀態時，您可以閱讀更多關於 Jupyter Notebook 的資訊，以下是一些參考資料：
- [Jupyter.org](https://jupyter.org)
- [Jupyter Notebook Tutorial](https://jupyter-notebook.readthedocs.io/en/stable/notebook.html)

---

這樣的彙整方便快速參考，讓您在 Amazon SageMaker 中創建和使用 Jupyter Notebook 更加高效。