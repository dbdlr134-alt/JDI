<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jdi.user.UserDTO" %>
<%
    UserDTO myUser = (UserDTO)session.getAttribute("sessionUser");
    if(myUser == null) { response.sendRedirect("login.jsp"); return; }
    
    // [임시 데이터] 나중에 DB에서 가져온 값으로 대체하면 됩니다.
    int totalWords = 150; // 학습한 단어
    int wrongWords = 25;  // 틀린 단어
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - My J-Dic</title>
    <link rel="stylesheet" href="style/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .mypage-container { max-width: 1000px; margin: 50px auto; display: flex; gap: 30px; padding: 0 20px; }
        
        /* 왼쪽 프로필 카드 */
        .profile-card {
            width: 300px; background: #fff; padding: 30px;
            border-radius: 20px; box-shadow: 0 5px 20px rgba(158, 173, 255, 0.2);
            text-align: center; height: fit-content;
        }
        .profile-img {
            width: 100px; height: 100px; background: var(--bg-color); border-radius: 50%;
            margin: 0 auto 20px; line-height: 100px; font-size: 40px; color: var(--main-color);
        }
        .btn-edit-go {
            display: block; width: 100%; padding: 15px; margin-top: 20px;
            background: var(--main-color); color: #fff; border-radius: 30px;
            font-weight: bold; transition: 0.3s;
        }
        .btn-edit-go:hover { background: var(--hover-color); transform: translateY(-2px); }

        /* 오른쪽 차트 영역 */
        .chart-section {
            flex: 1; background: #fff; padding: 40px;
            border-radius: 20px; box-shadow: 0 5px 20px rgba(158, 173, 255, 0.2);
            display: flex; flex-direction: column; align-items: center;
        }
        .chart-container { width: 300px; height: 300px; position: relative; }
        /* 차트 가운데 글씨 */
        .chart-text {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
            text-align: center; font-weight: bold; color: #555; pointer-events: none;
        }
        .chart-number { font-size: 32px; color: var(--main-color); }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="mypage-container">
        <div class="profile-card">
            <div class="profile-img">User</div>
            <h2><%= myUser.getJdi_name() %></h2>
            <p style="color:#888; margin-bottom:20px;"><%= myUser.getJdi_email() %></p>
            
            <a href="pwd_check.jsp" class="btn-edit-go">내 정보 수정하러 가기 ></a>
        </div>

        <div class="chart-section">
            <h3 style="margin-bottom:30px; color:#555;">나의 학습 달성도</h3>
            <div class="chart-container">
                <canvas id="myChart"></canvas>
                <div class="chart-text">
                    학습 단어<br>
                    <span class="chart-number"><%= totalWords %></span>개
                </div>
            </div>
        </div>
    </div>

    <script>
        // 차트 그리기
        const ctx = document.getElementById('myChart');
        new Chart(ctx, {
            type: 'doughnut', // 도넛(링) 모양
            data: {
                labels: ['학습 완료', '틀린 단어'],
                datasets: [{
                    data: [<%= totalWords %>, <%= wrongWords %>], // 데이터 넣기
                    backgroundColor: ['#9EADFF', '#FF6B6B'], // 색상 (페리윙클, 빨강)
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                cutout: '70%', // 가운데 구멍 크기
                plugins: { legend: { position: 'bottom' } } // 범례 위치
            }
        });
    </script>
</body>
</html>