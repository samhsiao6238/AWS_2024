# 在 VSCode 對 PHP 進行格式化

_使用 PHP CS Fixer_

## 說明

1. 使用 Composer 全局安裝 PHP CS Fixer。

```bash
composer global require --dev "friendsofphp/php-cs-fixer"
```

2. 確認 PHP CS Fixer 是否已正確安裝。

```bash
php-cs-fixer --version
```

3. 確認文件路徑。

```bash
ls ~/.composer/vendor/bin/php-cs-fixer
```

## 在 VSCode 中配置 PHP CS Fixer

1. 打開 VSCode 設定，搜索 `php cs fixer`，找到 `php-cs-fixer: Executable Path`，設定 `php-cs-fixer: Executable Path`。

    ```bash
    ~/.composer/vendor/bin/php-cs-fixer
    ```

### 4. 配置 .php_cs.dist 文件
在你的 PHP 項目根目錄下創建一個 `.php_cs.dist` 配置文件，用於定義 PHP CS Fixer 的格式化規則。例如：

```php
<?php

$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__);

$config = PhpCsFixer\Config::create()
    ->setRules([
        '@PSR2' => true,
        'array_syntax' => ['syntax' => 'short'],
        'single_quote' => true,
    ])
    ->setFinder($finder);

return $config;
```

### 5. 在 VSCode 中啟用自動格式化
1. 打開 VSCode 設定（按 `Cmd + ,`）。
2. 搜索 `format on save`，並啟用 `Editor: Format On Save` 選項。
3. 打開命令面板（按 `Cmd + Shift + P`），然後選擇 `Preferences: Open Settings (JSON)`。
4. 在設置文件中添加以下配置，以便在保存 PHP 文件時自動運行 PHP CS Fixer：

    ```json
    "[php]": {
        "editor.defaultFormatter": "junstyle.php-cs-fixer"
    }
    ```

### 6. 安裝 PHP CS Fixer VSCode 擴展
在 VSCode 的擴展市場中搜索並安裝 `php-cs-fixer` 擴展，這將允許你直接從 VSCode 使用 PHP CS Fixer 進行代碼格式化。

### 7. 測試配置
創建或打開一個 PHP 文件，並故意引入一些格式錯誤，如使用雙引號而不是單引號、錯誤的縮進等。保存文件後，PHP CS Fixer 應該會自動修復這些格式錯誤。

這樣配置完成後，VSCode 就可以自動格式化你的 PHP 代碼，確保代碼風格的一致性。