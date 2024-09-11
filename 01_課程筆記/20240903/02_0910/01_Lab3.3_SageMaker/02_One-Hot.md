## One-Hot Cofing

_非序數型變量的 `One-Hot Encoding`_

<br>

## 說明

1. `非序數型類別變量（Nominal Categorical Variables）` 是指沒有固有順序或等級關係的類別數據，這些變量的值之間沒有內在的大小或先後順序；例如本範例中的 `drive-wheels（驅動方式）`，它的類別包括 `fwd（前輪驅動）`、`rwd（後輪驅動）` 和 `4wd（四輪驅動）`，這些類別並無大小之分，也沒有自然的順序；另外，`aspiration（進氣方式）` 的 `turbo` 和 std（標準）` 也是獨立的類別，沒有任何順序。

<br>

2. 由於非序數型變量沒有固有順序，直接將它們轉換成數值如 `fwd` 轉成 `1` 或是`rwd` 轉成 `2` 並不合適，因為這會讓機器學習模型誤解這些類別間存在某種數值上的順序或大小關係，這可能會影響模型的表現。

<br>

## `One-Hot Encoding` 的目的

1. `One-Hot Encoding` 是一種常見的類別變量編碼技術，通過將每個類別轉換為單獨的二進位欄位來避免這種問題，在 `One-Hot Encoding` 中，每個類別值對應一個新的欄位，該欄位只有兩個值 `0` 與 `1`，其中 `1` 表示該樣本屬於這個類別，`0` 表示該樣本不屬於這個類別。

<br>

## 具體操作

1. 假設 `drive-wheels` 變量包含三個不同的值，分別是 `fwd`（前輪驅動）、`rwd`（後輪驅動）、`4wd`（四輪驅動）。

<br>

2. 使用 `One-Hot Encoding` 後，`drive-wheels` 會被轉換為三個新的欄位，分別是：`drive-wheels_fwd`、`drive-wheels_rwd`、`drive-wheels_4wd`；每個樣本的這三個欄位，都將只有一個欄位的值為 `1`，另兩個欄位為 `0`；特別補充一點，`One-Hot Encoding` 就是 `虛擬變數轉換（Dummy Variable Transformation）` 的具體應用之一。

    ![](images/img_02.png)

<br>

## 其他說明

1. 避免模型誤解數值的意義：如果將 `非序數型類別變量` 直接映射為數字，如 `fwd = 1`、`rwd = 2）`，這將誤導機器學習模型以為 `rwd` 的數值大於 `fwd`，或者兩者之間有數值上的 `距離`，但實際上它們是獨立且不相關的 `類別`；因此使用 `One-Hot Encoding` 來確保模型不會誤解類別變量的關係。

<br>

2. 確保數執行模型的兼容性：許多機器學習算法需要數值輸入，無法直接處理非數值類別變量，而 `One-Hot Encoding` 可將這些類別轉換為數值格式的簡單方法，確保這些算法可以正常運行。

<br>

3. 消除多重共線性問題：在某些情況下，可使用 `drop_first=True` 來避免因為生成了多個 `One-Hot Encoding` 列所引發可能 `多重共線性問題`。舉例來說，如果 `drive-wheels` 只有兩個類別值 `fwd` 和 `rwd`，那麼只需要生成一個欄位如 `drive-wheels_fwd`，而不需要生成兩個欄位，因為當 `drive-wheels_fwd` 為 `0` 時，就意味著這是 `rwd`。

<br>

## `One-Hot Encoding` 在代碼中的操作

1. `drive-wheels` 編碼，以下代碼會將 `drive-wheels` 的不同類別分別轉換為三個新的二進位欄位，每個新欄位只會取值 `0` 或 `1`，表示該樣本是否屬於對應的類別。

    ```python
    df_car = pd.get_dummies(
        df_car, columns=["drive-wheels"]
    )
    ```

<br>

2. 對 `aspiration` 進行 `One-Hot Encoding` ，其中使用 `drop_first=True` 來避免生成多餘的欄位。

    ```python
    df_car = pd.get_dummies(
        df_car, 
        columns=["aspiration"], 
        drop_first=True
    )
    ```

<br>

___

_END_