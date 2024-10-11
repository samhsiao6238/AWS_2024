## Task 02：部署應用

1.  下載官方範例文件 [tomcat.zip](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/samples/tomcat.zip) 到本地資料夾。

    ![](images/img_04.png)

<br>

2. 在 Elastic Beanstalk 控制台中展開選單，點擊 `Enviroments`，然後點擊右側的 `Enviroment name` 項目下的實例。

    ![](images/img_05.png)

<br>

3. 點擊 `Upload and Deploy`。

    ![](images/img_06.png)

<br>

4. 上傳下載的 `tomcat.zip` 檔案並部署。

    ![](images/img_07.png)

<br>

5. 完成部署後，刷新域名網頁便看到部署的範例應用程式。

    ![](images/img_08.png)

<br>

## 查看資源

1. 在控制台中，選擇 `Configuration`  可查看實例流量、擴展、EC2 安全組等設置；也可以為應用程式環境添加資料庫。

    ![](images/img_09.png)

<br>

2. 前往 EC2 控制台，可查看由 Elastic Beanstalk 建立的實例。

    ![](images/img_10.png)

<br>

3. 可以進一步探索負載均衡器和自動擴展組等資源。

_後補_

<br>

## 完成

_Submit && End Lab_

<br>

___

_END_