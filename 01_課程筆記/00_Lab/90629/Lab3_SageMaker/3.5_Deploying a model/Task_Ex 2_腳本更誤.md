# 腳本解析

_後補_

<br>

## 腳本更正

_這裡先說明官方腳本中的錯誤_

<br>

1. 官方在以下代碼中遺漏了一個參數。

    ```python
    s3 = boto3.client('s3')
    obj = s3.get_object(
        Bucket=bucket, 
        Key="{}/batch-out/{}".format(
            prefix,
            'batch-in.csv.out'
        )
    )
    # 遺漏參數
    '''
    target_predicted = pd.read_csv(
        io.BytesIO(obj['Body'].read()),',',names=['class']
    )
    '''
    # 修正如下
    target_predicted = pd.read_csv(
        io.BytesIO(obj['Body'].read()), sep=',', names=['class']
    )
    target_predicted.head(5)
    ```

<br>

___

_END_