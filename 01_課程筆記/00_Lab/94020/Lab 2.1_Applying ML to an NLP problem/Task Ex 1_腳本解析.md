# Lab 2.1：將機器學習應用於 NLP 問題

_使用 SageMaker 內建的 ML 模型 `LinearLearner` 來預測評論數據集中的 `isPositive` 欄位。_

<br>

## 商業場景介紹

1. 假設你在線上零售商工作，公司希望改善對發表負面評論的顧客的互動，所以希望檢測到負面評論，並將這些評論分配給客戶服務代理處理。

2. 你的任務是使用機器學習檢測負面評論，針對取得包含負面評論的數據集，其中評論已被分類為正面或負面，你將使用此數據集訓練一個 ML 模型來預測新評論的情感。

## 關於此數據集

1. `AMAZON-REVIEW-DATA-CLASSIFICATION.csv` 包含實際的產品評論，這些評論包括文本數據和數字數據，每條評論都被標記為正面 (1) 或負面 (0)。

## 數據集包含以下特徵

1. reviewText：評論的文本。

2. summary：評論的摘要。

3. verified：購買是否經過驗證 (True 或 False)。

4. time：評論的 UNIX 時間戳。

5. log_votes：投票的對數調整值 log(1+votes)。

6. isPositive：評論是否為正面或負面 (1 或 0)。

## 步驟

1. 讀取數據集；

2. 進行探索性數據分析；

3. 文本處理，移除停用詞和詞幹提取；

4. 拆分訓練、驗證和測試數據；

5. 使用管道和 ColumnTransformer 處理數據；

6. 使用 SageMaker 內建算法訓練分類器；

7. 評估模型；

8. 將模型部署到端點；

9. 測試端點；

10. 清理模型資源。

<br>

## 安裝套件

1. 在 ipynb 中使用魔法指令 `!` 或 `%` 下達終端機指令，以下是安裝並升級所需套件。

    ```python
    !pip install --upgrade pip
    !pip install --upgrade scikit-learn
    !pip install --upgrade sagemaker
    !pip install --upgrade botocore
    !pip install --upgrade awscli
    ```

<br>

## 開始進行

1. 使用 requests 和 zipfile 模組來下載並解壓縮文件。

    ```python
    import requests
    import zipfile
    import os

    # 下載文件的函數
    def download_and_unzip(url, extract_to='.'):
        local_filename = url.split('/')[-1]
        
        # 下載文件
        with requests.get(url, stream=True) as r:
            r.raise_for_status()
            with open(local_filename, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192): 
                    if chunk:
                        f.write(chunk)
        
        # 解壓縮文件
        with zipfile.ZipFile(local_filename, 'r') as zip_ref:
            zip_ref.extractall(extract_to)
        
        # 刪除壓縮文件
        os.remove(local_filename)

    # 文件下載 URL
    punkt_url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip"
    punkt_tab_url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt_tab.zip"

    # 執行下載並解壓縮
    download_and_unzip(punkt_url)
    download_and_unzip(punkt_tab_url)

    print("下載並解壓縮完成！")
    ```

<br>

2. 設定 NLTK 資源的路徑，使用本地的 punkt 和 punkt_tab 資源。

    ```python
    import nltk

    # 手動設置 nltk 資源的路徑
    nltk.data.path.append('./punkt')

    # 確認是否正確添加
    print(nltk.data.path)

    # 現在可以使用 word_tokenize 進行分詞
    # 如果下載到正確的資料夾，可以略過這一步
    # nltk.download('punkt')
    ```

<br>

3. 讀取數據集。

    ```python
    import pandas as pd

    df = pd.read_csv(
        '../data/AMAZON-REVIEW-DATA-CLASSIFICATION.csv'
    )

    print('數據集的形狀為：', df.shape)
    df.head(5)

    # 顯示更多文本數據
    pd.set_option('display.max_colwidth', None)
    df.head()

    # 查詢具體條目
    print(df.loc[[580]])

    # 檢查數據類型
    df.dtypes
    ```

<br>

4. 進行探索性數據分析。

    ```python
    df['isPositive'].value_counts()

    # 交換正負分類值
    df = df.replace({0:1, 1:0})
    df['isPositive'].value_counts()

    # 檢查缺失值
    df.isna().sum()
    ```

<br>

5. 文本處理，移除停用詞和詞幹提取。

    ```python
    import nltk
    nltk.download('punkt')
    nltk.download('stopwords')

    import nltk, re
    from nltk.corpus import stopwords
    from nltk.stem import SnowballStemmer
    from nltk.tokenize import word_tokenize

    # 設定停用詞
    stop = stopwords.words('english')

    excluding = [
        'against', 'not', 'don', 'don\'t','ain', 'are',
        'aren\'t', 'could', 'couldn\'t','did', 'didn\'t',
        'does', 'doesn\'t', 'had', 'hadn\'t', 'has', 'hasn\'t',
        'have', 'haven\'t', 'is', 'isn\'t', 'might',
        'mightn\'t', 'must', 'mustn\'t', 'need', 'needn\'t',
        'should', 'shouldn\'t', 'was', 'wasn\'t', 'were',
        'weren\'t', 'won\'t', 'would', 'wouldn\'t'
    ]

    # 新停用詞列表
    stopwords = [word for word in stop if word not in excluding]

    snow = SnowballStemmer('english')

    def process_text(texts): 
        final_text_list=[]
        for sent in texts:
            if isinstance(sent, str) == False:
                sent = ''
                
            filtered_sentence=[]
            
            sent = sent.lower() 
            sent = sent.strip() 
            sent = re.sub('\s+', ' ', sent) 
            sent = re.compile('<.*?>').sub('', sent)
            
            for w in word_tokenize(sent):
                if(not w.isnumeric()) and (len(w)>2) and (w not in stopwords):  
                    filtered_sentence.append(snow.stem(w))
            final_string = " ".join(filtered_sentence) 
            final_text_list.append(final_string)
            
        return final_text_list
    ```

<br>

6. 拆分訓練、驗證和測試數據。

    ```python
    from sklearn.model_selection import train_test_split

    X_train, X_val, y_train, y_val = train_test_split(
        df[['reviewText', 'summary', 'time', 'log_votes']],
        df['isPositive'], test_size=0.20, shuffle=True, 
        random_state=324
    )

    X_val, X_test, y_val, y_test = train_test_split(
        X_val,
        y_val,
        test_size=0.5,
        shuffle=True,
        random_state=324
    )

    print('處理 reviewText 欄位')
    X_train['reviewText'] = process_text(X_train['reviewText'].tolist())
    X_val['reviewText'] = process_text(X_val['reviewText'].tolist())
    X_test['reviewText'] = process_text(X_test['reviewText'].tolist())

    print('處理 summary 欄位')
    X_train['summary'] = process_text(X_train['summary'].tolist())
    X_val['summary'] = process_text(X_val['summary'].tolist())
    X_test['summary'] = process_text(X_test['summary'].tolist())
    ```

<br>

## 使用管道和 ColumnTransformer 處理數據

1. 在開始訓練模型之前，需要對數據進行一些預處理，這些步驟對於訓練模型和推理都非常重要。

<br>

2. 透過定義一個 `pipeline` 將不同的處理步驟有序地執行，對於不同的字段，可以建立不同的管道進行處理。

<br>

3. 對於數值特徵，使用 numerical_processor 進行 MinMaxScaler 的縮放。縮放對於某些算法（例如線性模型）是重要的。

<br>

4. 對於文本特徵，使用 `CountVectorizer()` 將文本字段轉換為特徵向量。

<br>

5. 這些不同的預處理操作會被放入一個 `ColumnTransformer` 中，並最終放入一個完整的管道。這樣，無論在訓練或推理階段，都可以自動對數據進行正確的處理。

<br>

6. 代碼。

    ```python
    # 設定模型的特徵和目標變量
    numerical_features = ['time', 'log_votes']
    text_features = ['summary', 'reviewText']
    model_features = numerical_features + text_features
    model_target = 'isPositive'

    from sklearn.impute import SimpleImputer
    from sklearn.preprocessing import MinMaxScaler
    from sklearn.feature_extraction.text import CountVectorizer
    from sklearn.pipeline import Pipeline
    from sklearn.compose import ColumnTransformer

    '''定義 COLUMN_TRANSFORMER'''

    # 數值特徵的預處理
    numerical_processor = Pipeline([
        ('num_imputer', SimpleImputer(strategy='mean')),
        ('num_scaler', MinMaxScaler()) 
    ])

    # 文本特徵 1 的預處理
    text_processor_0 = Pipeline([(
        'text_vect_0',
        CountVectorizer(binary=True, max_features=50)
    )])

    # 文本特徵 2 的預處理
    text_processor_1 = Pipeline([(
        'text_vect_1',
        CountVectorizer(binary=True, max_features=150)
    )])

    # 將所有預處理步驟組合到一個 ColumnTransformer 中
    data_preprocessor = ColumnTransformer([
        ('numerical_pre', numerical_processor, numerical_features),
        ('text_pre_0', text_processor_0, text_features[0]),
        ('text_pre_1', text_processor_1, text_features[1])
    ])

    '''準備數據'''

    print('數據集處理前的形狀: ', X_train.shape, X_val.shape, X_test.shape)

    X_train = data_preprocessor.fit_transform(X_train).toarray()
    X_val = data_preprocessor.transform(X_val).toarray()
    X_test = data_preprocessor.transform(X_test).toarray()

    print('數據集處理後的形狀: ', X_train.shape, X_val.shape, X_test.shape)
    ```

7. 可以看到，處理後數據集的特徵從 4 個增加到了 202 個。

    ```python
    print(X_train[0])
    ```

<br>

## 使用 SageMaker 內建算法訓練分類器

_使用 SageMaker 的 `LinearLearner()` 算法，設定以下選項_

<br>

1. 權限：使用當前環境的 AWS IAM 角色進行設定。

<br>

2. 計算能力：使用 `train_instance_count` 和 `train_instance_type` 參數來選擇實例。此範例使用 `ml.m4.xlarge` 執行資源進行訓練。

<br>

3. 模型類型：使用 `binary_classifier` 進行二分類問題的預測。如果問題是多分類問題，則可以使用 `multiclass_classifier`。

<br>

4. 代碼。

    ```python
    import sagemaker

    # 呼叫 LinearLearner 估計器
    linear_classifier = sagemaker.LinearLearner(
        role=sagemaker.get_execution_role(),
        instance_count=1,
        instance_type='ml.m4.xlarge',
        predictor_type='binary_classifier'
    )
    ```

<br>

5. 要將訓練、驗證和測試數據集設置到估計器中，可以使用 `record_set()` 函數。

    ```python
    train_records = linear_classifier.record_set(
        X_train.astype('float32'),
        y_train.values.astype('float32'),
        channel='train'
    )

    val_records = linear_classifier.record_set(
        X_val.astype('float32'),
        y_val.values.astype('float32'),
        channel='validation'
    )

    test_records = linear_classifier.record_set(
        X_test.astype('float32'),
        y_test.values.astype('float32'),
        channel='test'
    )
    ```

<br>

6. 使用 `fit()` 函數將數據傳遞給分佈式的隨機梯度下降 (SGD) 算法。此過程大約需要 3-4 分鐘。

    ```python
    linear_classifier.fit([train_records, val_records, test_records], logs=False)
    ```

<br>

## 評估模型

1. 可使用 SageMaker 的分析工具來獲取模型的測試集性能指標，而不需要部署模型。SageMaker 提供了許多訓練過程中的指標，這些指標可以幫助您調整模型。對於二分類問題，可選擇以下指標。

    ```bash
    1. objective_loss：二分類問題的平均邏輯損失值。

    2. binary_classification_accuracy：模型在數據集上的最終準確率。

    3. precision：模型正類預測的精度。

    4. recall：模型正類預測的召回率。

    5. binary_f_beta：precision 和 recall 的調和平均數。
    ```

<br>

2. 在這個範例中關心的是正確的預測數，因此使用 `binary_classification_accuracy` 指標最為合適。

    ```python
    sagemaker.analytics.TrainingJobAnalytics(
        linear_classifier._current_job_name, 
        metric_names=[
            'test:binary_classification_accuracy'
        ]
    ).dataframe()
    ```

<br>

3. 模型的準確率應該在 0.85 左右。您的數值可能有所不同，但應該接近此值。這代表模型約 85% 的時間能夠正確預測評論情感。

<br>

## 將模型部署到端點

1. 最後要將模型部署到另一個實例中。在生產環境中，可以使用此模型。部署的端點還可以與其他 AWS 服務一起使用，例如 AWS Lambda 和 Amazon API Gateway。要部署模型，運行以下代碼。此過程大約需要 7-8 分鐘。

    ```python
    linear_classifier_predictor = linear_classifier.deploy(
        initial_instance_count=1,
        instance_type='ml.c5.large'
    )
    ```

<br>

## 測試端點

1. 模型部署後，可將測試數據發送到端點，並從中獲取預測結果；特別注意代碼中的斷行。

    ```python
    import numpy as np

    # 以 25 條數據為一批次進行預測
    prediction_batches = [
        linear_classifier_predictor.predict(batch)
        for batch in np.array_split(
            X_test.astype('float32'), 25
        )
    ]

    # 獲取預測結果列表
    print([
        pred.label['score'].float32_tensor.values[0]
        for pred in prediction_batches[0]
    ])
    ```

<br>

## 清理模型資源

1. 當不再需要使用模型端點時，可運行以下命令進行刪除，尤其是使用自己的 AWS 帳戶，端點持續存在會產生費用。

    ```python
    linear_classifier_predictor.delete_endpoint()
    ```

<br>

___

_END_
