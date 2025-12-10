<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mjdi.user.UserDTO" %>
<%@ page import="com.mjdi.user.PointDAO" %>
<%@ page import="com.mjdi.quiz.QuizDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.io.File, java.util.List, java.util.ArrayList" %>

<%
    UserDTO myUser = (UserDTO)session.getAttribute("sessionUser");
    if(myUser == null) { response.sendRedirect("login.jsp"); return; }
    
    String userId = myUser.getJdi_user();
    
    // 포인트 & 통계 조회 (기본 정보)
    int currentPoint = PointDAO.getInstance().getTotalPoint(userId);
    int wrongWords = QuizDAO.getInstance().getIncorrectCount(userId);
    
    // ---------------------------------------------------------
    // [신규] 최근 30회 퀴즈 데이터 조회 (막대 그래프용)
    // ---------------------------------------------------------
    // QuizDAO에 getRecentScores 메서드가 있어야 합니다. (없으면 빈 리스트 반환 가정)
    List<Integer> recentScores = QuizDAO.getInstance().getRecentScores(userId);
    
    // JS에 넘겨줄 데이터 문자열 만들기 (예: "[80, 100, 60, ...]")
    StringBuilder dataStr = new StringBuilder("[");
    StringBuilder labelStr = new StringBuilder("[");
    
    for(int i=0; i<recentScores.size(); i++) {
        dataStr.append(recentScores.get(i));
        labelStr.append("'").append(i+1).append("회'"); // 1회, 2회...
        
        if(i < recentScores.size() - 1) {
            dataStr.append(",");
            labelStr.append(",");
        }
    }
    dataStr.append("]");
    labelStr.append("]");
    
    boolean hasHistory = !recentScores.isEmpty();

    // ---------------------------------------------------------
    // 프로필 이미지 로직 (기존 유지)
    // ---------------------------------------------------------
    String imgDir = application.getRealPath("/images");
    File folder = new File(imgDir);
    File[] files = folder.listFiles();
    List<String> profileList = new ArrayList<>();

    if (files != null) {
        for (File f : files) {
            String name = f.getName();
            if (name.startsWith("profile") && name.endsWith(".png")) {
                profileList.add(name);
            }
        }
    }

    String ctx = request.getContextPath();
    String currentProfile = (myUser != null) ? myUser.getJdi_profile() : "profile1.png"; 
    
    if (currentProfile == null || currentProfile.trim().isEmpty()) {
        currentProfile = "profile1.png";
    }

    boolean showCustomProfile = false;
    String profileSrc = "";
    boolean inDefaultList = false;
    for (String p : profileList) {
        if (p.equals(currentProfile)) {
            inDefaultList = true;
            break;
        }
    }

    if (!inDefaultList && !currentProfile.startsWith("profile")) {
        showCustomProfile = true;
    }
    
    if (currentProfile.startsWith("upload") || showCustomProfile) {
        profileSrc = ctx + "/" + currentProfile;
    } else {
        profileSrc = ctx + "/images/" + currentProfile;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - My J-Dic</title>
    
    <%
        String currentTheme = (myUser.getJdi_theme() != null) ? myUser.getJdi_theme() : "default";
        String cssPath = request.getContextPath() + "/style/style.css";
        if (!"default".equals(currentTheme)) {
            cssPath = request.getContextPath() + "/style/" + currentTheme + "/style.css";
        }
    %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/user.css">
    <link rel="stylesheet" href="<%= cssPath %>">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        /* 차트 컨테이너 스타일 보정 */
        .chart-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .chart-container-box {
            width: 100%;
            height: 300px;
            position: relative;
        }
    </style>
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="mypage-container">
        
        <div class="profile-card">
            <div class="point-badge">
                💰 <%= String.format("%,d", currentPoint) %> P
            </div>
            <div class="profile-img-box">
                <img src="<%= profileSrc %>" alt="프로필 이미지" 
                     style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
            </div>
            <h2 class="user-name"><%= myUser.getJdi_name() %></h2>
            <p class="user-email"><%= myUser.getJdi_email() %></p>
            
            <a href="pwd_check.jsp" class="btn-mypage btn-gray">내 정보 수정 ></a>
            
            <a href="${pageContext.request.contextPath}/QuizController?cmd=quiz_incorrect" class="btn-mypage" style="border:1px solid var(--chart-color-wrong); color:var(--chart-color-wrong); background:#fff;">
                📝 오답노트 확인 (<%= wrongWords %>개)
            </a>
            
            <a href="${pageContext.request.contextPath}/WordController?cmd=bookmark_list" class="btn-mypage" style="border:1px solid var(--mnu-green); color:var(--mnu-green); background:#fff;">
                ⭐ 즐겨찾기 단어장
            </a>
            
            <a href="${pageContext.request.contextPath}/theme_store.jsp" class="btn-mypage" style="background:#fff; border:1px solid var(--mnu-blue); color:var(--mnu-blue);">
                🎨 테마 상점 가기
            </a>

            <a href="${pageContext.request.contextPath}/request/requesr_word.jsp" class="btn-mypage btn-outline-green">
                ➕ 단어 등록 신청
            </a>
            
            <a href="${pageContext.request.contextPath}/QnAController?cmd=qna_list" class="btn-mypage btn-outline-green">
                ❓ QnA
            </a>
        </div>

        <div class="chart-section">
            <h3 class="chart-title">최근 학습 성취도 (Last 30)</h3>
            
            <div class="chart-container-box">
                <% if(!hasHistory) { %>
                    <p style="text-align:center; padding-top:130px; color:#999;">
                        아직 푼 퀴즈 기록이 없어요.<br>
                        퀴즈를 풀면 여기에 그래프가 나타납니다!
                    </p>
                <% } else { %>
                    <canvas id="myChart"></canvas>
                <% } %>
            </div>
            
            <% if(hasHistory) { %>
                <p style="text-align:center; margin-top:10px; font-size:13px; color:#666;">
                    최근 30회의 퀴즈 정답률(%) 변화 추이입니다.
                </p>
            <% } %>
        </div>
    </div>

    <% if(hasHistory) { %>
    <script>
        // 테마 색상 가져오기
        const styles = getComputedStyle(document.documentElement);
        const themeColor = styles.getPropertyValue('--mnu-blue').trim() || '#0C4DA1'; // 기본값 파랑
        const themeBg = styles.getPropertyValue('--mnu-green').trim() || '#00A295'; // 보조값 초록

        const ctx = document.getElementById('myChart').getContext('2d');
        
        // 그라데이션 효과 (선택사항)
        let gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, themeColor);
        gradient.addColorStop(1, '#ffffff');

        new Chart(ctx, {
            type: 'bar', // 막대 그래프
            data: {
                labels: <%= labelStr.toString() %>, // ['1회', '2회'...]
                datasets: [{
                    label: '정답률 (%)',
                    data: <%= dataStr.toString() %>, // [80, 100, 60...]
                    backgroundColor: themeColor,     // 막대 색상 (테마 따라감)
                    borderRadius: 4,                 // 막대 둥글게
                    barPercentage: 0.6               // 막대 너비 조절
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100, // Y축 최대 100점
                        grid: {
                            color: '#f0f0f0'
                        }
                    },
                    x: {
                        grid: {
                            display: false // X축 세로선 숨김
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false // 범례 숨김 (깔끔하게)
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y + '점';
                            }
                        }
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>