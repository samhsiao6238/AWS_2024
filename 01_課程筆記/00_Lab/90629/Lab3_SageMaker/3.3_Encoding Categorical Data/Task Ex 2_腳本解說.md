# 腳本解說

## 匯入與瀏覽數據

1. 首先，檢查數據集中的數據。

    ```python
    import pandas as pd
    # 最大烈數
    pd.set_option('display.max_rows', 500)
    # 最大欄位數
    pd.set_option('display.max_columns', 500)
    # 把寬度加大，避免自動換行
    pd.set_option('display.width', 1000)
    ```

<br>

2. 將數據集加載到 pandas DataFrame 中；因為數據不包含標題，因此在名為 `col_names` 的變數中為數據集定義欄名稱，將列表傳遞給參數 `names`。

    ```python
    url = "imports-85.csv"
    col_names=[
        'symboling','normalized-losses','fuel-type','aspiration',
        'num-of-doors','body-style','drive-wheels','engine-location',
        'wheel-base', 'length','width','height','curb-weight',
        'engine-type','num-of-cylinders','engine-size','fuel-system',
        'bore','stroke','compression-ratio','horsepower','peak-rpm',
        'city-mpg','highway-mpg','price'
    ]

    df_car = pd.read_csv(
        url, sep=',',
        names=col_names,
        na_values="?",
        header=None
    )
    ```

<br>

3. 使用 `shape` 查看行（實例）和欄（特徵）的數量。

    ```python
    df_car.shape
    ```

    ```bash
    (205, 25)
    ```

<br>

4. 使用 `head` 查看前五筆數據。

    ```python
    df_car.head(5)
    ```

    ![](images/img_04.png)

<br>

5. 若要顯示有關欄的信息，請使用 `info` 方法。

    ```python
    df_car.info()
    ```

    ![](images/img_05.png)

<br>

6. 查看有哪些欄。

    ```python
    df_car.columns
    ```

<br>

7. 可刪除不需要的欄；特別注意，在官方的腳本中，提取數據後先進行複製副本，然後再覆蓋原始變數 `df_car`，這是基於避免潛在錯誤的做法，並非絕對必要。

    ```python
    df_car = df_car[[
        'aspiration',
        'num-of-doors',
        'drive-wheels',
        'num-of-cylinders']
    ].copy()
    ```

<br>

7. 現在有 4 個欄，均包含文本值。

    ```python
    df_car.head()
    ```

<br>

8. 大多數機器學習算法要求輸入的是數值；其中 `num-of-cylinders` 和 `num-of-doors` 特徵具有序數值，可以將這些特徵的值轉換為對應的數值；但是，`aspiration` 和 `drive-wheels` 沒有序數值，這些特徵必須進行不同的轉換。

<br>

## 對序數特徵進行編碼

1. 在此步驟中，將使用映射器函數將序數特徵轉換為有序的數值。首先從 DataFrame 中獲取新的欄類型。

    ```python
    df_car.info()
    ```

<br>

2. 從 `num-of-doors` 特徵開始，可使用 `value_counts` 來發現值。

    ```python
    df_car['num-of-doors'].value_counts()
    ```

<br>

3. 此特徵只有兩個值 `two` 和 `four`，可建立一個包含字典的簡單映射器。

    ```python
    door_mapper = {
        "two": 2,
        "four": 4
    }
    ```

<br>

4. 然後可使用 pandas 的 `replace` 方法基於 `num-of-doors` 欄生成一個新的數值欄。

    ```python
    df_car['doors'] = df_car["num-of-doors"].replace(door_mapper)
    ```

<br>

5. 顯示 DataFrame 時，可以在右側看到新的欄，它包含 `門` 數量的數字表示。

    ```python
    df_car.head()
    ```

<br>

6. 對 `num-of-cylinders` 欄重複該過程。首先獲取值。

    ```python
    df_car['num-of-cylinders'].value_counts()
    ```

<br>

7. 接下來，建立映射器。

    ```python
    cylinder_mapper = {
        "two":2,
        "three":3,
        "four":4,
        "five":5,
        "six":6,
        "eight":8,
        "twelve":12
    }
    ```

<br>

8. 使用 `replace` 方法應用映射器。

    ```python
    df_car['cylinders'] = df_car['num-of-cylinders'].replace(
        cylinder_mapper
    )
    df_car.head()
    ```

<br>

## 對無序分類數據進行編碼

1. 在此步驟中，將使用 pandas 的 `get_dummies` 方法對無序分類數據進行編碼。根據屬性描述，存在以下可能的值：

    ```bash
    aspiration：標準、渦輪。
    drive-wheels：四輪驅動、前輪驅動、後輪驅動。
    ```

<br>

2. 可能會認為正確的策略是將這些值轉換為數值。以 `drive-wheels` 為例，可以使用 `4wd = 1`、`fwd = 2` 和 `rwd = 3`。但是，`fwd` 並不小於 `rwd`。這些值沒有順序，通過分配這些數值為它們引入了順序；正確的策略是將原始特徵中的每個值轉換為 _二元特徵_，這個過程在機器學習中通常被稱為 _one-hot 編碼_，而在統計學中則稱為 `虛擬變量`。

<br>

3. 根據屬性描述，`drive-wheels` 具有三個可能的值。

    ```python
    df_car['drive-wheels'].value_counts()
    ```

<br>

4. 使用 `get_dummies` 方法向 DataFrame 添加新的二元特徵。

    ```python
    df_car = pd.get_dummies(df_car, columns=['drive-wheels'])
    df_car.head()
    ```

<br>

5. 檢查數據集時，應該可以在右側看到三個新的 Column；編碼很簡單，如果 `drive-wheels` 欄中的值為 *4wd*，則 `drive-wheels_4wd` 欄中的值為 *1*，其他欄的值則為 *0*。如果 `drive-wheels` 欄中的值為 *fwd*，則 `drive-wheels_fwd` 欄中的值為 *1*，依此類推。

    ```bash
    drive-wheels_4wd
    drive-wheels_fwd
    drive-wheels_rwd
    ```

<br>

6. 藉助這些二元特徵，能夠以數字方式表示這些信息，無需考慮順序。

<br>

7. 檢查將編碼的最後一個欄；`aspiration` 欄中的數據只有兩個值：*標準* 和 *渦輪*。可以將此欄編碼為兩個二元特徵。不過，也可以忽略 *標準* 值並記錄是否為 *渦輪*。為此，仍將使用 `get_dummies` 方法，但這時將 `drop_first` 指定為 *True*。

    ```python
    df_car['aspiration'].value_counts()
    df_car = pd.get_dummies(df_car, columns=['aspiration'], drop_first=True)
    df_car.head()
    ```

<br>

## 挑戰任務

_返回本實驗的開頭，並將其他欄添加到數據集中。將如何對每個欄的值進行編碼？ 更新代碼以引入一些其他特徵。_

<br>

___

_END_