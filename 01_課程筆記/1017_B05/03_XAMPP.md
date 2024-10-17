# 安裝 XAMPP

<br>

## 在 Windows Server 開啟瀏覽器進行

_略_

<br>

## 在本機下載並透過 SSH 傳送

1. 在本機下載 `XAMPP`。

    ![](images/img_14.png)

<br>

2. 使用 `SCP` 指令傳送。

    ```bash
    scp xampp-windows-x64-8.0.30-0-VS16-installer.exe Administrator@34.237.2.154:C:/test
    ```

<br>

3. 速度實在有點慢。

    ![](images/img_53.png)

<br>

## 安裝

1. 安裝好之後，可瀏覽 C 槽中的目錄 `htdocs`，這就是用來存放網頁的目錄。

![](images/img_15.png)

3. 編輯任意 index.html 文本

4. 進入 XAMPP，啟動 Apach

## 嘗試使用 CLI 連線 Win 主機

1. 查詢 instance ID
```bash
i-0114836e36c8d7e9d
```

2. 查詢公共IP

```bash
52.87.199.155
```

## Win

1. 預設防火牆是關閉的

![](images/img_16.png)

2. 全部打開

![](images/img_17.png)

3. XAMPP 預設瀏覽 index.php，所以更名為 index1.php

4. xx

```bash
aws ec2 authorize-security-group-ingress --group-id sg-0ec93dbaf10be1cb7 --protocol tcp --port 445 --cidr 52.87.199.155/32
```

5. 