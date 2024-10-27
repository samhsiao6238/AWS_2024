# 安裝 EB CLI

_`EB CLI` 是專為 `AWS Elastic Beanstalk` 設計，具備針對性更強的指令，安裝時會自動安裝依賴項目，包括 Python 和 pip。_

<br>

## 安裝 EB CLI

_這是在 MacOS 操作_

<br>

1. 在 `Documents` 中建立安裝目錄；並非強制規範，這僅是我個人習慣。

    ```bash
    cd ~/Documents && mkdir ~/ebcli && cd ~/ebcli
    ```

<br>

2. 下載腳本。

    ```bash
    curl -O https://bootstrap.pypa.io/get-pip.py
    ```

<br>

3. 運行安裝腳本及相關依賴項目。

    ```bash
    python get-pip.py && pip install awsebcli --upgrade
    ```

<br>

4. 驗證安裝。

    ```bash
    eb --version
    ```

    _結果_

    ```bash
    EB CLI 3.20.10 (Python 3.10.11 (v3.10.11:7d4cc5aa85, Apr  4 2023, 19:05:19) [Clang 13.0.0 (clang-1300.0.29.30)])
    ```

<br>

## 若在全局安裝

1. 若進行全局安裝必須確保已退出虛擬環境。

    ```bash
    deactivate
    ```

<br>

2. 使用全局安裝 EB CLI 時，執行檔會安裝到使用者專用的 Python 執行路徑，先確定使用的 Python 版本後，將路徑加入環境變數；此處僅簡單說明不贅述。

    ```bash
    export PATH=$PATH:/Users/samhsiao/Library/Python/3.10/bin
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