# 完整代碼

1. 逐行繁體中文註解。

```python
# 設定 S3 Bucket 名稱
bucket = 'c130335a3301606l7986146t1w373590610266-labbucket-tpobvfpyzlsy'

import time
# 記錄腳本開始時間
start = time.time()
# 導入必要的模組
import warnings, requests, zipfile, io
# 忽略警告
warnings.simplefilter('ignore')
# 用於數據處理的 pandas
import pandas as pd
# 用於處理 .arff 格式文件的 scipy
from scipy.io import arff
import os
# AWS SDK，用於與 S3 等服務互動
import boto3
# SageMaker 用於機器學習模型訓練
import sagemaker
# 用於取得模型容器映像
from sagemaker.image_uris import retrieve
# 用於數據集分割
from sklearn.model_selection import train_test_split
# 用於模型評估的函數
from sklearn.metrics import {
    roc_auc_score, roc_curve, auc, confusion_matrix
}
# 用於數據可視化的 seaborn
import seaborn as sns
# 用於繪製圖表的 matplotlib
import matplotlib.pyplot as plt

# 定義 ROC 曲線繪製函數
def plot_roc(test_labels, target_predicted_binary):
    # 計算混淆矩陣並解包其結果
    TN, FP, FN, TP = confusion_matrix(
        test_labels, target_predicted_binary
    ).ravel()
    
    '''計算模型性能指標'''
    # 敏感度（真陽性率）
    Sensitivity = float(TP) / (TP + FN) * 100
    # 特異性（真陰性率）
    Specificity = float(TN) / (TN + FP) * 100
    # 精度
    Precision = float(TP) / (TP + FP) * 100
    # 陰性預測值
    NPV = float(TN) / (TN + FN) * 100
    # 假陽性率
    FPR = float(FP) / (FP + TN) * 100
    # 假陰性率
    FNR = float(FN) / (TP + FN) * 100
    # 假發現率
    FDR = float(FP) / (TP + FP) * 100
    # 總體準確度
    ACC = float(TP + TN) / (TP + FP + FN + TN) * 100

    # 輸出結果
    print(f"Sensitivity or TPR: {Sensitivity}%")
    print(f"Specificity or TNR: {Specificity}%")
    print(f"Precision: {Precision}%")
    print(f"Negative Predictive Value: {NPV}%")
    print(f"False Positive Rate: {FPR}%")
    print(f"False Negative Rate: {FNR}%")
    print(f"False Discovery Rate: {FDR}%")
    print(f"Accuracy: {ACC}%")

    # 取得測試標籤
    test_labels = test.iloc[:, 0]
    # 計算 AUC 分數
    print(
        "Validation AUC",
        roc_auc_score(test_labels, target_predicted_binary)
    )

    # 計算 ROC 曲線
    fpr, tpr, thresholds = roc_curve(test_labels, target_predicted_binary)
    roc_auc = auc(fpr, tpr)

    # 繪製 ROC 曲線
    plt.figure()
    plt.plot(fpr, tpr, label="ROC curve (area = %0.2f)" % (roc_auc))
    plt.plot([0, 1], [0, 1], "k--")
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")
    plt.title("Receiver Operating Characteristic")
    plt.legend(loc="lower right")

    # 繪製對應閾值的第二個軸
    ax2 = plt.gca().twinx()
    ax2.plot(fpr, thresholds, markeredgecolor="r", linestyle="dashed", color="r")
    ax2.set_ylabel("Threshold", color="r")
    ax2.set_ylim([thresholds[-1], thresholds[0]])
    ax2.set_xlim([fpr[0], fpr[-1]])

    # 顯示圖形
    print(plt.figure())

# 定義混淆矩陣繪製函數
def plot_confusion_matrix(test_labels, target_predicted):
    # 計算混淆矩陣
    matrix = confusion_matrix(test_labels, target_predicted)
    # 將其轉換為 DataFrame
    df_confusion = pd.DataFrame(matrix)
    # 設置配色
    colormap = sns.color_palette("BrBG", 10)
    # 繪製熱力圖
    sns.heatmap(
        df_confusion, annot=True, fmt=".2f", cbar=None, cmap=colormap
    )
    plt.title("Confusion Matrix")
    plt.tight_layout()
    plt.ylabel("True Class")
    plt.xlabel("Predicted Class")
    # 顯示圖表
    plt.show()

# 下載並解壓數據集
f_zip = "http://archive.ics.uci.edu/ml/machine-learning-databases/00212/vertebral_column_data.zip"
r = requests.get(f_zip, stream=True)
# 將下載的數據解壓
Vertebral_zip = zipfile.ZipFile(io.BytesIO(r.content))
Vertebral_zip.extractall()

'''加載數據並處理'''
# 加載 .arff 文件
data = arff.loadarff("column_2C_weka.arff")
# 將其轉換為 pandas DataFrame
df = pd.DataFrame(data[0])

# 映射類別標籤
class_mapper = {b"Abnormal": 1, b"Normal": 0}
# 替換類別標籤
df["class"] = df["class"].replace(class_mapper)

# 調整數據集順序
cols = df.columns.tolist()
cols = cols[-1:] + cols[:-1]
df = df[cols]

# 分割數據集
train, test_and_validate = train_test_split(
    df, test_size=0.2,
    random_state=42,
    stratify=df["class"]
)

test, validate = train_test_split(
    test_and_validate, test_size=0.5, 
    random_state=42, 
    stratify=test_and_validate["class"]
)

# S3 前綴
prefix = "lab3"

# 定義文件名
train_file = "vertebral_train.csv"
test_file = "vertebral_test.csv"
validate_file = "vertebral_validate.csv"

# 設置 S3 資源
s3_resource = boto3.Session().resource("s3")

# 上傳 CSV 到 S3 的函數
def upload_s3_csv(filename, folder, dataframe):
    # 使用內存中的 StringIO 來儲存 CSV
    csv_buffer = io.StringIO()
    # 將 DataFrame 轉換為 CSV
    dataframe.to_csv(csv_buffer, header=False, index=False)
    # 上傳至 S3
    s3_resource.Bucket(bucket).Object(
        os.path.join(prefix, folder, filename)
    ).put(Body=csv_buffer.getvalue())  

# 上傳訓練、測試和驗證數據到 S3
upload_s3_csv(train_file, "train", train)
upload_s3_csv(test_file, "test", test)
upload_s3_csv(validate_file, "validate", validate)

# 從 SageMaker 取得 XGBoost 容器
container = retrieve(
    "xgboost", boto3.Session().region_name, "1.0-1"
)

# 定義超參數
hyperparams = {
    "num_round": "42",
    "eval_metric": "auc",
    "objective": "binary:logistic",
    "silent": 1,
}

# 設置輸出位置
s3_output_location = "s3://{}/{}/output/".format(bucket, prefix)
xgb_model = sagemaker.estimator.Estimator(
    container,
    sagemaker.get_execution_role(),
    instance_count=1,
    instance_type="ml.m5.2xlarge",
    output_path=s3_output_location,
    hyperparameters=hyperparams,
    sagemaker_session=sagemaker.Session(),
)

# 設置訓練和驗證數據通道
train_channel = sagemaker.inputs.TrainingInput(
    "s3://{}/{}/train/".format(bucket, prefix, train_file),
    content_type="text/csv"
)
validate_channel = sagemaker.inputs.TrainingInput(
    "s3://{}/{}/validate/".format(bucket,
    prefix, validate_file),
    content_type="text/csv"
)

# 數據通道
data_channels = {
    "train": train_channel,
    "validation": validate_channel
}

# 訓練模型
xgb_model.fit(inputs=data_channels, logs=False)

# 取得測試數據
batch_X = test.iloc[:, 1:]

batch_X_file = "batch-in.csv"
# 上傳批次輸入數據
upload_s3_csv(batch_X_file, "batch-in", batch_X)

# 設置批次輸入和輸出位置
batch_output = "s3://{}/{}/batch-out/".format(bucket, prefix)
batch_input = "s3://{}/{}/batch-in/{}".format(
    bucket, prefix, batch_X_file
)

# 設置 Transformer
xgb_transformer = xgb_model.transformer(instance_count=1, instance_type="ml.m5.2xlarge", strategy="MultiRecord", assemble_with="Line", output_path=batch_output)
# 開始批次轉換
xgb_transformer.transform(
    data=batch_input, data_type="S3Prefix",
    content_type="text/csv", split_type="Line"
)
# 等待完成
xgb_transformer.wait(logs=False)

# 從 S3 取得預測結果
s3 = boto3.client("s3")
obj = s3.get_object(
    Bucket=bucket,
    Key="{}/batch-out/{}".format(prefix, "batch-in.csv.out")
)
# 加載預測結果
target_predicted = pd.read_csv(
    io.BytesIO(obj["Body"].read()),
    names=["class"]
)

# 二元轉換函數
def binary_convert(x):
    threshold = 0.5
    return 1 if x > threshold else 0

# 將預測結果轉換為二元值
target_predicted_binary = target_predicted["class"].apply(binary_convert)
# 取得測試標籤
test_labels = test.iloc[:, 0]

# 繪製混淆矩陣
plot_confusion_matrix(test_labels, target_predicted_binary)

import numpy as np

# 檢查 NaN 或 Inf 並進行處理
if target_predicted_binary.isnull().any() or test_labels.isnull().any():
    print("警告：有 NaN 值")
    target_predicted_binary = target_predicted_binary.fillna(0)
    test_labels = test_labels.fillna(0)

# 替換 Inf 值
target_predicted_binary = target_predicted_binary.replace(
    [np.inf, -np.inf], 0
)
test_labels = test_labels.replace([np.inf, -np.inf], 0)

# 修正並繪製 ROC 曲線
plot_roc(test_labels, target_predicted_binary)
```
