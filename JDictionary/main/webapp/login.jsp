<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - My J-Dic</title>
    <link rel="stylesheet" href="style/style.css"> <style>
        /* 로그인 페이지 전용 추가 스타일 */
        .login-wrap {
            display: flex; justify-content: center; align-items: center;
            height: 80vh;
        }
        .login-box {
            background: #fff; width: 400px; padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(158, 173, 255, 0.2);
            text-align: center;
        }
        .login-title { color: var(--main-color); font-size: 24px; font-weight: bold; margin-bottom: 30px; }
        .input-group { margin-bottom: 15px; }
        .input-field {
            width: 100%; height: 50px; padding: 0 15px;
            border: 2px solid #ddd; border-radius: 10px;
            font-size: 16px; outline: none; transition: 0.3s;
        }
        .input-field:focus { border-color: var(--main-color); }
        .btn-submit {
            width: 100%; height: 50px;
            background-color: var(--main-color); color: #fff;
            border: none; border-radius: 10px;
            font-size: 18px; font-weight: bold; cursor: pointer;
            margin-top: 10px; transition: 0.3s;
        }
        .btn-submit:hover { background-color: var(--hover-color); }
        .error-msg { color: #ff6b6b; font-size: 14px; margin-bottom: 15px; display: none; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="inner login-wrap">
        <div class="login-box">
            <h2 class="login-title">로그인</h2>

            <% if("1".equals(request.getParameter("error"))) { %>
                <p class="error-msg" style="display:block;">아이디 또는 비밀번호가 일치하지 않습니다.</p>
            <% } %>

            <form action="login.do" method="post">
                <div class="input-group">
                    <input type="text" name="id" class="input-field" placeholder="아이디" required>
                </div>
                <div class="input-group">
                    <input type="password" name="pw" class="input-field" placeholder="비밀번호" required>
                </div>
                <button type="submit" class="btn-submit">로그인 하기</button>
            </form>
            
            <div style="margin-top: 20px; font-size: 14px; color: #888;">
                아직 계정이 없으신가요? <a href="join.jsp" style="color:var(--main-color); font-weight:bold;">회원가입</a>
            </div>
        </div>
    </div>

</body>
</html>