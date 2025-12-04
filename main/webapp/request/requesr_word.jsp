<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 패키지명이 com.mjdi로 변경된 점 반영 (필요시 수정) --%>
<%@ page import="com.mjdi.word.WordDAO" %>
<%@ page import="com.mjdi.word.WordDTO" %>

<%
    int wordId = Integer.parseInt(request.getParameter("word_id"));
    WordDAO dao = WordDAO.getInstance();
    WordDTO word = dao.wordSelect(wordId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>단어 수정 신청</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/request.css">
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="req-container">
        <h2 class="req-title">단어 정보 수정</h2>
        <p class="req-desc">
            잘못된 정보가 있다면 수정해주세요.<br>
            관리자 검토 후 반영됩니다.
        </p>

        <form action="../requestEdit.apply" method="post">

            <input type="hidden" name="word_id" value="<%=word.getWord_id()%>">

            <div class="form-group">
                <label class="form-label">단어</label>
                <input type="text" name="word" value="<%=word.getWord()%>" class="form-input" required>
            </div>

            <div class="form-group">
                <label class="form-label">요미가나</label>
                <input type="text" name="doc" value="<%=word.getDoc()%>" class="form-input" required>
            </div>

            <div class="form-group">
                <label class="form-label">뜻</label>
                <input type="text" name="korean" value="<%=word.getKorean()%>" class="form-input" required>
            </div>

            <div class="form-group">
                <label class="form-label">JLPT 급수</label>
                <input type="text" name="jlpt" value="<%=word.getJlpt()%>" class="form-input" required>
            </div>

            <button type="submit" class="btn-submit">수정 신청 제출</button>

        </form>
    </div>
</body>
</html>