<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${vDto.word} - 상세 정보</title>
    <link rel="stylesheet" href="style/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>

    <jsp:include page="header.jsp" />

    <section class="search-section">
        <div class="title-area">
            <h1>일본어사전</h1>
            <p class="sub-title">나만의 단어장으로 실력 향상!</p>
        </div>
        <div class="search-box">
            <form action="WordController" method="GET">
                <input type="hidden" name="cmd" value="word_search">
                <input type="text" name="query" value="${searchQuery}" placeholder="단어, 뜻을 입력해보세요" class="search-input">
                <button type="submit" class="search-btn">검색</button>
            </form>
        </div>
    </section>
    
    <section class="daily-section">
        <div class="inner center-box">
           
           <article class="card" style="width: 100%; max-width: 600px; padding: 40px; text-align: left;">
                <div class="card-header" style="text-align: center; margin-bottom: 20px;">
                    단어 상세 정보
                </div>
                
                <div class="card-body">
                    <div style="border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; text-align: center;">
                        <h2 style="font-size: 48px; color: #333; margin-bottom: 10px;">${vDto.word}</h2>
                        <span style="background: #9EADFF; color: #fff; padding: 5px 12px; border-radius: 20px; font-size: 14px; font-weight: bold;">
                            ${vDto.jlpt}
                        </span>
                    </div>

                    <div style="margin-bottom: 15px;">
                        <span style="color: #888; font-size: 14px; display: block; margin-bottom: 5px;">음독 / 읽기</span>
                        <p style="font-size: 20px; color: #555;">${vDto.doc}</p>
                    </div>

                    <div style="margin-bottom: 30px;">
                        <span style="color: #888; font-size: 14px; display: block; margin-bottom: 5px;">뜻</span>
                        <p style="font-size: 24px; font-weight: bold; color: #333;">${vDto.korean}</p>
                    </div>

                    <div style="text-align: center; display: flex; gap: 10px; justify-content: center;">
                        <a href="WordController?cmd=word_search&query=${searchQuery}" class="btn-action" style="background: #eee; color: #555;">목록으로</a>
                        <a href="WordController?cmd=main" class="btn-action peri">메인으로</a>
                    </div>
                </div>
            </article>

        </div>
    </section>

</body>
</html>