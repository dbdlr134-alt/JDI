<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jdi.user.UserDTO" %>
<%
    UserDTO myUser = (UserDTO)session.getAttribute("sessionUser");
    // 보안 검사: pwd_check를 통과했다는 증표가 없으면 튕겨냄
    if(session.getAttribute("isPwdChecked") == null) {
        response.sendRedirect("pwd_check.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="style/style.css">
    <style>
        .edit-container { max-width: 600px; margin: 50px auto; background: #fff; padding: 40px; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .row { margin-bottom: 20px; }
        .label { display: block; margin-bottom: 5px; color: #666; font-weight: 500; }
        .input-edit { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; }
        .input-edit:read-only { background: #f5f5f5; color: #999; }
        
        .section-line { margin: 30px 0; border-top: 2px dashed #eee; }
        
        .btn-update { width: 100%; padding: 15px; background: var(--main-color); color: #fff; border: none; border-radius: 30px; font-size: 16px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="edit-container">
        <h2 style="text-align:center; margin-bottom:30px; color:var(--main-color);">회원정보 수정</h2>
        
        <form action="updateAll.do" method="post">
            <div class="row">
                <span class="label">아이디 (수정 불가)</span>
                <input type="text" class="input-edit" value="<%= myUser.getJdi_user() %>" readonly>
            </div>
            <div class="row">
                <span class="label">이름</span>
                <input type="text" name="name" class="input-edit" value="<%= myUser.getJdi_name() %>">
            </div>
            <div class="section-line"></div>
            <h3 style="margin-bottom:15px; font-size:16px;">비밀번호 변경 (선택사항)</h3>
            <p style="font-size:12px; color:#888; margin-bottom:10px;">변경을 원하지 않으면 비워두세요.</p>

            <div class="row">
                <input type="password" name="newPw" class="input-edit" placeholder="새로운 비밀번호">
            </div>
            <div class="row">
                <input type="password" name="newPwCheck" class="input-edit" placeholder="새로운 비밀번호 확인">
            </div>
			<div class="row">
                <span class="label">전화번호</span>
                <input type="text" name="phone" class="input-edit" value="<%= myUser.getJdi_phone() %>">
            </div>
            <div class="row">
                <span class="label">이메일</span>
                <input type="text" name="email" class="input-edit" value="<%= myUser.getJdi_email() %>">
            </div>
            <button type="submit" class="btn-update">수정 완료</button>
        </form>
    </div>
</body>
</html>