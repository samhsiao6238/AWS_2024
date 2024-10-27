<!DOCTYPE html>
<html lang="zh-TW">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>簡易 PHP 站台</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>

    <!-- 頁首 -->
    <header>
        <div class="logo">
            <img src="images/logo.png" alt="Logo" />
            <h1>歡迎來到AWS課程的練習網站</h1>
        </div>
        <nav>
            <ul>
                <li><a href="#">首頁</a></li>
                <li><a href="#">關於我</a></li>
                <li><a href="#">服務</a></li>
                <li><a href="#">聯絡我</a></li>
            </ul>
        </nav>
    </header>

    <!-- 主內容區域 -->
    <main>
        <section class="welcome">
            <h2>您好！歡迎光臨！</h2>
            <p>這是一個簡單的 PHP 站台範例。</p>
            <button onclick="alert('感謝您的到訪！')">了解更多</button>
        </section>
    </main>

    <!-- 頁腳 -->
    <footer>
        <p>&copy; <?php echo date("Y"); ?> 我的網站 | 版權所有</p>
    </footer>

</body>

</html>