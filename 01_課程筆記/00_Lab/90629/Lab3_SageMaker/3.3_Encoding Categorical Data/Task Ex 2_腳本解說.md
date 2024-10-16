# 步驟 1：匯入與瀏覽數據

首先，您將檢查數據集中的數據。

為了充分利用本實驗，在運行單元格中的內容之前，請先閱讀說明與代碼，並花點時間進行實驗！

首先匯入 pandas 程式庫並設置一些預設顯示選項。
```python
import pandas as pd

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)
```

接下來，將數據集加載到 pandas DataFrame 中。

數據不包含標題，因此您需要在名為 `col_names` 的變數中為數據集描述中列出的屬性定義列名稱。

```python
url = "imports-85.csv"
col_names=['symboling','normalized-losses','fuel-type','aspiration','num-of-doors','body-style','drive-wheels','engine-location','wheel-base',
                                    'length','width','height','curb-weight','engine-type','num-of-cylinders','engine-size',
                                    'fuel-system','bore','stroke','compression-ratio','horsepower','peak-rpm','city-mpg','highway-mpg','price']

df_car = pd.read_csv(url, sep=',', names=col_names, na_values="?", header=None)
```

首先，要查看行（實例）和列（特徵）的數量，您將使用 `shape`。
```python
df_car.shape
```

接下來，使用 `head` 方法檢查數據。

```python
df_car.head(5)
```

共有 25 列。一些列具有數值，但其中許多列包含文本。

若要顯示有關列的信息，請使用 `info` 方法。

```python
df_car.info()
```

為了使您在開始編碼時能夠更方便地查看數據集，可刪除不需要的列。

```python
df_car.columns
df_car = df_car[[ 'aspiration', 'num-of-doors',  'drive-wheels',  'num-of-cylinders']].copy()
```

現在有四列。這些列均包含文本值。

```python
df_car.head()
```

大多數機器學習算法要求輸入的是數值。

- num-of-cylinders 和 num-of-doors 特徵具有序數值。您可以將這些特徵的值轉換為對應的數值。
- 但是，aspiration 和 drive-wheels 沒有序數值。這些特徵必須進行不同的轉換。

您將首先探索序數特徵。

# 步驟 2：對序數特徵進行編碼

在此步驟中，您將使用映射器函數將序數特徵轉換為有序的數值。

首先從 DataFrame 中獲取新的列類型：

```python
df_car.info()
```

首先，確定序數列包含哪些值。

從 num-of-doors 特徵開始，您可以使用 `value_counts` 來發現值。

```python
df_car['num-of-doors'].value_counts()
```

此特徵只有兩個值：*four* 和 *two*。您可以創建一個包含字典的簡單映射器：

```python
door_mapper = {"two": 2,
              "four": 4}
```

然後，您可以使用 pandas 的 `replace` 方法基於 num-of-doors 列生成一個新的數值列。

```python
df_car['doors'] = df_car["num-of-doors"].replace(door_mapper)
```

顯示 DataFrame 時，您應該可以在右側看到新的列。它包含門數量的數字表示。

```python
df_car.head()
```

對 num-of-cylinders 列重複該過程。

首先，獲取值。

```python
df_car['num-of-cylinders'].value_counts()
```

接下來，創建映射器。

```python
cylinder_mapper = {"two":2,
                  "three":3,
                  "four":4,
                  "five":5,
                  "six":6,
                  "eight":8,
                  "twelve":12}
```

使用 `replace` 方法應用映射器。

```python
df_car['cylinders'] = df_car['num-of-cylinders'].replace(cylinder_mapper)
df_car.head()
```

有關 `replace` 方法的更多資訊，請參閱 pandas 文檔中的 [pandas.DataFrame.replace](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.replace.html)。

# 步驟 3：對無序分類數據進行編碼

在此步驟中，您

將使用 pandas 的 `get_dummies` 方法對無序分類數據進行編碼。

其餘兩個特徵為無序特徵。

根據屬性描述，存在以下可能的值：

- aspiration：標準、渦輪。
- drive-wheels：四輪驅動、前輪驅動、後輪驅動。

您可能會認為正確的策略是將這些值轉換為數值。以 drive-wheels 為例，您可以使用 *4wd = 1*、*fwd = 2* 和 *rwd = 3*。但是，*fwd* 並不小於 *rwd*。這些值沒有順序，但是您通過分配這些數值為它們引入了順序。

正確的策略是將原始特徵中的每個值轉換為*二元特徵*。這個過程在機器學習中通常被稱為*獨熱編碼*，而在統計學中則稱為*虛擬變量化*。

pandas 提供了一種 `get_dummies` 方法，該方法可將數據轉換為二元特徵。欲了解更多資訊，請參閱 pandas 文檔中的 [pandas.get_dummies](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.get_dummies.html)。

根據屬性描述，drive-wheels 具有三個可能的值。

```python
df_car['drive-wheels'].value_counts()
```

使用 `get_dummies` 方法向 DataFrame 添加新的二元特徵。

```python
df_car = pd.get_dummies(df_car, columns=['drive-wheels'])
df_car.head()
```

檢查數據集時，您應該可以在右側看到三個新的列：

- drive-wheels_4wd
- drive-wheels_fwd
- drive-wheels_rwd

編碼很簡單。如果 drive-wheels 列中的值為 *4wd*，則 * drive-wheels_4wd 列中的值為 *1*。其他列的值則為 *0*。如果 drive-wheels 列中的值為 *fwd*，則 drive-wheels_fwd 列中的值為 *1*，依此類推。

藉助這些二元特徵，您能夠以數字方式表示這些信息，無需考慮順序。

檢查您將編碼的最後一列。

aspiration 列中的數據只有兩個值：*標準* 和 *渦輪*。您可以將此列編碼為兩個二元特徵。不過，您也可以忽略 *標準* 值並記錄是否為 *渦輪*。為此，您仍將使用 `get_dummies` 方法，但這時將 `drop_first` 指定為 *True*。

```python
df_car['aspiration'].value_counts()
df_car = pd.get_dummies(df_car, columns=['aspiration'], drop_first=True)
df_car.head()
```

挑戰任務：返回本實驗的開頭，並將其他列添加到數據集中。您將如何對每列的值進行編碼？ 更新代碼以引入一些其他特徵。

# 恭喜！

您已經完成了本實驗內容，現在可以按照實驗指南中的說明結束本實驗內容。
```

希望這段翻譯對您有所幫助！