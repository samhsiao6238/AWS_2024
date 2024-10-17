# 修正腳本

## 說明

1. 欄檢查無效數據（NaN 或 Inf）欄；在繪製 ROC 曲線之前，應先檢查 `target_predicted_binary` 和 `test_labels` 中是否存在無效的數據（如 `NaN` 或 `Inf`）。這些無效數據可能會導致 ROC 曲線繪製時出現軸設置錯誤（如 `Axis limits cannot be NaN or Inf`）。如果發現無效數據，應用適當的方法進行替換，如將 `NaN` 替換為 0，並將 `Inf` 替換為 0 或其他適當的值。

2. 欄修正 `plot_roc()` 函數欄；在 `plot_roc()` 函數中，`ax2.set_ylim([thresholds[-1], thresholds[0]])` 這行直接設置了閾值範圍，但 `thresholds` 中可能包含 `NaN` 或 `Inf`。為避免出錯，應該在設置 y 軸範圍之前過濾掉無效的數據。另外，`test_labels` 已經作為函數參數傳遞，因此不需要重新從 `test` DataFrame 中提取。

3. 欄NaN 和 Inf 值的檢查欄；修正 `plot_roc()` 函數時，應添加 NaN 和 Inf 的值檢查，確保在設置 y 軸時數據有效，防止「Axis limits cannot be NaN or Inf」的錯誤。刪除重複的 `test_labels` 提取，因為它已經作為參數傳入，不需要從 DataFrame 中再次提取。

4. 欄完整修正代碼欄。

    ```python
    import numpy as np
    from sklearn.metrics import roc_curve, auc, confusion_matrix, roc_auc_score
    import matplotlib.pyplot as plt
    import seaborn as sns

    # 檢查數據中是否有 NaN 或 Inf，並進行替換
    if target_predicted_binary.isnull().any() or test_labels.isnull().any():
        print("警告：有 NaN 值")
        target_predicted_binary = target_predicted_binary.fillna(0)
        test_labels = test_labels.fillna(0)

    # 確保沒有 Inf 值
    target_predicted_binary = target_predicted_binary.replace(
        [np.inf, -np.inf], 0
    )
    test_labels = test_labels.replace(
        [np.inf, -np.inf], 0
    )

    # 修正這個函數
    def plot_roc(test_labels, target_predicted_binary):
        TN, FP, FN, TP = confusion_matrix(test_labels, target_predicted_binary).ravel()
        
        # Sensitivity, hit rate, recall, or true positive rate
        Sensitivity = float(TP) / (TP + FN) * 100
        # Specificity or true negative rate
        Specificity = float(TN) / (TN + FP) * 100
        # Precision or positive predictive value
        Precision = float(TP) / (TP + FP) * 100
        # Negative predictive value
        NPV = float(TN) / (TN + FN) * 100
        # Fall out or false positive rate
        FPR = float(FP) / (FP + TN) * 100
        # False negative rate
        FNR = float(FN) / (TP + FN) * 100
        # False discovery rate
        FDR = float(FP) / (TP + FP) * 100
        # Overall accuracy
        ACC = float(TP + TN) / (TP + FP + FN + TN) * 100

        print(f"Sensitivity or TPR: {Sensitivity}%")    
        print(f"Specificity or TNR: {Specificity}%") 
        print(f"Precision: {Precision}%")   
        print(f"Negative Predictive Value: {NPV}%")  
        print(f"False Positive Rate: {FPR}%") 
        print(f"False Negative Rate: {FNR}%")  
        print(f"False Discovery Rate: {FDR}%" )
        print(f"Accuracy: {ACC}%") 

        # 計算 ROC AUC
        roc_auc = roc_auc_score(test_labels, target_predicted_binary)
        print("Validation AUC", roc_auc)

        # 計算 ROC 曲線
        fpr, tpr, thresholds = roc_curve(test_labels, target_predicted_binary)
        roc_auc = auc(fpr, tpr)

        # 繪製 ROC 曲線
        plt.figure()
        plt.plot(fpr, tpr, label='ROC curve (area = %0.2f)' % roc_auc)
        plt.plot([0, 1], [0, 1], 'k--')
        plt.xlim([0.0, 1.0])
        plt.ylim([0.0, 1.05])
        plt.xlabel('False Positive Rate')
        plt.ylabel('True Positive Rate')
        plt.title('Receiver Operating Characteristic')
        plt.legend(loc="lower right")

        # create the axis of thresholds (scores)
        ax2 = plt.gca().twinx()
        ax2.plot(fpr, thresholds, markeredgecolor='r', linestyle='dashed', color='r')
        ax2.set_ylabel('Threshold', color='r')

        # 檢查 thresholds 中是否有 NaN 或 Inf 值
        valid_thresholds = thresholds[np.isfinite(thresholds)]
        if len(valid_thresholds) > 0:
            ax2.set_ylim([valid_thresholds[-1], valid_thresholds[0]])
        else:
            print("警告：沒有有效的閾值範圍")

        ax2.set_xlim([fpr[0], fpr[-1]])

        plt.show()
    ```

