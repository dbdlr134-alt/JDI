<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mjdi.user.UserDTO" %>
<%@ page import="com.mjdi.user.PointDAO" %>
<%@ page import="com.mjdi.quiz.QuizDAO" %>

<%
    UserDTO myUser = (UserDTO)session.getAttribute("sessionUser");
    if(myUser == null) { response.sendRedirect("login.jsp"); return; }
    
    String userId = myUser.getJdi_user();
    
    // 1. 포인트 조회
    int currentPoint = PointDAO.getInstance().getTotalPoint(userId);
    
    // 2. ★ [수정] 변수명을 wrongCount에서 wrongWords로 변경 (아래 HTML과 일치시킴)
    int wrongWords = QuizDAO.getInstance().getIncorrectCount(userId);
    
    // 3. 내가 푼 전체 문제 수 조회
    int mySolveCount = QuizDAO.getInstance().getMySolveCount(userId);
    
    // 4. 그래프용 계산 (전체 풀이 - 현재 오답 수 = 정답 수 추산)
    // ★ 변수명이 바뀌었으므로 계산식도 wrongWords를 사용
    int correctCount = mySolveCount - wrongWords;
    if(correctCount < 0) correctCount = 0; 
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - My J-Dic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/user.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="mypage-container">
        
        <div class="profile-card">
            <div class="point-badge">
                💰 <%= String.format("%,d", currentPoint) %> P
            </div>
            
            <div class="profile-img-box">
                <img src="${pageContext.request.contextPath}/images/<%= myUser.getJdi_profile() %>" alt="프로필">
            </div>
            
            <h2 class="user-name"><%= myUser.getJdi_name() %></h2>
            <p class="user-email"><%= myUser.getJdi_email() %></p>
            
            <a href="pwd_check.jsp" class="btn-mypage btn-gray">내 정보 수정 ></a>

            <a href="${pageContext.request.contextPath}/QuizController?cmd=quiz_incorrect" class="btn-mypage btn-outline-red">
                📝 오답노트 확인 (<%= wrongWords %>개)
            </a>

            <a href="${pageContext.request.contextPath}/request/requesr_word.jsp" class="btn-mypage btn-outline-green">
                + 단어 등록 신청
            </a>
        </div>

        <div class="chart-section">
            <h3 class="chart-title">나의 학습 활동</h3>
            <div style="width:300px; height:300px; position:relative;">
                <% if(mySolveCount == 0) { %>
                    <p style="text-align:center; padding-top:130px; color:#999;">
                        아직 푼 문제가 없어요.<br>퀴즈에 도전해보세요!
                    </p>
                <% } else { %>
                    <canvas id="myChart"></canvas>
                <% } %>
            </div>
             <p style="text-align:center; margin-top:20px; font-size:14px; color:#666;">
                지금까지 <strong><%= mySolveCount %></strong>문제를 풀었고,<br>
                현재 <span style="color:#FF6B6B; font-weight:bold;"><%= wrongWords %></span>개의 오답 단어가 있어요.
            </p>
        </div>
    </div>

    <% if(mySolveCount > 0) { %>
    <script>
        const ctx = document.getElementById('myChart');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['정답(누적)', '현재 오답'],
                datasets: [{
                    data: [<%= correctCount %>, <%= wrongWords %>],
                    backgroundColor: ['#00A295', '#FF6B6B'], 
                    borderWidth: 0, 
                    hoverOffset: 4
                }]
            },
            options: { 
                cutout: '70%', 
                plugins: { 
                    legend: { position: 'bottom' } 
                } 
            }
        });
    </script>
    <% } %>
</body>
</html>