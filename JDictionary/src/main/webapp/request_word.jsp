<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 안 했으면 쫓아내기
    if(session.getAttribute("sessionUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>단어 등록 신청</title>
    <link rel="stylesheet" href="style/style.css">
    <style>
        .req-container { 
            max-width: 600px; margin: 50px auto; 
            background: #fff; padding: 40px; 
            border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
        }
        .row { margin-bottom: 20px; }
        .label { display: block; margin-bottom: 5px; color: #666; font-weight: 500; }
        .input-req { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; }
        .btn-req { 
            width: 100%; padding: 15px; background: var(--main-color); color: #fff; 
            border: none; border-radius: 30px; font-size: 16px; font-weight: bold; cursor: pointer; 
        }
        .btn-req:hover { background-color: var(--hover-color); }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="req-container">
        <h2 style="text-align:center; margin-bottom:10px; color:var(--main-color);">단어 등록 신청</h2>
        <p style="text-align:center; color:#888; margin-bottom:30px; font-size:14px;">
            없는 단어가 있나요? 관리자에게 등록을 요청해보세요.<br>
            승인되면 포인트 <strong>50 P</strong>를 드립니다! (구현 예정)
        </p>
        
        <form action="WordController" method="post">
            <input type="hidden" name="cmd" value="word_req">
            
            <div class="row">
                <span class="label">단어 (한자/히라가나)</span>
                <input type="text" name="word" class="input-req" placeholder="예: 勉強" required>
            </div>
            
            <div class="row">
                <span class="label">요미가나 (읽는 법)</span>
                <input type="text" name="doc" class="input-req" placeholder="예: べんきょう" required>
            </div>
            
            <div class="row">
                <span class="label">뜻 (한국어)</span>
                <input type="text" name="korean" class="input-req" placeholder="예: 공부" required>
            </div>
            
            <div class="row">
                <span class="label">JLPT 급수</span>
                <select name="jlpt" class="input-req">
                    <option value="N5">N5 (기초)</option>
                    <option value="N4">N4</option>
                    <option value="N3">N3</option>
                    <option value="N2">N2</option>
                    <option value="N1">N1 (고급)</option>
                    <option value="ETC">기타</option>
                </select>
            </div>

            <button type="submit" class="btn-req">신청하기</button>
        </form>
    </div>
</body>
</html>