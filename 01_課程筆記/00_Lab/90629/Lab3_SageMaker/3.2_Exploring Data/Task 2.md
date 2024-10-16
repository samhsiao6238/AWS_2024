# Task 2：在筆記本實例中開啟筆記本

_從 Lab 角度來說，以上步驟就完成了，以下只是觀察一下代碼操作_

##

1. 進入後會有一個腳本 `3_2-machinelearning.jpynb`。

    ![](images/img_05.png)

<br>

2. 雙擊可開啟文件，預設會使用核心 `conda_python3`，若要切換可點擊核心進行選擇。

    ![](images/img_06.png)

<br>

##

<br>

1. 這段代碼的內容是針對 `椎骨數據集（vertebral column dataset）` 進行探索性數據分析（Exploratory Data Analysis，EDA），其中並未涉及模型的訓練，僅是對數據特徵進行視覺化處理並檢視。

<br>

2. 在 UCI 數據集中，`Vertebral Column Data Set（椎骨數據集）` 也算是個常用的來源，數據集主要關於人體椎骨的解剖學數據，包含 `6` 個特徵如骨盆傾角（Pelvic incidence）、骨盆傾斜度（Pelvic tilt）、腰椎彎曲度（Lumbar lordosis angle）等，最終目標是通過這些數據來預測椎骨的健康狀態，常被用於監督式學習中的分類問題，適合用來訓練和測試分類器如邏輯迴歸、決策樹、支持向量機等。

<br>

3. 若要在本機運行，要安裝必要庫，代碼等其他內容不再贅述。

    ```bash
    pip install requests pandas seaborn
    ```

<br>

___

_END_