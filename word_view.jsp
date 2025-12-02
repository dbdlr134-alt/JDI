<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나만의 일본어 사전 (JSP Ver.)</title>
    <link rel="stylesheet" href="style/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>

    <header class="top-header">
        <div class="inner">
            <div class="logo">My J-Dic</div>
            <nav class="util-nav">
                <a href="login.jsp" class="btn-login">로그인</a>
                <a href="#" class="btn-menu">:::</a>
            </nav>
        </div>
    </header>

    <section class="search-section">
        <div class="title-area">
            <h1>일본어사전</h1>
            <p class="sub-title">나만의 단어장으로 실력 향상!</p>
        </div>
        <div class="search-box">
            <form action="result.jsp" method="GET">
                <input type="text" name="query" placeholder="단어, 뜻을 입력해보세요" class="search-input">
                <button type="submit" class="search-btn">검색</button>
            </form>
        </div>
    </section>
    
   <div class="word-view" style="border:1px solid #666; padding:20px; margin-top:20px;">
    <h2>${wordList.word}</h2>
    <h5 style="color:#666;">JLPT: ${w.jlpt}</h5>
    <p><strong>발음:</strong> ${w.doc}</p>
    <p><strong>뜻:</strong> ${w.korean}</p>
</div>
    

</body>
</html>