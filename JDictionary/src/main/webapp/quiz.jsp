<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 풀기</title>
    <link rel="stylesheet" href="style/style.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <section class="daily-section" style="padding-top: 50px;">
        <div class="inner center-box">
            <article class="card" style="width: 100%; max-width: 500px; padding: 40px; text-align: center;">
                <div class="card-header" style="font-size: 18px; color: #9EADFF;">Today's Quiz</div>
                
                <div class="card-body">
                    <c:if test="${not empty sessionScope.quizWord}">
                        <h2 class="quiz-question" style="font-size: 50px; margin: 20px 0;">${sessionScope.quizWord.word}</h2>
                        <p class="quiz-desc" style="margin-bottom: 30px; font-size: 18px; color: #555;">
                            이 단어의 뜻은 무엇일까요?
                        </p>
                        
                        <div id="answer-box" style="display:none; margin-bottom: 20px; padding: 15px; background: #f4f6fa; border-radius: 10px;">
                            <strong style="color: #333; font-size: 20px;">${sessionScope.quizWord.korean}</strong>
                            <p style="color: #666;">[${sessionScope.quizWord.doc}]</p>
                        </div>

                        <button onclick="document.getElementById('answer-box').style.display='block'" class="btn-action peri">
                            정답 확인
                        </button>
                    </c:if>

                    <c:if test="${empty sessionScope.quizWord}">
                        <p>문제가 준비되지 않았습니다. 메인으로 돌아가주세요.</p>
                        <a href="WordController?cmd=main" class="btn-action">홈으로</a>
                    </c:if>
                </div>
            </article>
        </div>
    </section>
</body>
</html>