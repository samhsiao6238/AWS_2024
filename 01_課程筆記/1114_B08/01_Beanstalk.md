# Beanstalk

_以下使用 `90630` Learner Lab 進行建立站台，可參考 `07_Elastic Beanstalk`_

<br>

## 建立 Python 平台專案

_先建立簡易的範例專案_

<br>

1. 在 `~/.Downloads` 建立專案資料夾 `_test_`，內含三個 Flask 站台所需文件。

    ```bash
    mkdir -p ~/Downloads/_test_ && cd ~/Downloads/_test_
    touch app.py requirements.txt Procfile
    ```

<br>

2. 編輯簡易站台所需腳本，並啟動 VSCode。

    ```bash
    echo "from flask import Flask

    app = Flask(__name__)


    @app.route('/')
    def home():
        return 'Hello, AWS Elastic Beanstalk with Flask!'


    if __name__ == '__main__':
        app.run()" > app.py


    echo "Flask==2.0.2
    gunicorn==20.1.0" > requirements.txt

    echo "web: gunicorn app:app" > Procfile

    code .
    ```

<br>

3. 在終端機啟動站台，並訪問 `127.0.0.1:5000`。

    ```bash
    python app.py
    ```

    ![](images/img_01.png)

<br>

4. 在資料夾 `_test_` 內對於資料夾進行壓縮，並將壓縮檔 `my_project.zip` 存放在上層目錄中，這樣可讓站台訪問時維持在根路由；使用參數 `-x` 可指定要排除的項目，這裡示範排除 Mac 系統自動生成的 `__MACOSX` 資料夾。

    ```bash
    zip -r ../my_project.zip . -x "__MACOSX"
    ```

    ![](images/img_02.png)

<br>

## 使用主控台建立應用

1. 

<br>

___

_END_

