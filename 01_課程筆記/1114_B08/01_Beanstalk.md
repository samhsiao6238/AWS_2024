# Beanstalk

_可參考 `07_Elastic Beanstalk`_

<br>

## 打包部署

1. 建立專案資料夾，內含三個 Flask 站台所需文件。

```bash
mkdir -p ~/Downloads/_test_ && cd ~/Downloads/_test_
touch app.py requirements.txt Procfile

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

2. 對於資料夾進行壓縮時，若要維持在根路由，可使用以下指令進行壓縮；使用參數 `-x` 排除 Mac 系統自動生成的 `__MACOSX` 資料夾。

    ```bash
    zip -r ../your_project.zip . -x "__MACOSX"
    ```

<br>

## 部署 Flask 站台

_補_


<br>

___

_END_

