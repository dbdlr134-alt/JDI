<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mjdi.user.UserDTO" %>
<%@ page import="com.mjdi.user.PointDAO" %> 
<%
    UserDTO myUser = (UserDTO)session.getAttribute("sessionUser");
    if(myUser == null) { response.sendRedirect("login.jsp"); return; }
    
    int currentPoint = PointDAO.getInstance().getTotalPoint(myUser.getJdi_user());
    int totalWords = 150; 
    int wrongWords = 25;
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
                <img src="<%= request.getContextPath() %>/images/<%= myUser.getJdi_profile() %>" alt="프로필">
            </div>
            
            <h2 class="user-name"><%= myUser.getJdi_name() %></h2>
            <p class="user-email"><%= myUser.getJdi_email() %></p>
            
            <a href="pwd_check.jsp" class="btn-mypage btn-gray">내 정보 수정 ></a>

            <a href="../QuizController?cmd=quiz_incorrect" class="btn-mypage btn-outline-red">
                📝 오답노트 확인
            </a>

            <a href="../request/request_word.jsp" class="btn-mypage btn-outline-green">
                + 단어 등록 신청
            </a>
        </div>

        <div class="chart-section">
            <h3 class="chart-title">나의 학습 달성도</h3>
            <div style="width:300px; height:300px; position:relative;">
                <canvas id="myChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('myChart');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['학습 완료', '틀린 단어'],
                datasets: [{
                    data: [<%= totalWords %>, <%= wrongWords %>],
                    backgroundColor: ['#00A295', '#FF6B6B'], /* MNU Green 적용 */
                    borderWidth: 0, hoverOffset: 4
                }]
            },
            options: { cutout: '70%', plugins: { legend: { position: 'bottom' } } }
        });
    </script>
</body>
</html>