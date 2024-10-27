# 機器人 Lambda 腳本

<br>

## 完整內容

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


    # 取得當日的可用時間段
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
        時長預設為 30 或 60 分鐘。
        """
        if duration == 30:
            return appointment_time in availabilities
        elif duration == 60:
            second_half_hour_time = increment_time_by_thirty_mins(appointment_time)
            return appointment_time in availabilities and second_half_hour_time in availabilities

        # 無效的時長；拋出錯誤，因為應該在早前的驗證中被捕獲。
        raise Exception('Was not able to understand duration {}'.format(duration))


    # 根據預約類型取得時長
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

<br>

___

_END_