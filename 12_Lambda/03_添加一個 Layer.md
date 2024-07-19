# 添加一個 Layer

_製作 requests 的 Layer_

## 說明

1. 進入桌面建立資料夾 `python`；特別注意，這名稱不要改。

    ```bash
    cd ~/Desktop && mkdir python && cd python
    ```

<br>

2. 建立並進入一個層級資料夾。

    ```bash
    mkdir -p lib/python3.12/site-packages && cd lib/python3.12/site-packages
    ```

<br>

3. 使用指定版本安裝套件；特別說明，這裡是進入到 `site-packages` 路徑中進行安裝，所以在參數 `--target` 部分給值 `.`，這主要是避免過長的路徑發生錯誤，假如在其他路徑中安裝，這裡可填入相對路徑。

    ```bash
    pip3 install --platform manylinux2014_x86_64 --target . --python-version 3.12 --only-binary=:all: requests==2.31.0 beautifulsoup4

    ```

<br>

4. 退回到桌面。

    ```bash
    cd ~/Desktop
    ```

<br>

5. 將資料夾 `python` 進行壓縮並命名為 `myRequests.zip`；特別注意，這裡可自訂名稱。

    ```bash
    zip -r myRequests.zip python
    ```

<br>

6. 可透過指令查看。

    ```bash
    ls myRequests.zip
    ```

<br>

## 測試

1. 在 AWS Lambda 中，`lambda_handler()` 函數需要接受兩個參數 `event` 和 `context`，因為這兩個參數提供了 Lambda 函數運行時的必要信息。

<br>

2. 使用以下腳本。

    ```python
    import requests
    from bs4 import BeautifulSoup


    def lambda_handler(event, context):
        # 目標網址
        url = 'https://realpython.github.io/fake-jobs/'

        # 發送 GET 請求到目標網址
        response = requests.get(url)

        # 確認請求成功
        if response.status_code == 200:
            # 解析 HTML 內容
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # 找到所有的工作職位
            job_elements = soup.find_all('div', class_='card-content')
            
            results = []
            
            # 輸出三筆資料示範即可
            for job_element in job_elements[:3]:
                # 提取職位標題
                title_element = job_element.find('h2', class_='title')
                # 提取公司名稱
                company_element = job_element.find('h3', class_='company')
                # 提取地點
                location_element = job_element.find('p', class_='location')
                
                # 添加結果到列表
                results.append({
                    'Job Title': title_element.text.strip(),
                    'Company': company_element.text.strip(),
                    'Location': location_element.text.strip()
                })
            
            return {
                'statusCode': 200,
                'body': results
            }
        else:
            return {
                'statusCode': response.status_code,
                'body': f"檢索網頁失敗，狀態碼：{response.status_code}"
            }
    ```

<br>

## event 參數

1. event 參數包含觸發 Lambda 函數的事件數據，這些數據由觸發事件的源提供，並根據不同的事件源有不同的結構。

<br>

2. 如果 Lambda 函數是由 API Gateway 觸發的，event 參數將包含 API 請求的詳細信息；如果是由 S3 事件觸發的，則 event 參數將包含 S3 事件的相關數據。

<br>

## context 參數

_context 參數提供了 Lambda 執行環境的信息_

<br>

1. aws_request_id：此次函數調用的唯一標識符。

2. log_group_name：與 Lambda 函數關聯的 CloudWatch 日誌組名稱。

3. log_stream_name：此次調用的 CloudWatch 日誌流名稱。

4. function_name：Lambda 函數的名稱。

5. memory_limit_in_mb：為該函數配置的內存大小（以 MB 為單位）。

6. function_version：Lambda 函數的版本。

7. invoked_function_arn：調用函數的 ARN。

8. get_remaining_time_in_millis()：函數在超時之前剩餘的執行時間（以毫秒為單位）。

<br>

___

_END：其餘步驟與 Linebot SDK 步驟完全相同，不再贅述。_