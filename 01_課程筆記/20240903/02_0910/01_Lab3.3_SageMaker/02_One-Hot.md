## One-Hot Cofing

_非序數型變量的 One-Hot 編碼_

## 說明

1. `非序數型類別變量（Nominal Categorical Variables）` 是指沒有固有順序或等級關係的類別數據，這些變量的值之間沒有內在的大小或先後順序；例如本範例中的 `drive-wheels（驅動方式）`，它的類別包括 `fwd（前輪驅動）`、`rwd（後輪驅動）` 和 `4wd（四輪驅動）`，這些類別並無大小之分，也沒有自然的順序；另外，`aspiration（進氣方式）` 的 `turbo` 和 std（標準）` 也是獨立的類別，沒有任何順序。

2. 由於非序數型變量沒有固有順序，直接將它們轉換成數值如 `fwd` 轉成 `1` 或是`rwd` 轉成 `2` 並不合適，因為這會讓機器學習模型誤解這些類別間存在某種數值上的順序或大小關係，這可能會影響模型的表現。

## One-Hot 編碼的目的

1. `One-Hot 編碼` 是一種常見的類別變量編碼技術，通過將每個類別轉換為單獨的二進位欄位來避免這種問題，在 One-Hot 編碼中，每個類別值對應一個新的欄位，該欄位只有兩個值 `0` 與 `1`，其中 `1` 表示該樣本屬於這個類別，`0` 表示該樣本不屬於這個類別。

### 具體操作示例：
假設 `drive-wheels` 變量包含三個不同的值：
- `"fwd"`（前輪驅動）
- `"rwd"`（後輪驅動）
- `"4wd"`（四輪驅動）

使用 One-Hot 編碼後，`drive-wheels` 會被轉換為三個新的欄位：
- `drive-wheels_fwd`
- `drive-wheels_rwd`
- `drive-wheels_4wd`

每個樣本的這三個欄位中只有一個欄位的值為 1，其他欄位為 0。例如：

| drive-wheels | drive-wheels_fwd | drive-wheels_rwd | drive-wheels_4wd |
|--------------|------------------|------------------|------------------|
| fwd          | 1                | 0                | 0                |
| rwd          | 0                | 1                | 0                |
| 4wd          | 0                | 0                | 1                |

### 為什麼要使用 One-Hot 編碼？
1. 避免數值誤解：
   如果將非序數型類別變量直接映射為數字（如 "fwd" = 1, "rwd" = 2），這將誤導機器學習模型以為 "rwd" 的數值大於 "fwd"，或者兩者之間有數值上的距離，但實際上它們是獨立且不相關的類別。因此，我們使用 One-Hot 編碼來確保模型不會誤解類別變量的關係。

2. 兼容性：
   許多機器學習算法需要數值輸入，無法直接處理非數值類別變量。One-Hot 編碼提供了一種將這些類別轉換為數值格式的簡單方法，確保這些算法可以正常運行。

3. 消除多重共線性問題：
   在某些情況下，我們可以使用 `drop_first=True`，這是為了避免生成多個 One-Hot 編碼列時出現多重共線性問題。舉例來說，如果 `drive-wheels` 只有兩個類別值 "fwd" 和 "rwd"，那麼只需要生成一個欄位（例如 `drive-wheels_fwd`），而不需要生成兩個欄位，因為當 `drive-wheels_fwd` 為 0 時，就意味著這是 "rwd"。

### 腳本中的具體 One-Hot 編碼操作：
1. `drive-wheels` 編碼：
   ```python
   df_car = pd.get_dummies(df_car, columns=["drive-wheels"])
   ```
   這一行代碼會將 `drive-wheels` 的不同類別（如 "fwd", "rwd", "4wd"）分別轉換為三個新的二進位欄位：
   - `drive-wheels_fwd`
   - `drive-wheels_rwd`
   - `drive-wheels_4wd`

   每個新欄位只會取值 0 或 1，表示該樣本是否屬於對應的類別。

2. `aspiration` 編碼（使用 `drop_first=True`）：
   ```python
   df_car = pd.get_dummies(df_car, columns=["aspiration"], drop_first=True)
   ```
   這裡對 `aspiration` 進行 One-Hot 編碼，同時使用了 `drop_first=True`，這會避免生成多餘的欄位。例如，若 `aspiration` 變量有 "std" 和 "turbo" 兩個類別值，這裡只會生成一個欄位 `aspiration_turbo`，當值為 0 時即表示 "std"。

### One-Hot 編碼的優點：
- 簡單直觀：將類別變量直接轉換為多個二進位變量，使機器學習模型能正確解釋這些變量的作用。
- 模型兼容性：這種編碼格式與大多數機器學習模型高度兼容，特別是線性模型和決策樹模型。
- 避免誤解：它能夠消除類別變量之間虛假的數值關聯，保證模型不會誤解類別之間的邏輯關係。

總結來說，One-Hot 編碼 是處理非序數型類別變量的常見技術，能將類別數據轉換為機器學習模型可以理解和正確使用的格式，有助於避免數據錯誤解釋並提高模型效果。