## 腳本內容

<br>

1. 這個腳本的內容是針對 `椎骨數據集（vertebral column dataset）` 進行 `探索性數據分析（Exploratory Data Analysis，EDA）`，過程並未涉及模型的訓練，僅是對數據特徵進行視覺化處理並檢視。

<br>

2. 這個數據集來自 UCI 數據集，是個常用的來源，主要關於人體椎骨的解剖學數據，包含 `6` 個特徵如骨盆傾角（Pelvic incidence）、骨盆傾斜度（Pelvic tilt）、腰椎彎曲度（Lumbar lordosis angle）等，最終目標是通過這些數據來預測椎骨的健康狀態，常被用於監督式學習中的分類問題，適合用來訓練和測試分類器如邏輯迴歸、決策樹、支持向量機等。

<br>

3. 若要在本機運行，要安裝必要庫，代碼等其他內容不再贅述。

    ```bash
    pip install requests pandas seaborn
    ```

<br>

___

_END_