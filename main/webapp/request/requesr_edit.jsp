<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("sessionUser") == null) {
        response.sendRedirect("../login.jsp"); // 경로 주의 (상위 폴더로)
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>단어 등록 신청</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/request.css">
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="req-container">
        <h2 class="req-title">단어 등록 신청</h2>
        <p class="req-desc">
            없는 단어가 있나요? 관리자에게 등록을 요청해보세요.<br>
            승인되면 포인트 <strong>50 P</strong>를 드립니다!
        </p>
        
        <form action="../WordController" method="post">
            <input type="hidden" name="cmd" value="word_req">
            
            <div class="form-group">
                <label class="form-label">단어 (한자/히라가나)</label>
                <input type="text" name="word" class="form-input" placeholder="예: 勉強" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">요미가나 (읽는 법)</label>
                <input type="text" name="doc" class="form-input" placeholder="예: べんきょう" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">뜻 (한국어)</label>
                <input type="text" name="korean" class="form-input" placeholder="예: 공부" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">JLPT 급수</label>
                <select name="jlpt" class="form-select">
                    <option value="N5">N5 (기초)</option>
                    <option value="N4">N4</option>
                    <option value="N3">N3</option>
                    <option value="N2">N2</option>
                    <option value="N1">N1 (고급)</option>
                    <option value="ETC">기타</option>
                </select>
            </div>

            <button type="submit" class="btn-submit">신청하기</button>
        </form>
    </div>
</body>
</html>