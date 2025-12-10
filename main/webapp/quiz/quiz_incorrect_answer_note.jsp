<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="com.mjdi.user.UserDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // 1. 세션에서 유저 정보 가져오기 & 로그인 체크
    UserDTO myUser = (UserDTO)session.getAttribute("sessionUser");
    String ctx = request.getContextPath();

    if(myUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    // 2. 현재 테마 결정
    String currentTheme = "default";
    if (myUser.getJdi_theme() != null && !myUser.getJdi_theme().trim().isEmpty()) {
        currentTheme = myUser.getJdi_theme();
    }

    // 3. CSS 경로 설정
    String baseCss  = ctx + "/style/style.css";
    String themeCss = null;
    if (!"default".equals(currentTheme)) {
        themeCss = ctx + "/style/" + currentTheme + "/style.css";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>나만의 오답노트 - My J-Dic</title>

    <link rel="stylesheet" href="<%= baseCss %>">
    <% if (themeCss != null) { %>
        <link rel="stylesheet" href="<%= themeCss %>">
    <% } %>

    <style>
        .note-container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }

        .note-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--mnu-blue, #0C4DA1);
        }

        .note-title {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .wrong-badge {
            background-color: #ffebee;
            color: #e53935; /* 오답은 빨간색 고정 */
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            margin-left: 8px;
        }
        
        .wrong-date {
            font-size: 12px;
            color: #999;
            margin-left: auto; /* 우측 정렬 */
        }

        /* 복습 버튼 스타일 */
        .btn-retry {
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            border-radius: 50px;
            text-decoration: none;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        /* 활성화 상태 (테마 컬러 적용) */
        .btn-retry.active {
            background-color: var(--mnu-blue, #0C4DA1);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }
        .btn-retry.active:hover {
            filter: brightness(1.1);
            transform: translateY(-2px);
        }

        /* 비활성화 상태 */
        .btn-retry.disabled {
            background-color: #ccc;
            cursor: not-allowed;
            pointer-events: none; /* 클릭 방지 */
        }

        /* 리스트 스타일 보정 */
        .result-list .result-item a {
            display: block;
            text-decoration: none;
            color: inherit;
        }
        .word-row {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>

    <jsp:include page="/include/header.jsp" />

    <section class="daily-section">
        <div class="inner center-box">
            
            <div class="note-container">
                
                <div class="note-header">
                    <div class="note-title">
                        📝 나만의 오답노트
                    </div>
                    <span style="color:#666; font-size:14px;">
                        총 <strong>${fn:length(noteList)}</strong>개의 오답
                    </span>
                </div>

                <div style="text-align: right; margin-bottom: 20px;">
                    <%-- 
                        ★ 복습 버튼 로직
                        오답 개수가 10개 이상이어야 버튼이 활성화됨 (active 클래스)
                        그 외에는 disabled 클래스 적용
                    --%>
                    <c:choose>
                        <c:when test="${fn:length(noteList) >= 5}">
                            <a href="<%= ctx %>/QuizController?cmd=quiz_retry" class="btn-retry active">
                                🔄 오답 복습하기
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" class="btn-retry disabled" title="5개 이상부터 복습 가능합니다">
                                🔄 오답 복습하기 (5개↑)
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:choose>
                    <%-- 오답 기록이 있을 때 --%>
                    <c:when test="${not empty noteList}">
                        <ul class="result-list">
                            <c:forEach var="i" items="${noteList}">
                                <li class="result-item">
                                    <a href="<%= ctx %>/WordController?cmd=word_view&word_id=${i.word_id}">
                                        
                                        <div class="word-row">
                                            <span class="word">${i.word}</span>
                                            <span class="doc">[${i.doc}]</span>
                                            <span class="wrong-badge">${i.wrong_count}회 틀림</span>
                                        </div>
                                        
                                        <div class="info-row">
                                            <span class="korean">${i.korean}</span>
                                            <span class="wrong-date">${fn:substring(i.wrong_date, 0, 10)}</span>
                                        </div>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>

                    <%-- 오답 기록이 없을 때 --%>
                    <c:otherwise>
                        <div class="no-result" style="padding:60px 20px;">
                            <p style="font-size:18px; margin-bottom:20px; color:#333;">
                                틀린 문제가 없습니다! 완벽해요 🎉
                            </p>
                            <a href="<%= ctx %>/QuizController?cmd=word_quiz" class="btn-action peri">
                                퀴즈 풀러 가기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div style="text-align:center; margin-top:40px;">
                    <a href="<%= ctx %>/mypage.jsp" style="color:#888; text-decoration:underline; font-size:14px;">
                        ← 마이페이지로 돌아가기
                    </a>
                </div>

            </div>
        </div>
    </section>

</body>
</html>