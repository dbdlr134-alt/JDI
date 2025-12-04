<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mjdi.user.UserDTO" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <style>
        /* === 1. 전체 레이아웃 스타일 (이게 빠져서 안 보였던 겁니다) === */
        .edit-container { 
            max-width: 600px; margin: 50px auto; 
            background: #fff; padding: 40px; 
            border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
        }
        .row { margin-bottom: 20px; }
        .label { display: block; margin-bottom: 5px; color: #666; font-weight: 500; }
        .input-edit { 
            width: 100%; padding: 12px; 
            border: 1px solid #ddd; border-radius: 8px; font-size: 15px; 
        }
        .input-edit:read-only { background: #f5f5f5; color: #999; }
        
        .section-line { margin: 30px 0; border-top: 2px dashed #eee; }
        
        .btn-update { 
            width: 100%; padding: 15px; 
            background: var(--main-color); color: #fff; 
            border: none; border-radius: 30px; 
            font-size: 16px; font-weight: bold; cursor: pointer; 
        }
        .btn-update:hover { background-color: var(--hover-color); }

        /* === 2. 프로필 선택용 스타일 === */
        .profile-selector {
            display: flex; justify-content: center; gap: 15px; margin-bottom: 30px;
        }
        .profile-option {
            cursor: pointer; position: relative;
        }
        .profile-option img {
            width: 70px; height: 70px; border-radius: 50%;
            border: 3px solid #eee; transition: 0.2s;
        }
        /* 선택된 이미지 효과 (페리윙클 테두리) */
        .profile-option input:checked + img {
            border-color: var(--main-color);
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(158,173,255,0.5);
        }
        /* 라디오 버튼은 숨김 */
        .profile-option input { display: none; }
    </style>
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="edit-container">
        <h2 style="text-align:center; margin-bottom:30px; color:var(--main-color);">회원정보 수정</h2>
        
        <form action="updateAll.do" method="post">
    
            <h3 style="text-align:center; font-size:16px; margin-bottom:15px; color:#555;">프로필 사진 선택</h3>
            
            <div class="profile-selector">
                <label class="profile-option">
                    <input type="radio" name="profile" value="profile1.png" <%= "profile1.png".equals(myUser.getJdi_profile()) ? "checked" : "" %>>
                    <img src="<%= request.getContextPath() %>/images/profile1.png" alt="1">
                </label>
                
                <label class="profile-option">
                    <input type="radio" name="profile" value="profile2.png" <%= "profile2.png".equals(myUser.getJdi_profile()) ? "checked" : "" %>>
                    <img src="<%= request.getContextPath() %>/images/profile2.png" alt="2">
                </label>
                
                <label class="profile-option">
                    <input type="radio" name="profile" value="profile3.png" <%= "profile3.png".equals(myUser.getJdi_profile()) ? "checked" : "" %>>
                    <img src="<%= request.getContextPath() %>/images/profile3.png" alt="3">
                </label>
                
                <label class="profile-option">
                    <input type="radio" name="profile" value="profile4.png" <%= "profile4.png".equals(myUser.getJdi_profile()) ? "checked" : "" %>>
                    <img src="<%= request.getContextPath() %>/images/profile4.png" alt="4">
                </label>
            </div>

            <div class="row">
                <span class="label">아이디 (수정 불가)</span>
                <input type="text" class="input-edit" value="<%= myUser.getJdi_user() %>" readonly>
            </div>
            
            <div class="row">
                <span class="label">이름</span>
                <input type="text" name="name" class="input-edit" value="<%= myUser.getJdi_name() %>">
            </div>

            <div class="row">
                <span class="label">전화번호</span>
                <input type="text" name="phone" class="input-edit" value="<%= myUser.getJdi_phone() %>">
            </div>
            
            <div class="row">
                <span class="label">이메일</span>
                <input type="text" name="email" class="input-edit" value="<%= myUser.getJdi_email() %>">
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

            <button type="submit" class="btn-update">수정 완료</button>
        </form>
    </div>
</body>
</html>