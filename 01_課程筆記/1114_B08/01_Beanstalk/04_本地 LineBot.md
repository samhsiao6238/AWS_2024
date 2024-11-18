# 本地建立 LineBot

_可延續前一個步驟；特別注意，Webhook 必須使用 `https`，但是 Beanstalk 提供的網域是 `Http`。_

<br>

## 檢查端口

_在進行接下來步驟前，先檢查端口佔用情形，確認 Ngrok 將使用的端口目前是閒置的_

1. 檢查。

    ```bash
    lsof -i :5000
    ```

    ![](images/img_48.png)

<br>

2. 其中 `ControlCe (Control Center)` 是 macOS 系統的 `控制中心（Control Center）`，與 `AirDrop`、音量控制、Wi-Fi、藍牙等功能相關；另外 `Google` 代表可能正在與本地設備或遠程設備進行網絡通信，在這是因為 NAS 佔用了 `5000`；這在之前的專案中不受影響是因為單純在本地運行，接下來要使用 `ngrok`，所以必須確認端口閒置。

<br>

## 從頭開始

_假如重新建立專案，則從這裡開始，若沿用之前的專案，可以略過這個步驟_

<br>

1. 建立專案。

    ```python
    mkdir -p ~/Downloads/_linebot_ && cd ~/Downloads/_linebot_
    touch .env .gitignore application.py requirements.txt Procfile
    code .
    ```

<br>

2. 在 .gitignore 中寫入 .env 避免上傳敏感資訊。

    ```bash
    echo ".env" > .gitignore
    ```

<br>

3. 使用指令在 requirements.txt 中寫入套件。

    ```bash
    echo "Flask\ngunicorn\nline-bot-sdk==3.0.0" > requirements.txt
    ```

<br>

4. 使用指令在 Procfile 中寫入運行指令。

    ```bash
    echo "web: gunicorn application:application" > Procfile
    ```

<br>

5. 在 .env，添加兩個 Linebot 密鑰。

    ```bash
    echo "CHANNEL_ACCESS_TOKEN=\nCHANNEL_SECRET=" > .env
    ```

<br>

## 編輯腳本

_基礎範例，使用以下代碼覆蓋原本內容即可_

<br>

1. `application.py`。

    ```python
    import os
    import traceback
    from flask import (
        Flask,
        request,
        abort
    )
    from linebot.v3 import WebhookHandler
    from linebot.v3.messaging import (
        Configuration,
        ApiClient,
        MessagingApi,
        ReplyMessageRequest,
        TextMessage,
    )
    from linebot.v3.webhooks import (
        MessageEvent,
        TextMessageContent
    )


    # 判斷是否在 Beanstalk 環境
    is_beanstalk = os.getenv("AWS_EXECUTION_ENV") is not None

    # 如果不是 Beanstalk 環境，導入 dotenv 並加載 .env 文件
    if not is_beanstalk:
        from dotenv import load_dotenv
        load_dotenv()


    # 獲取環境變數
    CHANNEL_ACCESS_TOKEN = os.getenv("CHANNEL_ACCESS_TOKEN")
    CHANNEL_SECRET = os.getenv("CHANNEL_SECRET")

    if not CHANNEL_ACCESS_TOKEN or not CHANNEL_SECRET:
        raise ValueError(
            "請確認環境變數 CHANNEL_ACCESS_TOKEN "
            "和 CHANNEL_SECRET 是否正確設置。"
        )

    # 初始化 Flask 應用
    application = Flask(__name__)
    configuration = Configuration(access_token=CHANNEL_ACCESS_TOKEN)
    handler = WebhookHandler(CHANNEL_SECRET)


    @application.route("/callback", methods=["POST"])
    def callback():
        signature = request.headers.get("X-Line-Signature")
        body = request.get_data(as_text=True)

        application.logger.info(f"Request Body: {body}")
        application.logger.info(f"X-Line-Signature: {signature}")

        try:
            handler.handle(body, signature)
        except Exception as e:
            print(f"發生錯誤：{e}")
            application.logger.error(
                f"Handler Error：{traceback.format_exc()}")
            abort(400)

        return "OK", 200


    @handler.add(MessageEvent, message=TextMessageContent)
    def handle_message(event):
        application.logger.info(f"Received Event：{event}")
        with ApiClient(configuration) as api_client:
            messaging_api = MessagingApi(api_client)
            reply_token = event.reply_token
            user_message = event.message.text
            response_message = TextMessage(text=f"你說了：{user_message}")
            messaging_api.reply_message_with_http_info(
                ReplyMessageRequest(
                    reply_token=reply_token,
                    messages=[response_message],
                )
            )


    if __name__ == "__main__":
        # 判斷端口，Beanstalk 環境使用環境變數 `PORT`，本地環境使用 5050
        port = int(os.getenv("PORT", 5050)) if is_beanstalk else 5050
        application.run(debug=not is_beanstalk, port=port)

    ```

<br>

2. 修正 `requirements.txt` 內容如下。

    ```json
    Flask
    gunicorn
    line-bot-sdk==3.0.0
    ```

<br>

3. 修改 `.env`，添加兩個 Linebot 密鑰。

    ```json
    CHANNEL_ACCESS_TOKEN=
    CHANNEL_SECRET=
    ```

<br>

4. 在 Line Developer 中複製這兩個變數。

    ![](images/img_63.png)

<br>

## 本地測試

1. 首先啟動代碼。

    ```bash
    python application.py
    ```

<br>

2. 在 `ngrok` 所在路徑運行以下指令啟動服務。

    ```bash
    ngrok http 5050
    ```

    ![](images/img_64.png)

<br>

3. 複製 `Forwarding` 網址。

    ![](images/img_52.png)

<br>

4. 寫入 `Webhook URL`。

    ![](images/img_53.png)

<br>

5. 運行腳本。

    ```bash
    python application.py
    ```

<br>

6. 進行  `Webhook` 驗證。

    ![](images/img_54.png)

<br>

7. 與 Linebot 對話測試。

    ![](images/img_65.png)

<br>

___

_接下到下一個小節_