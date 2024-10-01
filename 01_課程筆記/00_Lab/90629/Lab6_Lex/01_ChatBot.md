# Lab 6

_Amazon Lex Guided Lab: Natural Language Processing；以下是本實驗的官方說明步驟，可完成 Amazon Lex 聊天機器人搭建，與使用者進行互動以預約牙科診療；相關說明可參考官方文件 [Getting Started with Amazon Lex](https://docs.aws.amazon.com/lex/latest/dg/getting-started.html)。_

<br>

## 專案涵蓋服務項目

1. 使用 `Amazon Lex` 的 `ScheduleAppointment` 範本建立並測試一個聊天機器人。

<br>

2. 建立並測試 `AWS Lambda` 函數與 `Lex` 整合，處理初始化、驗證和執行請求。

<br>

3. 配置 `MakeAppointment` 意圖，使用 `Lambda` 函數作為程式鉤子。

<br>

4. 在 `Amazon S3` 上建立並托管靜態網頁來運行聊天機器人，與聊天機器人進行互動。

<br>

## 建立 Amazon Lex 聊天機器人

1. 登入 AWS Management Console，選擇 `Amazon Lex` 服務。

    ![](images/img_12.png)

<br>

2. 進入 `Amazon Lex` 主控台後，先點擊左側欄位最下方的 `Return to the V1 console`。

    ![](images/img_01.png)

<br>

3. 點擊 `Create`。

    ![](images/img_02.png)

<br>

4. 選擇 `ScheduleAppointment`，這是一個範本。

    ![](images/img_03.png)

<br>

5. Bot name 使用預設的 `ScheduleAppointment` 即可。

    ![](images/img_13.png)

<br>

6. 選擇語言為 `English (US)`，然後在 `COPPA` 部分選擇 `No` 即可；`COPPA` 是指 `兒童網絡隱私保護法（Children's Online Privacy Protection Act）`，這是一部美國法律，旨在保護13歲以下兒童在互聯網上的隱私和安全，這裡選擇 `NO` 表示應用不是針對 13 歲以下的兒童所設計的。

    ![](images/img_14.png)

<br>

7. 點擊 `Create`。

    ![](images/img_04.png)

<br>

8. 應用程式會開始 Buile。

    ![](images/img_15.png)

<br>

9. 彈窗出現代表完成。

    ![](images/img_16.png)

<br>

## 測試聊天機器人

1. 若回到清單，當聊天機器人狀態顯示 `Ready` 表示可進一步進行測試，點擊便可進入。

    ![](images/img_05.png)

<br>

2. 展開右側 `Test Chatbot` 功能欄位，在對話框中依序輸入以下測試訊息，用以確認測試結果是否顯示預約成功訊息。

    ```bash
    "I would like to make an appointment"
    "A root canal"
    "10/1/2024"
    "3:00 PM"
    "Yes"
    ```

    ![](images/img_06.png)

<br>

3. 點擊 `Detail` 可查看詳細的訊息內容。

    ![](images/img_17.png)

<br>

## 建立 AWS Lambda 函數

1. 在主控台中搜尋並進入 `Lambda`。

    ![](images/img_18.png)

<br>

2. 點擊 `Create a function`，選擇 `Use a blueprint`；這些是預先設計好的 `模板（blueprint）`，包含常見的功能代碼和配置，可快速開始構建 Lambda 函數，並與其他 AWS 服務集成，無需從頭開始編寫代碼。

    ![](images/img_19.png)

<br>

3. 展開 `Blueprint name` 選單並搜尋 `Lex`，選擇 `Make an appointment with Lex` 範本。

    ![](images/img_07.png)

<br>

4. 函數名稱輸入 `MakeAppointmentCodeHook`；選擇 `Create a new role from AWS policy templates`，並命名角色為 `myLexrole`。

    ![](images/img_20.png)

<br>

5. 點擊 `Create function`。

    ![](images/img_21.png)

<br>

6. 完成一個簡單的 Lambda 架構。

    ![](images/img_62.png)

<br>

## 測試 Lambda 函數

1. 點擊 `Test`。

    ![](images/img_22.png)

<br>

2. 輸入事件名稱 `MyMakeAppointmentEvent`，然後點擊右下角的 `Save`。

    ![](images/img_23.png)

<br>

3. 再次點擊 `Test`，檢視頁籤 `Execution result` 中的內容；若有錯誤會顯示 `Error` 等資訊。

    ![](images/img_08.png)

<br>

## 更新聊天機器人意圖

_`意圖` 是機器人用來理解和處理用戶需求的主要邏輯單位，表示用戶想要達到的目標或請求；`更新意圖` 所指就是 `修改槽位（Slots）`、更改回應、調整對話流、新增或更改 Fulfillment 等操作；更新意圖的目的是讓機器人能更好地理解和回應用戶的需求，或者適應應用程序的新要求或功能變更。_

<br>

1. 返回 `Lex` 服務，選擇前面步驟建立的機器人；若是從 `Lex` 主控台返回，記要要先點擊左側的 `Return to the V1 console` 才會看到對應的機器人。

<br>

2. 進入機器人後，先點擊畫面上方的 `Edit`。

    ![](images/img_09.png)

<br>

3. 展開 `Lambda initialization and validation` 部分，勾選 `Initialization and validation code hook`，並選擇 `MakeAppointmentCodeHook` 函數，另外一定要選擇版本。

    ![](images/img_10.png)

<br>

4. 在 `Fulfillment` 部分，選擇 `Lambda` 函數 `MakeAppointmentCodeHook`，並保存意圖；`Fulfillment` 是指當 `Lex 聊天機器人` 成功收集到所需的資訊並完成用戶的請求時，最終執行的動作，也就是機器人回應過程的最後一步，用來處理用戶的請求。

    ![](images/img_11.png)

<br>

## 構建並測試機器人

1. 不同於之前自動進行的 `Build`，這裡要手動點擊 `Build` 構建機器人，完成時會出現彈窗通知。

    ![](images/img_24.png)

<br>

2. 確認以上步驟已經完成，在右側對話中輸入 `Make an appointment`，然後選擇 `root canal`。

    ![](images/img_25.png)

<br>

3. 選擇預約的時間後，點擊 `yes` 確認預約。

<br>

    ![](images/img_26.png)

<br>

4. 構建成功後，點擊 `Publish`；點擊後退出現彈窗。

    ![](images/img_27.png)

<br>

5. 設置機器人版本的 `別名` 例如 `MyBot`，這個名稱在後面步驟編輯腳本內容時還會用到，可稍做紀錄；`別名` 用於對特定版本機器人建立易於識別的名稱，這將有利於管理和部署機器人；再次點擊 `Publish`，完成時點擊 `Close` 關閉彈窗即可。

    ![](images/img_28.png)

<br>

## 設置 Amazon Cognito 身份池

_管理應用程序的用戶身份驗證、授權和用戶數據同步，可用於快速構建和管理應用的身份管理功能，確保應用可以安全地管理和訪問資源。_

<br>

1. 在主控台中，搜尋並進入 `Cognito`。

    ![](images/img_29.png)

<br>

2. 在左側選擇 `Identity pools`，並選擇 `Create identity pool`。

    ![](images/img_30.png)

<br>

3. 選擇 `Guest access` 並點擊 `Next`。

    ![](images/img_31.png)

<br>

4. 在 `IAM role name` 中命名為 `myidentitypoolrole`，接著點擊 `Next`。

    ![](images/img_32.png)

<br>

5. `Identity pool name` 命名為 `myidentitypool`，點擊右下角 `Next`。

    ![](images/img_33.png)

<br>

6. 接下來接使用預設值，然後滑動到最下方點擊 `Create identity pool`。

    ![](images/img_34.png)

<br>

7. 記下 `IdentityPoolID` 備用。

    ![](images/img_35.png)

<br>

## 修改 IAM 角色權限

1. 在主控台中，搜尋並進入 `IAM`。

    ![](images/img_37.png)

<br>

2. 進入 `Roles`，搜尋 `myidentitypoolrole` 並點擊進入。

    ![](images/img_38.png)

<br>

3. 預設僅有一個 Policy。

    ![](images/img_63.png)

<br>

4. 展開 `Add permissions` 並點擊 `Attach policies`。

    ![](images/img_39.png)

<br>

5. 依序附加 `AmazonLexReadOnly` 和 `AmazonLexRunBotsOnly` 政策。

    ![](images/img_40.png)

<br>

6. 完成時可以看到清單中多了兩個 Policies。

    ![](images/img_41.png)

<br>

## 關於權限錯誤訊息

1. 此時下方會出現紅色警告，表明當前用戶缺少執行 `access-analyzer:ListPolicyGenerations` 操作的權限。

    ![](images/img_64.png)

<br>

2. 特別強調，這個錯誤並不會阻止手動添加策略，只有在需要 `Access Analyzer` 來生成或檢查策略的安全性時將無法執行這些操作；在此可予以忽略，並不影響後續操作。

<br>

## 建立 S3 存儲桶

1. 在主控台中，搜尋並進入 `S3`。

    ![](images/img_42.png)

<br>

2. 下載教程中的壓縮檔，解壓縮後，在資料夾中有兩個文件 `index.html` 及 `error.html`。

    ![](images/img_43.png)

<br>

3. 在 S3 主頁中點擊右側 `Create bucket`。

    ![](images/img_44.png)

<br>

4. 依據教程，任意命名以前綴加六個隨機數字，這裡是 `lexlab6-241002`；然後就可以點擊最下方的 `Create bucket`。

    ![](images/img_45.png)

<br>

## 上傳文件

1. 點擊進入建立好的 S3，然後點擊 `Upload`。

    ![](images/img_46.png)

<br>

2. 點擊 `Add files`，選取兩個範例網頁檔案 `index.html` 和 `error.html`；記得點擊右下角的 `Upload`。

    ![](images/img_47.png)

<br>

3. 完成後點擊 `Close`。

    ![](images/img_48.png)

<br>

4. 切換到 `Properties` 頁籤。

    ![](images/img_49.png)

<br>

5. 滑動到 `Static website hosting`，點擊 `Edit`。

    ![](images/img_50.png)

<br>

6. 首先啟用靜態網站托管。

    ![](images/img_51.png)

<br>

7. 在 `Index document` 及 `Error document` 部分分別輸入 `index.html` 和 `error.html`；然後點擊右下角的 `Save changes`。

    ![](images/img_52.png)

<br>

## 更新並測試網頁

_在本地進行文件編輯然後重新上傳_

<br>

1. 編輯範例網頁檔案，找到 `144` 行，將前面步驟複製備用的 `ARN` 貼上替換。

    ![](images/img_53.png)

<br>

2. 在 `185、186` 行，分別替換為自己的機器人別名與名稱；這可在 Lex 清單中查詢；完成後儲存文件並重新上傳。

    ![](images/img_54.png)

<br>

3. 切換到 `Permissions` 頁籤。

    ![](images/img_55.png)

<br>

4. 在 `Block public access (bucket settings)` 區塊點擊 `Edit`。

    ![](images/img_56.png)

<br>

5. 取消勾選 `Block`，然後點擊 `Save changes`。

    ![](images/img_57.png)

<br>

6. 編輯 `Bucket policy`，貼上以下代碼，其中 `example.com` 要更換為自己的 S3 的名稱，例如前面所命名的 `lexlab6-241002`；然後點擊 `Save changes`。

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                    "s3:GetObject"
                ],
                "Resource": [
                    "arn:aws:s3:::lexlab6-241002/*"
                ]
            }
        ]
    }
    ```

<br>

7. 完成時顯示如下。

    ![](images/img_58.png)

<br>

8. 再次切換到 `Properties` 頁籤，滑動到下方的 `Static website hosting`，複製並訪問這個網頁。

    ![](images/img_59.png)

<br>

9. 顯示如下，可嘗試進行對話。

    ![](images/img_60.png)

<br>

10. 與之前對話相同，依此會完成預約程序。

    ![](images/img_61.png)

<br>

## 機器人腳本

1. 以下代碼是這個範例所使用的代碼，展示 `Lex Code Hook` 介面的實作，用於提供管理牙醫預約的機器人。兼容此範例的機器人、意圖和槽位模型可以在 Lex 控制台中找到。

```python

import json
import dateutil.parser
import datetime
import time
import os
import math
import random
import logging

# 設置日誌紀錄器
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


"""幫助構建匹配必要對話操作結構的回應"""

# 引導用戶填寫指定的槽位
def elicit_slot(session_attributes, intent_name, slots, slot_to_elicit, message, response_card):
    return {
        'sessionAttributes': session_attributes,
        'dialogAction': {
            # 對話操作類型：引導槽位
            'type': 'ElicitSlot',
            'intentName': intent_name,
            'slots': slots,
            'slotToElicit': slot_to_elicit,
            'message': message,
            'responseCard': response_card
        }
    }


# 確認用戶的意圖
def confirm_intent(session_attributes, intent_name, slots, message, response_card):
    return {
        'sessionAttributes': session_attributes,
        'dialogAction': {
            # 對話操作類型：確認意圖
            'type': 'ConfirmIntent',
            'intentName': intent_name,
            'slots': slots,
            'message': message,
            'responseCard': response_card
        }
    }


# 完成對話並關閉會話
def close(session_attributes, fulfillment_state, message):
    response = {
        'sessionAttributes': session_attributes,
        'dialogAction': {
            # 對話操作類型：關閉
            'type': 'Close',
            # 完成狀態
            'fulfillmentState': fulfillment_state,
            'message': message
        }
    }

    return response


# 讓機器人根據用戶輸入繼續對話
def delegate(session_attributes, slots):
    return {
        'sessionAttributes': session_attributes,
        'dialogAction': {
            # 對話操作類型：委派
            'type': 'Delegate',
            'slots': slots
        }
    }


# 構建回應卡片
def build_response_card(title, subtitle, options):
    """
    構建一個 responseCard，包含標題、副標題以及一組選項，這些選項會作為按鈕顯示。
    """
    buttons = None
    if options is not None:
        buttons = []
        # 限制按鈕數量為 5
        for i in range(min(5, len(options))):
            buttons.append(options[i])

    return {
        'contentType': 'application/vnd.amazonaws.card.generic',
        'version': 1,
        'genericAttachments': [{
            'title': title,
            'subTitle': subtitle,
            'buttons': buttons
        }]
    }


"""輔助函數"""


# 將字符串轉換為整數
def parse_int(n):
    try:
        return int(n)
    except ValueError:
        # 轉換失敗返回 NaN
        return float('nan')


# 安全調用字典中的值，避免 KeyError
def try_ex(func):
    """
    在 try 區塊中調用傳入的函數。如果遇到 KeyError，則返回 None。
    這個函數用於安全地訪問字典。
    """

    try:
        return func()
    except KeyError:
        return None


# 將時間加 30 分鐘
def increment_time_by_thirty_mins(appointment_time):
    hour, minute = list(map(int, appointment_time.split(':')))
    return '{}:00'.format(hour + 1) if minute == 30 else '{}:30'.format(hour)


# 返回一個隨機的整數
def get_random_int(minimum, maximum):
    """
    返回一個介於最小值（包含）和最大值（不包含）之間的隨機整數
    """
    min_int = math.ceil(minimum)
    max_int = math.floor(maximum)

    return random.randint(min_int, max_int - 1)


# 獲取當日的可用時間段
def get_availabilities(date):
    """
    幫助函數，用於在完整實作中連接到後端 API 提供排程可用性查詢。
    此函數的輸出是一組 30 分鐘的可用時段，以 ISO-8601 時間格式表示。

    為了快速展示所有可能的對話路徑，此函數返回固定和隨機結果的組合。
    """
    day_of_week = dateutil.parser.parse(date).weekday()
    availabilities = []
    # 隨機可用時間的機率
    available_probability = 0.3
    # 星期一
    if day_of_week == 0:
        start_hour = 10
        # 從 10 點到 16 點生成隨機可用性
        while start_hour <= 16:
            if random.random() < available_probability:
                appointment_type = get_random_int(1, 4)
                if appointment_type == 1:
                    availabilities.append('{}:00'.format(start_hour))
                elif appointment_type == 2:
                    availabilities.append('{}:30'.format(start_hour))
                else:
                    availabilities.append('{}:00'.format(start_hour))
                    availabilities.append('{}:30'.format(start_hour))
            start_hour += 1

    # 星期三或星期五
    if day_of_week == 2 or day_of_week == 4:
        availabilities.append('10:00')
        availabilities.append('16:00')
        availabilities.append('16:30')

    return availabilities


# 驗證日期是否有效
def isvalid_date(date):
    try:
        dateutil.parser.parse(date)
        return True
    except ValueError:
        return False


# 檢查指定時間是否可用
def is_available(appointment_time, duration, availabilities):
    """
    幫助函數，用於檢查指定的時間和時長是否在已知的可用時段內。
    時長默認為 30 或 60 分鐘。
    """
    if duration == 30:
        return appointment_time in availabilities
    elif duration == 60:
        second_half_hour_time = increment_time_by_thirty_mins(appointment_time)
        return appointment_time in availabilities and second_half_hour_time in availabilities

    # 無效的時長；拋出錯誤，因為應該在早前的驗證中被捕獲。
    raise Exception('Was not able to understand duration {}'.format(duration))


# 根據預約類型獲取時長
def get_duration(appointment_type):
    appointment_duration_map = {'cleaning': 30, 'root canal': 60, 'whitening': 30}
    return try_ex(lambda: appointment_duration_map[appointment_type.lower()])


# 根據時長篩選可用時間段
def get_availabilities_for_duration(duration, availabilities):
    """
    幫助函數，用於根據提供的 30 分鐘時間段，返回符合指定時長的可用時間段。
    """
    duration_availabilities = []
    start_time = '10:00'
    while start_time != '17:00':
        if start_time in availabilities:
            if duration == 30:
                duration_availabilities.append(start_time)
            elif increment_time_by_thirty_mins(start_time) in availabilities:
                duration_availabilities.append(start_time)

        start_time = increment_time_by_thirty_mins(start_time)

    return duration_availabilities


# 構建驗證結果
def build_validation_result(is_valid, violated_slot, message_content):
    return {
        # 是否通過驗證
        'isValid': is_valid,
        # 被違反的槽位
        'violatedSlot': violated_slot,
        'message': {'contentType': 'PlainText', 'content': message_content}
    }


# 驗證預約的有效性
def validate_book_appointment(appointment_type, date, appointment_time):
    if appointment_type and not get_duration(appointment_type):
        return build_validation_result(False, 'AppointmentType', 'I did not recognize that, can I book you a root canal, cleaning, or whitening?')

    if appointment_time:
        if len(appointment_time) != 5:
            return build_validation_result(False, 'Time', 'I did not recognize that, what time would you like to book your appointment?')

        hour, minute = appointment_time.split(':')
        hour = parse_int(hour)
        minute = parse_int(minute)
        if math.isnan(hour) or math.isnan(minute):
            return build_validation_result(False, 'Time', 'I did not recognize that, what time would you like to book your appointment?')

        if hour < 10 or hour > 16:
            # Outside of business hours
            return build_validation_result(False, 'Time', 'Our business hours are ten a.m. to five p.m.  What time works best for you?')

        if minute not in [30, 0]:
            # Must be booked on the hour or half hour
            return build_validation_result(False, 'Time', 'We schedule appointments every half hour, what time works best for you?')

    if date:
        if not isvalid_date(date):
            return build_validation_result(False, 'Date', 'I did not understand that, what date works best for you?')
        elif datetime.datetime.strptime(date, '%Y-%m-%d').date() <= datetime.date.today():
            return build_validation_result(False, 'Date', 'Appointments must be scheduled a day in advance.  Can you try a different date?')
        elif dateutil.parser.parse(date).weekday() == 5 or dateutil.parser.parse(date).weekday() == 6:
            return build_validation_result(False, 'Date', 'Our office is not open on the weekends, can you provide a work day?')

    return build_validation_result(True, None, None)


# 構建時間輸出字符串
def build_time_output_string(appointment_time):
    hour, minute = appointment_time.split(':')  # no conversion to int in order to have original string form. for eg) 10:00 instead of 10:0
    if int(hour) > 12:
        return '{}:{} p.m.'.format((int(hour) - 12), minute)
    elif int(hour) == 12:
        return '12:{} p.m.'.format(minute)
    elif int(hour) == 0:
        return '12:{} a.m.'.format(minute)

    return '{}:{} a.m.'.format(hour, minute)


# 構建可用時間字符串
def build_available_time_string(availabilities):
    """
    構建一個字符串，列出至少兩個可用時段的時間選項。
    """
    prefix = 'We have availabilities at '
    if len(availabilities) > 3:
        prefix = 'We have plenty of availability, including '

    prefix += build_time_output_string(availabilities[0])
    if len(availabilities) == 2:
        return '{} and {}'.format(prefix, build_time_output_string(availabilities[1]))

    return '{}, {} and {}'.format(prefix, build_time_output_string(availabilities[1]), build_time_output_string(availabilities[2]))


# 根據槽位構建選項
def build_options(slot, appointment_type, date, booking_map):
    """
    根據給定的槽位構建潛在選項列表，用於 responseCard 的生成。
    """
    day_strings = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    if slot == 'AppointmentType':
        return [
            {'text': 'cleaning (30 min)', 'value': 'cleaning'},
            {'text': 'root canal (60 min)', 'value': 'root canal'},
            {'text': 'whitening (30 min)', 'value': 'whitening'}
        ]
    elif slot == 'Date':
        # 返回接下來的五個工作日
        options = []
        potential_date = datetime.date.today()
        while len(options) < 5:
            potential_date = potential_date + datetime.timedelta(days=1)
            if potential_date.weekday() < 5:
                options.append({'text': '{}-{} ({})'.format((potential_date.month), potential_date.day, day_strings[potential_date.weekday()]),
                                'value': potential_date.strftime('%A, %B %d, %Y')})
        return options
    elif slot == 'Time':
        # 返回給定日期的可用時段
        if not appointment_type or not date:
            return None

        availabilities = try_ex(lambda: booking_map[date])
        if not availabilities:
            return None

        availabilities = get_availabilities_for_duration(get_duration(appointment_type), availabilities)
        if len(availabilities) == 0:
            return None

        options = []
        for i in range(min(len(availabilities), 5)):
            options.append({'text': build_time_output_string(availabilities[i]), 'value': build_time_output_string(availabilities[i])})

        return options


"""控制機器人行為的函數"""


# 預約牙醫的主要函數
def make_appointment(intent_request):
    """
    執行對話管理和預訂牙醫預約的履行。

    除了履行之外，此意圖的實作展示了：
    1) 使用 elicitSlot 進行槽位驗證並重新提示
    2) 使用 confirmIntent 支援對推斷槽位值的確認，當在機器人模型上需要確認時，
    並且推斷的槽位值完全指定意圖。
    """
    appointment_type = intent_request['currentIntent']['slots']['AppointmentType']
    date = intent_request['currentIntent']['slots']['Date']
    appointment_time = intent_request['currentIntent']['slots']['Time']
    source = intent_request['invocationSource']
    output_session_attributes = intent_request['sessionAttributes'] if intent_request['sessionAttributes'] is not None else {}
    booking_map = json.loads(try_ex(lambda: output_session_attributes['bookingMap']) or '{}')

    if source == 'DialogCodeHook':
        # 執行對提供的槽位進行基本驗證。
        slots = intent_request['currentIntent']['slots']
        validation_result = validate_book_appointment(appointment_type, date, appointment_time)
        if not validation_result['isValid']:
            slots[validation_result['violatedSlot']] = None
            return elicit_slot(
                output_session_attributes,
                intent_request['currentIntent']['name'],
                slots,
                validation_result['violatedSlot'],
                validation_result['message'],
                build_response_card(
                    'Specify {}'.format(validation_result['violatedSlot']),
                    validation_result['message']['content'],
                    build_options(validation_result['violatedSlot'], appointment_type, date, booking_map)
                )
            )

        if not appointment_type:
            return elicit_slot(
                output_session_attributes,
                intent_request['currentIntent']['name'],
                intent_request['currentIntent']['slots'],
                'AppointmentType',
                {'contentType': 'PlainText', 'content': 'What type of appointment would you like to schedule?'},
                build_response_card(
                    'Specify Appointment Type', 'What type of appointment would you like to schedule?',
                    build_options('AppointmentType', appointment_type, date, None)
                )
            )

        if appointment_type and not date:
            return elicit_slot(
                output_session_attributes,
                intent_request['currentIntent']['name'],
                intent_request['currentIntent']['slots'],
                'Date',
                {'contentType': 'PlainText', 'content': 'When would you like to schedule your {}?'.format(appointment_type)},
                build_response_card(
                    'Specify Date',
                    'When would you like to schedule your {}?'.format(appointment_type),
                    build_options('Date', appointment_type, date, None)
                )
            )

        if appointment_type and date:
            # 查詢或生成該日期的可用時段。
            booking_availabilities = try_ex(lambda: booking_map[date])
            if booking_availabilities is None:
                booking_availabilities = get_availabilities(date)
                booking_map[date] = booking_availabilities
                output_session_attributes['bookingMap'] = json.dumps(booking_map)

            appointment_type_availabilities = get_availabilities_for_duration(get_duration(appointment_type), booking_availabilities)
            if len(appointment_type_availabilities) == 0:
                # 該日期無可用時間；詢問新的日期和時間。
                slots['Date'] = None
                slots['Time'] = None
                return elicit_slot(
                    output_session_attributes,
                    intent_request['currentIntent']['name'],
                    slots,
                    'Date',
                    {'contentType': 'PlainText', 'content': 'We do not have any availability on that date, is there another day which works for you?'},
                    build_response_card(
                        'Specify Date',
                        'What day works best for you?',
                        build_options('Date', appointment_type, date, booking_map)
                    )
                )

            message_content = 'What time on {} works for you? '.format(date)
            if appointment_time:
                output_session_attributes['formattedTime'] = build_time_output_string(appointment_time)
                # 驗證預約的時間是否可用。
                if is_available(appointment_time, get_duration(appointment_type), booking_availabilities):
                    return delegate(output_session_attributes, slots)
                message_content = 'The time you requested is not available. '

            if len(appointment_type_availabilities) == 1:
                # 如果該日期只有一個可用時段，嘗試確認它。
                slots['Time'] = appointment_type_availabilities[0]
                return confirm_intent(
                    output_session_attributes,
                    intent_request['currentIntent']['name'],
                    slots,
                    {
                        'contentType': 'PlainText',
                        'content': '{}{} is our only availability, does that work for you?'.format
                                   (message_content, build_time_output_string(appointment_type_availabilities[0]))
                    },
                    build_response_card(
                        'Confirm Appointment',
                        'Is {} on {} okay?'.format(build_time_output_string(appointment_type_availabilities[0]), date),
                        [{'text': 'yes', 'value': 'yes'}, {'text': 'no', 'value': 'no'}]
                    )
                )

            available_time_string = build_available_time_string(appointment_type_availabilities)
            return elicit_slot(
                output_session_attributes,
                intent_request['currentIntent']['name'],
                slots,
                'Time',
                {'contentType': 'PlainText', 'content': '{}{}'.format(message_content, available_time_string)},
                build_response_card(
                    'Specify Time',
                    'What time works best for you?',
                    build_options('Time', appointment_type, date, booking_map)
                )
            )

        return delegate(output_session_attributes, slots)

    # 預訂預約。在實際機器人中，這可能涉及調用後端服務。
    duration = get_duration(appointment_type)
    booking_availabilities = booking_map[date]
    if booking_availabilities:
        # 移除該日期的可用時間段，因為它已被預訂。
        booking_availabilities.remove(appointment_time)
        if duration == 60:
            second_half_hour_time = increment_time_by_thirty_mins(appointment_time)
            booking_availabilities.remove(second_half_hour_time)

        booking_map[date] = booking_availabilities
        output_session_attributes['bookingMap'] = json.dumps(booking_map)
    else:
        # 這不會被視為錯誤，因為此代碼範例支援作為履行或對話代碼掛鉤功能。
        logger.debug('Availabilities for {} were null at fulfillment time.  '
                     'This should have been initialized if this function was configured as the dialog code hook'.format(date))

    return close(
        output_session_attributes,
        'Fulfilled',
        {
            'contentType': 'PlainText',
            'content': 'Okay, I have booked your appointment.  We will see you at {} on {}'.format(build_time_output_string(appointment_time), date)
        }
    )


"""意圖"""


def dispatch(intent_request):
    """
    當用戶為此機器人指定意圖時調用此函數。
    """

    logger.debug('dispatch userId={}, intentName={}'.format(intent_request['userId'], intent_request['currentIntent']['name']))

    intent_name = intent_request['currentIntent']['name']

    # 分派至機器人的意圖處理器
    if intent_name == 'MakeAppointment':
        return make_appointment(intent_request)
    raise Exception('Intent with name ' + intent_name + ' not supported')


"""主函數"""


def lambda_handler(event, context):
    """
    根據意圖路由傳入的請求。
    請求的 JSON 主體提供在 event 槽位中。
    """
    # 預設情況下，將用戶請求視為來自美國東部時區。
    os.environ['TZ'] = 'America/New_York'
    time.tzset()
    logger.debug('event.bot.name={}'.format(event['bot']['name']))

    return dispatch(event)
```

___

_END_


