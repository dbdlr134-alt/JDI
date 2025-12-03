<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.jdi.word.WordDAO" %>

<%
    // [기능 추가] 오늘의 퀴즈가 세션에 없으면 자동으로 생성해서 넣음 (index2.jsp의 로직)
    if (session.getAttribute("quizWord") == null) {
        WordDAO.getInstance().setTodayQuiz(session);
        System.out.println("JSP에서 오늘의 퀴즈 세팅 완료");
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나만의 일본어 사전</title>
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
            
            <c:choose>
                <%-- 상황 A: 검색 결과가 있을 때 --%>
                <c:when test="${not empty wordList}">
                    <div style="width:100%; max-width:800px;">
                        <h3 style="margin-bottom: 15px; color:#555;">'${searchQuery}' 검색 결과</h3>
                        <ul class="result-list">
                            <c:forEach var="w" items="${wordList}">
                                <li class="result-item">
                                    <a href="WordController?cmd=word_view&word_id=${w.word_id}" style="display:block; text-decoration:none;">
                                        <span class="word">${w.word}</span>
                                        <span class="doc">[${w.doc}]</span>
                                        <span class="korean">${w.korean}</span>
                                        <span class="jlpt">${w.jlpt}</span>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:when>
                
                <%-- 상황 B: 검색은 했는데 결과가 없을 때 --%>
                <c:when test="${not empty searchQuery and empty wordList}">
                    <div class="no-result">
                        <p>'${searchQuery}'에 대한 검색 결과가 없습니다 ㅠㅠ</p>
                        <a href="WordController?cmd=main" style="color:#9EADFF; margin-top:10px; display:inline-block;">메인으로 돌아가기</a>
                    </div>
                </c:when>

                <%-- 상황 C: 처음 접속했을 때 (퀴즈 + JLPT 카드 보여주기) --%>
                <c:otherwise>
                    <div style="display:flex; gap:20px; flex-wrap:wrap; justify-content:center;">
                        
                        <article class="card quiz-card">
                            <div class="card-header">오늘의 퀴즈</div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.quizWord}">
                                        <h2 class="quiz-question">${sessionScope.quizWord.word}</h2>
                                        <p class="quiz-desc">이 단어의 뜻은 무엇일까요?</p>
                                    </c:when>
                                    <c:otherwise>
                                        <h2 class="quiz-question">준비 중</h2>
                                        <p class="quiz-desc">단어 데이터를 불러오지 못했습니다.</p>
                                    </c:otherwise>
                                </c:choose>
                                <a href="quiz.jsp" class="btn-action peri">정답 확인하기 ></a>
                            </div>
                        </article>

                        <article class="card jlpt">
                            <div class="card-header">JLPT 급수별 단어</div>
                            <form action="WordController" method="get">
                                <input type="hidden" name="cmd" value="word_search">
                                <div class="card-body">
                                    <div style="margin-bottom:15px;">
                                        <input type="radio" id="n1" name="query" value="N1"> <label for="n1" class="radio-label">N1</label>
                                        <input type="radio" id="n2" name="query" value="N2"> <label for="n2" class="radio-label">N2</label>
                                        <input type="radio" id="n3" name="query" value="N3" checked> <label for="n3" class="radio-label">N3</label>
                                        <input type="radio" id="n4" name="query" value="N4"> <label for="n4" class="radio-label">N4</label>
                                        <input type="radio" id="n5" name="query" value="N5"> <label for="n5" class="radio-label">N5</label>
                                    </div>
                                    <button type="submit" class="btn-action peri" style="border:none; cursor:pointer; width:100%;">
                                        선택한 급수 단어 보기 >
                                    </button>
                                </div>
                            </form>
                        </article>

                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </section>

</body>
</html>