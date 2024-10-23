# 问题：预测航班延误

该笔记本的目标是：
- 处理下载的 .zip 文件并利用其创建数据集
- 执行探索性数据分析 (EDA)
- 建立基准模型
- 将简单模型转化为集成模型
- 执行超级参数优化
- 确认特征重要性


## 业务场景简介

您在一家行程预订网站工作，该网站希望能改善航班延误的旅客的客户体验。该公司希望开发一种功能，让乘客在预订美国国内最繁忙机场的到港或离港航班时，能够知道航班是否会因天气原因而延误。

您的任务是利用机器学习 (ML) 来确定航班是否会因天气原因而延误，从而在一定程度上解决这一问题。您可以访问一个有关大型航空公司国内航班的准点率的数据集。您可以使用这一数据来训练 ML 模型，以便预测最繁忙机场的航班是否会延误。


## 关于该数据集

该数据集包含经过认证的美国航空公司报告的预定和实际的出发与到达时间。对于预定行程的国内旅客产生的收入，这些航空公司至少占据了 1%。数据由美国交通统计局 (BTS) 下属的航空公司信息办公室收集。数据集包含 2013 到 2018 年间航班的日期、时刻、出发地、目的地、航空公司、航程以及航班延误状态。


### 特征

有关数据集内的特征的更多信息，请参阅 [准点延误数据集特征](https://www.transtats.bts.gov/Fields.asp)。

### 数据集属性  
网站：https://www.transtats.bts.gov/

本实验使用的数据集由美国交通统计局 (BTS) 下属的航空公司信息办公室编制，取自航空公司准点率数据库，网站为 https://www.transtats.bts.gov/DatabaseInfo.asp?DB_ID=120&amp;DB_URL=Mode_ID=1&amp;Mode_Desc=Aviation&amp;Subject_ID2=0。

# 步骤 1：问题定义和数据收集

在开始这个项目时，先用几句话来总结在这个场景中要解决的业务问题和要实现的业务目标。您可以在以下各部分写下想法。同时说明您想让自己的团队衡量的业务指标。填写这些信息后，编写 ML 问题陈述。最后，添加一两条备注，说明此活动所对应的机器学习的类型。

#### <span style="color: blue;">项目演示：在项目演示中总结这些详细信息。</span>

### 1.确定 ML 是否是适合在此场景中进行部署的解决方案以及原因。


```python
# Write your answer here
```

### 2.定义业务问题、成功指标和期望的 ML 输出。


```python
# Write your answer here
```

### 3.确定您要解决的 ML 问题的类型。


```python
# Write your answer here
```

### 4.分析您要使用的数据是否合适。


```python
# Write your answer here
```

### 设置

您已经决定要关注的部分，现在您可以设置此实验，以便开始解决问题。

注意：该笔记本是在具有 25 GB 存储的 `ml.m4.xlarge` 笔记本实例上创建和测试的。


```python
import os
from pathlib2 import Path
from zipfile import ZipFile
import time

import pandas as pd
import numpy as np
import subprocess

import matplotlib.pyplot as plt
import seaborn as sns

sns.set()
instance_type='ml.m4.xlarge'

import warnings
warnings.filterwarnings('ignore')

%matplotlib inline
```

# 步骤 2：数据预处理和可视化  
在数据预处理阶段，您将探索数据并将其可视化，以便更好地了解数据。首先，导入必要的库并将数据读入 pandas DataFrame。导入数据后，浏览数据集。查看数据集的形状，探索要使用的列及其类型（数值型、分类型）。对各项特征执行基本统计，以便了解特征的均值和范围；深入分析目标列并确定其分布。


### 要考虑的特定问题

在本实验的这一整个部分中，请考虑以下问题：

1.您可以从对特征执行的基本统计中推断出什么？ 
2.您可以从目标类的分布中推断出什么？
3.您从数据探索中还可以推断出什么？

#### <span style="color: blue;">项目演示：在项目演示中总结这些问题和其他类似问题的答案。</span>

首先将公有 Amazon Simple Storage Service (Amazon S3) 存储桶中的数据集引入这个笔记本环境。


```python
# download the files

zip_path = '/home/ec2-user/SageMaker/project/data/FlightDelays/'
base_path = '/home/ec2-user/SageMaker/project/data/FlightDelays/'
csv_base_path = '/home/ec2-user/SageMaker/project/data/csvFlightDelays/'

!mkdir -p {zip_path}
!mkdir -p {csv_base_path}
!aws s3 cp s3://aws-tc-largeobjects/CUR-TF-200-ACMLFO-1/flight_delay_project/data/ {zip_path} --recursive

```

    ```bash
    download: s3://aws-tc-largeobjects/CUR-TF-200-ACMLFO-1/flight_delay_project/data/On_Time_Reporting_Carrier_On_Time_Performance_1987_present_2014_1.zip to ../project/data/FlightDelays/

    # 以下省略 ...
    ```



```python
zip_files = [str(file) for file in list(Path(base_path).iterdir()) if '.zip' in str(file)]
len(zip_files)
```



    ```bash
    60
    ```


从 .zip 文件中提取逗号分隔值 (CSV) 文件。


```python
def zip2csv(zipFile_name , file_path):
    """
    Extract csv from zip files
    zipFile_name: name of the zip file
    file_path : name of the folder to store csv
    """

    try:
        with ZipFile(zipFile_name, 'r') as z: 
            print(f'Extracting {zipFile_name} ') 
            z.extractall(path=file_path) 
    except:
        print(f'zip2csv failed for {zipFile_name}')

for file in zip_files:
    zip2csv(file, csv_base_path)

print("Files Extracted")
```

    ```bash
    Extracting /home/ec2-user/SageMaker/project/data/FlightDelays/On_Time_Reporting_Carrier_On_Time_Performance_1987_present_2018_2.zip 
    # 以下省略 ...
    ```

```python
csv_files = [str(file) for file in list(Path(csv_base_path).iterdir()) if '.csv' in str(file)]
len(csv_files)
```

    ```bash
    60
    ```


在加载 CSV 文件前，请先阅读提取的文件夹中的 HTML 文件。该 HTML 文件介绍了相关背景以及有关数据集内包含的特征的更多信息。


```python
from IPython.display import IFrame

IFrame(src=os.path.relpath(f"{csv_base_path}readme.html"), width=1000, height=600)
```


<iframe
    width="1000"
    height="600"
    src="../project/data/csvFlightDelays/readme.html"
    frameborder="0"
    allowfullscreen

></iframe>




#### 加载示例 CSV 文件

在合并所有 CSV 文件之前，请检查单个 CSV 文件中的数据。使用 pandas 时，请先读取 `On_Time_Reporting_Carrier_On_Time_Performance_(1987_present)_2018_9.csv` 文件。您可以使用内置的 Python `read_csv` 函数 ([pandas.read_csv documentation](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html))。


```python
df_temp = pd.read_csv(f"{csv_base_path}On_Time_Reporting_Carrier_On_Time_Performance_(1987_present)_2018_9.csv")
```

问题：輸出数据集内的行数和列数，并輸出列名。

提示：要查看 DataFrame 的行和列，请使用 `<DataFrame>.shape` function. To view the column names, use the `` 函数。要查看列名，请使用 `<DataFrame>.columns` 函数。


```python
df_shape = # ENTER YOUR CODE HERE
print(f'Rows and columns in one CSV file is {df_shape}')
```

    ```bash
    Cell In[12], line 1
        df_shape = # ENTER YOUR CODE HERE
                   ^
    SyntaxError: invalid syntax
    ```


问题：輸出数据集的前 10 行。 

提示：要輸出 `x` 行，请使用 pandas 内置函数 `head(x)`。


```python
# Enter your code here
```

问题：輸出数据集里的所有列。要查看列名，使用 `<DataFrame>.columns`。


```python
print(f'The column names are :')
print('#########')
for col in <CODE>:# ENTER YOUR CODE HERE
    print(col)
```

问题：輸出数据集里包含 *Del* 一词的所有列。这可以让您了解包含*延误数据*的列有多少。

提示：您可以使用 Python 的列表推导功能来列出符合特定 `if` 语句条件的值。

例如：`[x for x in [1,2,3,4,5] if x > 2]`  

提示：您可以使用 `in` 关键字（[关键字文档中的 Python 部分](https://www.w3schools.com/python/ref_keyword_in.asp)）来确认值是否位于列表中。

例如：`5 in [1,2,3,4,5]`


```python
# Enter your code here
```

下列问题也可以帮助您了解有关数据集的更多信息。

问题   

1.数据集有多少个行和列？   
2.数据集里包含多少个年份？   
3.数据集的日期范围是多少？   
4.数据集里包含哪些航空公司？   
5.数据集里包含哪些出发地和目的地机场？

提示
- 要显示 DataFrame 的维度，请使用 `df_temp.shape`。
- 要引用特定列，请使用 `df_temp.columnName`（例如，`df_temp.CarrierDelay`）。
- 要获取列的唯一值，请使用 `df_temp.column.unique()`（例如`df_temp.Year.unique()`）。


```python
print("The #rows and #columns are ", <CODE> , " and ", <CODE>)
print("The years in this dataset are: ", <CODE>)
print("The months covered in this dataset are: ", <CODE>)
print("The date range for data is :" , min(<CODE>), " to ", max(<CODE>))
print("The airlines covered in this dataset are: ", list(<CODE>))
print("The Origin airports covered are: ", list(<CODE>))
print("The Destination airports covered are: ", list(<CODE>))
```

问题：出发地和目的地机场的总数分别是多少？

提示：要使用 Origin 和 Dest 列查找每个机场的值，可以在 pandas 中使用 `values_count` 函数（[pandas.Series.value_counts 文档](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.value_counts.html)）。


```python
counts = pd.DataFrame({'Origin':<CODE>, 'Destination':<CODE>})
counts
```

问题：根据数据集里的航班数量，輸出出前 15 个出发地和目的地机场。

提示：您可以在 pandas 中使用 `sort_values` 函数（[pandas.DataFrame.sort_values 文档](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sort_values.html)）。


```python
counts.sort_values(by=<CODE>,ascending=False).head(15) # Enter your code here
```

掌握了有关某个航班的所有信息后，您能否预测其是否会延误？

ArrDel15 列是指示变量，当航班延误超过 15 分钟时，其值为 *1*，否则为 *0*。

您可以将该列用作分类问题的目标列。

假设您要从旧金山到洛杉矶出差。您想更好地管理在洛杉矶的预订。因此，想要了解在给定一组特征的情况下，您的航班是否会延误。在登机之前，您需要了解这个数据集里的多少特征？

`DepDelay`、`ArrDelay`、`CarrierDelay`、`WeatherDelay`、`NASDelay`、`SecurityDelay`、`LateAircraftDelay` 和 `DivArrDelay` 等列包含有关延误的信息。但是，这种延误可能发生在出发地，也可能发生在目的地。如果航班因天气骤变而导致延误了 10 分钟才到达，则这种数据对您预订洛杉矶的酒店没有帮助。

因此，要简化问题陈述，请考虑用以下各列来预测到达延误：<br>

`Year`、`Quarter`、`Month`、`DayofMonth`、`DayOfWeek`、`FlightDate`、`Reporting_Airline`、`Origin`、`OriginState`、`Dest`、`DestState`、`CRSDepTime`、`DepDelayMinutes`、`DepartureDelayGroups`、`Cancelled`、`Diverted`、`Distance`、`DistanceGroup`、`ArrDelay`、`ArrDelayMinutes`、`ArrDel15`、`AirTime`

您也可以将出发地和目的地机场筛选为：
- 热门机场：ATL、ORD、DFW、DEN、CLT、LAX、IAH、PHX、SFO
- 排名前五的航空公司：UA、OO、WN、AA、DL

这些信息应有助于减少将要合并的 CSV 文件中的数据大小。

#### 合并所有 CSV 文件
 
首先，创建一个空 DataFrame，用于复制每个文件中的 DataFrame。然后，对于 `csv_files` 列表中的每个文件：

1.将 CSV 文件读入 DataFrame 
2.根据 `filter_cols` 变量筛选列

```
        columns = ['col1', 'col2']
        df_filter = df[columns]
```

3.每个 `subset_cols` 中仅保留 `subset_vals`。要检查 `val` 是否在 DataFrame 列中，请使用 pandas 的 `isin` 函数（[pandas.DataFram.isin 文档](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.isin.html)）。然后选择包含它的行。

```
        df_eg[df_eg['col1'].isin('5')]
```

4.将该 DataFrame 与空 DataFrame 合并 


```python
def combine_csv(csv_files, filter_cols, subset_cols, subset_vals, file_name):

    """
    Combine csv files into one Data Frame
    csv_files: list of csv file paths
    filter_cols: list of columns to filter
    subset_cols: list of columns to subset rows
    subset_vals: list of list of values to subset rows
    """

    df = pd.DataFrame()
    
    for file in csv_files:
        df_temp = pd.read_csv(file)
        df_temp = df_temp[filter_cols]
        for col, val in zip(subset_cols,subset_vals):
            df_temp = df_temp[df_temp[col].isin(val)]      
        
        df = pd.concat([df, df_temp], axis=0)
      
    df.to_csv(file_name, index=False)
    print(f'Combined csv stored at {file_name}')
```


```python
#cols is the list of columns to predict Arrival Delay 
cols = ['Year','Quarter','Month','DayofMonth','DayOfWeek','FlightDate',
        'Reporting_Airline','Origin','OriginState','Dest','DestState',
        'CRSDepTime','Cancelled','Diverted','Distance','DistanceGroup',
        'ArrDelay','ArrDelayMinutes','ArrDel15','AirTime']

subset_cols = ['Origin', 'Dest', 'Reporting_Airline']

# subset_vals is a list collection of the top origin and destination airports and top 5 airlines
subset_vals = [['ATL', 'ORD', 'DFW', 'DEN', 'CLT', 'LAX', 'IAH', 'PHX', 'SFO'], 
               ['ATL', 'ORD', 'DFW', 'DEN', 'CLT', 'LAX', 'IAH', 'PHX', 'SFO'], 
               ['UA', 'OO', 'WN', 'AA', 'DL']]
```

使用上一个函数将所有不同文件合并到一个可以轻松读取的文件中。

注意：这一过程需要 5 到 7 分钟才能完成。


```python
start = time.time()
combined_csv_filename = f"{base_path}combined_files.csv"
combine_csv(csv_files, cols, subset_cols, subset_vals, combined_csv_filename)
print(f'CSVs merged in {round((time.time() - start)/60,2)} minutes')
```

#### 加载数据集

加载已合并的数据集。


```python
data = pd.read_csv(combined_csv_filename)
```

輸出前五个记录。


```python
# Enter your code here 
```

下列问题也可以帮助您了解有关数据集的更多信息。

问题   

1.数据集有多少个行和列？   
2.数据集里包含多少个年份？   
3.数据集的日期范围是多少？   
4.数据集里包含哪些航空公司？   
5.数据集里包含哪些出发地和目的地机场？


```python
print("The #rows and #columns are ", <CODE> , " and ", <CODE>)
print("The years in this dataset are: ", list(<CODE>))
print("The months covered in this dataset are: ", sorted(list(<CODE>)))
print("The date range for data is :" , min(<CODE>), " to ", max(<CODE>))
print("The airlines covered in this dataset are: ", list(<CODE>))
print("The Origin airports covered are: ", list(<CODE>))
print("The Destination airports covered are: ", list(<CODE>))
```

定义目标列：is_delay（*1* 表示到达时间延误 15 分钟以上，*0* 表示所有其他情况）。要将 ArrDel15 列重命名为 is_delay，使用 `rename` 方法。

提示：您可以在 pandas 中使用 `rename` 函数（[pandas.DataFrame.rename 文档](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.rename.html)）。

例如：
```
data.rename(columns={'col1':'column1'}, inplace=True)
```


```python
data.rename(columns=<CODE>, inplace=True) # Enter your code here
```

查找各列的空值。您可以使用 `isnull()` 函数（[pandas.isnull 文档](https://pandas.pydata.org/pandas-docs/version/0.17.0/generated/pandas.isnull.html)）。

提示：`isnull()` 检测特定值是否为空值。它会在其位置返回一个布尔值（*True* 或 *False*）。要对列数求和，使用 `sum(axis=0)` 函数（例如，`df.isnull().sum(axis=0)`）。


```python
# Enter your code here
```

在 1658130 个行中，有 22540 个行缺少航班延误详情和飞行时间，占 1.3%。您可以删除或替换这些行。该文档没有提及有关丢失行的任何信息。



```python
### Remove null columns
data = data[~data.is_delay.isnull()]
data.isnull().sum(axis = 0)
```

将 CRSDepTime 转化为 24 小时制时间。


```python
data['DepHourofDay'] = (data['CRSDepTime']//100)
```

## ML 问题陈述
- 掌握了一组特征后，您能否预测出某个航班是否会延误 15 分钟以上？
- 目标变量只会有 *0* 和 *1* 两个值，因此您可以使用分类算法。

在开始建模前，最好先查看特征的分布和相关性等信息。
- 这可以让您了解数据中的任何非线性或模式。
    - 线性模型：添加幂、指数或交互特征
    - 尝试非线性模型
- 数据不平衡 
    - 选择不会给模型性能带来偏差的指标（准确率与曲线下面积（或称 AUC）之比）
    - 使用加权或自定义损失函数
- 缺少数据
    - 基于简单的统计数据进行替换：均值、中位数、众数（数值变量）和频繁类（分类变量）
    - 基于聚类进行替换（用 k 最近邻算法（或称 KNN）预测列值）
    - 删除列

### 数据探索

检查类别*延误*与*不延误*。



```python
(data.groupby('is_delay').size()/len(data) ).plot(kind='bar')# Enter your code here
plt.ylabel('Frequency')
plt.title('Distribution of classes')
plt.show()
```

问题：您能从柱状图中推断出有关*延误*率和*不延误*率的什么信息？


```python
# Enter your answer here
```

执行以下两个单元格的内容并回答问题。


```python
viz_columns = ['Month', 'DepHourofDay', 'DayOfWeek', 'Reporting_Airline', 'Origin', 'Dest']
fig, axes = plt.subplots(3, 2, figsize=(20,20), squeeze=False)
# fig.autofmt_xdate(rotation=90)

for idx, column in enumerate(viz_columns):
    ax = axes[idx//2, idx%2]
    temp = data.groupby(column)['is_delay'].value_counts(normalize=True).rename('percentage').\
    mul(100).reset_index().sort_values(column)
    sns.barplot(x=column, y="percentage", hue="is_delay", data=temp, ax=ax)
    plt.ylabel('% delay/no-delay')
    

plt.show()
```


```python
sns.lmplot( x="is_delay", y="Distance", data=data, fit_reg=False, hue='is_delay', legend=False)
plt.legend(loc='center')
plt.xlabel('is_delay')
plt.ylabel('Distance')
plt.show()
```

问题

使用先前图表中的数据，回答以下问题：

- 哪个月的延误次数最多？
- 一天之中什么时候的延误次数最多？
- 星期几的延误次数最多？
- 哪家航空公司的延误次数最多？
- 哪个出发地和目的地机场的延误次数最多？
- 航程是不是与延误有关的一项因素？


```python
# Enter your answers here
```

### 特征

查看所有列及其具体类型。


```python
data.columns
```


```python
data.dtypes
```

筛选出所需的列：
- *Date* 是多余的数据，因为已经有 *Year*、*Quarter*、*Month*、*DayofMonth* 和 *DayOfWeek* 可以描述日期。
- 使用 *Origin* 和 *Dest* 代码，而不是 *OriginState* 和 *DestState*。
- 因为您只是在对航班是否延误进行分类，所以不需要 *TotalDelayMinutes*、*DepDelayMinutes* 和 *ArrDelayMinutes*。

将 *DepHourofDay* 视为分类变量，因为它与目标没有数量关系。
- 如果需要对此变量进行独热编码，则会多出 23 列。
- 处理分类变量的其他方法包括进行哈希编码、进行正则化均值编码以及将值拆分到存储桶中等等。
- 在这种情况下，只需要拆分为多个存储桶即可。

要将列类型更改为类别，使用 `astype` 函数（[pandas.DataFrame.astype 文档](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.astype.html)）。


```python
data_orig = data.copy()
data = data[[ 'is_delay', 'Quarter', 'Month', 'DayofMonth', 'DayOfWeek', 
       'Reporting_Airline', 'Origin', 'Dest','Distance','DepHourofDay']]
categorical_columns  = ['Quarter', 'Month', 'DayofMonth', 'DayOfWeek', 
       'Reporting_Airline', 'Origin', 'Dest', 'DepHourofDay']
for c in categorical_columns:
    data[c] = data[c].astype('category')
```

要使用独热编码，针对选择的分类数据列使用 Pandas 函数 `get_dummies`。然后可以使用 Pandas 函数 `concat` 将生成的这些特征合并到原始数据集中。要对分类变量进行编码，您也可以使用关键字 `drop_first=True` 来进行*虚拟编码*。有关虚拟编码的更多信息，请参阅[虚拟编码（统计数据）](https://en.wikiversity.org/wiki/Dummy_variable_(statistics))。

例如：
```
pd.get_dummies(df[['column1','columns2']], drop_first=True)
```


```python
data_dummies = pd.get_dummies(<CODE>, drop_first=True) # Enter your code here
data = pd.concat([<CODE>, <CODE>], axis = 1)
data.drop(categorical_columns,axis=1, inplace=True)
```

确认数据集和新列的长度。

提示：使用 `shape` 和 `columns` 属性。


```python
# Enter your code here
```


```python
# Enter your code here
```

您现在可以训练模型了。在拆分数据之前，将 is_delay 列重命名为 *target*。

提示：您可以在 pandas 中使用 `rename` 函数（[pandas.DataFrame.rename 文档](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.rename.html)）。


```python
data.rename(columns = {<CODE>:<CODE>}, inplace=True )# Enter your code here
```

## <span style="color:red"> 步骤 2 结束 </span>

将项目文件保存到本地计算机。按照以下步骤进行操作：

1.在左侧的文件资源管理器中，右键单击您要处理的笔记本。

2.选择 Download（下载），然后将文件保存到本地。 

此操作会将当前的笔记本下载到计算机上默认的下载文件夹中。

# 步骤 3：模型训练和评估

在将数据集从 DataFrame 转换为可供机器学习算法使用的格式之前，您必须完成一些预备步骤。对于 Amazon SageMaker，您必须执行以下步骤：

1.使用 `sklearn.model_selection.train_test_split` 将数据分为 `train_data`、`validation_data` 和 `test_data`。 

2.将数据集转换为适合 Amazon SageMaker 训练作业使用的文件格式。可以是 CSV 文件或记录 protobuf。有关更多信息，请参阅 [适用于训练的常见数据格式](https://docs.aws.amazon.com/sagemaker/latest/dg/cdf-training.html)。 

3.将数据上传到 S3 存储桶。如果您从未创建过存储桶，请参阅 [创建存储桶](https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)。 

使用以下单元格完成这些步骤。根据需要插入和删除单元格。

#### <span style="color: blue;">项目演示：在您的项目演示中，写下您在此阶段所做的关键决策。</span>

### 训练测试拆分


```python
from sklearn.model_selection import train_test_split
def split_data(data):
    train, test_and_validate = train_test_split(data, test_size=0.2, random_state=42, stratify=data['target'])
    test, validate = train_test_split(test_and_validate, test_size=0.5, random_state=42, stratify=test_and_validate['target'])
    return train, validate, test
```


```python
train, validate, test = split_data(data)
print(train['target'].value_counts())
print(test['target'].value_counts())
print(validate['target'].value_counts())
```

示例答案
```
0.0 1033570
1.0 274902
名称：target，dtype：int64
0.0 129076
1.0 34483
名称：target，dtype：int64
0.0 129612
1.0 33947
名称：target，dtype：int64
```

### 基准分类模型


```python
import sagemaker
from sagemaker.serializers import CSVSerializer
from sagemaker.amazon.amazon_estimator import RecordSet
import boto3

# Instantiate the LinearLearner estimator object with 1 ml.m4.xlarge
classifier_estimator = sagemaker.LinearLearner(role=sagemaker.get_execution_role(),
                                               instance_count=<CODE>,
                                               instance_type=<CODE>,
                                               predictor_type=<CODE>,
                                               binary_classifier_model_selection_criteria=<CODE>)
```

### 示例代码
```
num_classes = len(pd.unique(train_labels))
classifier_estimator = sagemaker.LinearLearner(role=sagemaker.get_execution_role(),
                                              instance_count=1,
                                              instance_type='ml.m4.xlarge',
                                              predictor_type='binary_classifier',
                                              binary_classifier_model_selection_criteria = 'cross_entropy_loss')
                                              
```

线性学习器接受 protobuf 或 CSV 内容类型的训练数据。它还接受 protobuf、CSV 或 JavaScript 对象表示法 (JSON) 内容类型的推理请求。训练数据有特征和 ground-truth 标签，而推理请求中的数据只有特征。

在生产管道中，AWS 建议将数据转换为 Amazon SageMaker protobuf 格式并将其存储在 Amazon S3 中。为了快速启动并运行，AWS 提供 `record_set` 操作，让您 能够在数据集小到足以装入本地内存时来进行转换和上传。该方法接受您已有的 NumPy 数组，因此您将在此步骤中使用它。`RecordSet` 对象将跟踪数据的 Amazon S3 临时位置。使用 `estimator.record_set` 函数创建训练、验证和测试记录。然后，使用 `estimator.fit` 函数开始训练作业。


```python
### Create train, validate, and test records
train_records = classifier_estimator.record_set(train.values[:, 1:].astype(np.float32), train.values[:, 0].astype(np.float32), channel='train')
val_records = classifier_estimator.record_set(validate.values[:, 1:].astype(np.float32), validate.values[:, 0].astype(np.float32), channel='validation')
test_records = classifier_estimator.record_set(test.values[:, 1:].astype(np.float32), test.values[:, 0].astype(np.float32), channel='test')
```

下面，使用您上传的数据集训练模型。

### 示例代码
```
linear.fit([train_records,val_records,test_records])
```


```python
### Fit the classifier
# Enter your code here
```

## 模型评估
在本节中，您将评估自己训练的模型。

首先，检查训练作业的指标：


```python
sagemaker.analytics.TrainingJobAnalytics(classifier_estimator._current_job_name, 
                                         metric_names = ['test:objective_loss', 
                                                         'test:binary_f_beta',
                                                         'test:precision',
                                                         'test:recall']
                                        ).dataframe()
```

接下来，设置一些函数，用于将测试数据加载到 Amazon S3 中，并使用批量预测函数执行预测。使用批批量预测将有助于降低成本，因为实例仅在对提供的测试数据执行预测时才运行。

注意：将 `<LabBucketName>` 替换为在实验设置过程中创建的实验存储桶的名称。


```python
import io
#bucket='<LabBucketName>'
prefix='flight-linear'
train_file='flight_train.csv'
test_file='flight_test.csv'
validate_file='flight_validate.csv'
whole_file='flight.csv'
s3_resource = boto3.Session().resource('s3')

def upload_s3_csv(filename, folder, dataframe):
    csv_buffer = io.StringIO()
    dataframe.to_csv(csv_buffer, header=False, index=False )
    s3_resource.Bucket(bucket).Object(os.path.join(prefix, folder, filename)).put(Body=csv_buffer.getvalue())
```


```python
def batch_linear_predict(test_data, estimator):
    batch_X = test_data.iloc[:,1:];
    batch_X_file='batch-in.csv'
    upload_s3_csv(batch_X_file, 'batch-in', batch_X)

    batch_output = "s3://{}/{}/batch-out/".format(bucket,prefix)
    batch_input = "s3://{}/{}/batch-in/{}".format(bucket,prefix,batch_X_file)

    classifier_transformer = estimator.transformer(instance_count=1,
                                           instance_type='ml.m4.xlarge',
                                           strategy='MultiRecord',
                                           assemble_with='Line',
                                           output_path=batch_output)

    classifier_transformer.transform(data=batch_input,
                             data_type='S3Prefix',
                             content_type='text/csv',
                             split_type='Line')
    
    classifier_transformer.wait()

    s3 = boto3.client('s3')
    obj = s3.get_object(Bucket=bucket, Key="{}/batch-out/{}".format(prefix,'batch-in.csv.out'))
    target_predicted_df = pd.read_json(io.BytesIO(obj['Body'].read()),orient="records",lines=True)
    return test_data.iloc[:,0], target_predicted_df.iloc[:,0]
```


要对测试数据集运行预测，对测试数据集运行 `batch_linear_predict` 函数（先前已定义）。



```python
test_labels, target_predicted = batch_linear_predict(test, classifier_estimator)
```

要查看混淆矩阵的图以及各个评分指标，请创建几个函数：


```python
from sklearn.metrics import confusion_matrix

def plot_confusion_matrix(test_labels, target_predicted):
    matrix = confusion_matrix(test_labels, target_predicted)
    df_confusion = pd.DataFrame(matrix)
    colormap = sns.color_palette("BrBG", 10)
    sns.heatmap(df_confusion, annot=True, fmt='.2f', cbar=None, cmap=colormap)
    plt.title("Confusion Matrix")
    plt.tight_layout()
    plt.ylabel("True Class")
    plt.xlabel("Predicted Class")
    plt.show()
    
```


```python
from sklearn import metrics

def plot_roc(test_labels, target_predicted):
    TN, FP, FN, TP = confusion_matrix(test_labels, target_predicted).ravel()
    # Sensitivity, hit rate, recall, or true positive rate
    Sensitivity  = float(TP)/(TP+FN)*100
    # Specificity or true negative rate
    Specificity  = float(TN)/(TN+FP)*100
    # Precision or positive predictive value
    Precision = float(TP)/(TP+FP)*100
    # Negative predictive value
    NPV = float(TN)/(TN+FN)*100
    # Fall out or false positive rate
    FPR = float(FP)/(FP+TN)*100
    # False negative rate
    FNR = float(FN)/(TP+FN)*100
    # False discovery rate
    FDR = float(FP)/(TP+FP)*100
    # Overall accuracy
    ACC = float(TP+TN)/(TP+FP+FN+TN)*100

    print("Sensitivity or TPR: ", Sensitivity, "%") 
    print( "Specificity or TNR: ",Specificity, "%") 
    print("Precision: ",Precision, "%") 
    print("Negative Predictive Value: ",NPV, "%") 
    print( "False Positive Rate: ",FPR,"%")
    print("False Negative Rate: ",FNR, "%") 
    print("False Discovery Rate: ",FDR, "%" )
    print("Accuracy: ",ACC, "%") 

    test_labels = test.iloc[:,0];
    print("Validation AUC", metrics.roc_auc_score(test_labels, target_predicted) )

    fpr, tpr, thresholds = metrics.roc_curve(test_labels, target_predicted)
    roc_auc = metrics.auc(fpr, tpr)

    plt.figure()
    plt.plot(fpr, tpr, label='ROC curve (area = %0.2f)' % (roc_auc))
    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic')
    plt.legend(loc="lower right")

    # create the axis of thresholds (scores)
    ax2 = plt.gca().twinx()
    ax2.plot(fpr, thresholds, markeredgecolor='r',linestyle='dashed', color='r')
    ax2.set_ylabel('Threshold',color='r')
    ax2.set_ylim([thresholds[-1],thresholds[0]])
    ax2.set_xlim([fpr[0],fpr[-1]])

    print(plt.figure())
```

要绘制混淆矩阵，对批处理作业的 `test_labels` 和 `target_predicted` 数据调用 `plot_confusion_matrix` 函数：


```python
# Enter your code here
```

要輸出统计数据并绘制受试者操作特征 (ROC) 曲线，对批处理作业的 `test_labels` 和 `target_predicted` 数据调用 `plot_roc` 函数：


```python
# Enter your code here
```

### 要考虑的关键问题：

1.您的模型在测试集上的表现与训练集上的表现相比如何？ 您可以从这种比较中推断出什么？ 
2.准确率、查准率和查全率等指标结果之间有没有明显差异？ 如果是，为什么您会看到这些差异？ 
3.考虑到您的业务状况和目标，您此时最需要考虑的指标是什么？ 原因何在？
4.您认为最重要指标的结果是否足以满足您的业务需求？ 如果不满足，您在下一次迭代中可能会更改哪些内容？ （这将在接下来的特征工程部分中进行。）

用下面的单元格来回答这些问题和其他问题。根据需要插入和删除单元格。

#### <span style="color: blue;">项目演示：在项目演示中，写下这些问题的答案以及您可能会在本节中回答的其他类似问题的答案。记录关键细节和您所做的决策。</span>


问题：您可以从混淆矩阵中总结出什么？



```python
# Enter your answer here
```

## <span style="color:red"> 步骤 3 结束 </span>

将项目文件保存到本地计算机。按照以下步骤进行操作：

1.在左侧的文件资源管理器中，右键单击您要处理的笔记本。

2.选择 Download（下载），然后将文件保存到本地。 

此操作会将当前的笔记本下载到计算机上默认的下载文件夹中。

# 迭代 II

# 步骤 4：特征设计

现在，您已经完成了一次训练和评估模型的迭代。鉴于模型第一次获得的结果可能不足以解决您的业务问题，您可以对数据进行哪些更改以改进模型的表现？

### 要考虑的关键问题：

1.两个主要类（*延误*与*不延误*）的平衡可能会对模型效果有怎样的影响？
2.是否有任何相关联的特征？
3.在此阶段，您是否可以执行可能会对模型性能产生积极影响的特征约简技术？ 
4.您能否想办法添加更多数据或数据集？
5.执行一些特征设计之后，模型效果与第一次迭代相比如何？

使用以下单元格中的内容来执行您认为可以改善模型性能的特定工程技术（以前面的问题为指导）。根据需要插入和删除单元格。

#### <span style="color: blue;">项目演示：在项目演示中，记录您的关键决策以及在这个部分中使用的方法，并包含您在再次评估模型后获得的任何新性能指标。</span>

在开始之前，思考一下为什么精确率和召回率在 80% 左右，而准确率为 99%。

添加更多特征：

1.节假日
2.天气

2014 到 2018 年的节假日列表是已知数据，因此您可以创建指示变量 is_holiday 来标记这些节假日。

我们假设节假日的航班延误比平时更多。请添加一个涵盖 2014 到 2018 年的节假日的布尔变量 `is_holiday`。


```python
# Source: http://www.calendarpedia.com/holidays/federal-holidays-2014.html

holidays_14 = ['2014-01-01',  '2014-01-20', '2014-02-17', '2014-05-26', '2014-07-04', '2014-09-01', '2014-10-13', '2014-11-11', '2014-11-27', '2014-12-25' ] 
holidays_15 = ['2015-01-01',  '2015-01-19', '2015-02-16', '2015-05-25', '2015-06-03', '2015-07-04', '2015-09-07', '2015-10-12', '2015-11-11', '2015-11-26', '2015-12-25'] 
holidays_16 = ['2016-01-01',  '2016-01-18', '2016-02-15', '2016-05-30', '2016-07-04', '2016-09-05', '2016-10-10', '2016-11-11', '2016-11-24', '2016-12-25', '2016-12-26']
holidays_17 = ['2017-01-02', '2017-01-16', '2017-02-20', '2017-05-29' , '2017-07-04', '2017-09-04' ,'2017-10-09', '2017-11-10', '2017-11-23', '2017-12-25']
holidays_18 = ['2018-01-01', '2018-01-15', '2018-02-19', '2018-05-28' , '2018-07-04', '2018-09-03' ,'2018-10-08', '2018-11-12','2018-11-22', '2018-12-25']
holidays = holidays_14+ holidays_15+ holidays_16 + holidays_17+ holidays_18

### Add indicator variable for holidays
data_orig['is_holiday'] = # Enter your code here 
```

天气数据获取自 https://www.ncei.noaa.gov/access/services/data/v1?dataset=daily-summaries&amp;stations=USW00023174,USW00012960,USW00003017,USW00094846,USW00013874,USW00023234,USW00003927,USW00023183,USW00013881&amp;dataTypes=AWND,PRCP,SNOW,SNWD,TAVG,TMIN,TMAX&amp;startDate=2014-01-01&amp;endDate=2018-12-31。
<br>

该数据集包含多个城市的风速、降水量、降雪量和温度信息，按其机场代码列出。

问题：雨、雪或大风造成的恶劣天气是否会导致航班延误？ 您现在将对此进行检查。


```python
!aws s3 cp s3://aws-tc-largeobjects/CUR-TF-200-ACMLFO-1/flight_delay_project/data2/daily-summaries.csv /home/ec2-user/SageMaker/project/data/
#!wget 'https://www.ncei.noaa.gov/access/services/data/v1?dataset=daily-summaries&stations=USW00023174,USW00012960,USW00003017,USW00094846,USW00013874,USW00023234,USW00003927,USW00023183,USW00013881&dataTypes=AWND,PRCP,SNOW,SNWD,TAVG,TMIN,TMAX&startDate=2014-01-01&endDate=2018-12-31' -O /home/ec2-user/SageMaker/project/data/daily-summaries.csv
```

将与机场代码对应的天气数据导入数据集中。使用以下气象站和机场进行分析。创建一个名为 *airport* 的新列，用于将气象站映射到机场名称。


```python
weather = pd.read_csv('/home/ec2-user/SageMaker/project/data/daily-summaries.csv')
station = ['USW00023174','USW00012960','USW00003017','USW00094846','USW00013874','USW00023234','USW00003927','USW00023183','USW00013881'] 
airports = ['LAX', 'IAH', 'DEN', 'ORD', 'ATL', 'SFO', 'DFW', 'PHX', 'CLT']

### Map weather stations to airport code
station_map = {s:a for s,a in zip(station, airports)}
weather['airport'] = weather['STATION'].map(station_map)
```

从 DATE 列中创建另一个名为 *MONTH* 的列。


```python
weather['MONTH'] = weather['DATE'].apply(lambda x: x.split('-')[1])
weather.head()
```

### 示例输出
```
  STATION     DATE      AWND PRCP SNOW SNWD TAVG TMAX  TMIN airport MONTH
0 USW00023174 2014-01-01 16   0   NaN  NaN 131.0 178.0 78.0  LAX    01
1 USW00023174 2014-01-02 22   0   NaN  NaN 159.0 256.0 100.0 LAX    01
2 USW00023174 2014-01-03 17   0   NaN  NaN 140.0 178.0 83.0  LAX    01
3 USW00023174 2014-01-04 18   0   NaN  NaN 136.0 183.0 100.0 LAX    01
4 USW00023174 2014-01-05 18   0   NaN  NaN 151.0 244.0 83.0  LAX    01
```

使用 `fillna()` 来分析并处理 SNOW 和 SNWD 列缺少的值。使用 `isna()` 函数来检查所有列缺少的值。


```python
weather.SNOW.fillna(0, inplace=True)
weather.SNWD.fillna(0, inplace=True)
weather.isna().sum()
```

问题：輸出 *TAVG*、*TMAX* 和 *TMIN* 缺少值的行的索引。

提示：要查找缺少的行，请使用 `isna()` 函数。然后，在 *idx* 变量上使用该列表以获取索引。


```python
idx = np.array([i for i in range(len(weather))])
TAVG_idx = idx[weather.TAVG.isna()] 
TMAX_idx = # Enter your code here 
TMIN_idx = # Enter your code here 
TAVG_idx
```

### 示例输出

```
array([ 3956,  3957,  3958,  3959,  3960,  3961,  3962,  3963,  3964,
        3965,  3966,  3967,  3968,  3969,  3970,  3971,  3972,  3973,
        3974,  3975,  3976,  3977,  3978,  3979,  3980,  3981,  3982,
        3983,  3984,  3985,  4017,  4018,  4019,  4020,  4021,  4022,
        4023,  4024,  4025,  4026,  4027,  4028,  4029,  4030,  4031,
        4032,  4033,  4034,  4035,  4036,  4037,  4038,  4039,  4040,
        4041,  4042,  4043,  4044,  4045,  4046,  4047, 13420])
```

您可以用特定气象站或机场的平均值来替换缺少的 *TAVG*、*TMAX* 和 *TMIN* 值。由于 *TAVG_idx* 缺少连续的行，因此无法用上个值进行替换。请使用均值进行替换。使用 `groupby` 函数来聚合采用均值的变量。

提示：按 `MONTH` 和 `STATION` 分组。


```python
weather_impute = weather.groupby([<CODE>]).agg({'TAVG':'mean','TMAX':'mean', 'TMIN':'mean' }).reset_index()# Enter your code here
weather_impute.head(2)
```

合并均值数据与天气数据。


```python

weather = pd.merge(weather, weather_impute,  how='left', left_on=['MONTH','STATION'], right_on = ['MONTH','STATION'])\
.rename(columns = {'TAVG_y':'TAVG_AVG',
                   'TMAX_y':'TMAX_AVG', 
                   'TMIN_y':'TMIN_AVG',
                   'TAVG_x':'TAVG',
                   'TMAX_x':'TMAX', 
                   'TMIN_x':'TMIN'})
```

再次检查缺少的值。


```python
weather.TAVG[TAVG_idx] = weather.TAVG_AVG[TAVG_idx]
weather.TMAX[TMAX_idx] = weather.TMAX_AVG[TMAX_idx]
weather.TMIN[TMIN_idx] = weather.TMIN_AVG[TMIN_idx]
weather.isna().sum()
```

从数据集中删除 `STATION,MONTH,TAVG_AVG,TMAX_AVG,TMIN_AVG,TMAX,TMIN,SNWD`。


```python
weather.drop(columns=['STATION','MONTH','TAVG_AVG', 'TMAX_AVG', 'TMIN_AVG', 'TMAX' ,'TMIN', 'SNWD'],inplace=True)
```

将出发地和目的地天气状况添加到数据集内。


```python
### Add origin weather conditions
data_orig = pd.merge(data_orig, weather,  how='left', left_on=['FlightDate','Origin'], right_on = ['DATE','airport'])\
.rename(columns = {'AWND':'AWND_O','PRCP':'PRCP_O', 'TAVG':'TAVG_O', 'SNOW': 'SNOW_O'})\
.drop(columns=['DATE','airport'])

### Add destination weather conditions
data_orig = pd.merge(data_orig, weather,  how='left', left_on=['FlightDate','Dest'], right_on = ['DATE','airport'])\
.rename(columns = {'AWND':'AWND_D','PRCP':'PRCP_D', 'TAVG':'TAVG_D', 'SNOW': 'SNOW_D'})\
.drop(columns=['DATE','airport'])
```

注意：在合并数据后最好先检查空值或缺失值。


```python
sum(data.isna().any())
```


```python
data_orig.columns
```

使用独热编码将分类数据转化为数值数据。


```python
data = data_orig.copy()
data = data[['is_delay', 'Year', 'Quarter', 'Month', 'DayofMonth', 'DayOfWeek', 
       'Reporting_Airline', 'Origin', 'Dest','Distance','DepHourofDay','is_holiday', 'AWND_O', 'PRCP_O',
       'TAVG_O', 'AWND_D', 'PRCP_D', 'TAVG_D', 'SNOW_O', 'SNOW_D']]


categorical_columns  = ['Year', 'Quarter', 'Month', 'DayofMonth', 'DayOfWeek', 
       'Reporting_Airline', 'Origin', 'Dest', 'is_holiday']
for c in categorical_columns:
    data[c] = data[c].astype('category')
```


```python
data_dummies = pd.get_dummies(data[['Year', 'Quarter', 'Month', 'DayofMonth', 'DayOfWeek', 'Reporting_Airline', 'Origin', 'Dest', 'is_holiday']], drop_first=True)
data = pd.concat([data, data_dummies], axis = 1)
data.drop(categorical_columns,axis=1, inplace=True)
```

检查新列。


```python
data.shape
```


```python
data.columns
```

### 示例输出

```
Index(['Distance', 'DepHourofDay', 'is_delay', 'AWND_O', 'PRCP_O', 'TAVG_O',
       'AWND_D', 'PRCP_D', 'TAVG_D', 'SNOW_O', 'SNOW_D', 'Year_2015',
       'Year_2016', 'Year_2017', 'Year_2018', 'Quarter_2', 'Quarter_3',
       'Quarter_4', 'Month_2', 'Month_3', 'Month_4', 'Month_5', 'Month_6',
       'Month_7', 'Month_8', 'Month_9', 'Month_10', 'Month_11', 'Month_12',
       'DayofMonth_2', 'DayofMonth_3', 'DayofMonth_4', 'DayofMonth_5',
       'DayofMonth_6', 'DayofMonth_7', 'DayofMonth_8', 'DayofMonth_9',
       'DayofMonth_10', 'DayofMonth_11', 'DayofMonth_12', 'DayofMonth_13',
       'DayofMonth_14', 'DayofMonth_15', 'DayofMonth_16', 'DayofMonth_17',
       'DayofMonth_18', 'DayofMonth_19', 'DayofMonth_20', 'DayofMonth_21',
       'DayofMonth_22', 'DayofMonth_23', 'DayofMonth_24', 'DayofMonth_25',
       'DayofMonth_26', 'DayofMonth_27', 'DayofMonth_28', 'DayofMonth_29',
       'DayofMonth_30', 'DayofMonth_31', 'DayOfWeek_2', 'DayOfWeek_3',
       'DayOfWeek_4', 'DayOfWeek_5', 'DayOfWeek_6', 'DayOfWeek_7',
       'Reporting_Airline_DL', 'Reporting_Airline_OO', 'Reporting_Airline_UA',
       'Reporting_Airline_WN', 'Origin_CLT', 'Origin_DEN', 'Origin_DFW',
       'Origin_IAH', 'Origin_LAX', 'Origin_ORD', 'Origin_PHX', 'Origin_SFO',
       'Dest_CLT', 'Dest_DEN', 'Dest_DFW', 'Dest_IAH', 'Dest_LAX', 'Dest_ORD',
       'Dest_PHX', 'Dest_SFO', 'is_holiday_1'],
      dtype='object')
```

再次将 is_delay 列重命名为 target。使用与之前相同的代码。


```python
data.rename(columns = {<CODE>:<CODE>}, inplace=True )# Enter your code here
```

再次创建训练集。

提示：使用您先前定义（和使用）的函数 `split_data`。


```python
# Enter your code here
```

### 新基准分类器

现在我们来看一下这些新特征是否提高了模型的预测能力。


```python
# Instantiate the LinearLearner estimator object
classifier_estimator2 = # Enter your code here
```

### 示例代码

```
num_classes = len(pd.unique(train_labels)) 
classifier_estimator = sagemaker.LinearLearner(role=sagemaker.get_execution_role(),
                                               instance_count=1,
                                               instance_type='ml.m4.xlarge',
                                               predictor_type='binary_classifier',
                                               binary_classifier_model_selection_criteria = 'cross_entropy_loss')
```


```python
train_records = classifier_estimator2.record_set(train.values[:, 1:].astype(np.float32), train.values[:, 0].astype(np.float32), channel='train')
val_records = classifier_estimator2.record_set(validate.values[:, 1:].astype(np.float32), validate.values[:, 0].astype(np.float32), channel='validation')
test_records = classifier_estimator2.record_set(test.values[:, 1:].astype(np.float32), test.values[:, 0].astype(np.float32), channel='test')
```

使用刚刚创建的三个数据集训练模型。


```python
# Enter your code here
```

使用新训练的模型执行批量预测。


```python
# Enter your code here
```

绘制混淆矩阵。


```python
# Enter your code here
```

绘制 ROC 曲线。


```python
# Enter your code here
```

线性模型的效果只有少许提高。我们使用 Amazon SageMaker 来尝试基于树的集成模型 *XGBoost*。

### 尝试 XGBoost 模型

执行以下步骤：  

1.使用训练集变量并将其另存为 CSV 文件 train.csv、validation.csv 和 test.csv。
2.将存储桶名称存储在变量中。Amazon S3 存储桶名称位于实验说明左侧。 
a. `bucket = <LabBucketName>`  
b. `prefix = 'flight-xgb'`  
3.使用适用于 Python 的 AWS 开发工具包 (Boto3) 将模型上传到存储桶。   


```python
bucket='c130335a3301608l7992428t1w61683623926-flightbucket-i7m3o2pzzyh8'
prefix='flight-xgb'
train_file='flight_train.csv'
test_file='flight_test.csv'
validate_file='flight_validate.csv'
whole_file='flight.csv'
s3_resource = boto3.Session().resource('s3')

def upload_s3_csv(filename, folder, dataframe):
    csv_buffer = io.StringIO()
    dataframe.to_csv(csv_buffer, header=False, index=False )
    s3_resource.Bucket(bucket).Object(os.path.join(prefix, folder, filename)).put(Body=csv_buffer.getvalue())

upload_s3_csv(train_file, 'train', train)
upload_s3_csv(test_file, 'test', test)
upload_s3_csv(validate_file, 'validate', validate)
```

使用函数 `sagemaker.s3_input` 为训练和验证数据集创建 `record_set`。


```python
train_channel = sagemaker.inputs.TrainingInput(
    "s3://{}/{}/train/".format(bucket,prefix,train_file),
    content_type='text/csv')

validate_channel = sagemaker.inputs.TrainingInput(
    "s3://{}/{}/validate/".format(bucket,prefix,validate_file),
    content_type='text/csv')

data_channels = {'train': train_channel, 'validation': validate_channel}
```


```python
from sagemaker.image_uris import retrieve
container = retrieve('xgboost',boto3.Session().region_name,'1.0-1')
```


```python
sess = sagemaker.Session()
s3_output_location="s3://{}/{}/output/".format(bucket,prefix)

xgb = sagemaker.estimator.Estimator(container,
                                    role = sagemaker.get_execution_role(), 
                                    instance_count=1, 
                                    instance_type=instance_type,
                                    output_path=s3_output_location,
                                    sagemaker_session=sess)
xgb.set_hyperparameters(max_depth=5,
                        eta=0.2,
                        gamma=4,
                        min_child_weight=6,
                        subsample=0.8,
                        silent=0,
                        objective='binary:logistic',
                        eval_metric = "auc", 
                        num_round=100)

xgb.fit(inputs=data_channels)
```

将批批量转换器用于新模型，然后使用测试数据集评估模型。


```python
batch_X = test.iloc[:,1:];
batch_X_file='batch-in.csv'
upload_s3_csv(batch_X_file, 'batch-in', batch_X)
```


```python
batch_output = "s3://{}/{}/batch-out/".format(bucket,prefix)
batch_input = "s3://{}/{}/batch-in/{}".format(bucket,prefix,batch_X_file)

xgb_transformer = xgb.transformer(instance_count=1,
                                       instance_type=instance_type,
                                       strategy='MultiRecord',
                                       assemble_with='Line',
                                       output_path=batch_output)

xgb_transformer.transform(data=batch_input,
                         data_type='S3Prefix',
                         content_type='text/csv',
                         split_type='Line')
xgb_transformer.wait()
```

获取预测目标和测试标签。


```python
s3 = boto3.client('s3')
obj = s3.get_object(Bucket=bucket, Key="{}/batch-out/{}".format(prefix,'batch-in.csv.out'))
target_predicted = pd.read_csv(io.BytesIO(obj['Body'].read()),',',names=['target'])
test_labels = test.iloc[:,0]
```

根据定义的阈值计算预测值。

注意：预测目标为分数，必须将其转换为二元分类。


```python
print(target_predicted.head())

def binary_convert(x):
    threshold = 0.55
    if x > threshold:
        return 1
    else:
        return 0

target_predicted['target'] = target_predicted['target'].apply(binary_convert)

test_labels = test.iloc[:,0]

print(target_predicted.head())
```

为 `target_predicted` 和 `test_labels` 绘制混淆矩阵。


```python
# Enter your code here
```

绘制 ROC 图：


```python
# Enter your code here
```

### 尝试不同阈值

问题：根据模型在测试集上的表现，您可以得出什么结论？


```python
#Enter your answer here
```

### 超参数优化 (HPO)


```python
from sagemaker.tuner import IntegerParameter, CategoricalParameter, ContinuousParameter, HyperparameterTuner

### You can spin up multiple instances to do hyperparameter optimization in parallel

xgb = sagemaker.estimator.Estimator(container,
                                    role=sagemaker.get_execution_role(), 
                                    instance_count= 1, # make sure you have a limit set for these instances
                                    instance_type=instance_type, 
                                    output_path='s3://{}/{}/output'.format(bucket, prefix),
                                    sagemaker_session=sess)

xgb.set_hyperparameters(eval_metric='auc',
                        objective='binary:logistic',
                        num_round=100,
                        rate_drop=0.3,
                        tweedie_variance_power=1.4)

hyperparameter_ranges = {'alpha': ContinuousParameter(0, 1000, scaling_type='Linear'),
                         'eta': ContinuousParameter(0.1, 0.5, scaling_type='Linear'),
                         'min_child_weight': ContinuousParameter(3, 10, scaling_type='Linear'),
                         'subsample': ContinuousParameter(0.5, 1),
                         'num_round': IntegerParameter(10,150)}

objective_metric_name = 'validation:auc'

tuner = HyperparameterTuner(xgb,
                            objective_metric_name,
                            hyperparameter_ranges,
                            max_jobs=10, # Set this to 10 or above depending upon budget and available time.
                            max_parallel_jobs=1)
```


```python
tuner.fit(inputs=data_channels)
tuner.wait()
```

<i class="fas fa-exclamation-triangle" style="color:red"></i> 等待训练作业完成。这可能需要 25 到 30 分钟。

要监控超参数优化作业，您需要进行以下操作：  

1.在 AWS 管理控制台的 Services（服务）菜单中，选择 Amazon SageMaker。 
2.单击 Training > Hyperparameter tuning jobs（训练 >超参数优化作业）。
3.您可以查看每个超参数优化作业的状态、目标指标值和日志。 

检查作业是否成功完成。


```python
boto3.client('sagemaker').describe_hyper_parameter_tuning_job(
    HyperParameterTuningJobName=tuner.latest_tuning_job.job_name)['HyperParameterTuningJobStatus']
```

超参数优化作业将产生效果最佳的模型。您可以从优化作业中获取有关该模型的信息。


```python
sage_client = boto3.Session().client('sagemaker')
tuning_job_name = tuner.latest_tuning_job.job_name
print(f'tuning job name:{tuning_job_name}')
tuning_job_result = sage_client.describe_hyper_parameter_tuning_job(HyperParameterTuningJobName=tuning_job_name)
best_training_job = tuning_job_result['BestTrainingJob']
best_training_job_name = best_training_job['TrainingJobName']
print(f"best training job: {best_training_job_name}")

best_estimator = tuner.best_estimator()

tuner_df = sagemaker.HyperparameterTuningJobAnalytics(tuning_job_name).dataframe()
tuner_df.head()
```

使用估算器 `best_estimator` 并使用数据对其进行训练。

提示：请参阅之前的 XGBoost 估算器拟合函数。


```python
# Enter your code here'
```

将批批量转换器用于新模型，然后使用测试数据集评估模型。


```python
batch_output = "s3://{}/{}/batch-out/".format(bucket,prefix)
batch_input = "s3://{}/{}/batch-in/{}".format(bucket,prefix,batch_X_file)

xgb_transformer = best_estimator.transformer(instance_count=1,
                                       instance_type=instance_type,
                                       strategy='MultiRecord',
                                       assemble_with='Line',
                                       output_path=batch_output)

xgb_transformer.transform(data=batch_input,
                         data_type='S3Prefix',
                         content_type='text/csv',
                         split_type='Line')
xgb_transformer.wait()
```


```python
s3 = boto3.client('s3')
obj = s3.get_object(Bucket=bucket, Key="{}/batch-out/{}".format(prefix,'batch-in.csv.out'))
target_predicted = pd.read_csv(io.BytesIO(obj['Body'].read()),',',names=['target'])
test_labels = test.iloc[:,0]
```

获取预测目标和测试标签。


```python
print(target_predicted.head())

def binary_convert(x):
    threshold = 0.55
    if x > threshold:
        return 1
    else:
        return 0

target_predicted['target'] = target_predicted['target'].apply(binary_convert)

test_labels = test.iloc[:,0]

print(target_predicted.head())
```

为 `target_predicted` 和 `test_labels` 绘制混淆矩阵。


```python
# Enter your code here
```

绘制 ROC 图：


```python
# Enter your code here
```

问题：尝试不同的超参数和超参数范围。这些更改是否改善了模型？

## 总结

现在，您已经至少对模型进行了几次训练和评估。现在到了结束该项目并反思以下问题的时候：

- 您学到了什么？ 
- 接下来您可能会采取哪些类型的步骤（假设您有更多时间）

使用下面的单元格回答其中一些问题和其他相关问题：

1.您的模型性能是否能实现您的业务目标？ 如果不符合，而且您还有时间进行优化，那么您会采取哪些不同的做法？
2.在您对数据集、特征和超参数做出更改之后，模型有多大程度的改进？ 在整个项目中，您采用了哪些方法对模型进行改进？效果最佳的是哪个？
3.在整个项目中，您遇到的最大挑战是什么？
4.关于管道的各个方面，有哪些没有解决的问题对您来说是毫无意义的？
5.在进行这个项目的过程中，关于机器学习，您学到的三件最重要的事情是什么？

#### <span style="color: blue;">项目演示：确保在项目演示中同样总结这些问题的答案。现在，将项目演示期间的所有笔记整理在一起，准备向全班展示您的成果。</span>


```python
# Write your answers here
```
