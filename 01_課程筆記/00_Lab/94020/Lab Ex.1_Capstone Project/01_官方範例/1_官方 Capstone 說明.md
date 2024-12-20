版本：02.14.2023

# Capstone

本實驗中工具和技術整合到專案中，使用各種 AWS 管理服務如 `Amazon Comprehend` 或 `Amazon SageMaker`。

<br>

## 業務場景

1. 這個 Lab 包含超過 40 段涵蓋各種 ML 主題的視頻，任務是建立一個應用程式，讓學生可以搜尋主題和關鍵詞組，以便快速定位並查看視頻內容。

<br>

2. 已將所有視頻下載到 S3 Bucket，接著的工作是製作一個符合主管需求的控制面板。

<br>

## 步驟

1. 查看視頻文件

<br>

2. 轉錄視頻

<br>

3. 標準化文本

<br>

4. 提取關鍵詞組和主題

<br>

5. 建立控制面板

<br>

## 有用的資訊

1. 以下代碼包含完成此專案過程中用到的部分資訊。

    ```python
    bucket = "c133864a3391508l8212786t1w682683043554-labbucket-vo1xvuhgjkbb"
    job_data_access_role = 'arn:aws:iam::682683043554:role/service-role/c133864a3391508l8212786t1w-ComprehendDataAccessRole-jekgweMnZZER'
    ```

<br>

## 查看視頻文件

1. 源視頻文件位於以下共享的 Amazon Simple Storage Service (Amazon S3) 儲存桶中。

    ```python
    !aws s3 ls s3://aws-tc-largeobjects/CUR-TF-200-ACMNLP-1/video/
    ```

    _輸出_

    ```bash
    2021-04-26 20:17:33  410925369 Mod01_Course Overview.mp4
    2021-04-26 20:10:02   39576695 Mod02_Intro.mp4
    2021-04-26 20:31:23  302994828 Mod02_Sect01.mp4
    2021-04-26 20:17:33  416563881 Mod02_Sect02.mp4
    2021-04-26 20:17:33  318685583 Mod02_Sect03.mp4
    2021-04-26 20:17:33  255877251 Mod02_Sect04.mp4
    2021-04-26 20:23:51   99988046 Mod02_Sect05.mp4
    2021-04-26 20:24:54   50700224 Mod02_WrapUp.mp4
    2021-04-26 20:26:27   60627667 Mod03_Intro.mp4
    2021-04-26 20:26:28  272229844 Mod03_Sect01.mp4
    2021-04-26 20:27:06  309127124 Mod03_Sect02_part1.mp4
    2021-04-26 20:27:06  195635527 Mod03_Sect02_part2.mp4
    2021-04-26 20:28:03  123924818 Mod03_Sect02_part3.mp4
    2021-04-26 20:31:28  171681915 Mod03_Sect03_part1.mp4
    2021-04-26 20:32:07  285200083 Mod03_Sect03_part2.mp4
    2021-04-26 20:33:17  105470345 Mod03_Sect03_part3.mp4
    2021-04-26 20:35:10  157185651 Mod03_Sect04_part1.mp4
    2021-04-26 20:36:27  187435635 Mod03_Sect04_part2.mp4
    2021-04-26 20:36:40  280720369 Mod03_Sect04_part3.mp4
    2021-04-26 20:40:01  443479313 Mod03_Sect05.mp4
    2021-04-26 20:40:08  234182186 Mod03_Sect06.mp4
    2021-04-26 20:40:33  207718047 Mod03_Sect07_part1.mp4
    2021-04-26 20:42:07  125592110 Mod03_Sect07_part2.mp4
    2021-04-26 20:45:10  508500301 Mod03_Sect07_part3.mp4
    2021-04-26 20:46:16  320126756 Mod03_Sect08.mp4
    2021-04-26 20:46:43   41839508 Mod03_WrapUp.mp4
    2021-04-26 20:46:55   34148489 Mod04_Intro.mp4
    2021-04-26 20:48:24   84959465 Mod04_Sect01.mp4
    2021-04-26 20:48:25  345182970 Mod04_Sect02_part1.mp4
    2021-04-26 20:51:34  218661651 Mod04_Sect02_part2.mp4
    2021-04-26 20:53:32  430140637 Mod04_Sect02_part3.mp4
    2021-04-26 20:56:03   22036605 Mod04_WrapUp.mp4
    2021-04-26 20:57:18   49187118 Mod05_Intro.mp4
    2021-04-26 20:58:19  245798071 Mod05_Sect01_ver2.mp4
    2021-04-26 20:58:50  233314835 Mod05_Sect02_part1_ver2.mp4
    2021-04-26 20:59:14  348545306 Mod05_Sect02_part2.mp4
    2021-04-26 20:59:17  239142711 Mod05_Sect03_part1.mp4
    2021-04-26 21:06:04  267533559 Mod05_Sect03_part2.mp4
    2021-04-26 21:06:06  212502220 Mod05_Sect03_part3.mp4
    2021-04-26 21:06:48  206317022 Mod05_Sect03_part4_ver2.mp4
    2021-04-26 21:06:48   60361230 Mod05_WrapUp_ver2.mp4
    2021-04-26 21:09:14   35397860 Mod06_Intro.mp4
    2021-04-26 21:09:24  845633599 Mod06_Sect01.mp4
    2021-04-26 21:10:47  326126684 Mod06_Sect02.mp4
    2021-04-26 21:12:26   19790740 Mod06_WrapUp.mp4
    2021-04-26 21:12:56  131249036 Mod07_Sect01.mp4
    ```

<br>

## 轉錄視頻

_使用此部分實施您的解決方案，將視頻進行轉錄。_

<br>

## 標準化文本

_使用此部分執行您的解決方案所需的任何標準化步驟。_

<br>

## 提取關鍵詞組和主題

_使用此部分從視頻中提取關鍵詞組和主題。_

<br>

## 建立控制面板

_使用此部分為您的解決方案建立控制面板。_

<br>

___

_END_