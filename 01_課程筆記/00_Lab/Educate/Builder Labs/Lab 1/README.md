# Lab 1: 使用 Amazon Cognito 來保護應用程式

<br>

## 簡介 Amazon Cognito 

_用於身份驗證和用戶管理的服務，專為行動應用程式和網頁應用程式設計；Amazon Cognito 可簡化應用程式的用戶管理及身份驗證過程，無需自行處理這些基礎設施。_

<br>

1. 身份驗證與授權：支援用戶透過社交登入（例如 Google、Facebook）或自定義身份提供者（如 SAML 或 OpenID Connect）進行身份驗證，也可使用內建的用戶目錄進行註冊和登入。

<br>

2. 用戶管理：提供註冊、登入、多重驗證（MFA）和密碼重設功能，並可以自定義用戶屬性和安全性策略。

<br>

3. 安全性：整合 AWS Identity and Access Management (IAM) 來控制應用程式資源的存取，並支援多因素驗證 (MFA) 增加安全性。

<br>

4. 身份池（Identity Pool）：允許用戶獲取 AWS 資源的臨時憑證，讓應用程式能安全地訪問 S3、DynamoDB 等服務。

<br>

## Lab 概述與目標

_在本 Lab 中，將會配置一個 Amazon Cognito `user pool（User Pool）`，用來管理使用者及其對現有 Web 應用程式的存取。接著，將會建立一個 Amazon Cognito `身分池（Identity Pool）`，當應用程式呼叫 Amazon DynamoDB 服務時，身分池將授權使用者進行存取。_

<br>

## Lab 的目的

1. 建立一個 Amazon Cognito user pool。

<br>

2. 使用user pool建立一個使用者。

<br>

3. 更新範例應用程式以使用user pool進行身份驗證。

<br>

4. 配置 Amazon Cognito 身分池。

<br>

5. 更新範例應用程式以使用身分池進行授權。

<br>

## Lab 情境

_假設已開始開發 Birds 網頁應用程式，該應用程式將跟踪學生的鳥類觀察紀錄。到目前為止，已經完成以下內容；在繼續開發應用程式之前，您決定將身份驗證與授權機制添加到應用程式中。_

<br>

1. 一個首頁 HTML。

<br>

2. 一個教育頁面 HTML，教導學生有關鳥類的知識。

<br>

3. 兩個受保護的頁面 HTML，學生必須通過身份驗證才能存取，分別是 `觀察紀錄頁面`，學生可以在此頁面查看過去的鳥類觀察紀錄；另外一個是 `報告頁面`，學生可以在此頁面報告新的鳥類觀察紀錄。

<br>

## 認證與授權的實施

_在此 Lab 中，將實施 Web 應用程式的使用者認證功能。具體步驟如下_

<br>

1. 建立並配置 Amazon Cognito user pool，user pool用來管理使用者及其密碼，幫助應用程式實現身份驗證機制。

<br>

2. 建立 Amazon Cognito 身分池，身分池用來管理使用者授權，允許通過授權的學生存取 Amazon DynamoDB 資料表。

<br>

## 整合步驟

_在進行本 Lab 的過程中，將整合user pool與身分池到 Web 應用程式中，使其具備完整的身份驗證與授權功能_

<br>

1. user pool：幫助應用程式實現登入及使用者管理功能。

<br>

2. 身分池：幫助應用程式確保只有授權的使用者能夠存取 DynamoDB 資料，進行讀寫操作。

<br>

3. 完成該 Lab 之後，應用程式將具備基本的安全機制，確保僅有通過身份驗證並授權的使用者能夠存取重要的資源，例如鳥類觀察紀錄資料表。

<br>

___

_END_

