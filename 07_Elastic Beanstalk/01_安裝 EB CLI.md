# 安裝 EB CLI

_自動安裝 EB CLI 及其依賴項目，包括 Python 和 pip，並為 EB CLI 建立一個虛擬環境_

<br>

## MacOS 安裝 EB CLI

1. 在 `文件` 中建立安裝目錄。

    ```bash
    cd ~/Documents && mkdir ~/ebcli && cd ~/ebcli
    ```

<br>

2. 下載腳本。

    ```bash
    curl -O https://bootstrap.pypa.io/get-pip.py
    ```

<br>

3. 要進行全局安裝，所以必須確保已經退出虛擬環境；要安裝在虛擬環境也是可以，只是這在全局安裝對未來使用比較方便。

    ```bash
    deactivate
    ```

<br>

4. 運行安裝腳本及相關依賴項目。

    ```bash
    python get-pip.py --user && pip install awsebcli --upgrade --user
    ```

<br>

5. 出現警告。

    ```bash
    WARNING: The scripts eb and ebp are installed in '/Users/samhsiao/Library/Python/3.10/bin' which is not on PATH.
    Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
    NOTE: The current PATH contains path(s) starting with `~`, which may not be expanded by all applications.
    ```

<br>

6. 新增 EB CLI 環境變數；其餘不贅述。

    ```bash
    export PATH=$PATH:/Users/samhsiao/Library/Python/3.10/bin
    ```

<br>

7. 驗證安裝。

    ```bash
    eb --version
    ```

    _結果_

    ```bash
    EB CLI 3.20.10 (Python 3.10.11 (v3.10.11:7d4cc5aa85, Apr  4 2023, 19:05:19) [Clang 13.0.0 (clang-1300.0.29.30)])
    ```

<br>

## MacOS 透過 Homebrew 安裝

1. 安裝 EB CLI。

    ```bash
    brew install awsebcli
    ```

<br>

## Windows 安裝 EB CLI

1. 下載 [get-pip.py](https://bootstrap.pypa.io/get-pip.py) 並保存該文件到本地目錄。

<br>

2. 在 CMD 中運行以下指令。

    ```bash
    python get-pip.py --user
    pip install awsebcli --upgrade --user
    ```

<br>

3. 新增 EB CLI 環境變數；其餘不贅述。

    ```bash
    C:\Users\YourUsername\AppData\Roaming\Python\Scripts。
    ```

<br>

4. 驗證安裝。

    ```bash
    eb --version
    ```

<br>

___

_END_