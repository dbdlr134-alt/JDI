<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.jdi.word.WordDAO" %>

<%
    // 오늘의 퀴즈 세팅 (없으면 생성)
    if (session.getAttribute("quizWord") == null) {
        WordDAO.getInstance().setTodayQuiz(session);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나만의 일본어 사전</title>
    <link rel="stylesheet" href="style/style.css?ver=3"> <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>

    <jsp:include page="header.jsp" />

    <section class="search-section">
        <div class="title-area">
            <h1>일본어사전</h1>
            <p class="sub-title">나만의 단어장으로 실력 향상!</p>
        </div>
        
        <div class="search-box" style="position: relative;">
    <form action="WordController" method="GET" autocomplete="off">
        <input type="hidden" name="cmd" value="word_search">
        
        <input type="text" id="searchInput" name="query" value="${searchQuery}" 
               placeholder="단어, 뜻을 입력해보세요" class="search-input">
        
        <div id="autoBox" class="auto-box"></div>

        <button type="submit" class="search-btn">검색</button>
    </form>
</div>
    </section>

    <section class="daily-section">
        <div class="inner center-box">
            
            <c:choose>
                <%-- A. 검색 결과 있음 --%>
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
                
                <%-- B. 검색 결과 없음 --%>
                <c:when test="${not empty searchQuery and empty wordList}">
                    <div class="no-result">
                        <p>'${searchQuery}'에 대한 검색 결과가 없습니다 ㅠㅠ</p>
                        <a href="WordController?cmd=main" style="color:#9EADFF; margin-top:10px; display:inline-block;">메인으로 돌아가기</a>
                    </div>
                </c:when>

                <%-- C. 메인 화면 (퀴즈 + 급수별) --%>
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
                                        <p class="quiz-desc">단어 데이터를 불러오는 중...</p>
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

   <script>
   const searchInput = document.getElementById("searchInput");
   const autoBox = document.getElementById("autoBox");

   searchInput.addEventListener("keyup", function() {
       const key = this.value.trim();

       if (key.length === 0) {
           autoBox.innerHTML = "";
           autoBox.style.display = "none";
           return;
       }

       fetch("WordController?cmd=auto_complete&key=" + encodeURIComponent(key))
           .then(res => res.json())
           .then(data => {
               console.log("데이터 확인:", data); // F12 콘솔 확인용

               autoBox.innerHTML = "";

               if (!data || data.length === 0) {
                   autoBox.style.display = "none";
               } else {
                   // ★★★ [강제 스타일] 빨간 테두리로 위치 확인 ★★★
                   autoBox.style.cssText = `
                       display: block !important;
                       position: absolute !important;
                       top: 60px !important;
                       left: 0 !important;
                       width: 100% !important;
                       background-color: white !important;
                       border: 2px solid red !important; /* 빨간 테두리 */
                       z-index: 99999 !important;
                   `;

                   data.forEach(item => {
                       // 아까 보여주신 콘솔 내용에 맞춰 키 이름 고정 (word, korean)
                       const word = item.word; 
                       const korean = item.korean;

                       const div = document.createElement("div");
                       
                       // 아이템 스타일
                       div.style.cssText = `
                           padding: 10px;
                           border-bottom: 1px solid #eee;
                           cursor: pointer;
                           color: black;
                           font-weight: bold;
                           font-size: 16px;
                           background: white;
                       `;

                       div.innerHTML = word + " <span style='color:gray; font-weight:normal; font-size:14px;'>" + korean + "</span>";

                       // 클릭 이벤트
                       div.addEventListener("click", () => {
                           searchInput.value = word;
                           autoBox.style.display = "none";
                       });
                       
                       // 마우스 호버 효과
                       div.onmouseover = function() { this.style.backgroundColor = "#eee"; };
                       div.onmouseout = function() { this.style.backgroundColor = "#fff"; };

                       autoBox.appendChild(div);
                   });
               }
           })
           .catch(err => console.error("에러:", err));
   });
   
   // 닫기 이벤트
   document.addEventListener("click", function(e) {
       if (e.target !== searchInput && e.target !== autoBox) {
           autoBox.style.display = "none";
       }
   });
</script>
</body>
</html>