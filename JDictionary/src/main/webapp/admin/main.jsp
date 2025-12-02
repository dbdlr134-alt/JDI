<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jdi.user.UserDTO" %>
<%
    // 1. 보안 검사 (문지기)
    UserDTO adminUser = (UserDTO)session.getAttribute("sessionUser");
    
    // 로그인을 안 했거나 OR 등급이 ADMIN이 아니라면 -> 쫓아냄
    if(adminUser == null || !"ADMIN".equals(adminUser.getJdi_role())) {
        response.sendRedirect("../index.jsp"); // 상위 폴더의 메인으로 강제 이동
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="../style/style.css">
    <style>
        .admin-container { padding: 50px; max-width: 1200px; margin: 0 auto; }
        .admin-header { 
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px;
        }
        .dashboard-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .card { 
            background: #fff; padding: 30px; border-radius: 15px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); text-align: center; 
        }
        .card h3 { color: #888; margin-bottom: 10px; font-size: 16px; }
        .card strong { font-size: 36px; color: var(--main-color); }
        
        .btn-logout { 
            padding: 10px 20px; background: #333; color: #fff; 
            border-radius: 5px; font-size: 14px; 
        }
    </style>
</head>
<body>

    <div class="admin-container">
        <div class="admin-header">
            <h1>ADMINISTRATOR</h1>
            <div>
                <span><%= adminUser.getJdi_name() %> 관리자님</span>
                <a href="../logout.do" class="btn-logout">로그아웃</a>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <h3>총 회원 수</h3>
                <strong>140000000</strong>명
            </div>
            <div class="card">
                <h3>오늘 가입자</h3>
                <strong>20</strong>명
            </div>
            <div class="card">
                <h3>등록된 단어</h3>
                <strong>1,2050</strong>개
            </div>
        </div>
        
        <br><br>
        
        <h2>관리 메뉴</h2>
        <ul style="margin-top:20px; list-style:none;">
            <li style="margin-bottom:10px;"><a href="#">👉 회원 목록 조회 및 삭제</a></li>
            <li style="margin-bottom:10px;"><a href="#">👉 단어장 데이터 추가/수정</a></li>
        </ul>
        
        <br>
        <a href="../index.jsp" style="color:#888;">← 사용자 메인 페이지로 가기</a>
    </div>

</body>
</html>